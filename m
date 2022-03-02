Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE47C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbiCBFhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiCBFhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36641B16D4
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:30 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222bNBZ010964
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=CvzoEmqD2Ha8aFPBnqln8rrAH5c7YpxI7vZhSAvmsos=;
 b=c/E0iKxkVB/QjNi1XlZg1m59gPb4xI4VWgwB/C5JOFBITdPFsdp28gyfH51Fb75NwL2V
 BBgd5v6aJUr+JkEvWB2KN9sIjgAwR69ftXZBUgIWS2HTAfmQ5+Hv6AJTqkaG1Nw3L5Xg
 1sG/tT74hjBnVAVvRnjBpX+VzjbNG4Oe6kfvBqO7/1E1iAAZAiCtfVV36ehixZuMfOvu
 4C5cgRi8jpTJcvNAgHX10KzPc+dfM/mwFUwCvVDbvWezJt2WfJFRfPFyheLiJ0RxQvhS
 ezKPn+jCrI//2UvBhpJFanJh4RgxoLGhLbVgERfsb92xH8dfNr3i6gRJpZ0/B0+DIg0I rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvwcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IpfH175835
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vagt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:28 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZZ014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:28 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-4;
        Wed, 02 Mar 2022 05:36:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 03/14] scsi: core: Do not truncate INQUIRY data on modern devices
Date:   Wed,  2 Mar 2022 00:35:48 -0500
Message-Id: <20220302053559.32147-4-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: rlDMHU01r3H8SS-bluSHtUyH09vMIjx8
X-Proofpoint-ORIG-GUID: rlDMHU01r3H8SS-bluSHtUyH09vMIjx8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Low-level device drivers have had the ability to limit the size of an
INQUIRY for many years. This made sense for a wide variety of legacy
devices. However, we are unnecessarily truncating the INQUIRY response
for many modern devices. This prevents us from consulting fields
beyond the first 36 bytes.

If a device reports that it supports a larger INQUIRY response, and
the device also reports that it implements SPC-4 or newer, allow the
larger INQUIRY to proceed.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_scan.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f4e6c68ac99e..95bf9a1f35ce 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -728,7 +728,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		if (pass == 1) {
 			if (BLIST_INQUIRY_36 & *bflags)
 				next_inquiry_len = 36;
-			else if (sdev->inquiry_len)
+			/*
+			 * LLD specified a maximum sdev->inquiry_len
+			 * but device claims it has more data. Capping
+			 * the length only makes sense for legacy
+			 * devices. If a device supports SPC-4 (2014)
+			 * or newer, assume that it is safe to ask for
+			 * as much as the device says it supports.
+			 */
+			else if (sdev->inquiry_len &&
+				 response_len > sdev->inquiry_len &&
+				 (inq_result[2] & 0x7) < 6) /* SPC-4 */
 				next_inquiry_len = sdev->inquiry_len;
 			else
 				next_inquiry_len = response_len;
-- 
2.32.0

