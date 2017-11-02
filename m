From: Vic Thor <vic.thor@second.anddroptable.net>
Subject: [PATCH] Added Format Unit and Sanitize commands
Date: Thu, 2 Nov 2017 11:32:31 +0200
Message-ID: <20171102093231.GA26177@sadr.members.linode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.tmdhosting.com ([108.178.0.170]:58012 "EHLO
        mx1.tmdhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbdKBMFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2017 08:05:05 -0400
Received: from [184.154.216.246] (helo=s610.tmd.cloud)
        by mx1.tmdhosting.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <vic.thor@second.anddroptable.net>)
        id 1eABrX-0007Hd-5J
        for linux-scsi@vger.kernel.org; Thu, 02 Nov 2017 04:32:36 -0500
Received: from li1490-145.members.linode.com ([139.162.173.145]:42132 helo=sadr.members.linode.com)
        by s610.tmd.cloud with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89)
        (envelope-from <vic.thor@second.anddroptable.net>)
        id 1eABrV-0005jf-Ei
        for linux-scsi@vger.kernel.org; Thu, 02 Nov 2017 05:32:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch adds support for Sanitize and Format unit commands.
Sanitize block just zeroes the buffer.
Sanitize overwrite use the pattern given.
Sanitize crypto fills the buffer with random data. Obviously a
real drive doesn't do this, but it looks like it.
FORMAT UNIT either zeroes the drive or fills it with random if the
suitable SI bit is set. It doesn't support resizing or changing the
block size.

I don't know which F_* flag to use. I've used F_M_ACCESS for
both, please advice.

Should we notify the kernel to rescan for partitions?


Signed-off-by: Victor Gonzalo <vic.thor@second@anddroptable.net>
---
 drivers/scsi/scsi_debug.c | 289 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 271 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 09ba494f8896..74eb6a7dc9eb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -43,6 +43,7 @@
 #include <linux/hrtimer.h>
 #include <linux/uuid.h>
 #include <linux/t10-pi.h>
+#include <linux/random.h>
 
 #include <net/checksum.h>
 
