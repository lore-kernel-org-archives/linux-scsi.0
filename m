From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 2/2] RFC: iscsi ibft: convert iscsi_ibft module to iscsi boot lib
Date: Mon, 12 Apr 2010 13:06:18 -0500
Message-ID: <1271095578-4212-2-git-send-email-michaelc@cs.wisc.edu>
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCLPJla3WGRDawo3eBBoE00oR1A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1271095578-4212-1-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konrad-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

This patch just converts the iscsi_ibft module to the
iscsi boot sysfs lib module.

This patch was made over the ibft-2.6 tree's ibft-1.03 branch:
http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=shortlog;h=refs/heads/ibft-1.03

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/firmware/Kconfig      |    1 +
 drivers/firmware/iscsi_ibft.c |  698 +++++++++++++++--------------------------
 2 files changed, 248 insertions(+), 451 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 571d218..a6c670b 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -132,6 +132,7 @@ config ISCSI_BOOT_SYSFS
 
 config ISCSI_IBFT
 	tristate "iSCSI Boot Firmware Table Attributes module"
+	select ISCSI_BOOT_SYSFS
 	depends on ISCSI_IBFT_FIND
 	default	n
 	help
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index b3ab24f..6d262be 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -82,6 +82,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
+#include <linux/iscsi_boot_sysfs.h>
 
 #define IBFT_ISCSI_VERSION "0.5.0"
 #define IBFT_ISCSI_DATE "2010-Feb-25"
@@ -170,74 +171,6 @@ enum ibft_id {
 };
 
 /*
- * We do not support the other types, hence the usage of NULL.
- * This maps to the enum ibft_id.
- */
-static const char *ibft_id_names[] =
-	{NULL, NULL, "initiator", "ethernet%d", "target%d", NULL, NULL};
-
-/*
- * The text attributes names for each of the kobjects.
-*/
-enum ibft_eth_properties_enum {
-	ibft_eth_index,
-	ibft_eth_flags,
-	ibft_eth_ip_addr,
-	ibft_eth_subnet_mask,
-	ibft_eth_origin,
-	ibft_eth_gateway,
-	ibft_eth_primary_dns,
-	ibft_eth_secondary_dns,
-	ibft_eth_dhcp,
-	ibft_eth_vlan,
-	ibft_eth_mac,
-	/* ibft_eth_pci_bdf - this is replaced by link to the device itself. */
-	ibft_eth_hostname,
-	ibft_eth_end_marker,
-};
-
-static const char *ibft_eth_properties[] =
-	{"index", "flags", "ip-addr", "subnet-mask", "origin", "gateway",
-	"primary-dns", "secondary-dns", "dhcp", "vlan", "mac", "hostname",
-	NULL};
-
-enum ibft_tgt_properties_enum {
-	ibft_tgt_index,
-	ibft_tgt_flags,
-	ibft_tgt_ip_addr,
-	ibft_tgt_port,
-	ibft_tgt_lun,
-	ibft_tgt_chap_type,
-	ibft_tgt_nic_assoc,
-	ibft_tgt_name,
-	ibft_tgt_chap_name,
-	ibft_tgt_chap_secret,
-	ibft_tgt_rev_chap_name,
-	ibft_tgt_rev_chap_secret,
-	ibft_tgt_end_marker,
-};
-
-static const char *ibft_tgt_properties[] =
-	{"index", "flags", "ip-addr", "port", "lun", "chap-type", "nic-assoc",
-	"target-name", "chap-name", "chap-secret", "rev-chap-name",
-	"rev-chap-name-secret", NULL};
-
-enum ibft_initiator_properties_enum {
-	ibft_init_index,
-	ibft_init_flags,
-	ibft_init_isns_server,
-	ibft_init_slp_server,
-	ibft_init_pri_radius_server,
-	ibft_init_sec_radius_server,
-	ibft_init_initiator_name,
-	ibft_init_end_marker,
-};
-
-static const char *ibft_initiator_properties[] =
-	{"index", "flags", "isns-server", "slp-server", "pri-radius-server",
-	"sec-radius-server", "initiator-name", NULL};
-
-/*
  * The kobject and attribute structures.
  */
 
