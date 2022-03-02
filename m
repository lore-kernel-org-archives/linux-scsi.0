Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB21C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239642AbiCBFhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239521AbiCBFhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0865CB16F2
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:33 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222iBHk016894;
        Wed, 2 Mar 2022 05:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=ULnz/gkzD/hTVp62r05l6On+ELMmvG4umJ5WzfAQZts=;
 b=d3TszB61ijkLjHtsY+WmgP916WXsaCLHvS10CbMWv2SPrL5eRtTohRbHQwqbRLeJ059L
 EiPpN4jH7jRPZnhttQjl/DSGS8inOdl/xnbOmrQUxqMTbjcviMr9hZI8rPacOIgTGgwB
 ZdF2zMyhKmOIMDIzbqLTOIyIkBSq6+Vosmswh9Lc9DEcogfPzUKAdUYMvyCSVleo/exo
 7dma0wULgpQO5Cl4PiXPgzn0A7vCIsnNBf2m37gDCKlpqZIMbmF8zR2chrnovS78ffF3
 cCIKPWDw0qconnjdb8Msd+7smeTG9m3kFwaAnOSkeDFZKb337SYOnTaj0JDLTysMcFi1 oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehdayu52n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225Ipfg175853;
        Wed, 2 Mar 2022 05:36:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vag7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:28 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZX014395;
        Wed, 2 Mar 2022 05:36:28 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-3;
        Wed, 02 Mar 2022 05:36:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Maciej W . Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 02/14] scsi: core: Query VPD size before getting full page
