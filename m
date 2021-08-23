Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7921AC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 13:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 581BC61178
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 13:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhHWNhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 09:37:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230009AbhHWNhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 09:37:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17NDZRSr026716;
        Mon, 23 Aug 2021 09:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=bhKCun4hG0phkMjgRaAZpPwZ+pB8WymZD+p/xnZ24B8=;
 b=D3Mpjx8ZpgY1b4ZweVdx95H/ltWNKv9JrG04nDHbEEzRa3R/z6iY+Snhn2Zq5IJ89YxY
 yojEFfKFcmA9JZMZraURFHDAwKpGvdNcYtqGaoGpVgKxP2eYNGcH64eQhw3rhk7teqIn
 F/8i/dJjunapVHBFi11uZogp27wofNpNqfyU5ngu4pkf1Dzey/wkUSuHTjtv5N/BbMSs
 IOOCZ5Nb+fxqnvvxefcGKBI3Xj12KH+Bxd5Nqm6fK1JKPK9Pq4+4mpIc2kANAWVdfMWg
 9MkUpnzaNQHL3EGRiTWWYNHqbeO/bAyXsKD6bkOEVoiqTHshqeFEkr5UBmbWm3vEW0Ak fA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ambxj1f0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 09:35:50 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17NDTNIc025388;
        Mon, 23 Aug 2021 13:35:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3ajs48jwb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 13:35:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17NDZgsv53215530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 13:35:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AD4A42056;
        Mon, 23 Aug 2021 13:35:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA1C142045;
        Mon, 23 Aug 2021 13:35:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Aug 2021 13:35:41 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, oliver.sang@intel.com
Subject: [PATCH] scsi: scsi_ioctl: fix error code propagation in SG_IO
Date:   Mon, 23 Aug 2021 15:34:58 +0200
Message-Id: <20210823133458.3536824-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AV64in1NJPDY5rpmIHunw6aDR4Xn60SN
X-Proofpoint-ORIG-GUID: AV64in1NJPDY5rpmIHunw6aDR4Xn60SN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_02:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 mlxlogscore=685 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes: f2542a3be327 ("scsi: scsi_ioctl: Move the "block layer" SCSI
ioctl handling to drivers/scsi")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
This is a patch against the for-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git and/or
linux-next/master.
---
 drivers/scsi/scsi_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 7b2b0a1581f4..6ff2207bd45a 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -874,7 +874,7 @@ static int scsi_ioctl_sg_io(struct scsi_device *sdev, struct gendisk *disk,
 		return error;
 	if (put_sg_io_hdr(&hdr, argp))
 		return -EFAULT;
-	return 0;
+	return error;
 }
 
 /**
-- 
2.25.1

