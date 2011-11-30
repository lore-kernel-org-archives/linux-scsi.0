From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] iscsi_ibft: Display iBFT signature in sysfs
Date: Wed, 30 Nov 2011 15:10:28 +0100
Message-ID: <1322662228-51255-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab1K3OKa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 09:10:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

Broadcom iSCSI offload cards use the signature 'BIFT' to signal
that iSCSI offload is in use. This patch exports the iBFT signature
to sysfs so that userspace can enable iSCSI offloading here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/firmware/iscsi_ibft.c      |    7 +++++++
 drivers/firmware/iscsi_ibft_find.c |    3 +++
 drivers/scsi/iscsi_boot_sysfs.c    |    5 +++++
 include/linux/iscsi_boot_sysfs.h   |    1 +
 include/linux/iscsi_ibft.h         |    5 +++++
 5 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index c811cb1..fdedee6 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -275,6 +275,9 @@ static ssize_t ibft_attr_show_initiator(void *data, int type, char *buf)
 				      (char *)ibft_loc +
 				      initiator->initiator_name_off);
 		break;
+	case ISCSI_BOOT_INI_INITIATOR_SIG:
+		str += sprintf(str, "%s\n", ibft_sig);
+		break;
 	default:
 		break;
 	}
@@ -559,6 +562,10 @@ static mode_t __init ibft_check_initiator_for(void *data, int type)
 		if (init->initiator_name_len)
 			rc = S_IRUGO;
 		break;
+	case ISCSI_BOOT_INI_INITIATOR_SIG:
+		if (ibft_sig)
+			rc = S_IRUGO;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index bfe7232..58830ee 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -41,6 +41,8 @@
  */
 struct acpi_table_ibft *ibft_addr;
 EXPORT_SYMBOL_GPL(ibft_addr);
+char *ibft_sig;
+EXPORT_SYMBOL_GPL(ibft_sig);
 
 static const struct {
 	char *sign;
@@ -94,6 +96,7 @@ static int __init find_ibft_in_mem(void)
 				 * the table cannot be valid. */
 				if (pos + len <= (IBFT_END-1)) {
 					ibft_addr = (struct acpi_table_ibft *)virt;
+					ibft_sig = ibft_signs[i].sign;
 					goto done;
 				}
 			}
diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index 89700cb..12edb0e 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -253,6 +253,7 @@ iscsi_boot_rd_attr(ini_primary_radius, pri-radius-server,
 iscsi_boot_rd_attr(ini_secondary_radius, sec-radius-server,
 		   ISCSI_BOOT_INI_SEC_RADIUS_SERVER);
 iscsi_boot_rd_attr(ini_name, initiator-name, ISCSI_BOOT_INI_INITIATOR_NAME);
+iscsi_boot_rd_attr(ini_sig, initiator-signature, ISCSI_BOOT_INI_INITIATOR_SIG);
 
 static struct attribute *initiator_attrs[] = {
 	&iscsi_boot_attr_ini_index.attr,
@@ -262,6 +263,7 @@ static struct attribute *initiator_attrs[] = {
 	&iscsi_boot_attr_ini_primary_radius.attr,
 	&iscsi_boot_attr_ini_secondary_radius.attr,
 	&iscsi_boot_attr_ini_name.attr,
+	&iscsi_boot_attr_ini_sig.attr,
 	NULL
 };
 
@@ -292,6 +294,9 @@ static mode_t iscsi_boot_ini_attr_is_visible(struct kobject *kobj,
 	if (attr ==  &iscsi_boot_attr_ini_name.attr)
 		return boot_kobj->is_visible(boot_kobj->data,
 					     ISCSI_BOOT_INI_INITIATOR_NAME);
+	if (attr ==  &iscsi_boot_attr_ini_sig.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_INITIATOR_SIG);
 
 	return 0;
 }
diff --git a/include/linux/iscsi_boot_sysfs.h b/include/linux/iscsi_boot_sysfs.h
index f0a2f8b..2c4e8b0 100644
--- a/include/linux/iscsi_boot_sysfs.h
+++ b/include/linux/iscsi_boot_sysfs.h
@@ -60,6 +60,7 @@ enum iscsi_boot_initiator_properties_enum {
 	ISCSI_BOOT_INI_PRI_RADIUS_SERVER,
 	ISCSI_BOOT_INI_SEC_RADIUS_SERVER,
 	ISCSI_BOOT_INI_INITIATOR_NAME,
+	ISCSI_BOOT_INI_INITIATOR_SIG,
 	ISCSI_BOOT_INI_END_MARKER,
 };
 
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
index 8ba7e5b..8fadc5f 100644
--- a/include/linux/iscsi_ibft.h
+++ b/include/linux/iscsi_ibft.h
@@ -30,6 +30,11 @@
 extern struct acpi_table_ibft *ibft_addr;
 
 /*
+ * Pointer of the iSCSI Boot Format Table Signature.
+ */
+extern char *ibft_sig;
+
+/*
  * Routine used to find and reserve the iSCSI Boot Format Table. The
  * mapped address is set in the ibft_addr variable.
  */
-- 
1.6.0.2

