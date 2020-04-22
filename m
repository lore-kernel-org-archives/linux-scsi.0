Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957D0C5518A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DB5520656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RUyAqyRP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgDVKnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:43:05 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22891 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731744AbgDVKmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552145; x=1619088145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BWdN5Uq0KmTBC91tGfCvRVgx7zK7KxpVbt9ZP24cB9I=;
  b=RUyAqyRP0zTSlqaeEU9Ke6G8bpKoz3jR8kmnUk84u071zEdcQTEYu8wK
   WHiQXMhVX1cw21RZ3ppucU6xrwsd/r3QLXXAJm+LU3NuKHH5YB7tYK9Bg
   gqJLtCyIm34XHlTuBoJDtVeLBGUeCQeuSz3kYPxiMHjc7PMeW1F8PY7Sw
   Pf8xWTPA4oiFKfGXxZzW2Mu7m1ixxfOr2LQ4shJSK1VSw4tUaUJaHMakq
   EVaYFq+WFEO1nhU1Led3QZUPM0V/zj4tBuemR6nHpijMJNVFh8sqQtB1E
   McNJnR0854XltFlKS06B+Y/53QpgdEnykqEn4wH5phLmGb3m1dhcTJtfT
   g==;
IronPort-SDR: hNdB/WYq1Oze4rith0+Fh4NUZ+zbL5mfDCj0UdHns9kUOPLXyyXDlaUeb/ijhL/VVky1t1M1Bv
 Hq3qgJnoMtj1V5ezHu6c2ex2FKV+vN6DBYX3NmjHqiCXIbkcJ5FH+1oVAN0i+DROP/eIX2fE9p
 gMKq64Zw/2zV5emLjCbFtW1MxXKCez6UCOSTmOEItASFmTAB8lpW1BqWA+hmlrNN5nbKzUmrpN
 cm52hdWY0o2wh8daS5opOpFVzvH7H9xCPs08GpsbrBX+ZuInL4zmZrjbUDUIvXmCZg7wWLib6S
 QaM=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230018"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:24 +0800
IronPort-SDR: 8HhRIHpua1Le8tKMj67RWZZTrz1KB45Pqq0YbQ3yuomC8EMKbLdbcSfVlF6Jg2OZsnasNiSVPB
 FuUSS6QguuioMr290dSJqpracnPiYQ4+M=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:13 -0700
IronPort-SDR: 2oIXxnT3+eGAQApAZTsFkyH0yfHVdfhpX9AZkqDuAmVrQUrvbeYyq49Kxwx1Kw5McC8JPBj/OW
 8e7AG0eePvwA==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:22 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 1/7] scsi_debug: add zbc mode and VPD pages
Date:   Wed, 22 Apr 2020 19:42:15 +0900
Message-Id: <20200422104221.378203-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200422104221.378203-1-damien.lemoal@wdc.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

The ZBC standard "piggy-backs" on many, but not all, of the
facilities in SBC. Add those ZBC mode pages (plus mode
parameter block descriptors (e.g. "WP")) and VPD pages in
common with SBC. Add ZBC specific VPD page for the host-managed
ZBC device type (ptype=0x14).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 55 +++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0eede06fc66c..4aa4d9e58978 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1445,6 +1445,24 @@ static int inquiry_vpd_b2(unsigned char *arr)
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
 
@@ -1454,13 +1472,15 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -1498,11 +1518,14 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -1541,19 +1564,22 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -1591,6 +1617,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	} else if (sdebug_ptype == TYPE_TAPE) {	/* SSC-4 rev 3 */
 		put_unaligned_be16(0x525, arr + n);
 		n += 2;
+	} else if (is_zbc) {	/* ZBC BSR INCITS 536 revision 05 */
+		put_unaligned_be16(0x624, arr + n);
+		n += 2;
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
@@ -2180,7 +2209,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
-	bool dbd, llbaa, msense_6, is_disk, bad_pcode;
+	bool dbd, llbaa, msense_6, is_disk, is_zbc, bad_pcode;
 
 	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
 	pcontrol = (cmd[2] & 0xc0) >> 6;
@@ -2189,7 +2218,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	msense_6 = (MODE_SENSE == cmd[0]);
 	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
 	is_disk = (sdebug_ptype == TYPE_DISK);
-	if (is_disk && !dbd)
+	is_zbc = (sdebug_ptype == TYPE_ZBC);
+	if ((is_disk || is_zbc) && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
@@ -2201,8 +2231,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
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
@@ -2262,7 +2292,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 			bad_pcode = true;
 		break;
 	case 0x8:	/* Caching page, direct access */
-		if (is_disk) {
+		if (is_disk || is_zbc) {
 			len = resp_caching_pg(ap, pcontrol, target);
 			offset += len;
 		} else
@@ -2300,6 +2330,9 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
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
2.25.3

