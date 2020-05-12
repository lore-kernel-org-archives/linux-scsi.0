Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B77C54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 05:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01ACA20736
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 05:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgELFN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 01:13:29 -0400
Received: from smtp.infotech.no ([82.134.31.41]:32970 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgELFN3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 01:13:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id F37DC204238;
        Tue, 12 May 2020 07:13:26 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gcBXjE23lTFf; Tue, 12 May 2020 07:13:24 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 3A7FF20417A;
        Tue, 12 May 2020 07:13:22 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     damien.lemoal@wdc.com, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v2] scsi_debug: improve error reporting, zbc+general
Date:   Tue, 12 May 2020 01:13:20 -0400
Message-Id: <20200512051320.116081-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This driver attempts to help the application client in the case of
ILLEGAL REQUEST by using the field pointer information mechanism
to point to the location in a cdb or parameter block that triggered
an error. Some cases of the ILLEGAL REQUEST sense key being issued
without field pointer information snuck into the recently added zone
commands. There were also pre-existing cases that are picked up by
this patch.

The change is to use mk_sense_invalid_fld() rather than
mk_sense_buffer() and supply the extra information to the former.
Sometimes that is not so easy since the exact byte offset in the
cdb for the family of WRITE commands, for example, is "up the stack"
when some such errors are detected. In these cases incomplete field
pointer information is passed backed to the level that can see the
cbd_s at which point the sense data is rewritten in full.

Uses the scsi_set_sense_field_pointer() library function to replace
open coding of the same logic.

This patch is on top of the patchset whose cover pages is:
  [PATCH 0/7] scsi_debug: Add ZBC support
and
  [PATCH] scsi_debug: Fix compilation error on 32bits arch
both by Damien Le Moal

ChangeLog since first version:
  - incorporate changes suggested by Damien
    - didn't generalize small pattern to separate helper as after
      more pruning there is only 2 simple instances and 2 more
      complex ones.
  - use BLK_ZONED_NONE instead of 0 to make logic clearer

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 158 ++++++++++++++++++++++++++------------
 1 file changed, 109 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 79a48dd1b9e4..60e84a1cdfac 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -61,7 +61,7 @@
 
 /* make sure inq_product_rev string corresponds to this version */
 #define SDEBUG_VERSION "0189"	/* format to fit INQUIRY revision field */
-static const char *sdebug_version_date = "20200421";
+static const char *sdebug_version_date = "20200507";
 
 #define MY_NAME "scsi_debug"
 
@@ -925,8 +925,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 				 int in_byte, int in_bit)
 {
 	unsigned char *sbuff;
-	u8 sks[4];
-	int sl, asc;
+	int asc;
 
 	sbuff = scp->sense_buffer;
 	if (!sbuff) {
@@ -937,29 +936,27 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
 	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
 	scsi_build_sense_buffer(sdebug_dsense, sbuff, ILLEGAL_REQUEST, asc, 0);
-	memset(sks, 0, sizeof(sks));
-	sks[0] = 0x80;
-	if (c_d)
-		sks[0] |= 0x40;
-	if (in_bit >= 0) {
-		sks[0] |= 0x8;
-		sks[0] |= 0x7 & in_bit;
-	}
-	put_unaligned_be16(in_byte, sks + 1);
-	if (sdebug_dsense) {
-		sl = sbuff[7] + 8;
-		sbuff[7] = sl;
-		sbuff[sl] = 0x2;
-		sbuff[sl + 1] = 0x6;
-		memcpy(sbuff + sl + 4, sks, 3);
-	} else
-		memcpy(sbuff + 15, sks, 3);
+	scsi_set_sense_field_pointer(sbuff, SCSI_SENSE_BUFFERSIZE, in_byte,
+				     (in_bit < 0 ? 8 : in_bit), (bool)c_d);
 	if (sdebug_verbose)
 		sdev_printk(KERN_INFO, scp->device, "%s:  [sense_key,asc,ascq"
 			    "]: [0x5,0x%x,0x0] %c byte=%d, bit=%d\n",
 			    my_name, asc, c_d ? 'C' : 'D', in_byte, in_bit);
 }
 
+static bool have_sense_invalid_fld_cdb(struct scsi_cmnd *scp)
+{
+	if (!scp->sense_buffer)
+		return false;
+	if (sdebug_dsense)
+		return ((scp->sense_buffer[1] & 0xf) == ILLEGAL_REQUEST &&
+			scp->sense_buffer[2] == INVALID_FIELD_IN_CDB &&
+			scp->sense_buffer[3] == 0);
+	return ((scp->sense_buffer[2] & 0xf) == ILLEGAL_REQUEST &&
+		scp->sense_buffer[12] == INVALID_FIELD_IN_CDB &&
+		scp->sense_buffer[13] == 0);
+}
+
 static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 {
 	unsigned char *sbuff;
@@ -2777,14 +2774,14 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 }
 
 static int check_zbc_access_params(struct scsi_cmnd *scp,
-			unsigned long long lba, unsigned int num, bool write)
+		unsigned long long lba, unsigned int num, bool data_out)
 {
 	struct scsi_device *sdp = scp->device;
 	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
 	struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
 	struct sdeb_zone_state *zsp_end = zbc_zone(devip, lba + num - 1);
 
-	if (!write) {
+	if (!data_out) {
 		if (devip->zmodel == BLK_ZONED_HA)
 			return 0;
 		/* For host-managed, reads cannot cross zone types boundaries */
@@ -2820,8 +2817,8 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 		}
 		/* Cannot write full zones */
 		if (zsp->z_cond == ZC5_FULL) {
-			mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
+			/* want sLBA position in cdb, fix up later */
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 0, -1);
 			return check_condition_result;
 		}
 		/* Writes must be aligned to the zone WP */
@@ -2848,9 +2845,10 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 	return 0;
 }
 