Date:   Wed,  2 Mar 2022 00:35:47 -0500
Message-Id: <20220302053559.32147-3-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: w7o7fsOylgUtcgd0RgQ-LkZWA1vo8q4a
X-Proofpoint-ORIG-GUID: w7o7fsOylgUtcgd0RgQ-LkZWA1vo8q4a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently default to 255 bytes when fetching VPD pages during discovery.
However, we have had a few devices that are known to wedge if the requested
buffer exceeds a certain size. See commit af73623f5f10 ("[SCSI] sd: Reduce
buffer size for vpd request") which works around one example of this
problem in the SCSI disk driver.

With commit d188b0675b21 ("scsi: core: Add sysfs attributes for VPD pages
0h and 89h") we now risk triggering the same issue in the generic midlayer
code.

The problem with the ATA VPD page in particular is that the SCSI portion of
the page is trailed by 512 bytes of verbatim ATA Identify Device
information.  However, not all controllers actually provide the additional
512 bytes and will lock up if one asks for more than the 64 bytes
containing the SCSI protocol fields.

Instead of picking a new, somewhat arbitrary, number of bytes for the VPD
buffer size, start fetching the 4-byte header for each page. The header
contains the size of the page as far as the device is concerned. We can use
the reported size to specify the correct allocation length when
subsequently fetching the full page.

The header validation is done by a new helper function scsi_get_vpd_size()
and both scsi_get_vpd_page() and scsi_get_vpd_buf() now rely on this to
query the page size.

In addition, scsi_get_vpd_page() is simplified to mirror the logic in
scsi_get_vpd_page(). This involves removing the Supported VPD Pages lookup
prior to attempting to query a page. There does not appear any evidence,
even in the oldest SCSI specs, that this step is required. We already rely
on scsi_get_vpd_page() throughout the stack and this function never
consulted the Supported VPD Pages. Since this has not caused any problems
it should be safe to remove the precondition from scsi_get_vpd_page().

Instrumented runs also revealed that the Supported VPD Pages lookup had
little effect since the device page index often was larger than the
supplied buffer size. As a result, inquiries frequently bypassed the index
check and went through the "If we ran off the end of the buffer, give us
the benefit of the doubt" code path which assumed the page was present
despite not being listed. The revised code takes both the page size
reported by the device as well as the size of the buffer provided by the
scsi_get_vpd_page() caller into account.

Fixes: d188b0675b21 ("scsi: core: Add sysfs attributes for VPD pages 0h and 89h")
Reported-by: Maciej W. Rozycki <macro@orcam.me.uk>
Tested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c        | 94 +++++++++++++++++++++++++-------------
 include/scsi/scsi_device.h |  5 +-
 2 files changed, 67 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 211aace69c22..af896d0647a7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -321,6 +321,32 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	return get_unaligned_be16(&buffer[2]) + 4;
 }
 
+static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
+{
+	unsigned char vpd_header[SCSI_VPD_HEADER_SIZE];
+	int result;
+
+	/*
+	 * Fetch the VPD page header to find out how big the page
+	 * is. This is done to prevent problems on legacy devices
+	 * which can not handle allocation lengths as large as
+	 * potentially requested by the caller.
+	 */
+	result = scsi_vpd_inquiry(sdev, vpd_header, page, sizeof(vpd_header));
+
+	if (result < 0)
+		return 0;
+
+	if (result < SCSI_VPD_HEADER_SIZE) {
+		dev_warn_once(&sdev->sdev_gendev,
+			      "%s: short VPD page 0x%02x length: %d bytes\n",
+			      __func__, page, result);
+		return 0;
+	}
+
+	return result;
+}
+
 /**
  * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
  * @sdev: The device to ask
@@ -330,47 +356,42 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
  *
  * SCSI devices may optionally supply Vital Product Data.  Each 'page'
  * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
- * If the device supports this VPD page, this routine returns a pointer
- * to a buffer containing the data from that page.  The caller is
- * responsible for calling kfree() on this pointer when it is no longer
- * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
+ * If the device supports this VPD page, this routine fills @buf
+ * with the data from that page and return 0. If the VPD page is not
+ * supported or its content cannot be retrieved, -EINVAL is returned.
  */
 int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 		      int buf_len)
 {
-	int i, result;
+	int result, vpd_len;
 
-	if (sdev->skip_vpd_pages)
-		goto fail;
-
-	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
-	if (result < 4)
-		goto fail;
-
-	/* If the user actually wanted this page, we can skip the rest */
-	if (page == 0)
-		return 0;
+	if (!scsi_device_supports_vpd(sdev))
+		return -EINVAL;
 
-	for (i = 4; i < min(result, buf_len); i++)
-		if (buf[i] == page)
-			goto found;
+	vpd_len = scsi_get_vpd_size(sdev, page);
+	if (vpd_len <= 0)
+		return -EINVAL;
 
-	if (i < result && i >= buf_len)
-		/* ran off the end of the buffer, give us benefit of doubt */
-		goto found;
-	/* The device claims it doesn't support the requested page */
-	goto fail;
+	vpd_len = min(vpd_len, buf_len);
 
- found:
-	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
+retry_pg:
+	/*
+	 * Fetch the actual page. Since the appropriate size was reported
+	 * by the device it is now safe to ask for something bigger.
+	 */
+	memset(buf, 0, buf_len);
+	result = scsi_vpd_inquiry(sdev, buf, page, vpd_len);
 	if (result < 0)
-		goto fail;
+		return -EINVAL;
+	else if (result > vpd_len) {
+		dev_warn_once(&sdev->sdev_gendev,
+			      "%s: VPD page 0x%02x result %d > %d bytes\n",
+			      __func__, page, result, vpd_len);
+		vpd_len = min(result, buf_len);
+		goto retry_pg;
+	}
 
 	return 0;
-
- fail:
-	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
@@ -384,9 +405,17 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 static struct scsi_vpd *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page)
 {
 	struct scsi_vpd *vpd_buf;
-	int vpd_len = SCSI_VPD_PG_LEN, result;
+	int vpd_len, result;
+
+	vpd_len = scsi_get_vpd_size(sdev, page);
+	if (vpd_len <= 0)
+		return NULL;
 
 retry_pg:
+	/*
+	 * Fetch the actual page. Since the appropriate size was reported
+	 * by the device it is now safe to ask for something bigger.
+	 */
 	vpd_buf = kmalloc(sizeof(*vpd_buf) + vpd_len, GFP_KERNEL);
 	if (!vpd_buf)
 		return NULL;
@@ -397,6 +426,9 @@ static struct scsi_vpd *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page)
 		return NULL;
 	}
 	if (result > vpd_len) {
+		dev_warn_once(&sdev->sdev_gendev,
+			      "%s: VPD page 0x%02x result %d > %d bytes\n",
+			      __func__, page, result, vpd_len);
 		vpd_len = result;
 		kfree(vpd_buf);
 		goto retry_pg;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 647c53b26105..144d3a801c8d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -100,6 +100,10 @@ struct scsi_vpd {
 	unsigned char	data[];
 };
 
+enum scsi_vpd_parameters {
+	SCSI_VPD_HEADER_SIZE = 4,
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -141,7 +145,6 @@ struct scsi_device {
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 
-#define SCSI_VPD_PG_LEN                255
 	struct scsi_vpd __rcu *vpd_pg0;
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
-- 
2.32.0