@@ -249,29 +182,9 @@ struct ibft_kobject {
 		struct ibft_tgt *tgt;
 		struct ibft_hdr *hdr;
 	};
-	struct kobject kobj;
-	struct list_head node;
 };
 
-struct ibft_attribute {
-	struct attribute attr;
-	ssize_t (*show) (struct  ibft_kobject *entry,
-			 struct ibft_attribute *attr, char *buf);
-	union {
-		struct ibft_initiator *initiator;
-		struct ibft_nic *nic;
-		struct ibft_tgt *tgt;
-		struct ibft_hdr *hdr;
-	};
-	struct kobject *kobj;
-	int type; /* The enum of the type. This can be any value of:
-		ibft_eth_properties_enum, ibft_tgt_properties_enum,
-		or ibft_initiator_properties_enum. */
-	struct list_head node;
-};
-
-static LIST_HEAD(ibft_attr_list);
-static LIST_HEAD(ibft_kobject_list);
+static struct iscsi_boot_kset *boot_kset;
 
 static const char nulls[16];
 
@@ -310,35 +223,27 @@ static ssize_t sprintf_string(char *str, int len, char *buf)
 static int ibft_verify_hdr(char *t, struct ibft_hdr *hdr, int id, int length)
 {
 	if (hdr->id != id) {
-		printk(KERN_ERR "iBFT error: We expected the " \
+		printk(KERN_ERR "iBFT error: We expected the %s " \
 				"field header.id to have %d but " \
-				"found %d instead!\n", id, hdr->id);
+				"found %d instead!\n", t, id, hdr->id);
 		return -ENODEV;
 	}
 	if (hdr->length != length) {
-		printk(KERN_ERR "iBFT error: We expected the " \
+		printk(KERN_ERR "iBFT error: We expected the %s " \
 				"field header.length to have %d but " \
-				"found %d instead!\n", length, hdr->length);
+				"found %d instead!\n", t, length, hdr->length);
 		return -ENODEV;
 	}
 
 	return 0;
 }
 
-static void ibft_release(struct kobject *kobj)
-{
-	struct ibft_kobject *ibft =
-		container_of(kobj, struct ibft_kobject, kobj);
-	kfree(ibft);
-}
-
 /*
  *  Routines for parsing the iBFT data to be human readable.
  */