+/* Last argument should only be true when data-out and media modifying */
 static inline int check_device_access_params
 			(struct scsi_cmnd *scp, unsigned long long lba,
-			 unsigned int num, bool write)
+			 unsigned int num, bool modifying)
 {
 	struct scsi_device *sdp = scp->device;
 	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
@@ -2861,16 +2859,16 @@ static inline int check_device_access_params
 	}
 	/* transfer length excessive (tie in to block limits VPD page) */
 	if (num > sdebug_store_sectors) {
-		/* needs work to find which cdb byte 'num' comes from */
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		/* want num offset in cdb, fix up later */
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 0, -1);
 		return check_condition_result;
 	}
-	if (write && unlikely(sdebug_wp)) {
+	if (modifying && unlikely(sdebug_wp)) {
 		mk_sense_buffer(scp, DATA_PROTECT, WRITE_PROTECTED, 0x2);
 		return check_condition_result;
 	}
 	if (sdebug_dev_is_zoned(devip))
-		return check_zbc_access_params(scp, lba, num, write);
+		return check_zbc_access_params(scp, lba, num, modifying);
 
 	return 0;
 }
@@ -3462,6 +3460,36 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	write_lock(macc_lckp);
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret) {
+		if (have_sense_invalid_fld_cdb(scp)) {
+			bool is_zbc = (sdeb_zbc_model != BLK_ZONED_NONE);
+			int lba_o, num_o;
+
+			switch (cmd[0]) {
+			case WRITE_16:
+				lba_o = 2;
+				num_o = 10;
+				break;
+			case WRITE_10:
+			case 0x53:
+				lba_o = 2;
+				num_o = 7;
+				break;
+			case WRITE_6:
+				lba_o = 1;
+				num_o = 4;
+				break;
+			case WRITE_12:
+				lba_o = 2;
+				num_o = 6;
+				break;
+			default:	/* assume WRITE(32) */
+				lba_o = 20;
+				num_o = 28;
+				break;
+			}
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB,
+					     (is_zbc ? lba_o : num_o), -1);
+		}
 		write_unlock(macc_lckp);
 		return ret;
 	}
@@ -3568,7 +3596,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			sdev_printk(KERN_INFO, scp->device,
 				"%s: %s: LB Data Offset field bad\n",
 				my_name, __func__);
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, (is_16 ? 4 : 12), -1);
 		return illegal_condition_result;
 	}
 	lbdof_blen = lbdof * lb_size;
@@ -3577,7 +3605,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			sdev_printk(KERN_INFO, scp->device,
 				"%s: %s: LBA range descriptors don't fit\n",
 				my_name, __func__);
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, (is_16 ? 8 : 16), -1);
 		return illegal_condition_result;
 	}
 	lrdp = kzalloc(lbdof_blen, GFP_ATOMIC);
@@ -3607,8 +3635,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		if (num == 0)
 			continue;
 		ret = check_device_access_params(scp, lba, num, true);
-		if (ret)
+		if (ret) {
+			if (have_sense_invalid_fld_cdb(scp))
+				/* assume not zbc, point at number of LBs */
+				mk_sense_invalid_fld(scp, SDEB_IN_DATA,
+						     (up - lrdp) + 8, -1);
 			goto err_out_unlock;
+		}
 		num_by = num * lb_size;
 		ei_lba = is_16 ? 0 : get_unaligned_be32(up + 12);
 
