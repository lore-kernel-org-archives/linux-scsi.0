Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99CBC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E69F6124C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbhFIJ3Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:29:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60068 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbhFIJ3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 05:29:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599FPOu126774;
        Wed, 9 Jun 2021 09:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=uhPL+0un1SPv0y2rNarpfX6HYckw2hfBf4rTWYCa6IU=;
 b=IMrSFSbCzTQV/whD6aXdGE2xFMRyCGo05C6CLTdtKQxfnCHPmrJaiVE2Vm/5hOJh+yNv
 P9V7iltJmA3Xj2zppQSdNU7piXh5olLp3pLp5JLxut6fAMQhiKT24yKOyT9yyugCmq3L
 /RdLHA5bCQoQKQdt5lSvzdOIWNq0tGTZqulxYoKDLJ8uDOJDx0BQ4aBHtTX7J+Bt6D9f
 jFn9zqUvEmFNLu80QjQCW6ax/XH6jYGYrmedoEPEcAvOUK7xdfSbB4zFbXz0dah88ZyF
 JO3IP6ss2jzeBtmjFSECWW9fxdfnVAzWYxNSGi03tbTolHiJyJnEpdKgWnXwuPOpZBT/ og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38yxscgn8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:27:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599QOB8176314;
        Wed, 9 Jun 2021 09:27:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 38yxcvgu41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:27:24 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1599ROP4177706;
        Wed, 9 Jun 2021 09:27:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 38yxcvgu3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:27:24 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1599RMjB006327;
        Wed, 9 Jun 2021 09:27:22 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 02:27:22 -0700
Date:   Wed, 9 Jun 2021 12:27:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] scsi: mpi3mr: Fix error handling in mpi3mr_setup_isr()
Message-ID: <YMCJcnmSI4kOIyv/@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMCJKgykDYtyvY44@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: vK7RqIddjgDU9jYCdlfdeqiGWLuVdnOU
X-Proofpoint-GUID: vK7RqIddjgDU9jYCdlfdeqiGWLuVdnOU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090042
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pci_alloc_irq_vectors_affinity() function returns negative error
codes or it returns a number between the minimum vectors (1 in this
case) and max_vectors.  It won't return zero.  Because "i" is a u16 then
the error handling won't work.  And also if it did work the error code
was not set.

Really "max_vectors" can be an int as well because we're doing a min_t()
on int type.  The other change is that it's better to remove unnecessary
initialization so that static checkers can warn us if there are ever
uninitialized variable bugs introduced in the future.

I changed the error code from -1 (-EPERM) if the kmalloc() failed to
-ENOMEM.  And on success path I changed it from "return retval;" to
"return 0;" which shouldn't affect the compiled code but makes it more
readable.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 40696b75345d..88db2f0e13fd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -665,8 +665,9 @@ static inline int mpi3mr_request_irq(struct mpi3mr_ioc *mrioc, u16 index)
 static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 {
 	unsigned int irq_flags = PCI_IRQ_MSIX;
-	u16 max_vectors = 0, i;
-	int retval = 0;
+	int max_vectors;
+	int retval;
+	int i;
 	struct irq_affinity desc = { .pre_vectors =  1};
 
 	mpi3mr_cleanup_isr(mrioc);
@@ -687,29 +688,29 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
 
 	mrioc->op_reply_q_offset = (max_vectors > 1) ? 1 : 0;
-	i = pci_alloc_irq_vectors_affinity(mrioc->pdev,
-	    1, max_vectors, irq_flags, &desc);
-	if (i <= 0) {
+	retval = pci_alloc_irq_vectors_affinity(mrioc->pdev,
+				1, max_vectors, irq_flags, &desc);
+	if (retval < 0) {
 		ioc_err(mrioc, "Cannot alloc irq vectors\n");
 		goto out_failed;
 	}
-	if (i != max_vectors) {
+	if (retval != max_vectors) {
 		ioc_info(mrioc,
 		    "allocated vectors (%d) are less than configured (%d)\n",
-		    i, max_vectors);
+		    retval, max_vectors);
 		/*
 		 * If only one MSI-x is allocated, then MSI-x 0 will be shared
 		 * between Admin queue and operational queue
 		 */
-		if (i == 1)
+		if (retval == 1)
 			mrioc->op_reply_q_offset = 0;
 
-		max_vectors = i;
+		max_vectors = retval;
 	}
 	mrioc->intr_info = kzalloc(sizeof(struct mpi3mr_intr_info) * max_vectors,
 	    GFP_KERNEL);
 	if (!mrioc->intr_info) {
-		retval = -1;
+		retval = -ENOMEM;
 		pci_free_irq_vectors(mrioc->pdev);
 		goto out_failed;
 	}
@@ -722,7 +723,8 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	}
 	mrioc->intr_info_count = max_vectors;
 	mpi3mr_ioc_enable_intr(mrioc);
-	return retval;
+	return 0;
+
 out_failed:
 	mpi3mr_cleanup_isr(mrioc);
 
-- 
2.30.2

