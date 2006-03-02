From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] aic94xx: attaching to the sas transport class
Date: Thu, 02 Mar 2006 16:38:04 -0600
Message-ID: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:27577 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750939AbWCBWiJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 17:38:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>

This fairly minimal patch correctly attaches the aic94xx driver to the
SAS transport class (The driver is available from

www.kernel.org/git/jgarzik/sas-2.6

).  Unfortunately, the driver itself still has the following critical
issues

1. Discovery order is non-deterministic (it starts one thread per port,
so the threads race for discovery)

2. The minimal attachment to the sas transport class doesn't do
expanders.  This needs to be fixed up by patching better expander
support into the class.  The way to do this is probably to pull the
domain_device into the sas transport class.

3. The object lifetimes are all basically infinite (this will probably
fixed by 2)

There's a host of minor details, and I think the ultimate goal needs to
be to turn Luben's sas_class into an adjunct to the transport class that
handles drivers with domain devices.

However, my basic though is that once we can get the critical issues
sorted out, this driver can go in.

Comments?

James

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 79f0d58..eaf1e2e 100644
Index: BUILD-2.6/drivers/scsi/Makefile
===================================================================
--- BUILD-2.6.orig/drivers/scsi/Makefile	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/Makefile	2006-03-02 16:05:15.000000000 -0600
@@ -32,7 +32,7 @@
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
-obj-$(CONFIG_SAS_CLASS)		+= sas/
+obj-$(CONFIG_SCSI_SAS_DOMAIN_ATTRS)	+= sas/
 
 obj-$(CONFIG_ISCSI_TCP) 	+= iscsi_tcp.o
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
Index: BUILD-2.6/drivers/scsi/aic94xx/Kconfig
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/Kconfig	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/Kconfig	2006-03-02 16:05:15.000000000 -0600
@@ -27,7 +27,8 @@
 
 config SCSI_AIC94XX
 	tristate "Adaptec AIC94xx SAS/SATA support"
-	depends on PCI && SAS_CLASS
+	depends on PCI
+	select SCSI_SAS_DOMAIN_ATTRS
 	help
 		This driver supports Adaptec's SAS/SATA 3Gb/s 64 bit PCI-X
 		AIC94xx chip based host adapters.
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx.h	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx.h	2006-03-02 16:05:15.000000000 -0600
@@ -109,6 +109,6 @@
 int  asd_clear_nexus_ha(struct sas_ha_struct *sas_ha);
 
 /* ---------- Phy Management ---------- */