@@ -3703,7 +3736,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	write_lock(macc_lckp);
 
 	ret = check_device_access_params(scp, lba, num, true);
-	if (ret) {
+	if (ret) {	/* illegal request fixup next level up */
 		write_unlock(macc_lckp);
 		return ret;
 	}
@@ -3755,6 +3788,7 @@ static int resp_write_same_10(struct scsi_cmnd *scp,
 	u32 lba;
 	u16 num;
 	u32 ei_lba = 0;
+	int res;
 	bool unmap = false;
 
 	if (cmd[1] & 0x8) {
@@ -3770,7 +3804,13 @@ static int resp_write_same_10(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);
 		return check_condition_result;
 	}
-	return resp_write_same(scp, lba, num, ei_lba, unmap, false);
+	res = resp_write_same(scp, lba, num, ei_lba, unmap, false);
+	if (have_sense_invalid_fld_cdb(scp)) {
+		bool is_zbc = (sdeb_zbc_model != BLK_ZONED_NONE);
+
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, is_zbc ? 2 : 7, -1);
+	}
+	return res;
 }
 
 static int resp_write_same_16(struct scsi_cmnd *scp,
@@ -3780,6 +3820,7 @@ static int resp_write_same_16(struct scsi_cmnd *scp,
 	u64 lba;
 	u32 num;
 	u32 ei_lba = 0;
+	int res;
 	bool unmap = false;
 	bool ndob = false;
 
@@ -3798,7 +3839,13 @@ static int resp_write_same_16(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);
 		return check_condition_result;
 	}
-	return resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
+	res = resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
+	if (have_sense_invalid_fld_cdb(scp)) {
+		bool is_zbc = (sdeb_zbc_model != BLK_ZONED_NONE);
+
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, is_zbc ? 2 : 10, -1);
+	}
+	return res;
 }
 
 /* Note the mode field is in the same position as the (lower) service action
@@ -3878,9 +3925,13 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	    (cmd[1] & 0xe0) == 0)
 		sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 			    "to DIF device\n");
-	ret = check_device_access_params(scp, lba, num, false);
-	if (ret)
+	ret = check_device_access_params(scp, lba, num, true);
+	if (ret) {
+		if (have_sense_invalid_fld_cdb(scp))
+			/* assume not zbc, point at number of LBs */
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 13, -1);
 		return ret;
+	}
 	dnum = 2 * num;
 	arr = kcalloc(lb_size, dnum, GFP_ATOMIC);
 	if (NULL == arr) {
@@ -3959,8 +4010,18 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		unsigned int num = get_unaligned_be32(&desc[i].blocks);
 
 		ret = check_device_access_params(scp, lba, num, true);
-		if (ret)
+		if (ret) {
+			if (have_sense_invalid_fld_cdb(scp)) {
+				bool is_zbc = (sdeb_zbc_model !=
+					       BLK_ZONED_NONE);
+				u8 *offp = (u8 *)&desc[i].lba +
+					   (is_zbc ? 0 : 8);
+
+				mk_sense_invalid_fld(scp, SDEB_IN_DATA,
+						     (offp - buf), -1);
+			}
 			goto out;
+		}
 
 		unmap_region(sip, lba, num);
 	}
@@ -4230,7 +4291,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	a_num = is_bytchk3 ? 1 : vnum;
-	/* Treat following check like one for read (i.e. no write) access */
+	/* This is data-out but not media modifying, so last argument false */
 	ret = check_device_access_params(scp, lba, a_num, false);
 	if (ret)
 		return ret;
@@ -4367,8 +4428,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 				continue;
 			break;
 		default:
-			mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 14, 5);
 			ret = check_condition_result;
 			goto fini;
 		}
@@ -4458,12 +4518,12 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zsp = zbc_zone(devip, z_id);
 	if (z_id != zsp->z_start) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
 	if (zbc_zone_is_conv(zsp)) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
@@ -4528,12 +4588,12 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 
 	zsp = zbc_zone(devip, z_id);
 	if (z_id != zsp->z_start) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
 	if (zbc_zone_is_conv(zsp)) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
@@ -4601,12 +4661,12 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 
 	zsp = zbc_zone(devip, z_id);
 	if (z_id != zsp->z_start) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
 	if (zbc_zone_is_conv(zsp)) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
@@ -4676,12 +4736,12 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zsp = zbc_zone(devip, z_id);
 	if (z_id != zsp->z_start) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
 	if (zbc_zone_is_conv(zsp)) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 		res = check_condition_result;
 		goto fini;
 	}
-- 
2.25.1

