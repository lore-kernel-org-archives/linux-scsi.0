From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/ConfigFS]: Add PR APTPL device
	attributes
Date: Mon, 10 Aug 2009 10:10:11 -0700
Message-ID: <1249924211.31984.1.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:43493 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932313AbZHJRKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 13:10:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>, Florian Haas <florian.haas@linbit.com>

Hello,

This patch adds two configfs attributes in /sys/kernel/config/target/core/$HBA/$DEV/pr.
First a read only attr called res_aptpl_active that shows read-only APTPL_A status,
and then res_aptpl_metadata which accepts key=value pairs for core_scsi3_alloc_aptpl_registration()
to perform PR registrations from APTPL provided metadata through the target_core_mod
configfs interface.  The key=value pairs currently defined in target_core_dev_pr_store_attr_res_aptpl_metadata()
and which are written to /sys/kernel/config/target/core/$HBA/$DEV/res_aptpl_metadata
in key0=value0,key1=value1,etc format are:

*) initiator_fabric
*) initiator_node
*) sa_res_key
*) res_holder
*) res_type
*) res_scope
*) res_all_tg_pt
*) mapped_lun
*) target_fabric
*) target_node
*) tpgt
*) port_rtpi
*) target_lun

Note that initiator_fabric, target_fabric, and port_rtpi keys are saved in struct file
PR APTPL metadta and are currently being extracted, but not being passed in
core_scsi3_alloc_aptpl_registration() which saves the incoming metadata into a PR registration.
This will probably change in the near future as this code moves to use SCSI Transport IDs
parsing provide by struct target_core_fabric_ops