-static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
-					struct ibft_attribute *attr,
-					char *buf)
+static ssize_t ibft_attr_show_initiator(void *data, int type, char *buf)
 {
+	struct ibft_kobject *entry = data;
 	struct ibft_initiator *initiator = entry->initiator;
 	void *ibft_loc = entry->header;
 	char *str = buf;
@@ -346,26 +251,26 @@ static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
 	if (!initiator)
 		return 0;
 
-	switch (attr->type) {
-	case ibft_init_index:
+	switch (type) {
+	case ISCSI_BOOT_INI_INDEX:
 		str += sprintf(str, "%d\n", initiator->hdr.index);
 		break;
-	case ibft_init_flags:
+	case ISCSI_BOOT_INI_FLAGS:
 		str += sprintf(str, "%d\n", initiator->hdr.flags);
 		break;
-	case ibft_init_isns_server:
+	case ISCSI_BOOT_INI_ISNS_SERVER:
 		str += sprintf_ipaddr(str, initiator->isns_server);
 		break;
-	case ibft_init_slp_server:
+	case ISCSI_BOOT_INI_SLP_SERVER:
 		str += sprintf_ipaddr(str, initiator->slp_server);
 		break;
-	case ibft_init_pri_radius_server:
+	case ISCSI_BOOT_INI_PRI_RADIUS_SERVER:
 		str += sprintf_ipaddr(str, initiator->pri_radius_server);
 		break;
-	case ibft_init_sec_radius_server:
+	case ISCSI_BOOT_INI_SEC_RADIUS_SERVER:
 		str += sprintf_ipaddr(str, initiator->sec_radius_server);
 		break;
-	case ibft_init_initiator_name:
+	case ISCSI_BOOT_INI_INITIATOR_NAME:
 		str += sprintf_string(str, initiator->initiator_name_len,
 				      (char *)ibft_loc +
 				      initiator->initiator_name_off);
@@ -377,10 +282,9 @@ static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
 	return str - buf;
 }
 
-static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
-				  struct ibft_attribute *attr,
-				  char *buf)
+static ssize_t ibft_attr_show_nic(void *data, int type, char *buf)
 {
+	struct ibft_kobject *entry = data;
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
 	char *str = buf;
@@ -389,42 +293,42 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	if (!nic)
 		return 0;
 
-	switch (attr->type) {
-	case ibft_eth_index:
+	switch (type) {
+	case ISCSI_BOOT_ETH_INDEX:
 		str += sprintf(str, "%d\n", nic->hdr.index);
 		break;
-	case ibft_eth_flags:
+	case ISCSI_BOOT_ETH_FLAGS:
 		str += sprintf(str, "%d\n", nic->hdr.flags);
 		break;
-	case ibft_eth_ip_addr:
+	case ISCSI_BOOT_ETH_IP_ADDR:
 		str += sprintf_ipaddr(str, nic->ip_addr);
 		break;
-	case ibft_eth_subnet_mask:
+	case ISCSI_BOOT_ETH_SUBNET_MASK:
 		val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
 		str += sprintf(str, "%pI4", &val);
 		break;
-	case ibft_eth_origin:
+	case ISCSI_BOOT_ETH_ORIGIN:
 		str += sprintf(str, "%d\n", nic->origin);
 		break;
-	case ibft_eth_gateway:
+	case ISCSI_BOOT_ETH_GATEWAY:
 		str += sprintf_ipaddr(str, nic->gateway);
 		break;
-	case ibft_eth_primary_dns:
+	case ISCSI_BOOT_ETH_PRIMARY_DNS:
 		str += sprintf_ipaddr(str, nic->primary_dns);
 		break;
-	case ibft_eth_secondary_dns:
+	case ISCSI_BOOT_ETH_SECONDARY_DNS:
 		str += sprintf_ipaddr(str, nic->secondary_dns);
 		break;
-	case ibft_eth_dhcp:
+	case ISCSI_BOOT_ETH_DHCP:
 		str += sprintf_ipaddr(str, nic->dhcp);
 		break;
-	case ibft_eth_vlan:
+	case ISCSI_BOOT_ETH_VLAN:
 		str += sprintf(str, "%d\n", nic->vlan);
 		break;
-	case ibft_eth_mac:
+	case ISCSI_BOOT_ETH_MAC:
 		str += sprintf(str, "%pM\n", nic->mac);
 		break;
-	case ibft_eth_hostname:
+	case ISCSI_BOOT_ETH_HOSTNAME:
 		str += sprintf_string(str, nic->hostname_len,
 				      (char *)ibft_loc + nic->hostname_off);
 		break;
@@ -435,10 +339,9 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	return str - buf;
 };
 
-static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
-				     struct ibft_attribute *attr,
-				     char *buf)
+static ssize_t ibft_attr_show_target(void *data, int type, char *buf)
 {
+	struct ibft_kobject *entry = data;
 	struct ibft_tgt *tgt = entry->tgt;
 	void *ibft_loc = entry->header;
 	char *str = buf;
@@ -447,48 +350,48 @@ static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
 	if (!tgt)
 		return 0;
 
-	switch (attr->type) {
-	case ibft_tgt_index:
+	switch (type) {
+	case ISCSI_BOOT_TGT_INDEX:
 		str += sprintf(str, "%d\n", tgt->hdr.index);
 		break;
-	case ibft_tgt_flags:
+	case ISCSI_BOOT_TGT_FLAGS:
 		str += sprintf(str, "%d\n", tgt->hdr.flags);
 		break;
-	case ibft_tgt_ip_addr:
+	case ISCSI_BOOT_TGT_IP_ADDR:
 		str += sprintf_ipaddr(str, tgt->ip_addr);
 		break;
-	case ibft_tgt_port:
+	case ISCSI_BOOT_TGT_PORT:
 		str += sprintf(str, "%d\n", tgt->port);
 		break;
-	case ibft_tgt_lun:
+	case ISCSI_BOOT_TGT_LUN:
 		for (i = 0; i < 8; i++)
 			str += sprintf(str, "%x", (u8)tgt->lun[i]);
 		str += sprintf(str, "\n");
 		break;
-	case ibft_tgt_nic_assoc:
+	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		str += sprintf(str, "%d\n", tgt->nic_assoc);
 		break;
-	case ibft_tgt_chap_type:
+	case ISCSI_BOOT_TGT_CHAP_TYPE:
 		str += sprintf(str, "%d\n", tgt->chap_type);
 		break;
-	case ibft_tgt_name:
+	case ISCSI_BOOT_TGT_NAME:
 		str += sprintf_string(str, tgt->tgt_name_len,
 				      (char *)ibft_loc + tgt->tgt_name_off);
 		break;
-	case ibft_tgt_chap_name:
+	case ISCSI_BOOT_TGT_CHAP_NAME:
 		str += sprintf_string(str, tgt->chap_name_len,
 				      (char *)ibft_loc + tgt->chap_name_off);
 		break;
-	case ibft_tgt_chap_secret:
+	case ISCSI_BOOT_TGT_CHAP_SECRET:
 		str += sprintf_string(str, tgt->chap_secret_len,
 				      (char *)ibft_loc + tgt->chap_secret_off);
 		break;
-	case ibft_tgt_rev_chap_name:
+	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
 		str += sprintf_string(str, tgt->rev_chap_name_len,
 				      (char *)ibft_loc +
 				      tgt->rev_chap_name_off);
 		break;
-	case ibft_tgt_rev_chap_secret:
+	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
 		str += sprintf_string(str, tgt->rev_chap_secret_len,
 				      (char *)ibft_loc +
 				      tgt->rev_chap_secret_off);
@@ -500,40 +403,6 @@ static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
 	return str - buf;
 }
 
-/*
- * The routine called for all sysfs attributes.
- */
-static ssize_t ibft_show_attribute(struct kobject *kobj,
-				    struct attribute *attr,
-				    char *buf)
-{
-	struct ibft_kobject *dev =
-		container_of(kobj, struct ibft_kobject, kobj);
-	struct ibft_attribute *ibft_attr =
-		container_of(attr, struct ibft_attribute, attr);
-	ssize_t ret = -EIO;
-	char *str = buf;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if (ibft_attr->show)
-		ret = ibft_attr->show(dev, ibft_attr, str);
-
-	return ret;
-}
-
-static const struct sysfs_ops ibft_attr_ops = {
-	.show = ibft_show_attribute,
-};
-
-static struct kobj_type ibft_ktype = {
-	.release = ibft_release,
-	.sysfs_ops = &ibft_attr_ops,
-};
-
-static struct kset *ibft_kset;
-
 static int __init ibft_check_device(void)
 {
 	int len;
@@ -561,12 +430,149 @@ static int __init ibft_check_device(void)
 }
 
 /*
+ * Helper routiners to check to determine if the entry is valid
+ * in the proper iBFT structure.
+ */
+static mode_t ibft_check_nic_for(void *data, int type)
+{
+	struct ibft_kobject *entry = data;
+	struct ibft_nic *nic = entry->nic;
+	mode_t rc = 0;
+
+	switch (type) {
+	case ISCSI_BOOT_ETH_INDEX:
+	case ISCSI_BOOT_ETH_FLAGS:
+		rc = 1;
+		break;
+	case ISCSI_BOOT_ETH_IP_ADDR:
+		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_SUBNET_MASK:
+		if (nic->subnet_mask_prefix)
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_ORIGIN:
+		rc = 1;
+		break;
+	case ISCSI_BOOT_ETH_GATEWAY:
+		if (memcmp(nic->gateway, nulls, sizeof(nic->gateway)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_PRIMARY_DNS:
+		if (memcmp(nic->primary_dns, nulls,
+			   sizeof(nic->primary_dns)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_SECONDARY_DNS:
+		if (memcmp(nic->secondary_dns, nulls,
+			   sizeof(nic->secondary_dns)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_DHCP:
+		if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_VLAN:
+	case ISCSI_BOOT_ETH_MAC:
+		rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_HOSTNAME:
+		if (nic->hostname_off)
+			rc = S_IRUGO;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+static mode_t __init ibft_check_tgt_for(void *data, int type)
+{
+	struct ibft_kobject *entry = data;
+	struct ibft_tgt *tgt = entry->tgt;
+	mode_t rc = 0;
+
+	switch (type) {
+	case ISCSI_BOOT_TGT_INDEX:
+	case ISCSI_BOOT_TGT_FLAGS:
+	case ISCSI_BOOT_TGT_IP_ADDR:
+	case ISCSI_BOOT_TGT_PORT:
+	case ISCSI_BOOT_TGT_LUN:
+	case ISCSI_BOOT_TGT_NIC_ASSOC:
+	case ISCSI_BOOT_TGT_CHAP_TYPE:
+		rc = S_IRUGO;
+	case ISCSI_BOOT_TGT_NAME:
+		if (tgt->tgt_name_len)
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_TGT_CHAP_NAME:
+	case ISCSI_BOOT_TGT_CHAP_SECRET:
+		if (tgt->chap_name_len)
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
+	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
+		if (tgt->rev_chap_name_len)
+			rc = S_IRUGO;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+static mode_t __init ibft_check_initiator_for(void *data, int type)
+{
+	struct ibft_kobject *entry = data;
+	struct ibft_initiator *init = entry->initiator;
+	mode_t rc = 0;
+
+	switch (type) {
+	case ISCSI_BOOT_INI_INDEX:
+	case ISCSI_BOOT_INI_FLAGS:
+		rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_ISNS_SERVER:
+		if (memcmp(init->isns_server, nulls,
+			   sizeof(init->isns_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_SLP_SERVER:
+		if (memcmp(init->slp_server, nulls,
+			   sizeof(init->slp_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_PRI_RADIUS_SERVER:
+		if (memcmp(init->pri_radius_server, nulls,
+			   sizeof(init->pri_radius_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_SEC_RADIUS_SERVER:
+		if (memcmp(init->sec_radius_server, nulls,
+			   sizeof(init->sec_radius_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_INITIATOR_NAME:
+		if (init->initiator_name_len)
+			rc = S_IRUGO;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+/*
  * Helper function for ibft_register_kobjects.
  */
 static int __init ibft_create_kobject(struct acpi_table_ibft *header,
-				       struct ibft_hdr *hdr,
-				       struct list_head *list)
+				      struct ibft_hdr *hdr)
 {
+	struct iscsi_boot_kobj *boot_kobj = NULL;
 	struct ibft_kobject *ibft_kobj = NULL;
 	struct ibft_nic *nic = (struct ibft_nic *)hdr;
 	struct pci_dev *pci_dev;
@@ -583,14 +589,47 @@ static int __init ibft_create_kobject(struct acpi_table_ibft *header,
 	case id_initiator:
 		rc = ibft_verify_hdr("initiator", hdr, id_initiator,
 				     sizeof(*ibft_kobj->initiator));
+		if (rc)
+			break;
+
+		boot_kobj = iscsi_boot_create_initiator(boot_kset, hdr->index,
+						ibft_kobj,
+						ibft_attr_show_initiator,
+						ibft_check_initiator_for);
+		if (!boot_kobj) {
+			rc = -ENOMEM;
+			goto free_ibft_obj;
+		}
 		break;
 	case id_nic:
 		rc = ibft_verify_hdr("ethernet", hdr, id_nic,
 				     sizeof(*ibft_kobj->nic));
+		if (rc)
+			break;
+
+		boot_kobj = iscsi_boot_create_ethernet(boot_kset, hdr->index,
+						       ibft_kobj,
+						       ibft_attr_show_nic,
+						       ibft_check_nic_for);
+		if (!boot_kobj) {
+			rc = -ENOMEM;
+			goto free_ibft_obj;
+		}
 		break;
 	case id_target:
 		rc = ibft_verify_hdr("target", hdr, id_target,
 				     sizeof(*ibft_kobj->tgt));
+		if (rc)
+			break;
+
+		boot_kobj = iscsi_boot_create_target(boot_kset, hdr->index,
+						     ibft_kobj,
+						     ibft_attr_show_target,
+						     ibft_check_tgt_for);
+		if (!boot_kobj) {
+			rc = -ENOMEM;
+			goto free_ibft_obj;
+		}
 		break;
 	case id_reserved:
 	case id_control:
@@ -608,22 +647,10 @@ static int __init ibft_create_kobject(struct acpi_table_ibft *header,
 
 	if (rc) {
 		/* Skip adding this kobject, but exit with non-fatal error. */
-		kfree(ibft_kobj);
-		goto out_invalid_struct;
+		rc = 0;
+		goto free_ibft_obj;
 	}
 
-	ibft_kobj->kobj.kset = ibft_kset;
-
-	rc = kobject_init_and_add(&ibft_kobj->kobj, &ibft_ktype,
-				  NULL, ibft_id_names[hdr->id], hdr->index);
-
-	if (rc) {
-		kfree(ibft_kobj);
-		goto out;
-	}
-
-	kobject_uevent(&ibft_kobj->kobj, KOBJ_ADD);
-
 	if (hdr->id == id_nic) {
 		/*
 		* We don't search for the device in other domains than
@@ -634,19 +661,16 @@ static int __init ibft_create_kobject(struct acpi_table_ibft *header,
 		pci_dev = pci_get_bus_and_slot((nic->pci_bdf & 0xff00) >> 8,
 					       (nic->pci_bdf & 0xff));
 		if (pci_dev) {
-			rc = sysfs_create_link(&ibft_kobj->kobj,
+			rc = sysfs_create_link(&boot_kobj->kobj,
 					       &pci_dev->dev.kobj, "device");
 			pci_dev_put(pci_dev);
 		}
 	}
+	return 0;
 
-	/* Nothing broke so lets add it to the list. */
-	list_add_tail(&ibft_kobj->node, list);
-out:
+free_ibft_obj:
+	kfree(ibft_kobj);
 	return rc;
-out_invalid_struct:
-	/* Unsupported structs are skipped. */
-	return 0;
 }
 
 /*
@@ -654,8 +678,7 @@ out_invalid_struct:
  * found add them on the passed-in list. We do not support the other
  * fields at this point, so they are skipped.
  */
-static int __init ibft_register_kobjects(struct acpi_table_ibft *header,
-					  struct list_head *list)
+static int __init ibft_register_kobjects(struct acpi_table_ibft *header)
 {
 	struct ibft_control *control = NULL;
 	void *ptr, *end;
@@ -680,8 +703,7 @@ static int __init ibft_register_kobjects(struct acpi_table_ibft *header,
 		if (offset && offset < header->header.length &&
 						offset < eot_offset) {
 			rc = ibft_create_kobject(header,
-						 (void *)header + offset,
-						 list);
+						 (void *)header + offset);
 			if (rc)
 				break;
 		}
@@ -690,240 +712,28 @@ static int __init ibft_register_kobjects(struct acpi_table_ibft *header,
 	return rc;
 }
 
-static void ibft_unregister(struct list_head *attr_list,
-			     struct list_head *kobj_list)
+static void ibft_unregister(void)
 {
-	struct ibft_kobject *data = NULL, *n;
-	struct ibft_attribute *attr = NULL, *m;
-
-	list_for_each_entry_safe(attr, m, attr_list, node) {
-		sysfs_remove_file(attr->kobj, &attr->attr);
-		list_del(&attr->node);
-		kfree(attr);
-	};
-	list_del_init(attr_list);
-
-	list_for_each_entry_safe(data, n, kobj_list, node) {
-		list_del(&data->node);
-		if (data->hdr->id == id_nic)
-			sysfs_remove_link(&data->kobj, "device");
-		kobject_put(&data->kobj);
+	struct iscsi_boot_kobj *boot_kobj, *tmp_kobj;
+	struct ibft_kobject *ibft_kobj;
+
+	list_for_each_entry_safe(boot_kobj, tmp_kobj,
+				 &boot_kset->kobj_list, list) {
+		ibft_kobj = boot_kobj->data;
+		if (ibft_kobj->hdr->id == id_nic)
+			sysfs_remove_link(&boot_kobj->kobj, "device");
 	};
-	list_del_init(kobj_list);
-}
-
-static int __init ibft_create_attribute(struct ibft_kobject *kobj_data,
-					 int type,
-					 const char *name,
-					 ssize_t (*show)(struct ibft_kobject *,
-							 struct ibft_attribute*,
-							 char *buf),
-					 struct list_head *list)
-{
-	struct ibft_attribute *attr = NULL;
-	struct ibft_hdr *hdr = kobj_data->hdr;
-
-	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr)
-		return -ENOMEM;
-
-	attr->attr.name = name;
-	attr->attr.mode = S_IRUSR;
-
-	attr->hdr = hdr;
-	attr->show = show;
-	attr->kobj = &kobj_data->kobj;
-	attr->type = type;
-
-	list_add_tail(&attr->node, list);
-
-	return 0;
-}
-
-/*
- * Helper routiners to check to determine if the entry is valid
- * in the proper iBFT structure.
- */
-static int __init ibft_check_nic_for(struct ibft_nic *nic, int entry)
-{
-	int rc = 0;
-
-	switch (entry) {
-	case ibft_eth_index:
-	case ibft_eth_flags:
-		rc = 1;
-		break;
-	case ibft_eth_ip_addr:
-		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
-			rc = 1;
-		break;
-	case ibft_eth_subnet_mask:
-		if (nic->subnet_mask_prefix)
-			rc = 1;
-		break;
-	case ibft_eth_origin:
-		rc = 1;
-		break;
-	case ibft_eth_gateway:
-		if (memcmp(nic->gateway, nulls, sizeof(nic->gateway)))
-			rc = 1;
-		break;
-	case ibft_eth_primary_dns:
-		if (memcmp(nic->primary_dns, nulls,
-			   sizeof(nic->primary_dns)))
-			rc = 1;
-		break;
-	case ibft_eth_secondary_dns:
-		if (memcmp(nic->secondary_dns, nulls,
-			   sizeof(nic->secondary_dns)))
-			rc = 1;
-		break;
-	case ibft_eth_dhcp:
-		if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
-			rc = 1;
-		break;
-	case ibft_eth_vlan:
-	case ibft_eth_mac:
-		rc = 1;
-		break;
-	case ibft_eth_hostname:
-		if (nic->hostname_off)
-			rc = 1;
-		break;
-	default:
-		break;
-	}
-
-	return rc;
-}
-
-static int __init ibft_check_tgt_for(struct ibft_tgt *tgt, int entry)
-{
-	int rc = 0;
-
-	switch (entry) {
-	case ibft_tgt_index:
-	case ibft_tgt_flags:
-	case ibft_tgt_ip_addr:
-	case ibft_tgt_port:
-	case ibft_tgt_lun:
-	case ibft_tgt_nic_assoc:
-	case ibft_tgt_chap_type:
-		rc = 1;
-	case ibft_tgt_name:
-		if (tgt->tgt_name_len)
-			rc = 1;
-		break;
-	case ibft_tgt_chap_name:
-	case ibft_tgt_chap_secret:
-		if (tgt->chap_name_len)
-			rc = 1;
-		break;
-	case ibft_tgt_rev_chap_name:
-	case ibft_tgt_rev_chap_secret:
-		if (tgt->rev_chap_name_len)
-			rc = 1;
-		break;
-	default:
-		break;
-	}
-
-	return rc;
 }
 
-static int __init ibft_check_initiator_for(struct ibft_initiator *init,
-					    int entry)
+static void ibft_cleanup(void)
 {
-	int rc = 0;
-
-	switch (entry) {
-	case ibft_init_index:
-	case ibft_init_flags:
-		rc = 1;
-		break;
-	case ibft_init_isns_server:
-		if (memcmp(init->isns_server, nulls,
-			   sizeof(init->isns_server)))
-			rc = 1;
-		break;
-	case ibft_init_slp_server:
-		if (memcmp(init->slp_server, nulls,
-			   sizeof(init->slp_server)))
-			rc = 1;
-		break;
-	case ibft_init_pri_radius_server:
-		if (memcmp(init->pri_radius_server, nulls,
-			   sizeof(init->pri_radius_server)))
-			rc = 1;
-		break;
-	case ibft_init_sec_radius_server:
-		if (memcmp(init->sec_radius_server, nulls,
-			   sizeof(init->sec_radius_server)))
-			rc = 1;
-		break;
-	case ibft_init_initiator_name:
-		if (init->initiator_name_len)
-			rc = 1;
-		break;
-	default:
-		break;
-	}
-
-	return rc;
+	ibft_unregister();
+	iscsi_boot_destroy_kset(boot_kset);
 }
 
-/*
- *  Register the attributes for all of the kobjects.
- */
-static int __init ibft_register_attributes(struct list_head *kobject_list,
-					    struct list_head *attr_list)
+static void __exit ibft_exit(void)
 {
-	int rc = 0, i = 0;
-	struct ibft_kobject *data = NULL;
-	struct ibft_attribute *attr = NULL, *m;
-
-	list_for_each_entry(data, kobject_list, node) {
-		switch (data->hdr->id) {
-		case id_nic:
-			for (i = 0; i < ibft_eth_end_marker && !rc; i++)
-				if (ibft_check_nic_for(data->nic, i))
-					rc = ibft_create_attribute(data, i,
-						ibft_eth_properties[i],
-						ibft_attr_show_nic, attr_list);
-			break;
-		case id_target:
-			for (i = 0; i < ibft_tgt_end_marker && !rc; i++)
-				if (ibft_check_tgt_for(data->tgt, i))
-					rc = ibft_create_attribute(data, i,
-						ibft_tgt_properties[i],
-						ibft_attr_show_target,
-						attr_list);
-			break;
-		case id_initiator:
-			for (i = 0; i < ibft_init_end_marker && !rc; i++)
-				if (ibft_check_initiator_for(
-					data->initiator, i))
-					rc = ibft_create_attribute(data, i,
-						ibft_initiator_properties[i],
-						ibft_attr_show_initiator,
-						attr_list);
-			break;
-		default:
-			break;
-		}
-		if (rc)
-			break;
-	}
-	list_for_each_entry_safe(attr, m, attr_list, node) {
-		rc = sysfs_create_file(attr->kobj, &attr->attr);
-		if (rc) {
-			list_del(&attr->node);
-			kfree(attr);
-			break;
-		}
-	}
-
-	return rc;
+	ibft_cleanup();
 }
 
 /*
@@ -933,26 +743,20 @@ static int __init ibft_init(void)
 {
 	int rc = 0;
 
-	ibft_kset = kset_create_and_add("ibft", NULL, firmware_kobj);
-	if (!ibft_kset)
-		return -ENOMEM;
-
 	if (ibft_addr) {
 		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
 		       (u64)isa_virt_to_bus(ibft_addr));
 
 		rc = ibft_check_device();
 		if (rc)
-			goto out_firmware_unregister;
+			return rc;
 
-		/* Scan the IBFT for data and register the kobjects. */
-		rc = ibft_register_kobjects(ibft_addr, &ibft_kobject_list);
-		if (rc)
-			goto out_free;
+		boot_kset = iscsi_boot_create_kset("ibft");
+		if (!boot_kset)
+			return -ENOMEM;
 
-		/* Register the attributes */
-		rc = ibft_register_attributes(&ibft_kobject_list,
-					      &ibft_attr_list);
+		/* Scan the IBFT for data and register the kobjects. */
+		rc = ibft_register_kobjects(ibft_addr);
 		if (rc)
 			goto out_free;
 	} else
@@ -961,17 +765,9 @@ static int __init ibft_init(void)
 	return 0;
 
 out_free:
-	ibft_unregister(&ibft_attr_list, &ibft_kobject_list);
-out_firmware_unregister:
-	kset_unregister(ibft_kset);
+	ibft_cleanup();
 	return rc;
 }
 
-static void __exit ibft_exit(void)
-{
-	ibft_unregister(&ibft_attr_list, &ibft_kobject_list);
-	kset_unregister(ibft_kset);
-}
-
 module_init(ibft_init);
 module_exit(ibft_exit);
-- 
1.6.6.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
