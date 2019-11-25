Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6FFC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 694CB20748
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LmqIXMUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfKYHFV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:05:21 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:52582 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfKYHFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 02:05:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574665520; x=1606201520;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GslTODm/Z7VcGdUGoY7qwAyun9tO5ugD7HLGK+2qvI8=;
  b=LmqIXMUNFOa0V/zfSKpB+lJVwiPOzs4iVykWF4z2rLe761aQU7+EjCI0
   muvwXi0e9nA2vqjDT8+XMWqGYfEEWsmbEtC6HIOfc5LGSO6CL/jfopzEh
   f8A7Sax5FOgx+DZEnDzKS95Wl04L4slCNaEFaACRfzFRfIFoYV9ZB/gP1
   7wqTCNPpp0+C710o+LyO4iS4YlYWpyqx6a2MvQ/cTFS/E9JgfPE4speSE
   wliLL/MgMzfA9xYt1rKNz/divOa5AjQLP+j7h12XkxfB65fiTGUFSMZjb
   jawxjYBeBCWS2WVyi/XHsu7BpOUbYySj6wX2V5VnPOnO2qJmks42akFRK
   g==;
IronPort-SDR: /8JfdBUMMx12pC/i39ZF2yzbJah5jbjrWUAyA/WEWyaA2YgWoZJIv+AYwwfT63d+Yxlh7Hqk0X
 PJ89mWJ/qraYUzYRlmaC2qwks8v0H+TmMWEs+Y29fo4yf3/Ikot4xJPP+QGcr2yA7LJgtKMoVi
 iW2iCXxO4tKrDerC2yh6pxLFvM6NdM0wz9dxFtg+A8udsMGTkTZArOM/esYQfqPxwXd94pvwaS
 O6efph8D4bl21TXnxiI+1Z3LO4zN3xtjPK4YRuk6PVqVfFfLeQtN5dJ8upZiWiO2SrEdISMbSb
 UeE=
X-IronPort-AV: E=Sophos;i="5.69,240,1571673600"; 
   d="scan'208";a="124682225"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2019 15:05:20 +0800
IronPort-SDR: WoDYBJygiD8cT9PHOFZR5IkN2ir+0Z5q3hqSaoEMP7wt3wfx9/opiQuzD3mJZzWHSbW2IVfz0E
 IATCU7QR1m5irL/8I+swJk9a392x/yVQBU0KrX5zYU4zdgHHLdUwQWNfKk4MXcq3ev75xN8lNe
 Dd3gsuUg3Vn8xPg9+DQUya6t4AIJbLVsk40sbJ12yqNTBUwkaA/Rh1NPb1W6tMyWRoc39KVzYR
 STbxGizNMCe+GKe5hFdVLaY395AbFMUCnAOG0/C9a3RFLJfkkJS01yhkbZXV2gCYh3240SLh1l
 RGgiawoVAcCGM+synFF2ALoF
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2019 23:00:22 -0800
IronPort-SDR: jyiElVXqwikrJM9dmnpxCUv8Mo0PicKJvUzi0Piq2784yl9QeoAlpnyQ8hIiitRdm170JslOZe
 2io3ccsVmhUgX9B1zk8+V2TT/9TCg/2kI6heTW+EF38zDbOzAh6MEdACwSf4FU0yL4HpvAAZBG
 CkIvJMAxG1fIRlu7rBXyqmcZ5I97DQwpq4iIsHp26XrS4bXmQNKrRQsQVEgOSw/0KOmJ+V2nTr
 G8CqlR12SUgeu7PU4iqH2U1IhhqQgpwngpMvnJd8C+dKY9C87fRV3pJfIQwmanPM/vTi7Tlez5
 SvY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Nov 2019 23:05:20 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd_zbc: Improve report zones error printout
Date:   Mon, 25 Nov 2019 16:05:18 +0900
Message-Id: <20191125070518.951717-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the case of a report zones command failure, instead of simply
printing the host_byte and driver_byte values returned, print a message
that is more human readable and useful, adding sense codes too.

To do so, use the already defined sd_print_sense_hdr() and
sd_print_result() functions by moving the declaration of these functions
into sd.h.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c     | 9 ++-------
 drivers/scsi/sd.h     | 3 +++
 drivers/scsi/sd_zbc.c | 8 +++++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 326e2877f169..93edccb1a737 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -122,8 +122,6 @@ static void sd_eh_reset(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
-static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
-static void sd_print_result(const struct scsi_disk *, const char *, int);
 
 static DEFINE_IDA(sd_index_ida);
 
@@ -3704,15 +3702,13 @@ static void __exit exit_sd(void)
 module_init(init_sd);
 module_exit(exit_sd);
 
-static void sd_print_sense_hdr(struct scsi_disk *sdkp,
-			       struct scsi_sense_hdr *sshdr)
+void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
 	scsi_print_sense_hdr(sdkp->device,
 			     sdkp->disk ? sdkp->disk->disk_name : NULL, sshdr);
 }
 
-static void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
-			    int result)
+void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result)
 {
 	const char *hb_string = scsi_hostbyte_string(result);
 	const char *db_string = scsi_driverbyte_string(result);
@@ -3727,4 +3723,3 @@ static void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
 			  "%s: Result: hostbyte=0x%02x driverbyte=0x%02x\n",
 			  msg, host_byte(result), driver_byte(result));
 }
-
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 1eab779f812b..43dc0228f1ce 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -239,4 +239,7 @@ static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr);
+void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result);
+
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index de4019dc0f0b..71db972bf71f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -87,9 +87,11 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 				  timeout, SD_MAX_RETRIES, NULL);
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
-			  "REPORT ZONES lba %llu failed with %d/%d\n",
-			  (unsigned long long)lba,
-			  host_byte(result), driver_byte(result));
+			  "REPORT ZONES start lba %llu failed\n", lba);
+		sd_print_result(sdkp, "REPORT ZONES", result);
+		if (driver_byte(result) == DRIVER_SENSE &&
+		    scsi_sense_valid(&sshdr))
+			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EIO;
 	}
 
-- 
2.23.0

