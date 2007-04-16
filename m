From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 14:10:49 -0700
Message-ID: <20070416211049.GC13590@andrew-vasquezs-computer.local>
References: <20070416.010218.130850966.davem@davemloft.net> <20070416163712.GA10822@andrew-vasquezs-computer.local> <20070416.123743.07452378.davem@davemloft.net> <20070416200857.GH10822@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28639 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbXDPVKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 17:10:53 -0400
Content-Disposition: inline
In-Reply-To: <20070416200857.GH10822@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Mon, 16 Apr 2007, Andrew Vasquez wrote:

> On Mon, 16 Apr 2007, David Miller wrote:
> 
> > They DON'T
> > CARE, they want their systems to work and if you don't give them that
> > you're not being a good driver maintainer.
> 
> Let's push aside attitudes and unrealistic statistics, could we
> perhaps agree to re-add the use of doctored NVRAM (and thus
> non-random WWPN/WWNN) when NVRAM is corrupted or non-present with a
> module-parameter (which defaults to 0) which indicates the user
> *really* knows what she is doing and recognizes WWPN collisions may
> occur -- non-zero the parameter value indicates doctored values will
> be used, zero value (the default) fails initialization.  In both cases
> a big FAT warning is issued.
> 
> > You BROKE things, therefore you must FIX it.
> >
> > Now I'm happy to code up the sparc OFW property bits but your attitude
> > and perspective on this absolutely has to change and the old fallback
> > code still has to go back in there, possible FC ID collisions or not.
> 
> That would be great,  I'd like to insure the balance is maintained for
> *all* our users.

Ok, how about the following patch based on the one you posted which
adds the codes to retrieve the WWPN/WWNN from firmware on SPARC, and
also adds the module-parameter override I mentioned above.

Perhaps the module-parameter should be set to non-zero in the case of
SPARC, to take care of your system configurations?

Regards,
Andrew Vasquez

---

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 74544ae..b26090d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -62,6 +62,7 @@ extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
+extern int ql2xoverrideinvalidnvram;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 98c01cd..fa5df97 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -11,6 +11,11 @@
 
 #include "qla_devtbl.h"
 
+#ifdef CONFIG_SPARC
+#include <asm/prom.h>
+#include <asm/pbm.h>
+#endif
+
 /* XXX(hch): this is ugly, but we don't want to pull in exioctl.h */
 #ifndef EXT_IS_LUN_BIT_SET
 #define EXT_IS_LUN_BIT_SET(P,L) \
@@ -1393,6 +1398,42 @@ qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *de
 	}
 }
 