-int  asd_control_phy(struct sas_phy *phy, enum phy_func func);
+int  asd_control_phy(struct asd_sas_phy *phy, enum phy_func func);
 
 #endif
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_hwi.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-03-02 16:05:15.000000000 -0600
@@ -90,7 +90,7 @@
 static int asd_init_phy(struct asd_phy *phy)
 {
 	struct asd_ha_struct *asd_ha = phy->sas_phy.ha->lldd_ha;
-	struct sas_phy *sas_phy = &phy->sas_phy;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
 	sas_phy->enabled = 1;
 	sas_phy->class = SAS;
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_init.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c	2006-03-02 16:05:15.000000000 -0600
@@ -70,7 +70,7 @@
 	.queuecommand		= sas_queuecommand,
 	.eh_strategy_handler	= sas_scsi_recover_host,
 	.eh_timed_out		= sas_scsi_timed_out,
-	.slave_alloc		= sas_slave_alloc,
+	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
 	.change_queue_depth	= sas_change_queue_depth,
@@ -486,7 +486,8 @@
 static int asd_register_sas_ha(struct asd_ha_struct *asd_ha)
 {
 	int i;
-	static struct sas_phy   *sas_phys[ASD_MAX_PHYS];
+	/* FIXME: this would screw up on >1 aic94xx card */
+	static struct asd_sas_phy   *sas_phys[ASD_MAX_PHYS];
 	static struct sas_port  *sas_ports[ASD_MAX_PHYS];
 
 	asd_ha->sas_ha.sas_ha_name = (char *) asd_ha->name;
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_sas.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_sas.h	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_sas.h	2006-03-02 16:05:15.000000000 -0600
@@ -731,7 +731,7 @@
 /* ---------- PHYS ---------- */
 
 struct asd_phy {
-	struct sas_phy        sas_phy;
+	struct asd_sas_phy        sas_phy;
 	struct asd_phy_desc   *phy_desc; /* hw profile */
 
 	struct sas_identify_frame *identify_frame;
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_scb.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_scb.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_scb.c	2006-03-02 16:05:15.000000000 -0600
@@ -55,13 +55,17 @@
 {
 	switch (oob_mode & 7) {
 	case PHY_SPEED_60:
+		/* FIXME: sas transport class doesn't have this */
 		phy->sas_phy.linkrate = PHY_LINKRATE_6;
+		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
 		break;
 	case PHY_SPEED_30:
 		phy->sas_phy.linkrate = PHY_LINKRATE_3;
+		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	case PHY_SPEED_15:
 		phy->sas_phy.linkrate = PHY_LINKRATE_1_5;
+		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	}
 	if (oob_mode & SAS_MODE)
@@ -125,6 +129,7 @@
 			return k;
 		k++;
 	}
+	return 0;
 }
 
 /**
@@ -184,7 +189,7 @@
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct sas_ha_struct *sas_ha = &asd_ha->sas_ha;
-	struct sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
+	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
 	u8 lr_error = dl->status_block[1];
 	u8 retries_left = dl->status_block[2];
 
@@ -235,7 +240,7 @@
 {
 	unsigned long flags;
 	struct sas_ha_struct *sas_ha = &ascb->ha->sas_ha;
-	struct sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
+	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
 	u8  reg  = dl->status_block[1];
 	u32 cont = dl->status_block[2] << ((reg & 3)*8);
 
@@ -338,7 +343,7 @@
 	int edb = (dl->opcode & DL_PHY_MASK) - 1; /* [0xc1,0xc7] -> [0,6] */
 	u8  sb_opcode = dl->status_block[0];
 	int phy_id = sb_opcode & DL_PHY_MASK;
-	struct sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
+	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
 
 	if (edb > 6 || edb < 0) {
 		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n",
@@ -704,7 +709,7 @@
 	[PHY_FUNC_RELEASE_SPINUP_HOLD] = RELEASE_SPINUP_HOLD,
 };
 
-int asd_control_phy(struct sas_phy *phy, enum phy_func func)
+int asd_control_phy(struct asd_sas_phy *phy, enum phy_func func)
 {
 	struct asd_ha_struct *asd_ha = phy->ha->lldd_ha;
 	struct asd_ascb *ascb;
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_seq.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_seq.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_seq.c	2006-03-02 16:05:15.000000000 -0600
@@ -1286,7 +1286,7 @@
  * port_map_by_links is also used as the conn_mask byte in the
  * initiator/target port DDB.
  */
-void asd_update_port_links(struct sas_phy *sas_phy)
+void asd_update_port_links(struct asd_sas_phy *sas_phy)
 {
 	struct asd_ha_struct *asd_ha = sas_phy->ha->lldd_ha;
 	const u8 phy_mask = (u8) sas_phy->port->phy_mask;
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_seq.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_seq.h	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_seq.h	2006-03-02 16:05:15.000000000 -0600
@@ -35,6 +35,6 @@
 int asd_init_seqs(struct asd_ha_struct *asd_ha);
 int asd_start_seqs(struct asd_ha_struct *asd_ha);
 
-void asd_update_port_links(struct sas_phy *phy);
+void asd_update_port_links(struct asd_sas_phy *phy);
 
 #endif
Index: BUILD-2.6/drivers/scsi/sas/Kconfig
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/Kconfig	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/Kconfig	2006-03-02 16:05:15.000000000 -0600
@@ -24,22 +24,18 @@
 # $Id: //depot/sas-class/Kconfig#6 $
 #
 
-config SAS_CLASS
-	tristate "SAS Layer and Discovery"
+config SCSI_SAS_DOMAIN_ATTRS
+	tristate "SAS Domain Transport Attributes"
 	depends on SCSI
+	select SCSI_SAS_ATTRS
 	help
-		If you wish to use a SAS Low Level Device Driver (LLDD)
-		say Y or M here.  Otherwise, say N.
+	  This provides transport specific helpers for SAS drivers which
+	  use the domain device construct (like the aic94xxx).
 
-		SAS LLDDs which can make use of the SAS Transport Layer
-		are LLDDs who do not hide the transport in firmware.
-		Such LLDDs expose the transport to a management layer.
-		E.g. aic94xx SAS LLDD is such a LLDD.
-
-config SAS_DEBUG
-	bool "Compile the SAS Layer in debug mode"
+config SCSI_SAS_DOMAIN_DEBUG
+	bool "Compile the SAS Domain Transport Attributes in debug mode"
 	default y
-	depends on SAS_CLASS
+	depends on SCSI_SAS_DOMAIN_ATTRS
 	help
 		Compiles the SAS Layer in debug mode.  In debug mode, the
 		SAS Layer prints diagnostic and debug messages.
Index: BUILD-2.6/drivers/scsi/sas/Makefile
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/Makefile	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/Makefile	2006-03-02 16:05:15.000000000 -0600
@@ -24,14 +24,14 @@
 # $Id: //depot/sas-class/Makefile#20 $
 #
 
-ifeq ($(CONFIG_SAS_DEBUG),y)
+ifeq ($(CONFIG_SCSI_SAS_DOMAIN_DEBUG),y)
 	EXTRA_CFLAGS += -DSAS_DEBUG -g
 endif
 
 clean-files += expander_conf
 
-obj-$(CONFIG_SAS_CLASS) += sas_class.o
-sas_class-y +=  sas_init.o     \
+obj-$(CONFIG_SCSI_SAS_DOMAIN_ATTRS) += scsi_transport_sas_domain.o
+scsi_transport_sas_domain-y +=  sas_init.o     \
 		sas_common.o   \
 		sas_phy.o      \
 		sas_port.o     \
Index: BUILD-2.6/drivers/scsi/sas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_discover.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_discover.c	2006-03-02 16:05:15.000000000 -0600
@@ -31,431 +31,6 @@
 #include <scsi/sas/sas_task.h>
 #include <scsi/sas/sas_discover.h>
 
-/* ---------- Domain device attributes ---------- */
-
-ssize_t dev_show_type(struct domain_device *dev, char *page)
-{
-	static const char *dev_type[] = {
-		"no device",
-		"end device",
-		"edge expander",
-		"fanout expander",
-		"host adapter",
-		"sata device",
-		"sata port multiplier",
-		"sata port multiplier port",
-	};
-	return sprintf(page, "%s\n", dev_type[dev->dev_type]);
-}
-
-ssize_t dev_show_iproto(struct domain_device *dev, char *page)
-{
-	return sas_show_proto(dev->iproto, page);
-}
-
-ssize_t dev_show_tproto(struct domain_device *dev, char *page)
-{
-	return sas_show_proto(dev->tproto, page);
-}
-
-ssize_t dev_show_sas_addr(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%llx\n", SAS_ADDR(dev->sas_addr));
-}
-
-ssize_t dev_show_linkrate(struct domain_device *dev, char *page)
-{
-	return sas_show_linkrate(dev->linkrate, page);
-}
-
-ssize_t dev_show_min_linkrate(struct domain_device *dev, char *page)
-{
-	return sas_show_linkrate(dev->min_linkrate, page);
-}
-
-ssize_t dev_show_max_linkrate(struct domain_device *dev, char *page)
-{
-	return sas_show_linkrate(dev->max_linkrate, page);
-}
-
-ssize_t dev_show_pathways(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%d\n", dev->pathways);
-}
-
-/* ---------- SATA specific sysfs ---------- */
-
-static ssize_t sata_show_command_set(struct domain_device *dev, char *page)
-{
-	static const char *cs[] = {
-		"ATA",
-		"ATAPI",
-	};
-	return sprintf(page, "%s\n", cs[dev->sata_dev.command_set]);
-}
-
-static ssize_t sata_show_rps_resp(struct domain_device *dev, char *page)
-{
-	char *buf = page;
-	if ((dev->tproto & SAS_PROTO_STP) &&
-	    dev->sata_dev.rps_resp.frame_type == SMP_RESPONSE &&
-	    dev->sata_dev.rps_resp.function == SMP_REPORT_PHY_SATA &&
-	    dev->sata_dev.rps_resp.result == SMP_RESP_FUNC_ACC) {
-		int i = 0;
-		u8 *p = (u8 *) &dev->sata_dev.rps_resp;
-		for (i = 0; i < sizeof(struct smp_resp); i+=4, p+=4) {
-			buf += sprintf(buf, "%02x %02x %02x %02x\n",
-				       *(p+0), *(p+1), *(p+2), *(p+3));
-		}
-	}
-	return buf-page;
-}
-
-static inline int show_chars(__le16 *p, int start, int words, char *page)
-{
-	int i;
-	char *buf = page;
-
-	for (i = start; i < start+words; i++) {
-		u16  s = le16_to_cpu(p[i]);
-		char a = (s&0xFF00)>>8;
-		char b = s&0x00FF;
-
-		if (a == 0)
-			break;
-		buf += sprintf(buf, "%c", a);
-		if (b == 0)
-			break;
-		buf += sprintf(buf, "%c", b);
-	}
-	return buf-page;
-}
-
-static ssize_t sata_show_serial_number(struct domain_device *dev, char *page)
-{
-	char *buf = page;
-	__le16 *identify_x = NULL;
-
-	if (dev->sata_dev.command_set == ATA_COMMAND_SET)
-		identify_x = dev->sata_dev.identify_device;
-	else
-		identify_x = dev->sata_dev.identify_packet_device;
-
-	if (identify_x &&
-	    (dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM_PORT)) {
-		buf += show_chars(identify_x, 10, 10, buf);
-		buf += sprintf(buf, "\n");
-	}
-	return buf-page;
-}
-
-static ssize_t sata_show_firmware_rev(struct domain_device *dev, char *page)
-{
-	char *buf = page;
-	__le16 *identify_x = NULL;
-
-	if (dev->sata_dev.command_set == ATA_COMMAND_SET)
-		identify_x = dev->sata_dev.identify_device;
-	else
-		identify_x = dev->sata_dev.identify_packet_device;
-
-	if (identify_x &&
-	    (dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM_PORT)) {
-		buf += show_chars(identify_x, 23, 4, buf);
-		buf += sprintf(buf, "\n");
-	}
-	return buf-page;
-}
-
-static ssize_t sata_show_model_number(struct domain_device *dev, char *page)
-{
-	char *buf = page;
-	__le16 *identify_x = NULL;
-
-	if (dev->sata_dev.command_set == ATA_COMMAND_SET)
-		identify_x = dev->sata_dev.identify_device;
-	else
-		identify_x = dev->sata_dev.identify_packet_device;
-
-	if (identify_x &&
-	    (dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM_PORT)) {
-		buf += show_chars(identify_x, 27, 20, buf);
-		buf += sprintf(buf, "\n");
-	}
-	return buf-page;
-}
-
-static ssize_t sata_show_identify_device(struct domain_device *dev, char *page)
-{
-	char *buf = page;
-
-	if (dev->sata_dev.identify_device &&
-	    (dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM_PORT)) {
-		__le16 *p = dev->sata_dev.identify_device;
-		int i;
-
-		for (i = 0; i < 16; i++) {
-			int k;
-			for (k = 0; k < 16; k++)
-				buf += sprintf(buf, "%04x%s",
-					      le16_to_cpu(p[i*16+k]),
-					      k==15 ? "\n" : " ");
-		}
-	}
-	return buf-page;
-}
-
-static ssize_t sata_show_identify_packet(struct domain_device *dev, char *page)
-{
-	char *buf = page;
-
-	if (dev->sata_dev.identify_packet_device &&
-	    (dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM_PORT)) {
-		__le16 *p = dev->sata_dev.identify_packet_device;
-		int i;
-
-		for (i = 0; i < 16; i++) {
-			int k;
-			for (k = 0; k < 16; k++)
-				buf += sprintf(buf, "%04x%s",
-					      le16_to_cpu(p[i*16+k]),
-					      k==15 ? "\n" : " ");
-		}
-	}
-
-	return buf-page;
-}
-
-static ssize_t sata_show_port_no(struct domain_device *dev, char *page)
-{
-	int res = 0;
-
-	if (dev->dev_type == SATA_PM || dev->dev_type == SATA_PM_PORT)
-		res = sprintf(page, "%02Xh\n", dev->sata_dev.port_no);
-	return res;
-}
-
-/* ---------- SAS end device specific ---------- */
-
-static ssize_t sas_show_rled_meaning(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%d\n", dev->end_dev.ready_led_meaning);
-}
-
-static ssize_t sas_show_itnl_timeout(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "0x%04x\n", dev->end_dev.itnl_timeout);
-}
-
-static ssize_t sas_show_iresp_timeout(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "0x%04x\n", dev->end_dev.iresp_timeout);
-}
-
-static ssize_t sas_show_rl_wlun(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%d\n", dev->end_dev.rl_wlun);
-}
-
-/* ---------- LU specific ---------- */
-
-static ssize_t lu_show_lun(struct LU *lu, char *page)
-{
-	return sprintf(page, "%016llx\n", SAS_ADDR(lu->LUN));
-}
-
-static ssize_t lu_show_inq(struct LU *lu, char *_page)
-{
-	int i;
-	char *buf = _page;
-	if (lu->inquiry_valid_data_len <= 0)
-		return 0;
-	for (i = 0; i < lu->inquiry_valid_data_len; i += 4) {
-		buf += sprintf(buf, "%02x %02x %02x %02x\n",
-			       lu->inquiry_data[i+0], lu->inquiry_data[i+1],
-			       lu->inquiry_data[i+2], lu->inquiry_data[i+3]);
-	}
-	return buf-_page;
-}
-
-static ssize_t lu_show_tm_type(struct LU *lu, char *page)
-{
-	static const char *tm_type[] = {
-		"none",
-		"full",
-		"basic",
-	};
-	return sprintf(page, "%s\n", tm_type[lu->tm_type]);
-}
-
-static ssize_t lu_show_channel(struct LU *lu, char *page)
-{
-	if (lu->uldd_dev)
-		return sprintf(page, "%d\n", lu->map.channel);
-	return 0;
-}
-
-static ssize_t lu_show_id(struct LU *lu, char *page)
-{
-	if (lu->uldd_dev)
-		return sprintf(page, "%d\n", lu->map.id);
-	return 0;
-}
-
-/* ---------- Sysfs attribute implementation ---------- */
-
-struct lu_dev_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct LU *lu, char *);
-	ssize_t (*store)(struct LU *lu, const char *, size_t);
-};
-
-static struct lu_dev_attribute lu_attrs[] = {
-	__ATTR(lun, 0444, lu_show_lun, NULL),
-	__ATTR(inquiry_data, 0444, lu_show_inq, NULL),
-	__ATTR(channel, 0444, lu_show_channel, NULL),
-	__ATTR(id, 0444, lu_show_id, NULL),
-	__ATTR(task_management, 0444, lu_show_tm_type, NULL),
-	__ATTR_NULL,
-};
-
-static struct domain_dev_attribute dev_attrs[] = {
-	__ATTR(dev_type, 0444, dev_show_type, NULL),
-	__ATTR(iproto, 0444, dev_show_iproto, NULL),
-	__ATTR(tproto, 0444, dev_show_tproto, NULL),
-	__ATTR(sas_addr, 0444, dev_show_sas_addr, NULL),
-	__ATTR(ready_led_meaning, 0444, sas_show_rled_meaning, NULL),
-	__ATTR(itnl_timeout, 0444, sas_show_itnl_timeout, NULL),
-	__ATTR(iresp_timeout, 0444, sas_show_iresp_timeout, NULL),
-	__ATTR(rl_wlun, 0444, sas_show_rl_wlun, NULL),
-	__ATTR(linkrate, 0444, dev_show_linkrate, NULL),
-	__ATTR(min_linkrate, 0444, dev_show_min_linkrate, NULL),
-	__ATTR(max_linkrate, 0444, dev_show_max_linkrate, NULL),
-	__ATTR(pathways, 0444, dev_show_pathways, NULL),
-	__ATTR_NULL,
-};
-
-static struct domain_dev_attribute sata_attrs[] = {
-	__ATTR(dev_type, 0444, dev_show_type, NULL),
-	__ATTR(iproto, 0444, dev_show_iproto, NULL),
-	__ATTR(tproto, 0444, dev_show_tproto, NULL),
-	__ATTR(sas_addr, 0444, dev_show_sas_addr, NULL),
-	__ATTR(linkrate, 0444, dev_show_linkrate, NULL),
-	__ATTR(min_linkrate, 0444, dev_show_min_linkrate, NULL),
-	__ATTR(max_linkrate, 0444, dev_show_max_linkrate, NULL),
-	__ATTR(command_set, 0444, sata_show_command_set, NULL),
-	__ATTR(report_phy_sata_resp, 0444, sata_show_rps_resp, NULL),
-	__ATTR(serial_number, 0444, sata_show_serial_number, NULL),
-	__ATTR(firmware_rev, 0444, sata_show_firmware_rev, NULL),
-	__ATTR(model_number, 0444, sata_show_model_number, NULL),
-	__ATTR(identify_device, 0444, sata_show_identify_device, NULL),
-	__ATTR(identify_packet_device, 0444, sata_show_identify_packet, NULL),
-	__ATTR(port_no, 0444, sata_show_port_no, NULL),
-	__ATTR_NULL,
-};
-
-static void end_dev_release(struct kobject *obj)
-{
-	struct domain_device *dev = to_dom_device(obj);
-	BUG_ON(!list_empty(&dev->end_dev.LU_list));
-	SAS_DPRINTK("freeing dev %llx\n", SAS_ADDR(dev->sas_addr));
-	kfree(dev);
-}
-
-static void sata_dev_release(struct kobject *obj)
-{
-	struct domain_device *dev = to_dom_device(obj);
-
-	SAS_DPRINTK("freeing SATA dev %llx\n", SAS_ADDR(dev->sas_addr));
-	/* XXX Hint: unregister this SATA device with SATL.
-	if (dev->sata_dev->lu)
-		sas_satl_unregister_dev(dev);
-	*/
-	if (dev->sata_dev.identify_device) {
-		void *p = dev->sata_dev.identify_device;
-		mb();
-		dev->sata_dev.identify_device = NULL;
-		kfree(p);
-	}
-	if (dev->sata_dev.identify_packet_device) {
-		void *p = dev->sata_dev.identify_packet_device;
-		mb();
-		dev->sata_dev.identify_packet_device = NULL;
-		kfree(p);
-	}
-	kfree(dev);
-}
-
-static void sas_lu_release(struct kobject *obj)
-{
-	struct LU *lu = to_lu_device(obj);
-	SAS_DPRINTK("freeing LUN %016llx\n", SAS_ADDR(lu->LUN));
-	sas_release_scsi_id(lu->parent->port, lu->map.id);
-	kfree(lu);
-}
-
-static ssize_t dev_show_attr(struct kobject *kobj, struct attribute *attr,
-			     char *page)
-{
-	ssize_t ret = 0;
-	struct domain_device *dev = to_dom_device(kobj);
-	struct domain_dev_attribute *dev_attr = to_dev_attr(attr);
-
-	if (dev_attr->show)
-		ret = dev_attr->show(dev, page);
-	return ret;
-}
-
-static ssize_t lu_show_attr(struct kobject *obj, struct attribute *attr,
-			    char *page)
-{
-	ssize_t ret = 0;
-	struct LU *lu = to_lu_device(obj);
-	struct lu_dev_attribute *lu_attr = to_lu_attr(attr);
-
-	if (lu_attr->show)
-		ret = lu_attr->show(lu, page);
-	return ret;
-}
-
-struct sysfs_ops dev_sysfs_ops = {
-	.show = dev_show_attr,
-};
-static struct sysfs_ops lu_sysfs_ops = {
-	.show = lu_show_attr,
-};
-
-static struct attribute *end_dev_attrs[ARRAY_SIZE(dev_attrs)];
-static struct attribute *sata_dev_attrs[ARRAY_SIZE(sata_attrs)];
-static struct attribute *lu_dev_attrs[ARRAY_SIZE(lu_attrs)];
-
-static struct kobj_type end_dev_ktype = {
-	.release = end_dev_release,
-	.sysfs_ops = &dev_sysfs_ops,
-	.default_attrs = end_dev_attrs,
-};
-static struct kobj_type sata_dev_ktype = {
-	.release = sata_dev_release,
-	.sysfs_ops = &dev_sysfs_ops,
-	.default_attrs = sata_dev_attrs,
-};
-static struct kobj_type lu_dev_ktype = {
-	.release = sas_lu_release,
-	.sysfs_ops = &lu_sysfs_ops,
-	.default_attrs = lu_dev_attrs,
-};
-
-struct kobj_type *dev_ktype[] = {
-	NULL,
-	&end_dev_ktype,
-	&ex_dev_ktype,
-	&ex_dev_ktype,
-	NULL,
-	&sata_dev_ktype,
-	NULL,
-	NULL,
-};
-
 /* ---------- Basic task processing for discovery purposes ---------- */
 
 static void sas_task_timedout(unsigned long _task)
@@ -614,7 +189,8 @@
 static int sas_get_port_device(struct sas_port *port)
 {
 	unsigned long flags;
-	struct sas_phy *phy;
+	struct asd_sas_phy *phy;
+	struct sas_rphy *rphy;
 	struct domain_device *dev;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -627,7 +203,14 @@
 		kfree(dev);
 		return -ENODEV;
 	}
-	phy = container_of(port->phy_list.next, struct sas_phy, port_phy_el);
+	phy = container_of(port->phy_list.next, struct asd_sas_phy, port_phy_el);
+	rphy = sas_rphy_alloc(phy->phy);
+	if (!rphy) {
+		spin_unlock_irqrestore(&port->phy_list_lock, flags);
+		kfree(dev);
+		return -ENODEV;
+	}
+	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	spin_lock(&phy->frame_rcvd_lock);
 	memcpy(dev->frame_rcvd, phy->frame_rcvd, min(sizeof(dev->frame_rcvd),
 					     (size_t)phy->frame_rcvd_size));