@@ -340,14 +341,16 @@ enum sdeb_opcode_index {
 	SDEB_I_WRITE_SAME = 27,		/* 10, 16 */
 	SDEB_I_SYNC_CACHE = 28,		/* 10 only */
 	SDEB_I_COMP_WRITE = 29,
-	SDEB_I_LAST_ELEMENT = 30,	/* keep this last */
+	SDEB_I_FORMAT_UNIT = 30,
+	SDEB_I_SANITIZE = 31,
+	SDEB_I_LAST_ELEMENT = 32,	/* keep this last */
 };
 
 
 static const unsigned char opcode_ind_arr[256] = {
 /* 0x0; 0x0->0x1f: 6 byte cdbs */
 	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
-	    0, 0, 0, 0,
+	SDEB_I_FORMAT_UNIT, 0, 0, 0,
 	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
 	0, 0, SDEB_I_INQUIRY, 0, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
 	    SDEB_I_RELEASE,
@@ -360,7 +363,7 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, SDEB_I_WRITE_BUFFER, 0, 0, 0, 0,
 /* 0x40; 0x40->0x5f: 10 byte cdbs */
 	0, SDEB_I_WRITE_SAME, SDEB_I_UNMAP, 0, 0, 0, 0, 0,
-	0, 0, 0, 0, 0, SDEB_I_LOG_SENSE, 0, 0,
+	SDEB_I_SANITIZE, 0, 0, 0, 0, SDEB_I_LOG_SENSE, 0, 0,
 	0, 0, 0, SDEB_I_XDWRITEREAD, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
 	    SDEB_I_RELEASE,
 	0, 0, SDEB_I_MODE_SENSE, 0, 0, 0, 0, 0,
@@ -408,6 +411,8 @@ static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_xdwriteread_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_format_unit(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_sanitize(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 static const struct opcode_info_t msense_iarr[1] = {
 	{0, 0x1a, 0, F_D_IN, NULL, NULL,
@@ -565,6 +570,12 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	     0, 0xff, 0x1f, 0xc7} },		/* COMPARE AND WRITE */
 
 /* 30 */
+	{0, 0x04, 0, F_M_ACCESS /*TODO:???*/, resp_format_unit, NULL,
+	    {6, 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	     0, 0, 0, 0} }, /* FORMAT UNIT */
+	{0, 0x48, 0, F_M_ACCESS /*TODO:???*/, resp_sanitize, NULL,
+	    {10, 0xff, 0, 0, 0, 0, 0, 0xff, 0xff, 0, 0, 0,
+	     0, 0, 0, 0} }, /* Sanitize */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
@@ -1309,7 +1320,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		int lu_id_num, port_group_id, target_dev_id, len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
-		
+
 		port_group_id = (((host_no + 1) & 0x7f) << 8) +
 		    (devip->channel & 0x7f);
 		if (sdebug_vpd_use_hostno == 0)
@@ -2336,6 +2347,256 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 		    min(len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
+static int clear_fake_store(unsigned char *pattern, bool random)
+{
+	unsigned long sz, iflags = 0, i;
+
+	if (sdebug_fake_rw != 0)
+		return 0;
+
+	write_lock_irqsave(&atomic_rw, iflags);
+
+	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
+
+	if (random) {
+		/*Not really what disks do, but close enough for simulation porpuses*/
+		get_random_bytes(fake_storep, sz);
+	} else {
+		if (pattern) {
+			for (i = 0; i < sdebug_store_sectors; i++)
+				memcpy(fake_storep + i * sdebug_sector_size, pattern, sdebug_sector_size);
+		} else
+			memset(fake_storep, 0, sz);
+	}
+	write_unlock_irqrestore(&atomic_rw, iflags);
+
+	return 0;
+}
+
+static void create_pattern_from_ip(
+	unsigned char *pattern, unsigned char *ip, size_t ip_length)
+{
+	size_t filled = 0, sz = 0;
+
+	while (filled < sdebug_sector_size) {
+		sz = (filled + ip_length > sdebug_sector_size) ?
+			(sdebug_sector_size - filled) : ip_length;
+		memcpy(pattern + filled, ip, sz);
+		filled += sz;
+	}
+}
+
+static int resp_format_unit(
+	struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	bool longlist = scp->cmnd[1] & 0x20;
+	bool fmtdata = scp->cmnd[1] & 0x10;
+	bool ip = false, si = false, immed = false;
+	unsigned char *buf = NULL, *pattern = NULL;
+	int len = 0, buf_len = 0, retval = 0, ip_offset = 0;
+	unsigned char ip_modifier = 0, ip_type = 0;
+	u16 ip_length = 0;
+	u32 defect_list_length = 0;
+
+	ip_offset = (longlist ? 8 : 4);
+
+	buf_len = scsi_bufflen(scp);
+	buf = kzalloc(buf_len, GFP_ATOMIC);
+	if (!buf) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC, INSUFF_RES_ASCQ);
+		retval = check_condition_result;
+		goto out;
+	}
+
+	if (fmtdata) {
+		len = fetch_to_dev_buffer(scp, buf, buf_len);
+		if (len < ip_offset) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_PARAM_LIST, 0);
+			retval = check_condition_result;
+			goto out;
+		}
+
+		if (longlist)
+			defect_list_length = get_unaligned(buf + 4);
+		else
+			defect_list_length = get_unaligned_be16(buf+2);
+
+		immed = buf[1] & 0x20;
+		ip = buf[1] & 0x80;
+		if (ip) {
+			if (len < ip_offset + 4) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_PARAM_LIST, 0);
+				retval = check_condition_result;
+				goto out;
+			}
+
+			ip_modifier = (buf[ip_offset] & 0xc0) >> 6;
+			si = buf[ip_offset] & 0x20;
+			ip_type = buf[ip_offset + 1];
+			ip_length = get_unaligned_be16(buf + ip_offset + 2);
+
+			switch (ip_type) {
+			case 0:
+				if (ip_length) {
+					mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_PARAM_LIST, 0);
+					retval = check_condition_result;
+					goto out;
+				}
+				pattern = NULL;
+				break;
+			case 1:
+				if ((!ip_length) ||
+						(ip_length > sdebug_sector_size) ||
+						(len != ip_offset + 4 + ip_length)) {
+					mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_PARAM_LIST, 0);
+					retval = check_condition_result;
+					goto out;
+				}
+
+			  pattern = kzalloc(sdebug_sector_size, GFP_ATOMIC);
+				if (!pattern) {
+					mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC, INSUFF_RES_ASCQ);
+					retval = check_condition_result;
+					goto out;
+				}
+
+				create_pattern_from_ip(pattern, buf + ip_offset + 4, ip_length);
+				break;
+			default:
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_PARAM_LIST, 0);
+				retval = check_condition_result;
+				goto out;
+			}
+		}
+	}
+
+	if (sdebug_verbose) {
+		sdev_printk(KERN_DEBUG, scp->device,	": Format unit\n");
+		if (fmtdata) {
+			sdev_printk(KERN_DEBUG, scp->device,
+				": Format unit parameters (%s header), %s, with%s IP, with%s SI\n",
+				longlist ? "long" : "short",
+				immed ? "return inmediately" : "wait to complete",
+				ip ? "" : "out",
+				si ? "" : "out");
+
+			if (ip_length)
+				print_hex_dump_bytes("Format Unit Initialization pattern: ",
+					DUMP_PREFIX_NONE, buf + ip_offset + 4, ip_length);
+
+			/*Not doing anything with these, but at least listing them debugging*/
+			if (defect_list_length) {
+				print_hex_dump_bytes("Format Unit defect list: ",
+					DUMP_PREFIX_NONE, buf + ip_offset + 4 + ip_length, defect_list_length);
+			}
+
+			if (ip_modifier)
+				sdev_printk(KERN_DEBUG, scp->device,
+					": Format unit ip modifier (%x) used, but it's obsolete in SBC-3\n",
+					ip_modifier);
+		}
+	}
+
+	clear_fake_store(pattern, si);
+
+out:
+	kfree(buf);
+	kfree(pattern);
+
+	return retval;
+}
+static int sanitize_overwrite(
+	struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	unsigned char *buf = NULL;
+	int buf_len = 0, len = 0;
+	unsigned char *pattern = NULL;
+	u16 ip_length = 0;
+	u16 parameter_list_length = get_unaligned_be16(scp->cmnd + 7);
+	int retval = 0;
+
+	buf_len = scsi_bufflen(scp);
+	if ((parameter_list_length < 4) ||
+			(parameter_list_length > sdebug_sector_size + 5) ||
+			(parameter_list_length != buf_len)) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
+
+	buf = kzalloc(buf_len, GFP_ATOMIC);
+	if (!buf) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC, INSUFF_RES_ASCQ);
+		retval = check_condition_result;
+		goto out;
+	}
+
+	len = fetch_to_dev_buffer(scp, buf, buf_len);
+	ip_length = get_unaligned_be16(buf + 2);
+
+	if (!ip_length || ip_length > sdebug_sector_size) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_PARAM_LIST, 0);
+		retval = check_condition_result;
+		goto out;
+	}
+
+	pattern = kzalloc(sdebug_sector_size, GFP_ATOMIC);
+	if (!pattern) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC, INSUFF_RES_ASCQ);
+		retval = check_condition_result;
+		goto out;
+	}
+
+	create_pattern_from_ip(pattern, buf + 4, ip_length);
+
+	clear_fake_store(pattern, false);
+
+	if (sdebug_verbose) {
+		sdev_printk(KERN_DEBUG, scp->device,
+			": Sanitize Overwrite With%s Invert, Test: %x, Overwrite count: %d\n",
+			(buf[0] & 0x80) ? "" : "out ",
+			((buf[0] & 0x60) >> 5),
+			(buf[0] & 0x1f));
+		print_hex_dump_bytes("Sanitize Overwrite Initialization Pattern: ",
+			DUMP_PREFIX_NONE, buf + 4, ip_length);
+	}
+
+out:
+	kfree(buf);
+	kfree(pattern);
+
+	return retval;
+}
+
+static int resp_sanitize(
+	struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	unsigned char service_action = scp->cmnd[1] & 0x1f;
+
+	switch (service_action) {
+	case 0x01:
+		return sanitize_overwrite(scp, devip);
+	case 0x02:
+		if (sdebug_verbose)
+			sdev_printk(KERN_DEBUG, scp->device, ": Sanitize Block\n");
+		clear_fake_store(NULL, false);
+		break;
+	case 0x03:
+		if (sdebug_verbose)
+			sdev_printk(KERN_DEBUG, scp->device, ": Sanitize Cryptographic Erase\n");
+		/*This is not what a real disk does, but it's good enough for testing */
+		clear_fake_store(NULL, true);
+	break;
+	case 0x1f:
+		/*Exit Failure Mode*/
+		break;
+	default:
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
+
+	return 0;
+}
+
 static int check_device_access_params(struct scsi_cmnd *scp,
 				      unsigned long long lba, unsigned int num)
 {
@@ -2995,8 +3256,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		memset(fake_storep + lba_off, 0, sdebug_sector_size);
 		ret = 0;
 	} else
-		ret = fetch_to_dev_buffer(scp, fake_storep + lba_off,
-					  sdebug_sector_size);
+		ret = fetch_to_dev_buffer(scp, fake_storep + lba_off, sdebug_sector_size);
 
 	if (-1 == ret) {
 		write_unlock_irqrestore(&atomic_rw, iflags);
@@ -3109,12 +3369,9 @@ static int resp_write_buffer(struct scsi_cmnd *scp,
 		break;
 	case 0x7:	/* download MC with offsets, save, and ACT */
 		/* set UA on all devices (LUs) in this target */
-		list_for_each_entry(dp,
-				    &devip->sdbg_host->dev_info_list,
-				    dev_list)
+		list_for_each_entry(dp, &devip->sdbg_host->dev_info_list, dev_list)
 			if (dp->target == sdp->id)
-				set_bit(SDEBUG_UA_MICROCODE_CHANGED_WO_RESET,
-					dp->uas_bm);
+				set_bit(SDEBUG_UA_MICROCODE_CHANGED_WO_RESET, dp->uas_bm);
 		break;
 	default:
 		/* do nothing for this command for other mode values */
@@ -4480,17 +4737,14 @@ static ssize_t fake_rw_show(struct device_driver *ddp, char *buf)
 static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 			     size_t count)
 {
-        int n;
+	int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		n = (n > 0);
 		sdebug_fake_rw = (sdebug_fake_rw > 0);
 		if (sdebug_fake_rw != n) {
 			if ((0 == n) && (NULL == fake_storep)) {
-				unsigned long sz =
-					(unsigned long)sdebug_dev_size_mb *
-					1048576;
-
+				unsigned long sz = (unsigned long)sdebug_dev_size_mb * 1048576;
 				fake_storep = vmalloc(sz);
 				if (NULL == fake_storep) {
 					pr_err("out of memory, 9\n");
@@ -4988,8 +5242,7 @@ static int __init scsi_debug_init(void)
 		pr_err("submit_queues must be 1 or more\n");
 		return -EINVAL;
 	}
-	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue),
-			       GFP_KERNEL);
+	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue), GFP_KERNEL);
 	if (sdebug_q_arr == NULL)
 		return -ENOMEM;
 	for (k = 0; k < submit_queues; ++k)
-- 
2.14.1
