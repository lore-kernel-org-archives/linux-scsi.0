Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C60AC11D0C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A2BB20722
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgBTUIz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 15:08:55 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47256 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbgBTUIz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 15:08:55 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A4A41204155;
        Thu, 20 Feb 2020 21:08:53 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id a7OkZpdtcwX0; Thu, 20 Feb 2020 21:08:51 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id BE8C620426D;
        Thu, 20 Feb 2020 21:08:50 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v3 07/15] scsi_debug: expand zbc support
Date:   Thu, 20 Feb 2020 15:08:30 -0500
Message-Id: <20200220200838.15809-8-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220200838.15809-1-dgilbert@interlog.com>
References: <20200220200838.15809-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ZBC standard "piggy-backs" on many, but not all, of the
facilities in SBC. Add those ZBC mode pages (plus mode
parameter block descriptors (e.g. "WP")) and VPD pages in
common with SBC. Add ZBC specific VPD page.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 55 +++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6568ad7cfb56..5a720d2a14c4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1416,6 +1416,24 @@ static int inquiry_vpd_b2(unsigned char *arr)
 	return 0x4;
 }
 
+/* Zoned block device characteristics VPD page (ZBC mandatory) */
+static int inquiry_vpd_b6(unsigned char *arr)
+{
+	memset(arr, 0, 0x3c);
+	arr[0] = 0x1; /* set URSWRZ (unrestricted read in seq. wr req zone) */
+	/*
+	 * Set Optimal number of open sequential write preferred zones and
+	 * Optimal number of non-sequentially written sequential write
+	 * preferred zones and Maximum number of open sequential write
+	 * required zones fields to 'not reported' (0xffffffff). Leave other
+	 * fields set to zero.
+	 */
+	put_unaligned_be32(0xffffffff, &arr[4]);
+	put_unaligned_be32(0xffffffff, &arr[8]);
+	put_unaligned_be32(0xffffffff, &arr[12]);
+	return 0x3c;
+}
+
 #define SDEBUG_LONG_INQ_SZ 96
 #define SDEBUG_MAX_INQ_ARR_SZ 584
 
@@ -1425,13 +1443,15 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char *arr;
 	unsigned char *cmd = scp->cmnd;
 	int alloc_len, n, ret;
-	bool have_wlun, is_disk;
+	bool have_wlun, is_disk, is_zbc, is_disk_zbc;
 
 	alloc_len = get_unaligned_be16(cmd + 3);
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
 	is_disk = (sdebug_ptype == TYPE_DISK);
+	is_zbc = (sdebug_ptype == TYPE_ZBC);
+	is_disk_zbc = (is_disk || is_zbc);
 	have_wlun = scsi_is_wlun(scp->device->lun);
 	if (have_wlun)
 		pq_pdt = TYPE_WLUN;	/* present, wlun */
@@ -1469,11 +1489,14 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[n++] = 0x86;  /* extended inquiry */
 			arr[n++] = 0x87;  /* mode page policy */
 			arr[n++] = 0x88;  /* SCSI ports */
-			if (is_disk) {	  /* SBC only */
+			if (is_disk_zbc) {	  /* SBC or ZBC */
 				arr[n++] = 0x89;  /* ATA information */
 				arr[n++] = 0xb0;  /* Block limits */
 				arr[n++] = 0xb1;  /* Block characteristics */
-				arr[n++] = 0xb2;  /* Logical Block Prov */
+				if (is_disk)
+					arr[n++] = 0xb2;  /* LB Provisioning */
+				else if (is_zbc)
+					arr[n++] = 0xb6;  /* ZB dev. char. */
 			}
 			arr[3] = n - 4;	  /* number of supported VPD pages */
 		} else if (0x80 == cmd[2]) { /* unit serial number */
@@ -1512,19 +1535,22 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		} else if (0x88 == cmd[2]) { /* SCSI Ports */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_vpd_88(&arr[4], target_dev_id);
-		} else if (is_disk && 0x89 == cmd[2]) { /* ATA information */
+		} else if (is_disk_zbc && 0x89 == cmd[2]) { /* ATA info */
 			arr[1] = cmd[2];        /*sanity */
 			n = inquiry_vpd_89(&arr[4]);
 			put_unaligned_be16(n, arr + 2);
-		} else if (is_disk && 0xb0 == cmd[2]) { /* Block limits */
+		} else if (is_disk_zbc && 0xb0 == cmd[2]) { /* Block limits */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b0(&arr[4]);
-		} else if (is_disk && 0xb1 == cmd[2]) { /* Block char. */
+		} else if (is_disk_zbc && 0xb1 == cmd[2]) { /* Block char. */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b1(&arr[4]);
 		} else if (is_disk && 0xb2 == cmd[2]) { /* LB Prov. */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b2(&arr[4]);
+		} else if (is_zbc && cmd[2] == 0xb6) { /* ZB dev. charact. */
+			arr[1] = cmd[2];        /*sanity */
+			arr[3] = inquiry_vpd_b6(&arr[4]);
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 			kfree(arr);
@@ -1562,6 +1588,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	} else if (sdebug_ptype == TYPE_TAPE) {	/* SSC-4 rev 3 */
 		put_unaligned_be16(0x525, arr + n);
 		n += 2;
+	} else if (is_zbc) {	/* ZBC BSR INCITS 536 revision 05 */
+		put_unaligned_be16(0x624, arr + n);
+		n += 2;
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
@@ -2151,7 +2180,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
-	bool dbd, llbaa, msense_6, is_disk, bad_pcode;
+	bool dbd, llbaa, msense_6, is_disk, is_zbc, bad_pcode;
 
 	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
 	pcontrol = (cmd[2] & 0xc0) >> 6;
@@ -2160,7 +2189,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	msense_6 = (MODE_SENSE == cmd[0]);
 	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
 	is_disk = (sdebug_ptype == TYPE_DISK);
-	if (is_disk && !dbd)
+	is_zbc = (sdebug_ptype == TYPE_ZBC);
+	if ((is_disk || is_zbc) && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
@@ -2172,8 +2202,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	}
 	target_dev_id = ((devip->sdbg_host->shost->host_no + 1) * 2000) +
 			(devip->target * 1000) - 3;
-	/* for disks set DPOFUA bit and clear write protect (WP) bit */
-	if (is_disk) {
+	/* for disks+zbc set DPOFUA bit and clear write protect (WP) bit */
+	if (is_disk || is_zbc) {
 		dev_spec = 0x10;	/* =0x90 if WP=1 implies read-only */
 		if (sdebug_wp)
 			dev_spec |= 0x80;
@@ -2233,7 +2263,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 			bad_pcode = true;
 		break;
 	case 0x8:	/* Caching page, direct access */
-		if (is_disk) {
+		if (is_disk || is_zbc) {
 			len = resp_caching_pg(ap, pcontrol, target);
 			offset += len;
 		} else
@@ -2271,6 +2301,9 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 						      target);
 				len += resp_caching_pg(ap + len, pcontrol,
 						       target);
+			} else if (is_zbc) {
+				len += resp_caching_pg(ap + len, pcontrol,
+						       target);
 			}
 			len += resp_ctrl_m_pg(ap + len, pcontrol, target);
 			len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
-- 
2.25.0