@@ -655,6 +238,25 @@
 	sas_init_dev(dev);
 
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
+	rphy->identify.sas_address = SAS_ADDR(dev->sas_addr);
+	rphy->identify.initiator_port_protocols = dev->iproto;
+	rphy->identify.target_port_protocols = dev->tproto;
+	switch (dev->dev_type) {
+	case SATA_DEV:
+		/* FIXME: need sata device type */
+	case SAS_END_DEV:
+		rphy->identify.device_type = SAS_END_DEVICE;
+		break;
+	case EDGE_DEV:
+		rphy->identify.device_type = SAS_EDGE_EXPANDER_DEVICE;
+		break;
+	case FANOUT_DEV:
+		rphy->identify.device_type = SAS_FANOUT_EXPANDER_DEVICE;
+		break;
+	default:
+		rphy->identify.device_type = SAS_PHY_UNUSED;
+		break;
+	}
 	sas_hash_addr(dev->hashed_sas_addr, dev->sas_addr);
 	port->port_dev = dev;
 	dev->port = port;
@@ -667,6 +269,11 @@
 	memset(port->disc.eeds_b, 0, SAS_ADDR_SIZE);
 	port->disc.max_level = 0;
 
+	dev->rphy = rphy;
+	spin_lock(&port->dev_list_lock);
+	list_add_tail(&dev->dev_list_node, &port->dev_list);
+	spin_unlock(&port->dev_list_lock);
+
 	return 0;
 }
 
@@ -758,7 +365,7 @@
 {
 	unsigned long flags;
 	struct sas_port *port = dev->port;
-	struct sas_phy  *phy;
+	struct asd_sas_phy  *phy;
 
 	BUG_ON(dev->parent);
 
@@ -930,236 +537,8 @@
 	return res;
 }
 
-static int sas_get_report_luns(struct domain_device *dev, u8 **buffer,
-			       int *size)
-{
-	static const u8 report_luns[16] = { 0xA0, };
-	static const u8 RL_WLUN[8] = { 0xC1, 0x01, };
-
-	int res = -ENOMEM;
-	struct sas_task *task;
-	u8 *buf;
-	int buffer_size = 16;
-	u32 len;
-
-	*buffer = kzalloc(buffer_size, GFP_KERNEL);
-	if (!*buffer)
-		return -ENOMEM;
-	buf = *buffer;
-
-	task = sas_alloc_task(GFP_KERNEL);
-	if (!task)
-		goto out_err;
-
-	task->dev = dev;
-	task->ssp_task.retry_count = 1;
-	memcpy(task->ssp_task.cdb, report_luns, 16);
-	*(__be32 *)(&task->ssp_task.cdb[6]) = cpu_to_be32(buffer_size);
-
-	res = sas_execute_task(task, buf, buffer_size, PCI_DMA_FROMDEVICE);
-	if (res) {
-		SAS_DPRINTK("REPORT LUNS to LUN0 failed for device %llx "
-			    "with status:0x%x\n",
-			    SAS_ADDR(dev->sas_addr), task->task_status.stat);
-		memcpy(task->ssp_task.LUN, RL_WLUN, 8);
-		res = sas_execute_task(task, buf, buffer_size,
-				       PCI_DMA_FROMDEVICE);
-		if (res) {
-			SAS_DPRINTK("REPORT LUNS to REPORT LUNS W-LUN failed "
-				    "for device %llx with status:0x%x\n",
-				    SAS_ADDR(dev->sas_addr),
-				    task->task_status.stat);
-			goto out_err_task;
-		}
-		dev->end_dev.rl_wlun = 1;
-	}
-
-	len = be32_to_cpu(*(__be32 *)buf);
-	if (len + 8 > buffer_size) {
-		SAS_DPRINTK("need bigger buffer for REPORT LUNS\n");
-		buffer_size = len + 8;
-		res = -ENOMEM;
-		buf = kzalloc(buffer_size, GFP_KERNEL);
-		if (!buf)
-			goto out_err_task;
-		kfree(*buffer);
-		*buffer = buf;
-		if (dev->end_dev.rl_wlun)
-			memcpy(task->ssp_task.LUN, RL_WLUN, 8);
-		else
-			memset(task->ssp_task.LUN, 0, 8);
-		res = sas_execute_task(task, buf, buffer_size,
-				       PCI_DMA_FROMDEVICE);
-		if (res) {
-			SAS_DPRINTK("2nd REPORT LUNS to %s failed "
-				    "for device %llx with status:0x%x\n",
-				    dev->end_dev.rl_wlun ? "REPORT LUNS W-LUN"
-				    : "LUN0",
-				    SAS_ADDR(dev->sas_addr),
-				    task->task_status.stat);
-			goto out_err_task;
-		}
-	}
-
-	*size = len+8;
-	sas_free_task(task);
-	return 0;
-
-out_err_task:
-	sas_free_task(task);
-out_err:
-	kfree(*buffer);
-	*buffer = NULL;
-	size = 0;
-	return res;
-}
-
-#if 0
-static int sas_get_inquiry(struct LU *lu)
-{
-	static const u8 inquiry_cmd[16] = { 0x12, };
-	struct sas_task *task;
-	int res;
-
-	task = sas_alloc_task(GFP_KERNEL);
-	if (!task)
-		return -ENOMEM;
-
-	task->dev = lu->parent;
-	task->ssp_task.retry_count = 1;
-	memcpy(task->ssp_task.LUN, lu->LUN, 8);
-	memcpy(task->ssp_task.cdb, inquiry_cmd, 16);
-	*(__be16 *)(task->ssp_task.cdb+3) = cpu_to_be16(SAS_INQUIRY_DATA_LEN);
-
-	res = sas_execute_task(task, lu->inquiry_data, SAS_INQUIRY_DATA_LEN,
-			       PCI_DMA_FROMDEVICE);
-	if (!res)
-		lu->inquiry_valid_data_len = min(SAS_INQUIRY_DATA_LEN,
-						 lu->inquiry_data[4]+5);
-	sas_free_task(task);
-	return res;
-}
-#endif
-
-static struct LU *sas_alloc_lu(void)
-{
-	struct LU *lu = kzalloc(sizeof(*lu), GFP_KERNEL);
-	if (lu)
-		INIT_LIST_HEAD(&lu->list);
-	return lu;
-}
-
-static int sas_register_lu(struct domain_device *dev, u8 *buf, int size)
-{
-#if 0
-	int res;
-
-	for (buf = buf+8, size -= 8; size > 0; size -= 8, buf += 8) {
-		struct LU *lu = sas_alloc_lu();
-
-		SAS_DPRINTK("%016llx probing LUN:%016llx\n",
-			    SAS_ADDR(dev->sas_addr),
-			    be64_to_cpu(*(__be64 *)buf));
-		if (lu) {
-			lu->parent = dev;
-			memcpy(lu->LUN, buf, 8);
-			res = sas_get_inquiry(lu);
-			if (res) {
-				SAS_DPRINTK("dev %llx LUN %016llx didn't reply"
-					    " to INQUIRY, forgotten\n",
-					    SAS_ADDR(dev->sas_addr),
-					    SAS_ADDR(lu->LUN));
-				kfree(lu);
-				continue;
-			}
-			lu->lu_obj.kset = &dev->end_dev.LU_kset;
-			kobject_set_name(&lu->lu_obj, "%016llx",
-					 SAS_ADDR(lu->LUN));
-			lu->lu_obj.ktype = dev->end_dev.LU_kset.ktype;
-			list_add_tail(&lu->list, &dev->end_dev.LU_list);
-		}
-	}
-#else
-	struct LU *lu = sas_alloc_lu();
-	if (!lu)
-		goto out;
-	
-	lu->parent = dev;
-	memset(lu->LUN, 0, 8);
-
-	lu->lu_obj.kset = &dev->end_dev.LU_kset;
-	kobject_set_name(&lu->lu_obj, "%016llx",
-			 SAS_ADDR(lu->LUN));
-	lu->lu_obj.ktype = dev->end_dev.LU_kset.ktype;
-	list_add_tail(&lu->list, &dev->end_dev.LU_list);
-out:
-#endif
-
-	return list_empty(&dev->end_dev.LU_list) ? -ENODEV : 0;
-}
-
-/**
- * sas_do_lu_discovery -- Discover LUs of a SCSI device
- * @dev: pointer to a domain device of interest
- *
- * Discover logical units present in the SCSI device.  I'd like this
- * to be moved to SCSI Core, but SCSI Core has no concept of a "SCSI
- * device with a SCSI Target port".  A SCSI device with a SCSI Target
- * port is a device which the _transport_ found, but other than that,
- * the transport has little or _no_ knowledge about the device.
- * Ideally, a LLDD would register a "SCSI device with a SCSI Target
- * port" with SCSI Core and then SCSI Core would do LU discovery of
- * that device.
- *
- * REPORT LUNS is mandatory.  If a device doesn't support it,
- * it is broken and you should return it.  Nevertheless, we
- * assume (optimistically) that the link hasn't been severed and
- * that maybe we can get to the device anyhow.
- */
-static int sas_do_lu_discovery(struct domain_device *dev)
-{
-	int  res;
-	u8  *buffer;
-	int  size;
-
-	res = sas_get_report_luns(dev, &buffer, &size);
-	if (res) {
-		SAS_DPRINTK("dev %llx didn't reply to REPORT LUNS, trying "
-			    "LUN 0 anyway\n",
-			    SAS_ADDR(dev->sas_addr));
-		size = 16;
-		buffer = kzalloc(size, GFP_KERNEL);
-	}
-
-	res = sas_register_lu(dev, buffer, size);
-	if (res) {
-		SAS_DPRINTK("dev %llx didn't report any LUs\n",
-			    SAS_ADDR(dev->sas_addr));
-		res = 0;
-	}
-
-	kfree(buffer);
-	return res;
-}
-
 /* ---------- Common/dispatchers ---------- */
 
-void sas_kobj_set(struct domain_device *dev)
-{
-	if (!dev->parent) {
-		/* device directly attached to the host adapter */
-		dev->dev_obj.kset = &dev->port->dev_kset;
-	} else {
-		/* parent is an expander */
-		dev->dev_obj.parent = &dev->parent->dev_obj;
-		dev->port = dev->parent->port;
-	}
-
-	list_add_tail(&dev->dev_list_node, &dev->port->dev_list);
-	kobject_set_name(&dev->dev_obj, "%016llx", SAS_ADDR(dev->sas_addr));
-	dev->dev_obj.ktype = dev_ktype[dev->dev_type];
-}
-
 /**
  * sas_discover_sata -- discover an STP/SATA domain device
  * @dev: pointer to struct domain_device of interest
@@ -1199,7 +578,6 @@
 	sas_notify_lldd_dev_gone(dev);
 	if (!res) {
 		sas_notify_lldd_dev_found(dev);
-		sas_kobj_set(dev);
 	}
 	return res;
 }
@@ -1224,16 +602,10 @@
 		sas_notify_lldd_dev_found(dev);
 	}
 
-	dev->end_dev.LU_kset.kobj.parent = &dev->dev_obj;
-	dev->end_dev.LU_kset.ktype  = &lu_dev_ktype;
-
-	res = sas_do_lu_discovery(dev);
+	res = sas_rphy_add(dev->rphy);
 	if (res)
 		goto out_err;
 
-	kobject_set_name(&dev->end_dev.LU_kset.kobj, "%s", "LUNS");
-
-	sas_kobj_set(dev);
 	return 0;
 
 out_err:
@@ -1251,130 +623,11 @@
 	else
 		list_del_init(&dev->siblings);
 	list_del_init(&dev->dev_list_node);
-	kobject_unregister(&dev->dev_obj);
-}
-
-static int sas_register_end_dev(struct domain_device *dev)
-{
-	struct LU *lu;
-
-	kobject_register(&dev->dev_obj);
-	kset_register(&dev->end_dev.LU_kset);
-
-	list_for_each_entry(lu, &dev->end_dev.LU_list, list) {
-		sas_register_with_scsi(lu);
-	}
-
-	return 0;
-}
-
-static void sas_unregister_end_dev(struct domain_device *dev)
-{
-	struct LU *lu, *n;
-
-	list_for_each_entry_safe(lu, n, &dev->end_dev.LU_list, list) {
-		sas_unregister_with_scsi(lu);
-		list_del_init(&lu->list);
-	}
-	kset_unregister(&dev->end_dev.LU_kset);
-	sas_unregister_common_dev(dev);
-}
-
-static int sas_register_sata(struct domain_device *dev)
-{
-	/* XXX Hint: Register the SATL supported LU with SCSI.
-	if (dev->sata_dev->lu)
-		sas_register_with_scsi(dev->sata_dev->lu)
-	*/
-	kobject_register(&dev->dev_obj);
-	return 0;
-}
-
-static void sas_unregister_sata(struct domain_device *dev)
-{
-	/* XXX Hint: See hint above.
-	if (dev->sata_dev->lu)
-		sas_unregister_with_scsi(dev->sata_dev->lu);
-	*/
-	sas_unregister_common_dev(dev);
-}
-
-/**
- * sas_register_ex_dev -- Register this expander
- * @ex: pointer to domain device
- *
- * It is imperative that this is done breadth-first.  Other parts of
- * the code rely on that.
- */
-static int sas_register_ex_dev(struct domain_device *dev)
-{
-	kobject_register(&dev->dev_obj);
-	sysfs_create_bin_file(&dev->dev_obj, &dev->ex_dev.smp_bin_attr);
-	return 0;
-}
-
-static void sas_unregister_ex_dev(struct domain_device *dev)
-{
-	BUG_ON(!list_empty(&dev->ex_dev.children));
-	sas_unregister_common_dev(dev);
-}
-
-/**
- * sas_register_domain_devs -- register the domain devices with sysfs
- * @port: the port to the domain
- *
- * This function registers the domain devices with sysfs and with
- * the SCSI subsystem.
- */
-static int sas_register_domain_devs(struct sas_port *port)
-{
-	struct domain_device *dev;
-
-	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-		if (dev->dev_obj.dentry)
-			continue;
-		switch (dev->dev_type) {
-		case SAS_END_DEV:
-			sas_register_end_dev(dev);
-			break;
-		case EDGE_DEV:
-		case FANOUT_DEV:
-			sas_register_ex_dev(dev);
-			break;
-		case SATA_DEV:
-		case SATA_PM:
-			sas_register_sata(dev);
-			break;
-		default:
-			SAS_DPRINTK("%s: unknown device type %d\n",
-				    __FUNCTION__, dev->dev_type);
-			break;
-		}
-	}
-
-	return 0;
 }
 
 void sas_unregister_dev(struct domain_device *dev)
 {
-	switch (dev->dev_type) {
-	case SAS_END_DEV:
-		sas_unregister_end_dev(dev);
-		break;
-	case EDGE_DEV:
-	case FANOUT_DEV:
-		sas_unregister_ex_dev(dev);
-		break;
-	case SATA_DEV:
-	case SATA_PM:
-		sas_unregister_sata(dev);
-		break;
-	default:
-		SAS_DPRINTK("%s: unknown device type %d\n",
-			    __FUNCTION__, dev->dev_type);
-		BUG_ON(dev);
-		break;
-	}
+	sas_rphy_delete(dev->rphy);
 }
 
 static void sas_unregister_domain_devices(struct sas_port *port)