Also note that /sys/kernel/config/target/core/$HBA/$DEV/pr/res_aptpl_metadata can also
used to create PR registration from APTPL metadata when no active fabric module
(eg: iSCSI ports) exist, which prevents things from changing while SCSI Initiator ports
are actively using PR logic for the TCM storage object.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |  266 ++++++++++++++++++++++++++++++++-
 1 files changed, 265 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 4561ee2..847995a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1125,6 +1125,266 @@ static ssize_t target_core_dev_pr_show_attr_res_type(
 
 SE_DEV_PR_ATTR_RO(res_type);
 
+/*
+ * res_aptpl_active
+ */
+
+static ssize_t target_core_dev_pr_show_attr_res_aptpl_active(
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	if (!(su_dev->se_dev_ptr))
+		return -ENODEV;
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+		return 0;
+
+	return sprintf(page, "APTPL Bit Status: %s\n",
+		(T10_RES(su_dev)->pr_aptpl_active) ? "Activated" : "Disabled");
+}
+
+SE_DEV_PR_ATTR_RO(res_aptpl_active);
+
+/*
+ * res_aptpl_metadata
+ */
+static ssize_t target_core_dev_pr_show_attr_res_aptpl_metadata(
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	if (!(su_dev->se_dev_ptr))
+		return -ENODEV;
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+		return 0;
+
+	return sprintf(page, "Ready to process PR APTPL metadata..\n");
+}
+
+static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
+	struct se_subsystem_dev_s *su_dev,
+	const char *page,
+	size_t count)
+{
+	se_device_t *dev;
+	unsigned char *i_fabric, *t_fabric, *i_port = NULL, *t_port = NULL;
+	char *ptr, *ptr2, *cur, *buf;
+	unsigned long long tmp_ll;
+	unsigned long tmp_l;
+	u64 sa_res_key = 0;
+	u32 mapped_lun = 0, target_lun = 0;
+	int ret = -1, res_holder = 0, all_tg_pt = 0;
+	u16 port_rpti = 0, tpgt = 0;
+	u8 type = 0, scope;
+
+	dev = su_dev->se_dev_ptr;
+	if (!(dev))
+		return -ENODEV;
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+		return 0;
+
+	if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
+		printk(KERN_INFO "Unable to process APTPL metadata while"
+			" active fabric exports exist\n");
+		return -EINVAL;
+	}
+	/*
+	 * Allocate and copy input to our own buffer so that we can setup
+	 * NULL terminators later for incoming PR APTPL metadata..
+	 */
+	buf = kzalloc(count, GFP_KERNEL);
+	memcpy(buf, page, count);
+	cur = &buf[0];
+
+	while (cur) {
+		ptr = strstr(cur, "=");
+		if (!(ptr))
+			goto out;
+
+		*ptr = '\0';
+		ptr++;
+		/*
+		 * PR APTPL Metadata for Initiator Port
+		 */
+		ptr2 = strstr(cur, "initiator_fabric");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			i_fabric = ptr;
+			continue;
+		}
+		ptr2 = strstr(cur, "initiator_node");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			if (strlen(ptr) > PR_APTPL_MAX_IPORT_LEN) {
+				printk(KERN_ERR "APTPL metadata initiator_node="
+					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
+					PR_APTPL_MAX_IPORT_LEN);	
+				ret = -1;
+				break;
+			}
+			i_port = ptr;
+			continue;
+		}
+		ptr2 = strstr(cur, "sa_res_key");	
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoull(ptr, 0, &tmp_ll);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoull() failed for"
+					" sa_res_key=\n");
+				break;
+			}
+			sa_res_key = (u64)tmp_ll;
+			continue;
+		}
+		/*
+		 * PR APTPL Metadata for Reservation
+		 */
+		ptr2 = strstr(cur, "res_holder");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" res_holder=\n");
+				break;
+			}
+			res_holder = (int)tmp_l;
+			continue;
+		}
+		ptr2 = strstr(cur, "res_type");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" res_type=\n");
+				break;
+			}
+			type = (u8)tmp_l;
+			continue;
+		}
+		ptr2 = strstr(cur, "res_scope");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" res_scope=\n");
+				break;
+			}
+			scope = (u8)tmp_l;
+			continue;
+		}
+		ptr2 = strstr(cur, "res_all_tg_pt");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" res_all_tg_pt=\n");
+				break;
+			}
+			all_tg_pt = (int)tmp_l;	
+			continue;
+		}
+		ptr2 = strstr(cur, "mapped_lun");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" mapped_lun=\n");	
+				break;
+			}
+			mapped_lun = (u32)tmp_l;
+			continue;
+		}
+		/*
+		 * PR APTPL Metadata for Target Port
+		 */	
+		ptr2 = strstr(cur, "target_fabric");	
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			t_fabric = ptr;
+			continue;
+		}
+		ptr2 = strstr(cur, "target_node");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			if (strlen(ptr) > PR_APTPL_MAX_TPORT_LEN) {
+				printk(KERN_ERR "APTPL metadata target_node="
+					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
+					PR_APTPL_MAX_TPORT_LEN);        
+				ret = -1;
+				break;
+			}
+			t_port = ptr;
+			continue;
+		}
+		ptr2 = strstr(cur, "tpgt");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" tpgt=\n");
+				break;
+			}
+			tpgt = (u16)tmp_l;
+			continue;
+		}
+		ptr2 = strstr(cur, "port_rtpi");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" port_rtpi=\n");	
+				break;
+			}
+			port_rpti = (u16)tmp_l;
+			continue;
+		}
+		ptr2 = strstr(cur, "target_lun");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			ret = strict_strtoul(ptr, 0, &tmp_l);
+			if (ret < 0) {
+				printk(KERN_ERR "strict_strtoul() failed for"
+					" target_lun=\n");
+				break;
+			}
+			target_lun = (u32)tmp_l;
+			continue;
+		} else
+			cur = NULL;
+	}
+
+	if (!(i_port) || !(t_port) || !(sa_res_key)) {
+		printk(KERN_ERR "Illegal parameters for APTPL registration\n");
+		ret = -1;
+		goto out;	
+	}
+
+	if (res_holder && !(type)) {
+		printk(KERN_ERR "Illegal PR type: 0x%02x for reservation"
+				" holder\n", type);
+		ret = -1;
+		goto out;
+	}
+
+	ret = core_scsi3_alloc_aptpl_registration(T10_RES(su_dev), sa_res_key,
+			i_port, mapped_lun, t_port, tpgt, target_lun, res_holder,
+			all_tg_pt, type);
+out:
+	kfree(buf);
+	return (ret == 0) ? count : -EINVAL;
+}
+
+SE_DEV_PR_ATTR(res_aptpl_metadata, S_IRUGO | S_IWUSR);
+
 CONFIGFS_EATTR_OPS(target_core_dev_pr, se_subsystem_dev_s, se_dev_pr_group);
 
 static struct configfs_attribute *target_core_dev_pr_attrs[] = {
@@ -1135,6 +1395,8 @@ static struct configfs_attribute *target_core_dev_pr_attrs[] = {
 	&target_core_dev_pr_res_pr_registered_i_pts.attr,
 	&target_core_dev_pr_res_pr_type.attr,
 	&target_core_dev_pr_res_type.attr,
+	&target_core_dev_pr_res_aptpl_active.attr,
+	&target_core_dev_pr_res_aptpl_metadata.attr,
 	NULL,
 };
 
@@ -2158,9 +2420,11 @@ static struct config_group *target_core_call_createdev(
 	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&se_dev->t10_wwn.t10_vpd_lock);
 	INIT_LIST_HEAD(&se_dev->t10_reservation.registration_list);
+	INIT_LIST_HEAD(&se_dev->t10_reservation.aptpl_reg_list);
 	spin_lock_init(&se_dev->t10_reservation.registration_lock);
+	spin_lock_init(&se_dev->t10_reservation.aptpl_reg_lock);
 	spin_lock_init(&se_dev->se_dev_lock);
-
+	se_dev->t10_reservation.pr_aptpl_buf_len = PR_APTPL_BUF_LEN;
 	se_dev->t10_wwn.t10_sub_dev = se_dev;
 	se_dev->se_dev_attrib.da_sub_dev = se_dev;
 
-- 
1.5.4.1



