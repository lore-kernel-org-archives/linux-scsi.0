From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 1/9] [SCSI] Detect overflow of sense data buffer
Date: Fri, 18 Jan 2013 11:27:06 -0500
Message-ID: <1358526434-1173-2-git-send-email-emilne@redhat.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3ARQ1Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2013 11:27:16 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRG9S008147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:16 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRFnE026564
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:16 -0500
In-Reply-To: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Added code to SCSI mid-layer sense processing to detect the SDAT_OVFL
bit in Fixed or Descriptor format sense data, and log a kernel message
if the device reported that the sense data did not fit in the buffer.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c |  9 ++++++++-
 include/scsi/scsi_eh.h    |  1 +
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 182d5a5..88f6d16 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -230,6 +230,7 @@ struct sdebug_dev_info {
 	char reset;
 	char stopped;
 	char used;
+	char sense_pending;
 };
 
 struct sdebug_host_info {
@@ -3205,6 +3206,32 @@ static ssize_t sdebug_map_show(struct device_driver *ddp, char *buf)
 }
 DRIVER_ATTR(map, S_IRUGO, sdebug_map_show, NULL);
 
+static ssize_t sdebug_sense_overflow_store(struct device_driver *ddp,
+					   const char *buf, size_t count)
+{
+	int n;
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		spin_lock(&sdebug_host_list_lock);
+		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+			list_for_each_entry(devip, &sdbg_host->dev_info_list,
+					    dev_list) {
+				mk_sense_buffer(devip, NO_SENSE, 0, 0);
+				if (scsi_debug_dsense)
+					devip->sense_buff[4] = 0x80;
+				else
+					devip->sense_buff[2] = 0x10;
+				devip->sense_pending = 1;
+			}
+		}
+		spin_unlock(&sdebug_host_list_lock);
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(sense_overflow, S_IWUSR, NULL, sdebug_sense_overflow_store);
 
 /* Note: The following function creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
@@ -3239,11 +3266,15 @@ static int do_create_driverfs_files(void)
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_guard);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_ato);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_map);
+	ret |= driver_create_file(&sdebug_driverfs_driver,
+				  &driver_attr_sense_overflow);
 	return ret;
 }
 
 static void do_remove_driverfs_files(void)
 {
+	driver_remove_file(&sdebug_driverfs_driver,
+			   &driver_attr_sense_overflow);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_map);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_ato);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_guard);
@@ -3926,6 +3957,10 @@ write:
 		errsts = check_condition_result;
 		break;
 	}
+	if (!errsts && devip->sense_pending) {
+		devip->sense_pending = 0;
+		errsts = check_condition_result;
+	}
 	return schedule_resp(SCpnt, devip, done, errsts,
 			     (delay_override ? 0 : scsi_debug_delay));
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0f71e5..20669836 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,6 +241,9 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	if (sshdr.overflow)
+		scmd_printk(KERN_WARNING, scmd, "Sense data overflow");
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
@@ -2059,14 +2062,18 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 			sshdr->asc = sense_buffer[2];
 		if (sb_len > 3)
 			sshdr->ascq = sense_buffer[3];
+		if (sb_len > 4)
+			sshdr->overflow = ((sense_buffer[4] & 0x80) != 0);
 		if (sb_len > 7)
 			sshdr->additional_length = sense_buffer[7];
 	} else {
 		/*
 		 * fixed format
 		 */
-		if (sb_len > 2)
+		if (sb_len > 2) {
+			sshdr->overflow = ((sense_buffer[2] & 0x10) != 0);
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
+		}
 		if (sb_len > 7) {
 			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
 					 sb_len : (sense_buffer[7] + 8);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..ddf58cf 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -25,6 +25,7 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 byte5;
 	u8 byte6;
 	u8 additional_length;	/* always 0 for fixed sense format */
+	unsigned int overflow:1;	/* sense data overflow */
 };
 
 static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
-- 
1.7.11.7