@@ -1431,8 +684,7 @@
 	if (error) {
 		kfree(port->port_dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
-	} else
-		sas_register_domain_devs(port);
+	}
 
 	SAS_DPRINTK("DONE DISCOVERY on port %d, pid:%d, result:%d\n", port->id,
 		    current->pid, error);
@@ -1446,11 +698,9 @@
 
 	SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
 		    current->pid);
-	if (port->port_dev) {
+	if (port->port_dev)
 		res = sas_ex_revalidate_domain(port->port_dev);
-		if (!res)
-			sas_register_domain_devs(port);
-	}
+
 	SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
 		    port->id, current->pid, res);
 	return res;
@@ -1564,19 +814,6 @@
 {
 	int i;
 
-	if (!end_dev_attrs[0]) {
-		for (i = 0; i < ARRAY_SIZE(dev_attrs)-1; i++)
-			end_dev_attrs[i] = &dev_attrs[i].attr;
-		end_dev_attrs[i] = NULL;
-		sas_init_ex_attr();
-		for (i = 0; i < ARRAY_SIZE(sata_attrs)-1; i++)
-			sata_dev_attrs[i] = &sata_attrs[i].attr;
-		sata_dev_attrs[i] = NULL;
-		for (i = 0; i < ARRAY_SIZE(lu_attrs)-1; i++)
-			lu_dev_attrs[i] = &lu_attrs[i].attr;
-		lu_dev_attrs[i] = NULL;
-	}
-
 	spin_lock_init(&disc->disc_event_lock);
 	INIT_LIST_HEAD(&disc->disc_event_list);
 	init_MUTEX(&disc->disc_sema);
Index: BUILD-2.6/drivers/scsi/sas/sas_event.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_event.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_event.c	2006-03-02 16:05:15.000000000 -0600
@@ -70,7 +70,7 @@
 #include "sas_dump.h"
 #include <scsi/sas/sas_discover.h>
 
-static void sas_process_phy_event(struct sas_phy *phy)
+static void sas_process_phy_event(struct asd_sas_phy *phy)
 {
 	unsigned long flags;
 	struct sas_ha_struct *sas_ha = phy->ha;
@@ -106,7 +106,7 @@
 	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
 }
 
-static void sas_process_port_event(struct sas_phy *phy)
+static void sas_process_port_event(struct asd_sas_phy *phy)
 {
 	unsigned long flags;
 	struct sas_ha_struct *sas_ha = phy->ha;
@@ -206,7 +206,7 @@
 	spin_unlock_irqrestore(&sas_ha->event_lock, flags);
 }
 
-static void notify_port_event(struct sas_phy *phy, enum port_event event)
+static void notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 {
 	struct sas_ha_struct *ha = phy->ha;
 	unsigned long flags;
@@ -218,7 +218,7 @@
 	spin_unlock_irqrestore(&ha->event_lock, flags);
 }
 
-static void notify_phy_event(struct sas_phy *phy, enum phy_event event)
+static void notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 {
 	struct sas_ha_struct *ha = phy->ha;
 	unsigned long flags;
Index: BUILD-2.6/drivers/scsi/sas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_expander.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_expander.c	2006-03-02 16:22:33.000000000 -0600
@@ -34,118 +34,11 @@
 static int sas_configure_routing(struct domain_device *dev, u8 *sas_addr);
 static int sas_disable_routing(struct domain_device *dev,  u8 *sas_addr);
 
+#if 0
+/* FIXME: smp needs to migrate into the sas class */
 static ssize_t smp_portal_read(struct kobject *, char *, loff_t, size_t);
 static ssize_t smp_portal_write(struct kobject *, char *, loff_t, size_t);
-
-/* ---------- Expander attributes ---------- */
-
-static ssize_t ex_show_change_count(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%d\n", dev->ex_dev.ex_change_count);
-}
-
-static ssize_t ex_show_max_route_indexes(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%d\n", dev->ex_dev.max_route_indexes);
-}
-
-static ssize_t ex_show_num_phys(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%d\n", dev->ex_dev.num_phys);
-}
-
-static ssize_t ex_show_enclosure_logical_id(struct domain_device *dev,
-					    char *page)
-{
-	return sprintf(page, "%llx\n",
-		       SAS_ADDR(dev->ex_dev.enclosure_logical_id));
-}
-
-static ssize_t ex_show_vendor_id(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%s\n", dev->ex_dev.vendor_id);
-}
-
-static ssize_t ex_show_product_id(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%s\n", dev->ex_dev.product_id);
-}
-
-static ssize_t ex_show_product_rev(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%s\n", dev->ex_dev.product_rev);
-}
-
-static ssize_t ex_show_component_vendor_id(struct domain_device *dev,
-					   char *page)
-{
-	return sprintf(page, "%s\n", dev->ex_dev.component_vendor_id);
-}
-
-static ssize_t ex_show_component_id(struct domain_device *dev, char *page)
-{
-	return sprintf(page, "%d\n", dev->ex_dev.component_id);
-}
-
-static ssize_t ex_show_component_revision_id(struct domain_device *dev,
-					     char *page)
-{
-	return sprintf(page, "%d\n", dev->ex_dev.component_revision_id);
-}
-
-static ssize_t ex_show_conf_route_table(struct domain_device *dev,
-					char *page)
-{
-	return sprintf(page, "%d\n", dev->ex_dev.conf_route_table);
-}
-
-static ssize_t ex_show_configuring(struct domain_device *dev,
-				   char *page)
-{
-	return sprintf(page, "%d\n", dev->ex_dev.configuring);
-}
-
-static struct domain_dev_attribute ex_attrs[] = {
-	__ATTR(dev_type, 0444, dev_show_type, NULL),
-	__ATTR(iproto, 0444, dev_show_iproto, NULL),
-	__ATTR(tproto, 0444, dev_show_tproto, NULL),
-	__ATTR(sas_addr, 0444, dev_show_sas_addr, NULL),
-	__ATTR(linkrate, 0444, dev_show_linkrate, NULL),
-	__ATTR(min_linkrate, 0444, dev_show_min_linkrate, NULL),
-	__ATTR(max_linkrate, 0444, dev_show_max_linkrate, NULL),
-	__ATTR(pathways, 0444, dev_show_pathways, NULL),
-	__ATTR(change_count, 0444, ex_show_change_count, NULL),
-	__ATTR(max_route_indexes, 0444, ex_show_max_route_indexes, NULL),
-	__ATTR(num_phys, 0444, ex_show_num_phys, NULL),
-	__ATTR(enclosure_logical_id, 0444, ex_show_enclosure_logical_id, NULL),
-	__ATTR(vendor_id, 0444, ex_show_vendor_id, NULL),
-	__ATTR(product_id, 0444, ex_show_product_id, NULL),
-	__ATTR(product_rev, 0444, ex_show_product_rev, NULL),
-	__ATTR(component_vendor_id, 0444, ex_show_component_vendor_id, NULL),
-	__ATTR(component_id, 0444, ex_show_component_id, NULL),
-	__ATTR(component_revision_id, 0444,ex_show_component_revision_id,NULL),
-	__ATTR(conf_route_table, 0444, ex_show_conf_route_table, NULL),
-	__ATTR(configuring, 0444, ex_show_configuring, NULL),
-	__ATTR_NULL,
-};
-
-static struct attribute *ex_dev_attrs[ARRAY_SIZE(ex_attrs)];
-
-static void ex_dev_release(struct kobject *obj)
-{
-	struct domain_device *dev = to_dom_device(obj);
-	SAS_DPRINTK("freeing dev %016llx\n", SAS_ADDR(dev->sas_addr));
-	sysfs_remove_bin_file(&dev->dev_obj, &dev->ex_dev.smp_bin_attr);
-	kfree(dev->ex_dev.ex_phy);
-	kfree(dev->ex_dev.smp_req);
-	kfree(dev);
-}
-
-struct kobj_type ex_dev_ktype = {
-	.release = ex_dev_release,
-	.sysfs_ops = &dev_sysfs_ops,
-	.default_attrs = ex_dev_attrs,
-};
+#endif
 
 /* ---------- SMP task management ---------- */
 
@@ -1284,6 +1177,7 @@
 	return 0;
 }
 
+#if 0
 #define SMP_BIN_ATTR_NAME "smp_portal"
 
 static void sas_ex_smp_hook(struct domain_device *dev)
@@ -1306,6 +1200,7 @@
 	ex_dev->smp_portal_pid = -1;
 	init_MUTEX(&ex_dev->smp_sema);
 }
+#endif
 
 /**
  * sas_discover_expander -- expander discovery
@@ -1339,8 +1234,6 @@
 	res = sas_check_parent_topology(dev);
 	if (res)
 		goto out_err;
-	sas_ex_smp_hook(dev);
-	sas_kobj_set(dev);
 	return 0;
 out_err:
 	sas_notify_lldd_dev_gone(dev);
@@ -1391,15 +1284,6 @@
 	return res;
 }
 
-void sas_init_ex_attr(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ex_attrs)-1; i++)
-		ex_dev_attrs[i] = &ex_attrs[i].attr;
-	ex_dev_attrs[i] = NULL;
-}
-
 /* ---------- Domain revalidation ---------- */
 
 static int sas_get_phy_discover(struct domain_device *dev,
@@ -1752,6 +1636,7 @@
 	return res;
 }
 
+#if 0
 /* ---------- SMP portal ---------- */
 
 static ssize_t smp_portal_write(struct kobject *kobj, char *buf, loff_t offs,
@@ -1821,3 +1706,4 @@
 	up(&ex->smp_sema);
 	return res;
 }
+#endif
Index: BUILD-2.6/drivers/scsi/sas/sas_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_init.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_init.c	2006-03-02 16:05:15.000000000 -0600
@@ -29,10 +29,13 @@
 #include <linux/device.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_sas.h>
 
 #include "sas_internal.h"
 #include <scsi/sas/sas_task.h>
 
+static struct scsi_transport_template *sas_transport_template;
+
 kmem_cache_t *sas_task_cache;
 
 /* ---------- HA events ---------- */
@@ -42,71 +45,10 @@
 	;
 }
 
