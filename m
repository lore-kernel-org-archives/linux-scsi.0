Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C17C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbiCBFhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238131AbiCBFhN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC073B16F2
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222mYWQ014686
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=0LLMyZhZjz4qMc2o8EuyyAy4o3yGULcdQ9C4Xi4+nss=;
 b=ytz0ctY8htiH9ppNYzuSqyoxB1DyB5pLAZO5KIfB5eeJ9ars2AjWCBay72zFAikwKtDw
 1oj6WMrx0SuYpwdSu/wNHwFZu57TKxt7O4Fjd3Q3qXJKN/A4f8+GQozJ6dxCtD1ZiU37
 8488r2Gjn0iaZr/mqBGqY9W9H8FBKda5v12fosvV8h0mvmERF+BamUC8KECrrHUt8jh4
 TuUvpvXtOLAoHRFmuacMLIv1N6nTrP1LSJRbBKFmVn/oyGGoAMzgaQ/mjIToAMIrir8M
 wV2X8dqobpaRAvEKbTCzh1ibszE3ZxiSJzXdwFj6k+bQYwU+kyH4aPHPIS18k+7j+pLn jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amq8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IpAh175833
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vahw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:30 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZf014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:30 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-7;
        Wed, 02 Mar 2022 05:36:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06/14] scsi: sd: Use cached ATA Information VPD page
Date:   Wed,  2 Mar 2022 00:35:51 -0500
Message-Id: <20220302053559.32147-7-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: eTF4YuAL-mjpXUhY7NKsl9A1jf9gv1jw
X-Proofpoint-GUID: eTF4YuAL-mjpXUhY7NKsl9A1jf9gv1jw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the ATA Information VPD is now cached at device discovery time it is
no longer necessary to request this page when we configure WRITE SAME.
Instead use the cached information to determine if this disk sits behind a
SCSI-ATA translation layer.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2f9d160bc8c2..d6aec12aef76 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3024,8 +3024,7 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
-		/* too large values might cause issues with arcmsr */
-		int vpd_buf_len = 64;
+		struct scsi_vpd *vpd;
 
 		sdev->no_report_opcodes = 1;
 
@@ -3033,8 +3032,11 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		 * CODES is unsupported and the device has an ATA
 		 * Information VPD page (SAT).
 		 */
-		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
+		rcu_read_lock();
+		vpd = rcu_dereference(sdev->vpd_pg89);
+		if (vpd)
 			sdev->no_write_same = 1;
+		rcu_read_unlock();
 	}
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
-- 
2.32.0

