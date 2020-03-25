Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB125C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 22:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B58762070A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 22:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ShaEZ+kg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCYWYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 18:24:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgCYWYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 18:24:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02PMOI3E124977
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 22:24:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=B82MktY7e/NvKJ4PNaOgvZ4EJK1/s8R7mBmEsNrNU5Q=;
 b=ShaEZ+kg5iqOC3sUrXxIpklKoogPJzyBeXUlmwqNzfL4zzmdctURKciKmG1k7gIOR/8Q
 Di86GAsmP8l8/5x9A2sD6pWBOEdMLwh29NDFPdxsqohVZFdn3+LZ6+k4p8lb9Ka+9eo7
 TtVGQkV1ODxALmLZIDi+RMN74qg0RuGKsGehNxOzntfARp/G+ri3Djd9haHpDSbuO89W
 Ir+q1gFKNFgxhPzBDmCPpFLIG8d+ZlISUGUjyMdXCCqRTQLAvYG15hecBCYF3UAywkGG
 WwfsmRp8Q/zXDlcuMLCIPfpcKkiP02/Fsg2AWvnMOdt+u4qvg9lm7udpHp6n23+964vp 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ywavmcdy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 22:24:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02PMLoEa120436
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 22:24:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3006r7buyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 22:24:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02PMOHrq023226
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 22:24:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Mar 2020 15:24:16 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: core: Make MODE SENSE DBD a boolean
Date:   Wed, 25 Mar 2020 18:24:16 -0400
Message-Id: <20200325222416.5094-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <116e8e24-d442-6239-b401-dd3145f4e8e8@acm.org>
References: <116e8e24-d442-6239-b401-dd3145f4e8e8@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=1 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250171
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_mode_sense() function has an argument called 'dbd' but
confusingly this is used to specify the entire second byte of the CDB
and not just the DBD bit.

Several callers assumed that 'dbd' was a flag and passed in a value of
1 instead of the required 8 to disable fetching block descriptors.
The invalid value of 1 was subsequently masked off by the function and
was not actually passed on to the device.

Turn the 'dbd' argument into a boolean and fix all callers.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

v2:	Fix conversion error spotted by Bart
---
 drivers/scsi/scsi_lib.c           |  7 ++++---
 drivers/scsi/scsi_transport_sas.c |  2 +-
 drivers/scsi/sd.c                 | 14 +++++++-------
 drivers/scsi/sr.c                 |  2 +-
 include/scsi/scsi_device.h        |  2 +-
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..acbbdb022a45 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2085,7 +2085,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	issued) if successful.
  */
 int
-scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+scsi_mode_sense(struct scsi_device *sdev, bool dbd, int modepage,
 		  unsigned char *buffer, int len, int timeout, int retries,
 		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
 {
@@ -2098,8 +2098,9 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
 
-	dbd = sdev->set_dbd_for_ms ? 8 : dbd;
-	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
+	dbd = sdev->set_dbd_for_ms ? true : dbd;
+	if (dbd)
+		cmd[1] = 1 << 3; /* DBD bit */
 	cmd[2] = modepage;
 
 	/* caller might not be interested in sense, but we need it */
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 182fd25c7c43..0547ccd81e84 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1234,7 +1234,7 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
 	if (!buffer)
 		return -ENOMEM;
 
-	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
+	res = scsi_mode_sense(sdev, true, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
 			      &mode_data, NULL);
 
 	error = -EINVAL;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ca9299ffd36..7f7b0ba8c3d8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -193,7 +193,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		return count;
 	}
 
-	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
+	if (scsi_mode_sense(sdp, true, 8, buffer, sizeof(buffer), SD_TIMEOUT,
 			    SD_MAX_RETRIES, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
@@ -2561,7 +2561,7 @@ sd_print_capacity(struct scsi_disk *sdkp,
 
 /* called with buffer of length 512 */
 static inline int
-sd_do_mode_sense(struct scsi_device *sdp, int dbd, int modepage,
+sd_do_mode_sense(struct scsi_device *sdp, bool dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
 		 struct scsi_sense_hdr *sshdr)
 {
@@ -2639,7 +2639,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	int len = 0, res;
 	struct scsi_device *sdp = sdkp->device;
 
-	int dbd;
+	bool dbd;
 	int modepage;
 	int first_len;
 	struct scsi_mode_data data;
@@ -2662,14 +2662,14 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			modepage = 0x3F;
 			if (sdp->use_192_bytes_for_3f)
 				first_len = 192;
-			dbd = 0;
+			dbd = false;
 		}
 	} else if (sdp->type == TYPE_RBC) {
 		modepage = 6;
-		dbd = 8;
+		dbd = true;
 	} else {
 		modepage = 8;
-		dbd = 0;
+		dbd = false;
 	}
 
 	/* cautiously ask */
@@ -2823,7 +2823,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->protection_type == 0)
 		return;
 
-	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+	res = scsi_mode_sense(sdp, true, 0x0a, buffer, 36, SD_TIMEOUT,
 			      SD_MAX_RETRIES, &data, &sshdr);
 
 	if (!scsi_status_is_good(res) || !data.header_length ||
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fe0e1c721a99..f31a946b7cd5 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -936,7 +936,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
+	rc = scsi_mode_sense(cd->device, false, 0x2a, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
 	if (!scsi_status_is_good(rc) || data.length > ms_len ||
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c3cba2aaf934..853082b7bcf6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -397,7 +397,7 @@ extern int scsi_track_queue_full(struct scsi_device *, int);
 
 extern int scsi_set_medium_removal(struct scsi_device *, char);
 
-extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+extern int scsi_mode_sense(struct scsi_device *sdev, bool dbd, int modepage,
 			   unsigned char *buffer, int len, int timeout,
 			   int retries, struct scsi_mode_data *data,
 			   struct scsi_sense_hdr *);
-- 
2.24.1