-/* ---------- HA attributes ---------- */
-
-static ssize_t sas_ha_name_show(struct sas_ha_struct *sas_ha, char *buf)
-{
-	if (sas_ha->sas_ha_name)
-		return sprintf(buf, "%s\n", sas_ha->sas_ha_name);
-	return 0;
-}
-
-static ssize_t sas_ha_addr_show(struct sas_ha_struct *sas_ha, char *buf)
-{
-	return sprintf(buf, "%llx\n", SAS_ADDR(sas_ha->sas_addr));
-}
-
-/* ---------- SAS HA Class ---------- */
-
-#define to_sas_ha(_obj) container_of(to_kset(_obj),struct sas_ha_struct,ha_kset)
-#define to_ha_attr(_attr) container_of(_attr, struct ha_attribute, attr)
-
-struct ha_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct sas_ha_struct *sas_ha, char *);
-	ssize_t (*store)(struct sas_ha_struct *sas_ha,const char *,size_t len);
-};
-
-static ssize_t ha_show_attr(struct kobject *kobj,
-		     struct attribute *attr,
-		     char *page)
-{
-	ssize_t ret = 0;
-	struct sas_ha_struct *sas_ha = to_sas_ha(kobj);
-	struct ha_attribute *ha_attr = to_ha_attr(attr);
-
-	if (ha_attr->show)
-		ret = ha_attr->show(sas_ha, page);
-	return ret;
-}
-
-static struct ha_attribute ha_attrs[] = {
-	__ATTR(ha_name, 0444, sas_ha_name_show, NULL),
-	__ATTR(device_name, 0444, sas_ha_addr_show, NULL),
-	__ATTR_NULL,
-};
-
-static struct attribute *def_attrs[ARRAY_SIZE(ha_attrs)];
-
-static struct sysfs_ops ha_sysfs_ops = {
-	.show = ha_show_attr,
-};
-
-static struct kobj_type ha_ktype = {
-	.sysfs_ops = &ha_sysfs_ops,
-	.default_attrs = def_attrs,
-};
-
-/* This is our "root". */
-static struct kset sas_kset = {
-	.kobj = { .name = "sas" },
-	.ktype = &ha_ktype,	  /* children are of this type */
-};
-
 int sas_register_ha(struct sas_ha_struct *sas_ha,
 		    const struct scsi_host_template *scsi_ht)
 {
-	int i, error = 0;
+	int error = 0;
 
 	spin_lock_init(&sas_ha->phy_port_lock);
 	sas_hash_addr(sas_ha->hashed_sas_addr, sas_ha->sas_addr);
@@ -116,26 +58,13 @@
 	else if (sas_ha->lldd_queue_size == -1)
 		sas_ha->lldd_queue_size = 128; /* Sanity */
 
-	error = sas_register_scsi_host(sas_ha, scsi_ht);
+	error = sas_register_scsi_host(sas_ha, scsi_ht,
+				       sas_transport_template);
 	if (error) {
 		printk(KERN_NOTICE "couldn't register scsi host\n");
 		return error;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(def_attrs)-1; i++)
-		def_attrs[i] = &ha_attrs[i].attr;
-	def_attrs[i] = NULL;
-
-	/* make sas/ appear */
-	sas_kset.kobj.parent = &sas_ha->core.shost->shost_gendev.kobj;
-	kset_register(&sas_kset);
-
-	/* make sas/ha/ appear */
-	kobject_set_name(&sas_ha->ha_kset.kobj, "%s", "ha");
-	sas_ha->ha_kset.kobj.kset = &sas_kset; /* parent */
-	sas_ha->ha_kset.kobj.ktype = sas_kset.ktype;
-	kset_register(&sas_ha->ha_kset);
-
 	error = sas_register_phys(sas_ha);
 	if (error) {
 		printk(KERN_NOTICE "couldn't register sas phys:%d\n", error);
@@ -156,9 +85,7 @@
 
 	if (sas_ha->lldd_max_execute_num > 1) {
 		error = sas_init_queue(sas_ha);
-		if (!error)
-			kobject_register(&sas_ha->core.scsi_core_obj);
-		else {
+		if (error) {
 			printk(KERN_NOTICE "couldn't start queue thread:%d, "
 			       "running in direct mode\n", error);
 			sas_ha->lldd_max_execute_num = 1;
@@ -170,10 +97,7 @@
 Undo_ports:
 	sas_unregister_ports(sas_ha);
 Undo_phys:
-	sas_unregister_phys(sas_ha);
 Undo:
-	kset_unregister(&sas_ha->ha_kset);
-	kset_unregister(&sas_kset);
 	sas_unregister_scsi_host(sas_ha);
 
 	return error;
@@ -184,23 +108,21 @@
 	sas_unregister_devices(sas_ha);
 
 	if (sas_ha->lldd_max_execute_num > 1) {
-		kobject_unregister(&sas_ha->core.scsi_core_obj);
 		sas_shutdown_queue(sas_ha);
 	}
 
 	sas_kill_event_thread(sas_ha);
 
 	sas_unregister_ports(sas_ha);
-	sas_unregister_phys(sas_ha);
-
-	kset_unregister(&sas_ha->ha_kset);
-	kset_unregister(&sas_kset);
 
 	sas_unregister_scsi_host(sas_ha);
 
 	return 0;
 }
 
+static struct sas_function_template sas_transport_functions = {
+};
+
 /* ---------- SAS Class register/unregister ---------- */
 
 static int __init sas_class_init(void)
@@ -210,6 +132,12 @@
 	if (!sas_task_cache)
 		return -ENOMEM;
 
+	sas_transport_template = sas_attach_transport(&sas_transport_functions);
+	if (!sas_transport_template) {
+		kmem_cache_destroy(sas_task_cache);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
Index: BUILD-2.6/drivers/scsi/sas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_internal.h	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_internal.h	2006-03-02 16:05:15.000000000 -0600
@@ -49,7 +49,8 @@
 void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
 extern int  sas_register_scsi_host(struct sas_ha_struct *,
-				   const struct scsi_host_template *);
+				   const struct scsi_host_template *,
+				   struct scsi_transport_template *);
 void sas_unregister_scsi_host(struct sas_ha_struct *sas_ha);
 
 int  sas_start_event_thread(struct sas_ha_struct *sas_ha);
@@ -58,18 +59,18 @@
 int  sas_init_queue(struct sas_ha_struct *sas_ha);
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha);
 
-void sas_phye_loss_of_signal(struct sas_phy *phy);
-void sas_phye_oob_done(struct sas_phy *phy);
-void sas_phye_oob_error(struct sas_phy *phy);
-void sas_phye_spinup_hold(struct sas_phy *phy);
-
-void sas_deform_port(struct sas_phy *phy);
-
-void sas_porte_bytes_dmaed(struct sas_phy *phy);
-void sas_porte_broadcast_rcvd(struct sas_phy *phy);
-void sas_porte_link_reset_err(struct sas_phy *phy);
-void sas_porte_timer_event(struct sas_phy *phy);
-void sas_porte_hard_reset(struct sas_phy *phy);
+void sas_phye_loss_of_signal(struct asd_sas_phy *phy);
+void sas_phye_oob_done(struct asd_sas_phy *phy);
+void sas_phye_oob_error(struct asd_sas_phy *phy);
+void sas_phye_spinup_hold(struct asd_sas_phy *phy);
+
+void sas_deform_port(struct asd_sas_phy *phy);
+
+void sas_porte_bytes_dmaed(struct asd_sas_phy *phy);
+void sas_porte_broadcast_rcvd(struct asd_sas_phy *phy);
+void sas_porte_link_reset_err(struct asd_sas_phy *phy);
+void sas_porte_timer_event(struct asd_sas_phy *phy);
+void sas_porte_hard_reset(struct asd_sas_phy *phy);
 
 int  sas_reserve_free_id(struct sas_port *port);
 void sas_reserve_scsi_id(struct sas_port *port, int id);
Index: BUILD-2.6/drivers/scsi/sas/sas_phy.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_phy.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_phy.c	2006-03-02 16:24:25.000000000 -0600
@@ -24,21 +24,23 @@
  */
 
 #include "sas_internal.h"
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_sas.h>
 
 /* ---------- Phy events ---------- */
 
-void sas_phye_loss_of_signal(struct sas_phy *phy)
+void sas_phye_loss_of_signal(struct asd_sas_phy *phy)
 {
 	phy->error = 0;
 	sas_deform_port(phy);
 }
 
-void sas_phye_oob_done(struct sas_phy *phy)
+void sas_phye_oob_done(struct asd_sas_phy *phy)
 {
 	phy->error = 0;
 }
 
-void sas_phye_oob_error(struct sas_phy *phy)
+void sas_phye_oob_error(struct asd_sas_phy *phy)
 {
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_port *port = phy->port;
@@ -62,7 +64,7 @@
 	}
 }
 
-void sas_phye_spinup_hold(struct sas_phy *phy)
+void sas_phye_spinup_hold(struct asd_sas_phy *phy)
 {
 	struct sas_ha_struct *sas_ha = phy->ha;
 
@@ -70,195 +72,16 @@
 	sas_ha->lldd_control_phy(phy, PHY_FUNC_RELEASE_SPINUP_HOLD);
 }
 
-/* ---------- Phy attributes ---------- */
-
-static ssize_t sas_phy_id_show(struct sas_phy *phy, char *buf)
-{
-	return sprintf(buf, "%d\n", phy->id);
-}
-
-static ssize_t sas_phy_enabled_show(struct sas_phy *phy, char *buf)
-{
-	return sprintf(buf, "%d\n", phy->enabled);
-}
-
-static ssize_t sas_phy_enabled_store(struct sas_phy *phy, const char *buf,
-				     size_t size)
-{
-	if (size > 0) {
-		if (buf[0] == '1')
-			phy->ha->lldd_control_phy(phy, PHY_FUNC_LINK_RESET);
-	}
-	return size;
-}
-
-static ssize_t sas_phy_class_show(struct sas_phy *phy, char *buf)
-{
-	if (!phy->enabled)
-		return 0;
-	return sas_show_class(phy->class, buf);
-}
-
-static ssize_t sas_phy_iproto_show(struct sas_phy *phy, char *page)
-{
-	if (!phy->enabled)
-		return 0;
-	return sas_show_proto(phy->iproto, page);
-}
-
-static ssize_t sas_phy_tproto_show(struct sas_phy *phy, char *page)
-{
-	if (!phy->enabled)
-		return 0;
-	return sas_show_proto(phy->tproto, page);
-}
-
-static ssize_t sas_phy_type_show(struct sas_phy *phy, char *buf)
-{
-	static const char *phy_type_str[] = {
-		[PHY_TYPE_PHYSICAL] = "physical",
-		[PHY_TYPE_VIRTUAL] = "virtual",
-	};
-	if (!phy->enabled)
-		return 0;
-	return sprintf(buf, "%s\n", phy_type_str[phy->type]);
-}
-
-static ssize_t sas_phy_role_show(struct sas_phy *phy, char *page)
-{
-	static const char *phy_role_str[] = {
-		[PHY_ROLE_NONE] = "none",
-		[PHY_ROLE_TARGET] = "target",
-		[PHY_ROLE_INITIATOR] = "initiator",
-	};
-	int  v;
-	char *buf = page;
-
-	if (!phy->enabled)
-		return 0;
-
-	if (phy->role == PHY_ROLE_NONE)
-		return sprintf(buf, "%s\n", phy_role_str[PHY_ROLE_NONE]);
-
-	for (v = 1; v <= PHY_ROLE_INITIATOR; v <<= 1) {
-		if (v & phy->role) {
-			buf += sprintf(buf, "%s", phy_role_str[v]);
-			if (phy->role & ~((v<<1)-1))
-				buf += sprintf(buf, "|");
-			else
-				buf += sprintf(buf, "\n");
-		}
-	}
-	return buf-page;
-}
-
-static ssize_t sas_phy_linkrate_show(struct sas_phy *phy, char *buf)
-{
-	if (!phy->enabled)
-		return 0;
-	return sas_show_linkrate(phy->linkrate, buf);
-}
-
-static ssize_t sas_phy_addr_show(struct sas_phy *phy, char *buf)
-{
-	if (!phy->enabled)
-		return 0;
-	return sprintf(buf, "%llx\n", SAS_ADDR(phy->sas_addr));
-}
-
-static ssize_t sas_phy_oob_mode_show(struct sas_phy *phy, char *buf)
-{
-	if (!phy->enabled)
-		return 0;
-	return sas_show_oob_mode(phy->oob_mode, buf);
-}
-
-struct phy_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct sas_phy *phy, char *);
-	ssize_t (*store)(struct sas_phy *phy, const char *, size_t);
-};
-
-static struct phy_attribute phy_attrs[] = {
-	/* port is a symlink */
-	__ATTR(id, 0444, sas_phy_id_show, NULL),
-	__ATTR(enabled, 0644, sas_phy_enabled_show, sas_phy_enabled_store),
-	__ATTR(class, 0444, sas_phy_class_show, NULL),
-	__ATTR(iproto, 0444, sas_phy_iproto_show, NULL),
-	__ATTR(tproto, 0444, sas_phy_tproto_show, NULL),
-	__ATTR(type, 0444, sas_phy_type_show, NULL),
-	__ATTR(role, 0444, sas_phy_role_show, NULL),
-	__ATTR(linkrate, 0444, sas_phy_linkrate_show, NULL),
-	__ATTR(sas_addr, 0444, sas_phy_addr_show, NULL),
-	__ATTR(oob_mode, 0444, sas_phy_oob_mode_show, NULL),
-	__ATTR_NULL,
-};
-
-static struct attribute *def_attrs[ARRAY_SIZE(phy_attrs)];
-
-#define to_sas_phy(_obj) container_of(_obj, struct sas_phy, phy_kobj)
-#define to_phy_attr(_attr) container_of(_attr, struct phy_attribute, attr)
-
-static ssize_t phy_show_attr(struct kobject *kobj,
-			     struct attribute *attr,
-			     char *page)
-{
-	ssize_t ret = 0;
-	struct sas_phy *phy = to_sas_phy(kobj);
-	struct phy_attribute *phy_attr = to_phy_attr(attr);
-
-	if (phy_attr->show)
-		ret = phy_attr->show(phy, page);
-	return ret;
-}
-
-static ssize_t phy_store_attr(struct kobject *kobj,
-			      struct attribute *attr,
-			      const char *page, size_t size)
-{
-	ssize_t ret = 0;
-	struct sas_phy *phy = to_sas_phy(kobj);
-	struct phy_attribute *phy_attr = to_phy_attr(attr);
-
-	if (phy_attr->store)
-		ret = phy_attr->store(phy, page, size);
-	return ret;
-}
-
-static struct sysfs_ops phy_sysfs_ops = {
-	.show = phy_show_attr,
-	.store = phy_store_attr,
-};
-
-static struct kobj_type phy_ktype = {
-	.sysfs_ops = &phy_sysfs_ops,
-	.default_attrs = def_attrs,
-};
-
 /* ---------- Phy class registration ---------- */
 
 int sas_register_phys(struct sas_ha_struct *sas_ha)
 {
-	int i, error;
-
-	for (i = 0; i < ARRAY_SIZE(def_attrs)-1; i++)
-		def_attrs[i] = &phy_attrs[i].attr;
-	def_attrs[i] = NULL;
-
-	/* make sas/ha/phys/ appear */
-	kobject_set_name(&sas_ha->phy_kset.kobj, "%s", "phys");
-	sas_ha->phy_kset.kobj.kset = &sas_ha->ha_kset; /* parent */
-	/* we do not inherit the type of the parent */
-	sas_ha->phy_kset.kobj.ktype = NULL;
-	sas_ha->phy_kset.ktype = &phy_ktype;
-	error = kset_register(&sas_ha->phy_kset);
-	if (error)
-		return error;
+	int i;
 
 	/* Now register the phys. */
 	for (i = 0; i < sas_ha->num_phys; i++) {
 		int k;
-		struct sas_phy *phy = sas_ha->sas_phy[i];
+		struct asd_sas_phy *phy = sas_ha->sas_phy[i];
 
 		phy->error = 0;
 		INIT_LIST_HEAD(&phy->port_phy_el);
@@ -280,28 +103,25 @@
 		spin_lock_init(&phy->sas_prim_lock);
 		phy->frame_rcvd_size = 0;
 
-		kobject_set_name(&phy->phy_kobj, "%d", i);
-		phy->phy_kobj.kset = &sas_ha->phy_kset; /* parent */
-		phy->phy_kobj.ktype = sas_ha->phy_kset.ktype;
-		error = kobject_register(&phy->phy_kobj);
-		if (error)
-			goto unroll;
+		phy->phy = sas_phy_alloc(&sas_ha->core.shost->shost_gendev,
+					 i);
+		if (!phy->phy)
+			return -ENOMEM;
+
+		phy->phy->local_attached = 1;
+		phy->phy->identify.initiator_port_protocols =
+			phy->iproto;
+		phy->phy->identify.target_port_protocols = phy->tproto;
+		phy->phy->identify.sas_address = SAS_ADDR(sas_ha->sas_addr);
+		phy->phy->identify.phy_identifier = i;
+		phy->phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		phy->phy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		phy->phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		phy->phy->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
+
+		sas_phy_add(phy->phy);
 	}
 
 	return 0;
-unroll:
-	for (i--; i >= 0; i--)
-		kobject_unregister(&sas_ha->sas_phy[i]->phy_kobj);
-
-	return error;
-}
-
-void sas_unregister_phys(struct sas_ha_struct *sas_ha)
-{
-	int i;
-
-	for (i = 0; i < sas_ha->num_phys; i++)
-		kobject_unregister(&sas_ha->sas_phy[i]->phy_kobj);
-
-	kset_unregister(&sas_ha->phy_kset);
 }