+/* On sparc systems, obtain port and node WWN from firmware
+ * properties.
+ */
+static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, nvram_t *nv)
+{
+#ifdef CONFIG_SPARC
+	struct pci_dev *pdev = ha->pdev;
+	struct pcidev_cookie *pcp = pdev->sysdata;
+	struct device_node *dp = pcp->prom_node;
+	u8 *val;
+	int len;
+
+	val = of_get_property(dp, "port-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->port_name, val, WWN_SIZE);
+
+	val = of_get_property(dp, "node-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->node_name, val, WWN_SIZE);
+#endif
+}
+
+static inline int
+qla2x00_override_invalid_nvram(scsi_qla_host_t *ha)
+{
+	if (!ql2xoverrideinvalidnvram) {
+		qla_printk(KERN_WARNING, ha,
+		    "Reload the driver with the ql2xoverrideinvalidnvram \n");
+		qla_printk(KERN_WARNING, ha,
+		    " module parameter set to a non-zero value to ignore \n");
+		qla_printk(KERN_WARNING, ha,
+		    " this warning.\n");
+	}
+	return ql2xoverrideinvalidnvram;
+}
+
 /*
 * NVRAM configuration for ISP 2xxx
 *
@@ -1440,7 +1481,57 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
 		    nv->nvram_version);
-		return QLA_FUNCTION_FAILED;
+		if (!qla2x00_override_invalid_nvram(ha))
+			return QLA_FUNCTION_FAILED;
+		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
+		    "invalid -- WWPN) defaults.\n");
+
+		/*
+		 * Set default initialization control block.
+		 */
+		memset(nv, 0, ha->nvram_size);
+		nv->parameter_block_version = ICB_VERSION;
+
+		if (IS_QLA23XX(ha)) {
+			nv->firmware_options[0] = BIT_2 | BIT_1;
+			nv->firmware_options[1] = BIT_7 | BIT_5;
+			nv->add_firmware_options[0] = BIT_5;
+			nv->add_firmware_options[1] = BIT_5 | BIT_4;
+			nv->frame_payload_size = __constant_cpu_to_le16(2048);
+			nv->special_options[1] = BIT_7;
+		} else if (IS_QLA2200(ha)) {
+			nv->firmware_options[0] = BIT_2 | BIT_1;
+			nv->firmware_options[1] = BIT_7 | BIT_5;
+			nv->add_firmware_options[0] = BIT_5;
+			nv->add_firmware_options[1] = BIT_5 | BIT_4;
+			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+		} else if (IS_QLA2100(ha)) {
+			nv->firmware_options[0] = BIT_3 | BIT_1;
+			nv->firmware_options[1] = BIT_5;
+			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+		}
+
+		nv->max_iocb_allocation = __constant_cpu_to_le16(256);
+		nv->execution_throttle = __constant_cpu_to_le16(16);
+		nv->retry_count = 8;
+		nv->retry_delay = 1;
+
+		nv->port_name[0] = 33;
+		nv->port_name[3] = 224;
+		nv->port_name[4] = 139;
+
+		qla2xxx_nvram_wwn_from_ofw(ha, nv);
+
+		nv->login_timeout = 4;
+
+		/*
+		 * Set default host adapter parameters
+		 */
+		nv->host_p[1] = BIT_2;
+		nv->reset_delay = 5;
+		nv->port_down_retry_count = 8;
+		nv->max_luns_per_target = __constant_cpu_to_le16(8);
+		nv->link_down_timeout = 60;
 	}
 
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
@@ -3290,6 +3381,28 @@ qla24xx_reset_adapter(scsi_qla_host_t *ha)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+/* On sparc systems, obtain port and node WWN from firmware
+ * properties.
+ */
+static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, struct nvram_24xx *nv)
+{
+#ifdef CONFIG_SPARC
+	struct pci_dev *pdev = ha->pdev;
+	struct pcidev_cookie *pcp = pdev->sysdata;
+	struct device_node *dp = pcp->prom_node;
+	u8 *val;
+	int len;
+
+	val = of_get_property(dp, "port-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->port_name, val, WWN_SIZE);
+
+	val = of_get_property(dp, "node-wwn", &len);
+	if (val && len >= WWN_SIZE)
+		memcpy(nv->node_name, val, WWN_SIZE);
+#endif
+}
+
 int
 qla24xx_nvram_config(scsi_qla_host_t *ha)
 {
@@ -3332,7 +3445,52 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
 		    le16_to_cpu(nv->nvram_version));
-		return QLA_FUNCTION_FAILED;
+		if (!qla2x00_override_invalid_nvram(ha))
+			return QLA_FUNCTION_FAILED;
+		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
+		    "invalid -- WWPN) defaults.\n");
+
+		/*
+		 * Set default initialization control block.
+		 */
+		memset(nv, 0, ha->nvram_size);
+		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+		nv->exchange_count = __constant_cpu_to_le16(0);
+		nv->hard_address = __constant_cpu_to_le16(124);
+		nv->port_name[0] = 0x21;
+		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
+		nv->port_name[2] = 0x00;
+		nv->port_name[3] = 0xe0;
+		nv->port_name[4] = 0x8b;
+		nv->port_name[5] = 0x1c;
+		nv->port_name[6] = 0x55;
+		nv->port_name[7] = 0x86;
+		nv->node_name[0] = 0x20;
+		nv->node_name[1] = 0x00;
+		nv->node_name[2] = 0x00;
+		nv->node_name[3] = 0xe0;
+		nv->node_name[4] = 0x8b;
+		nv->node_name[5] = 0x1c;
+		nv->node_name[6] = 0x55;
+		nv->node_name[7] = 0x86;
+		qla24xx_nvram_wwn_from_ofw(ha, nv);
+		nv->login_retry_count = __constant_cpu_to_le16(8);
+		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
+		nv->login_timeout = __constant_cpu_to_le16(0);
+		nv->firmware_options_1 =
+		    __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
+		nv->firmware_options_2 = __constant_cpu_to_le32(2 << 4);
+		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+		nv->firmware_options_3 = __constant_cpu_to_le32(2 << 13);
+		nv->host_p = __constant_cpu_to_le32(BIT_11|BIT_10);
+		nv->efi_parameters = __constant_cpu_to_le32(0);
+		nv->reset_delay = 5;
+		nv->max_luns_per_target = __constant_cpu_to_le16(128);
+		nv->port_down_retry_count = __constant_cpu_to_le16(30);
+		nv->link_down_timeout = __constant_cpu_to_le16(30);
 	}
 
 	/* Reset Initialization control block */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 68f5d24..acbe2db 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -90,6 +90,13 @@ MODULE_PARM_DESC(ql2xqfullrampup,
 		"depth for a device after a queue-full condition has been "
 		"detected.  Default is 120 seconds.");
 
+int ql2xoverrideinvalidnvram;
+module_param(ql2xoverrideinvalidnvram, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xoverrideinvalidnvram,
+		"When set and upon detecting an invalid or non-present "
+		"NVRAM state, use doctored settings (potentially invalid) "
+		"to initialize the HBA.");
+
 /*
  * SCSI host template entry points
  */
@@ -1575,9 +1582,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
-	if (qla2x00_initialize_adapter(ha) &&
-	    !(ha->device_flags & DFLG_NO_CABLE)) {
-
+	if (qla2x00_initialize_adapter(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
 
@@ -1733,7 +1738,8 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	ha->flags.online = 0;
 
 	/* Stop currently executing firmware. */
-	qla2x00_try_to_stop_firmware(ha);
+	if (ha->fw_major_version)
+		qla2x00_try_to_stop_firmware(ha);
 
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