Index: BUILD-2.6/drivers/scsi/sas/sas_port.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_port.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_port.c	2006-03-02 16:05:15.000000000 -0600
@@ -26,40 +26,6 @@
 #include "sas_internal.h"
 #include <scsi/sas/sas_discover.h>
 
-/* called only when num_phys increments, afterwards */
-static void sas_create_port_sysfs_links(struct sas_phy *phy)
-{
-	struct sas_port *port = phy->port;
-
-	if (port->num_phys == 1) {
-		kobject_register(&port->port_kobj);
-		kset_register(&port->phy_kset);
-		kset_register(&port->dev_kset);
-	}
-	/* add port->phy link */
-	sysfs_create_link(&port->phy_kset.kobj, &phy->phy_kobj,
-			  kobject_name(&phy->phy_kobj));
-	/* add phy->port link */
-	sysfs_create_link(&phy->phy_kobj, &port->port_kobj, "port");
-}
-
-/* called only when num_phys decrements, just before it does */
-static void sas_remove_port_sysfs_links(struct sas_phy *phy)
-{
-	struct sas_port *port = phy->port;
-
-	/* remove phy->port link */
-	sysfs_remove_link(&phy->phy_kobj, "port");
-	/* remove port to phy link */
-	sysfs_remove_link(&port->phy_kset.kobj, kobject_name(&phy->phy_kobj));
-
-	if (port->num_phys == 1) {
-		kset_unregister(&port->dev_kset);
-		kset_unregister(&port->phy_kset);
-		kobject_unregister(&port->port_kobj);
-	}
-}
-
 /**
  * sas_form_port -- add this phy to a port
  * @phy: the phy of interest
@@ -67,7 +33,7 @@
  * This function adds this phy to an existing port, thus creating a wide
  * port, or it creates a port and adds the phy to the port.
  */
-static void sas_form_port(struct sas_phy *phy)
+static void sas_form_port(struct asd_sas_phy *phy)
 {
 	int i;
 	struct sas_ha_struct *sas_ha = phy->ha;
@@ -118,6 +84,10 @@
 	port->num_phys++;
 	port->phy_mask |= (1U << phy->id);
 
+	phy->phy->port_identifier = port->id;
+	if (!port->phy)
+		port->phy = phy->phy;
+
 	SAS_DPRINTK("phy%d added to port%d, phy_mask:0x%x\n", phy->id,
 		    port->id, port->phy_mask);
 
@@ -137,7 +107,6 @@
 	if (port->port_dev)
 		port->port_dev->pathways = port->num_phys;
 
-	sas_create_port_sysfs_links(phy);
 	/* Tell the LLDD about this port formation. */
 	if (sas_ha->lldd_port_formed)
 		sas_ha->lldd_port_formed(phy);
@@ -152,7 +121,7 @@
  * This is called when the physical link to the other phy has been
  * lost (on this phy), in Event thread context. We cannot delay here.
  */
-void sas_deform_port(struct sas_phy *phy)
+void sas_deform_port(struct asd_sas_phy *phy)
 {
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_port *port = phy->port;
@@ -172,8 +141,6 @@
 	if (sas_ha->lldd_port_deformed)
 		sas_ha->lldd_port_deformed(phy);
 
-	sas_remove_port_sysfs_links(phy);
-
 	spin_lock(&sas_ha->phy_port_lock);
 	spin_lock(&port->phy_list_lock);
 
@@ -200,12 +167,12 @@
 
 /* ---------- SAS port events ---------- */
 
-void sas_porte_bytes_dmaed(struct sas_phy *phy)
+void sas_porte_bytes_dmaed(struct asd_sas_phy *phy)
 {
 	sas_form_port(phy);
 }
 
-void sas_porte_broadcast_rcvd(struct sas_phy *phy)
+void sas_porte_broadcast_rcvd(struct asd_sas_phy *phy)
 {
 	unsigned long flags;
 	u32 prim;
@@ -218,106 +185,25 @@
 	sas_discover_event(phy->port, DISCE_REVALIDATE_DOMAIN);
 }
 
-void sas_porte_link_reset_err(struct sas_phy *phy)
+void sas_porte_link_reset_err(struct asd_sas_phy *phy)
 {
 	sas_deform_port(phy);
 }
 
-void sas_porte_timer_event(struct sas_phy *phy)
+void sas_porte_timer_event(struct asd_sas_phy *phy)
 {
 	sas_deform_port(phy);
 }
 
-void sas_porte_hard_reset(struct sas_phy *phy)
+void sas_porte_hard_reset(struct asd_sas_phy *phy)
 {
 	sas_deform_port(phy);
 }
 
-/* ---------- SAS port attributes ---------- */
-
-static ssize_t sas_port_id_show(struct sas_port *port, char *buf)
-{
-	return sprintf(buf, "%d\n", port->id);
-}
-
-static ssize_t sas_port_class_show(struct sas_port *port, char *buf)
-{
-	return sas_show_class(port->class, buf);
-}
-
-static ssize_t sas_port_sas_addr_show(struct sas_port *port, char *buf)
-{
-	return sprintf(buf, "%llx\n", SAS_ADDR(port->sas_addr));
-}
-
-static ssize_t sas_port_attached_sas_addr_show(struct sas_port *port,char *buf)
-{
-	return sprintf(buf, "%llx\n", SAS_ADDR(port->attached_sas_addr));
-}
-
-static ssize_t sas_port_iproto_show(struct sas_port *port, char *buf)
-{
-	return sas_show_proto(port->iproto, buf);
-}
-
-static ssize_t sas_port_tproto_show(struct sas_port *port, char *buf)
-{
-	return sas_show_proto(port->tproto, buf);
-}
-
-static ssize_t sas_port_oob_mode_show(struct sas_port *port, char *buf)
-{
-	return sas_show_oob_mode(port->oob_mode, buf);
-}
-
-struct port_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct sas_port *port, char *);
-	ssize_t (*store)(struct sas_port *port, const char *, size_t);
-};
-
-static struct port_attribute port_attrs[] = {
-	__ATTR(id, 0444, sas_port_id_show, NULL),
-	__ATTR(class, 0444, sas_port_class_show, NULL),
-	__ATTR(port_identifier, 0444, sas_port_sas_addr_show, NULL),
-	__ATTR(attached_port_identifier, 0444, sas_port_attached_sas_addr_show, NULL),
-	__ATTR(iproto, 0444, sas_port_iproto_show, NULL),
-	__ATTR(tproto, 0444, sas_port_tproto_show, NULL),
-	__ATTR(oob_mode, 0444, sas_port_oob_mode_show, NULL),
-	__ATTR_NULL,
-};
-
-static struct attribute *def_attrs[ARRAY_SIZE(port_attrs)];
-
-#define to_sas_port(_obj) container_of(_obj, struct sas_port, port_kobj)
-#define to_port_attr(_attr) container_of(_attr, struct port_attribute, attr)
-
-static ssize_t port_show_attr(struct kobject *kobj, struct attribute *attr,
-			      char *page)
-{
-	ssize_t ret = 0;
-	struct sas_port *port = to_sas_port(kobj);
-	struct port_attribute *port_attr = to_port_attr(attr);
-
-	if (port_attr->show)
-		ret = port_attr->show(port, page);
-	return ret;
-}
-
-static struct sysfs_ops port_sysfs_ops = {
-	.show = port_show_attr,
-};
-
-static struct kobj_type port_type = {
-	.sysfs_ops = &port_sysfs_ops,
-	.default_attrs = def_attrs,
-};
-
 /* ---------- SAS port registration ---------- */
 
 static void sas_init_port(struct sas_port *port,
-			  struct sas_ha_struct *sas_ha, int i,
-			  struct kset *parent_kset)
+			  struct sas_ha_struct *sas_ha, int i)
 {
 	port->id = i;
 	INIT_LIST_HEAD(&port->dev_list);
@@ -327,54 +213,27 @@
 	port->phy_mask = 0;
 	port->ha = sas_ha;
 
-	memset(&port->port_kobj, 0, sizeof(port->port_kobj));
-	memset(&port->phy_kset, 0, sizeof(port->phy_kset));
-	memset(&port->dev_kset, 0, sizeof(port->dev_kset));
-
-	kobject_set_name(&port->port_kobj, "%d", port->id);
-	port->port_kobj.kset = parent_kset;
-	port->port_kobj.ktype= parent_kset->ktype;
-
-	kobject_set_name(&port->phy_kset.kobj, "%s", "phys");
-	port->phy_kset.kobj.parent = &port->port_kobj;
-	port->phy_kset.ktype = NULL;
-
-	kobject_set_name(&port->dev_kset.kobj, "%s", "domain");
-	port->dev_kset.kobj.parent = &port->port_kobj;
-	port->dev_kset.ktype = NULL;
-
 	port->id_map.max_ids = 128;
 	port->id_map.id_bitmap_size =
 		BITS_TO_LONGS(port->id_map.max_ids)*sizeof(long);
 	port->id_map.id_bitmap = kzalloc(port->id_map.id_bitmap_size,
 					 GFP_KERNEL);
 	spin_lock_init(&port->id_map.id_bitmap_lock);
+	spin_lock_init(&port->dev_list_lock);
 }
 
 int sas_register_ports(struct sas_ha_struct *sas_ha)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(def_attrs)-1; i++)
-		def_attrs[i] = &port_attrs[i].attr;
-	def_attrs[i] = NULL;
-
-	/* make sas/ha/ports/ appear */
-	kobject_set_name(&sas_ha->port_kset.kobj, "%s", "ports");
-	sas_ha->port_kset.kobj.kset = &sas_ha->ha_kset; /* parent */
-	/* no type inheritance */
-	sas_ha->port_kset.kobj.ktype = NULL;
-	sas_ha->port_kset.ktype = &port_type; /* children are of this type */
-
 	/* initialize the ports and discovery */
 	for (i = 0; i < sas_ha->num_phys; i++) {
 		struct sas_port *port = sas_ha->sas_port[i];
 
-		sas_init_port(port, sas_ha, i, &sas_ha->port_kset);
+		sas_init_port(port, sas_ha, i);
 		sas_init_disc(&port->disc, port);
 	}
-
-	return kset_register(&sas_ha->port_kset);
+	return 0;
 }
 
 void sas_unregister_ports(struct sas_ha_struct *sas_ha)
@@ -389,8 +248,6 @@
 		kfree(sas_ha->sas_port[i]->id_map.id_bitmap);
 		sas_ha->sas_port[i]->id_map.id_bitmap = NULL;
 	}
-
-	kset_unregister(&sas_ha->port_kset);
 }
 
 int sas_reserve_free_id(struct sas_port *port)
Index: BUILD-2.6/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_scsi_host.c	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sas/sas_scsi_host.c	2006-03-02 16:22:13.000000000 -0600
@@ -32,6 +32,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_transport_sas.h>
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
@@ -47,29 +48,6 @@
  */
 #define SCSI_LUN(_sam_lun)   ((unsigned int)be32_to_cpu(*(__be32 *)_sam_lun))
 
-/* ---------- SCSI Core device registration ---------- */
-
-int  sas_register_with_scsi(struct LU *lu)
-{
-	struct domain_device *dev = lu->parent;
-	lu->map.channel = dev->port->id;
-	lu->map.id      = sas_reserve_free_id(dev->port);
-	if (lu->map.id == -ENOMEM)
-		return -ENOMEM;
-
-	scsi_scan_target(&dev->port->ha->core.shost->shost_gendev,
-		         lu->map.channel, lu->map.id, ~0, 0);
-	return 0;
-}
-
-void sas_unregister_with_scsi(struct LU *lu)
-{
-	if (lu->uldd_dev) {
-		struct scsi_device *scsi_dev = lu->uldd_dev;
-		scsi_remove_device(scsi_dev);
-	}
-}
-
 /* ---------- SCSI Host glue ---------- */
 
 #define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
@@ -166,10 +144,11 @@
 }
 
 static inline struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
-					       struct LU *lu,
+					       struct domain_device *dev,
 					       unsigned long gfp_flags)
 {
 	struct sas_task *task = sas_alloc_task(gfp_flags);
+	struct scsi_lun lun;
 
 	if (!task)
 		return NULL;
@@ -178,11 +157,12 @@
 	task->uldd_task = cmd;
 	ASSIGN_SAS_TASK(cmd, task);
 
-	task->dev = lu->parent;
+	task->dev = dev;
 	task->task_proto = task->dev->tproto; /* BUG_ON(!SSP) */
 
 	task->ssp_task.retry_count = 1;
-	memcpy(task->ssp_task.LUN, lu->LUN, 8);
+	int_to_scsilun(cmd->device->lun, &lun);
+	memcpy(task->ssp_task.LUN, &lun.scsi_lun, 8);
 	task->ssp_task.task_attr = sas_scsi_get_task_attr(cmd);
 	memcpy(task->ssp_task.cdb, cmd->cmnd, 16);
 
@@ -227,22 +207,17 @@
 		     void (*scsi_done)(struct scsi_cmnd *))
 {
 	int res = 0;
-	struct LU *lu = cmd->device->hostdata;
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 
 	spin_unlock_irq(host->host_lock);
-	if (!lu) {
-		SAS_DPRINTK("scsi cmd 0x%p sent to non existing LU\n",
-			    cmd);
-		cmd->result = DID_BAD_TARGET << 16;
-		scsi_done(cmd);
-		goto out;
-	} else {
-		struct sas_ha_struct *sas_ha = lu->parent->port->ha;
+
+	{
+		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
 
 		res = -ENOMEM;
-		task = sas_create_task(cmd, lu, GFP_ATOMIC);
+		task = sas_create_task(cmd, dev, GFP_ATOMIC);
 		if (!task)
 			goto out;
 
@@ -271,14 +246,12 @@
 	return res;
 }
 
-static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct LU *lu)
+static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct scsi_cmnd *my_cmd)
 {
 	struct scsi_cmnd *cmd, *n;
 
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
-		struct LU *x = cmd->device->hostdata;
-
-		if (x == lu)
+		if (cmd == my_cmd)
 			list_del_init(&cmd->eh_entry);
 	}
 }
@@ -289,8 +262,7 @@
 	struct scsi_cmnd *cmd, *n;
 
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
-		struct LU *y = cmd->device->hostdata;
-		struct domain_device *x = y->parent;
+		struct domain_device *x = cmd_to_domain_dev(cmd);
 
 		if (x == dev)
 			list_del_init(&cmd->eh_entry);
@@ -303,8 +275,8 @@
 	struct scsi_cmnd *cmd, *n;
 
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
-		struct LU *y = cmd->device->hostdata;
-		struct sas_port *x = y->parent->port;
+		struct domain_device *dev = cmd_to_domain_dev(cmd);
+		struct sas_port *x = dev->port;
 
 		if (x == port)
 			list_del_init(&cmd->eh_entry);
@@ -378,26 +350,29 @@
 	return res;
 }
 
-static int sas_recover_lu(struct domain_device *dev, struct LU *lu)
+static int sas_recover_lu(struct domain_device *dev, struct scsi_cmnd *cmd)
 {
 	struct sas_ha_struct *ha = dev->port->ha;
 	int res = TMF_RESP_FUNC_FAILED;
+	struct scsi_lun lun;
+
+	int_to_scsilun(cmd->device->lun, &lun);
 
-	SAS_DPRINTK("eh: device %llx LUN %llx has the task\n",
+	SAS_DPRINTK("eh: device %llx LUN %x has the task\n",
 		    SAS_ADDR(dev->sas_addr),
-		    SAS_ADDR(lu->LUN));
+		    cmd->device->lun);
 
 	if (ha->lldd_abort_task_set)
-		res = ha->lldd_abort_task_set(dev, lu->LUN);
+		res = ha->lldd_abort_task_set(dev, lun.scsi_lun);
 
 	if (res == TMF_RESP_FUNC_FAILED) {
 		if (ha->lldd_clear_task_set)
-			res = ha->lldd_clear_task_set(dev, lu->LUN);
+			res = ha->lldd_clear_task_set(dev, lun.scsi_lun);
 	}
 
 	if (res == TMF_RESP_FUNC_FAILED) {
 		if (ha->lldd_lu_reset)
-			res = ha->lldd_lu_reset(dev, lu->LUN);
+			res = ha->lldd_lu_reset(dev, lun.scsi_lun);
 	}
 
 	return res;
@@ -439,7 +414,6 @@
 	SAS_DPRINTK("going over list...\n");
 	list_for_each_entry_safe(cmd, n, &error_q, eh_entry) {
 		struct sas_task *task = TO_SAS_TASK(cmd);
-		struct LU *lu = cmd->device->hostdata;
 
 		SAS_DPRINTK("trying to find task 0x%p\n", task);
 		list_del_init(&cmd->eh_entry);
@@ -461,14 +435,14 @@
 			continue;
 		case TASK_IS_AT_LU:
 			SAS_DPRINTK("task 0x%p is at LU: lu recover\n", task);
-			tmf_resp = sas_recover_lu(task->dev, lu);
+			tmf_resp = sas_recover_lu(task->dev, cmd);
 			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
-				SAS_DPRINTK("dev %016llx LU %016llx is "
+				SAS_DPRINTK("dev %016llx LU %x is "
 					    "recovered\n",
 					    SAS_ADDR(task->dev),
-					    SAS_ADDR(lu->LUN));
+					    cmd->device->lun);
 				task->task_done(task);
-				sas_scsi_clear_queue_lu(&error_q, lu);
+				sas_scsi_clear_queue_lu(&error_q, cmd);
 				goto Again;
 			}
 			/* fallthrough */
@@ -512,10 +486,10 @@
 			 * of effort could recover from errors.  Quite
 			 * possibly the HA just disappeared.
 			 */
-			SAS_DPRINTK("error from  device %llx, LUN %llx "
+			SAS_DPRINTK("error from  device %llx, LUN %x "
 				    "couldn't be recovered in any way\n",
 				    SAS_ADDR(task->dev->sas_addr),
-				    SAS_ADDR(lu->LUN));
+				    cmd->device->lun);
 
 			task->task_done(task);
 			goto clear_q;
@@ -561,53 +535,35 @@
 	return EH_NOT_HANDLED;
 }
 
-/**
- * sas_slave_alloc -- configure an LU which SCSI Core wants to poke at
- * @scsi_dev: pointer to scsi device
- *
- * The kludge here is that the only token we have to go by in order to
- * identify which device SCSI Core has just found about, is channel,
- * id and lun/2.  Of course this is 1) incredibly broken and 2)
- * leftover from when SCSI Core was SPI-centric.  A solution would be
- * to pass an opaque token to scsi_add_device, which SCSI Core treats
- * as that, an opaque token, which it sets inside scsi_dev, so we can
- * find out which device SCSI Core is talking about.  That is, how
- * SCSI Core is _addressing_ the device is not the business of LLDD
- * and vice versa.  An even _better_ solution is if SCSI Core knew
- * about a "SCSI device with Target ports" so we can register only the
- * targets, and then it would do its own LU discovery...  See comment
- * in sas_do_lu_discovery().
- */
-int sas_slave_alloc(struct scsi_device *scsi_dev)
+int sas_target_alloc(struct scsi_target *starget)
 {
-	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(scsi_dev->host);
-	struct sas_port *port = sas_ha->sas_port[scsi_dev->channel];
-        unsigned id = scsi_dev->id;
-	unsigned lun = scsi_dev->lun;
-
-	struct domain_device *dev = NULL;
-	struct LU *lu = NULL;
-
-	scsi_dev->hostdata = NULL;
-
-	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-		if (dev->dev_type == SAS_END_DEV) {
-			list_for_each_entry(lu, &dev->end_dev.LU_list, list) {
-				if (lu->map.id == id &&
-				    SCSI_LUN(lu->LUN) == lun) {
-					scsi_dev->hostdata = lu;
-					lu->uldd_dev = scsi_dev;
-					goto out_loop;
-				}
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
+	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
+	struct domain_device *found_dev = NULL;
+	int i;
+
+	spin_lock(&ha->phy_port_lock);
+	for (i = 0; i < ha->num_phys; i++) {
+		struct sas_port *port = ha->sas_port[i];
+		struct domain_device *dev;
+
+		spin_lock(&port->dev_list_lock);
+		list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+			if (rphy == dev->rphy) {
+				found_dev = dev;
+				spin_unlock(&port->dev_list_lock);
+				goto found;
 			}
 		}
+		spin_unlock(&port->dev_list_lock);
 	}
-out_loop:
-	if (!scsi_dev->hostdata) {
-		SAS_DPRINTK("sas device not found! How is this possible?\n");
+ found:
+	spin_unlock(&ha->phy_port_lock);
+	if (!found_dev)
 		return -ENODEV;
-	}
-	kobject_get(&lu->lu_obj);
+
+	starget->hostdata = found_dev;
 	return 0;
 }
 
@@ -616,38 +572,22 @@
 
 int sas_slave_configure(struct scsi_device *scsi_dev)
 {
-	struct LU *lu = scsi_dev->hostdata;
 	struct domain_device *dev;
 	struct sas_ha_struct *sas_ha;
 
-	if (!lu) {
-		SAS_DPRINTK("slave configure and no LU?!\n");
-		return -ENODEV;
-	}
-
-	dev = lu->parent;
+	dev = sdev_to_domain_dev(scsi_dev);
 	sas_ha = dev->port->ha;
 
-	if (scsi_dev->inquiry_len > 7) {
-		u8 bq = (scsi_dev->inquiry[6] & 0x80) ? 1 : 0;
-		u8 cq = (scsi_dev->inquiry[7] & 0x02) ? 1 : 0;
-
-		if (bq ^ cq) {
-			lu->tm_type = (bq<<1) | cq;
-			scsi_dev->tagged_supported = 1;
-			if (cq)
-				scsi_set_tag_type(scsi_dev, MSG_ORDERED_TAG);
-			else
-				scsi_set_tag_type(scsi_dev, MSG_SIMPLE_TAG);
-			scsi_activate_tcq(scsi_dev, SAS_DEF_QD);
-		} else {
-			SAS_DPRINTK("device %llx, LUN %llx doesn't support "
-				    "TCQ\n", SAS_ADDR(dev->sas_addr),
-				    SAS_ADDR(lu->LUN));
-			scsi_dev->tagged_supported = 0;
-			scsi_set_tag_type(scsi_dev, 0);
-			scsi_deactivate_tcq(scsi_dev, 1);
-		}
+	if (scsi_dev->tagged_supported) {
+		scsi_set_tag_type(scsi_dev, MSG_SIMPLE_TAG);
+		scsi_activate_tcq(scsi_dev, SAS_DEF_QD);
+	} else {
+		SAS_DPRINTK("device %llx, LUN %x doesn't support "
+			    "TCQ\n", SAS_ADDR(dev->sas_addr),
+			    scsi_dev->lun);
+		scsi_dev->tagged_supported = 0;
+		scsi_set_tag_type(scsi_dev, 0);
+		scsi_deactivate_tcq(scsi_dev, 1);
 	}
 
 	if (dev->end_dev.itnl_timeout > 0)
@@ -659,13 +599,6 @@
 
 void sas_slave_destroy(struct scsi_device *scsi_dev)
 {
-	struct LU *lu = scsi_dev->hostdata;
-
-	if (lu) {
-		scsi_dev->hostdata = NULL;
-		lu->uldd_dev = NULL;
-		kobject_put(&lu->lu_obj);
-	}
 }
 
 int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth)
@@ -676,10 +609,10 @@
 		scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev),
 					res);
 	else {
-		struct LU *lu = scsi_dev->hostdata;
-		sas_printk("device %llx LUN %llx queue depth changed to 1\n",
-			   SAS_ADDR(lu->parent->sas_addr),
-			   SAS_ADDR(lu->LUN));
+		struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
+		sas_printk("device %llx LUN %x queue depth changed to 1\n",
+			   SAS_ADDR(dev->sas_addr),
+			   scsi_dev->lun);
 		scsi_adjust_queue_depth(scsi_dev, 0, 1);
 		res = 1;
 	}
@@ -689,23 +622,11 @@
 
 int sas_change_queue_type(struct scsi_device *scsi_dev, int qt)
 {
-	struct LU *lu = scsi_dev->hostdata;
-
 	if (!scsi_dev->tagged_supported)
 		return 0;
 
 	scsi_deactivate_tcq(scsi_dev, 1);
 
-	switch (qt) {
-	case MSG_ORDERED_TAG:
-		if (lu->tm_type != TASK_MANAGEMENT_FULL)
-			qt = MSG_SIMPLE_TAG;
-		break;
-	case MSG_SIMPLE_TAG:
-	default:
-		;
-	}
-
 	scsi_set_tag_type(scsi_dev, qt);
 	scsi_activate_tcq(scsi_dev, scsi_dev->queue_depth);
 
@@ -737,7 +658,8 @@
 }
 
 int sas_register_scsi_host(struct sas_ha_struct *sas_ha,
-			   const struct scsi_host_template *scsi_ht)
+			   const struct scsi_host_template *scsi_ht,
+			   struct scsi_transport_template *tt)
 {
 	int err = -ENOMEM;
 
@@ -760,6 +682,7 @@
 	sas_ha->core.shost->max_lun = ~0 - 1;
 
 	sas_ha->core.shost->max_cmd_len = 16;
+	sas_ha->core.shost->transportt = tt;
 
 	err = scsi_add_host(sas_ha->core.shost, &sas_ha->pcidev->dev);
 	if (err) {
@@ -862,52 +785,6 @@
 	return 0;
 }
 
-/* ---------- SCSI Core struct attributes ---------- */
-
-static ssize_t show_task_queue_size(struct scsi_core *core, char *page)
-{
-	return sprintf(page, "%d\n", core->task_queue_size);
-}
-
-struct scsi_core_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct scsi_core *, char *);
-	ssize_t (*store)(struct scsi_core *, const char *, size_t len);
-};
-
-#define to_scsi_core(_obj) container_of((_obj), struct scsi_core, \
-					scsi_core_obj)
-#define to_sc_attr(_attr) container_of((_attr), struct scsi_core_attribute,\
-				       attr)
-
-static ssize_t sc_show_attr(struct kobject *kobj, struct attribute *attr,
-			    char *page)
-{
-	ssize_t ret = 0;
-	struct scsi_core *core = to_scsi_core(kobj);
-	struct scsi_core_attribute *sc_attr = to_sc_attr(attr);
-
-	if (sc_attr->show)
-		ret = sc_attr->show(core, page);
-	return ret;
-}
-
-static struct scsi_core_attribute sc_attrs[] = {
-	__ATTR(task_queue_size, 0444, show_task_queue_size, NULL),
-	__ATTR_NULL,
-};
-
-static struct attribute *sc_def_attrs[ARRAY_SIZE(sc_attrs)];
-
-static struct sysfs_ops sc_sysfs_ops = {
-	.show = sc_show_attr,
-};
-
-static struct kobj_type scsi_core_ktype = {
-	.sysfs_ops = &sc_sysfs_ops,
-	.default_attrs = sc_def_attrs,
-};
-
 int sas_init_queue(struct sas_ha_struct *sas_ha)
 {
 	int res;
@@ -919,19 +796,9 @@
 	init_MUTEX_LOCKED(&core->queue_thread_sema);
 
 	res = kernel_thread(sas_queue_thread, sas_ha, 0);
-	if (res >= 0) {
-		int i;
+	if (res >= 0)
 		wait_for_completion(&queue_th_comp);
 
-		for (i = 0; i < ARRAY_SIZE(sc_attrs)-1; i++)
-			sc_def_attrs[i] = &sc_attrs[i].attr;
-		sc_def_attrs[i] = NULL;
-
-		core->scsi_core_obj.kset = &sas_ha->ha_kset;
-		kobject_set_name(&core->scsi_core_obj, "%s", "scsi_core");
-		core->scsi_core_obj.ktype = &scsi_core_ktype;
-	}
-
 	return res < 0 ? res : 0;
 }
 
@@ -967,7 +834,7 @@
 EXPORT_SYMBOL_GPL(sas_queuecommand);
 EXPORT_SYMBOL_GPL(sas_scsi_recover_host);
 EXPORT_SYMBOL_GPL(sas_scsi_timed_out);
-EXPORT_SYMBOL_GPL(sas_slave_alloc);
+EXPORT_SYMBOL_GPL(sas_target_alloc);
 EXPORT_SYMBOL_GPL(sas_slave_configure);
 EXPORT_SYMBOL_GPL(sas_slave_destroy);
 EXPORT_SYMBOL_GPL(sas_change_queue_depth);
Index: BUILD-2.6/include/scsi/sas/sas_class.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sas/sas_class.h	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/include/scsi/sas/sas_class.h	2006-03-02 16:05:15.000000000 -0600
@@ -31,7 +31,9 @@
 #include <linux/pci.h>
 #include <asm/semaphore.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/sas/sas.h>
+#include <scsi/scsi_transport_sas.h>
 
 struct block_device;
 
@@ -92,10 +94,8 @@
 /* The phy pretty much is controlled by the LLDD.
  * The class only reads those fields.
  */
-struct sas_phy {
+struct asd_sas_phy {
 /* private: */
-	struct kobject phy_kobj;
-
 	/* protected by ha->event_lock */
 	struct list_head   port_event_list;
 	struct list_head   phy_event_list;
@@ -104,6 +104,8 @@
 
 	int error;
 
+	struct sas_phy *phy;
+
 /* public: */
 	/* The following are class:RO, driver:R/W */
 	int            enabled;	  /* must be set */
@@ -164,18 +166,16 @@
 /* The port struct is Class:RW, driver:RO */
 struct sas_port {
 /* private: */
-	struct kobject port_kobj;
-	struct kset    phy_kset;
-	struct kset    dev_kset;
-
 	struct completion port_gone_completion;
 
 	struct sas_discovery disc;
 	struct domain_device *port_dev;
+	spinlock_t dev_list_lock;
 	struct list_head dev_list;
 	enum   sas_phy_linkrate linkrate;
 
 	struct scsi_id_map id_map;
+	struct sas_phy *phy;
 
 /* public: */
 	int id;
@@ -201,8 +201,6 @@
 struct sas_task;
 
 struct scsi_core {
-	struct kobject scsi_core_obj;
-
 	struct scsi_host_template *sht;
 	struct Scsi_Host *shost;
 
@@ -216,10 +214,6 @@
 
 struct sas_ha_struct {
 /* private: */
-	struct kset      ha_kset; /* "this" */
-	struct kset      phy_kset;
-	struct kset      port_kset;
-
 	struct semaphore event_sema;
 	int              event_thread_kill;
 
@@ -240,18 +234,18 @@
 	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
 
 	spinlock_t      phy_port_lock;
-	struct sas_phy  **sas_phy; /* array of valid pointers, must be set */
+	struct asd_sas_phy  **sas_phy; /* array of valid pointers, must be set */
 	struct sas_port **sas_port; /* array of valid pointers, must be set */
 	int             num_phys; /* must be set, gt 0, static */
 
 	/* LLDD calls these to notify the class of an event. */
 	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
-	void (*notify_port_event)(struct sas_phy *, enum port_event);
-	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
+	void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
+	void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
 
 	/* The class calls these to notify the LLDD of an event. */
-	void (*lldd_port_formed)(struct sas_phy *);
-	void (*lldd_port_deformed)(struct sas_phy *);
+	void (*lldd_port_formed)(struct asd_sas_phy *);
+	void (*lldd_port_deformed)(struct asd_sas_phy *);
 
 	/* The class calls these when a device is found or gone. */
 	int  (*lldd_dev_found)(struct domain_device *);
@@ -277,13 +271,29 @@
 	int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);
 
 	/* Phy management */
-	int (*lldd_control_phy)(struct sas_phy *, enum phy_func);
+	int (*lldd_control_phy)(struct asd_sas_phy *, enum phy_func);
 
 	void *lldd_ha;		  /* not touched by sas class code */
 };
 
 #define SHOST_TO_SAS_HA(_shost) (*(struct sas_ha_struct **)(_shost)->hostdata)
 
+static inline struct domain_device *
+starget_to_domain_dev(struct scsi_target *starget) {
+	return starget->hostdata;
+}
+
+static inline struct domain_device *
+sdev_to_domain_dev(struct scsi_device *sdev) {
+	return starget_to_domain_dev(sdev->sdev_target);
+}
+
+static inline struct domain_device *
+cmd_to_domain_dev(struct scsi_cmnd *cmd)
+{
+	return sdev_to_domain_dev(cmd->device);
+}
+
 void sas_hash_addr(u8 *hashed, const u8 *sas_addr);
 
 /* Before calling a notify event, LLDD should use this function
@@ -291,7 +301,7 @@
  * The idea is that the Class only reads those, while the LLDD,
  * can R/W these (thus avoiding a race).
  */
-static inline void sas_phy_disconnected(struct sas_phy *phy)
+static inline void sas_phy_disconnected(struct asd_sas_phy *phy)
 {
 	phy->oob_mode = OOB_NOT_CONNECTED;
 	phy->linkrate = PHY_LINKRATE_NONE;
@@ -304,6 +314,7 @@
 		     void (*scsi_done)(struct scsi_cmnd *));
 extern int sas_scsi_recover_host(struct Scsi_Host *shost);
 extern enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd);
+extern int sas_target_alloc(struct scsi_target *starget);
 extern int sas_slave_alloc(struct scsi_device *scsi_dev);
 extern int sas_slave_configure(struct scsi_device *scsi_dev);
 extern void sas_slave_destroy(struct scsi_device *scsi_dev);
Index: BUILD-2.6/include/scsi/sas/sas_discover.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sas/sas_discover.h	2006-03-02 16:04:39.000000000 -0600
+++ BUILD-2.6/include/scsi/sas/sas_discover.h	2006-03-02 16:05:15.000000000 -0600
@@ -95,31 +95,12 @@
 	TASK_MANAGEMENT_BASIC = 2,
 };
 
-struct LU {
-	struct kobject   lu_obj;
-	struct list_head list;
-
-	struct domain_device *parent;
-
-	u8     LUN[8];
-	int    inquiry_valid_data_len;
-	u8     inquiry_data[SAS_INQUIRY_DATA_LEN];
-	struct scsi_core_mapping map;
-
-	enum task_management_type tm_type;
-
-	void  *uldd_dev;
-};
-
 struct end_device {
 	u8     ms_10:1;
 	u8     ready_led_meaning:1;
 	u8     rl_wlun:1;
 	u16    itnl_timeout; 	  /* 0 if you do not know it */
 	u16    iresp_timeout;
-
-	struct kset LU_kset;
-	struct list_head LU_list;
 };
 
 #include <scsi/sas/sas_expander.h>
@@ -127,7 +108,6 @@
 /* ---------- Domain device ---------- */
 
 struct domain_device {
-	struct kobject    dev_obj;
 	enum sas_dev_type dev_type;
 
 	enum sas_phy_linkrate linkrate;
@@ -145,6 +125,8 @@
 	enum sas_proto    iproto;
 	enum sas_proto    tproto;
 
+	struct sas_rphy *rphy;
+
 	u8  sas_addr[SAS_ADDR_SIZE];
 	u8  hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
 
@@ -198,7 +180,6 @@
 	INIT_LIST_HEAD(&dev->dev_list_node);
 	switch (dev->dev_type) {
 	case SAS_END_DEV:
-		INIT_LIST_HEAD(&dev->end_dev.LU_list);
 		break;
 	case EDGE_DEV:
 	case FANOUT_DEV:
@@ -223,9 +204,6 @@
 
 void sas_unregister_dev(struct domain_device *dev);
 
-int  sas_register_with_scsi(struct LU *lu);
-void sas_unregister_with_scsi(struct LU *lu);
-
 void sas_unregister_devices(struct sas_ha_struct *sas_ha);
 
 #endif /* _SAS_DISCOVER_H_ */



