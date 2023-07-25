Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5D5C04A6A
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 16:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjGYQTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjGYQTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 12:19:39 -0400
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E89FD
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 09:19:26 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1690301965; x=1690309165; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=XpCJhzJkJBUGoyjOoMfRPKbTguUgPXwvzyrJfExm90E=;
 b=PxaYqM1BkuIs3cXONLPcHuqzGSd94LrnNlZc72bf3pQbSqQY4f03yIj/18RFZDYtSWaN4BrL2Bd+JCwrXzENryEIVHxhfcAJvdYhrO+bg+pMKYPzNQLuM5fn0zkPSlAy/4gu0DxliFtBKzHuGm3DHZ5IqMlvllIixmdk8URHTDzFqEBNoeOSzsO4kjzqXLwzuR9ffwvPiBz6yl93xlCT+rdQ43/+1QamLhGbgaNP9s5yHEQ0W9RXRlG01ZwY5Ckswi2a+4UjqpgqmNjIo3q910TBEFkI9/upVpdIEvKZ5L4ClXkESN3jSKCg7c0ZzXreSh9Wk0wRsREjnXy3uCgO+w==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by c1186c613a58 with SMTP id
 64bff4e06f49ebc4e506eac8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 Jul 2023 16:14:24 GMT
Sender: james@equiv.tech
From:   James Seo <james@equiv.tech>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     James Seo <james@equiv.tech>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] scsi: mpt3sas: Replace a dynamic allocation with a local variable
Date:   Tue, 25 Jul 2023 09:13:31 -0700
Message-Id: <20230725161331.27481-7-james@equiv.tech>
In-Reply-To: <20230725161331.27481-1-james@equiv.tech>
References: <20230725161331.27481-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This dynamic allocation can be replaced with a local variable.

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index cd6f36094159..a32a6fa728a7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5361,10 +5361,9 @@ _base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
 static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2ConfigReply_t mpi_reply;
-	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
+	Mpi2SasIOUnitPage1_t sas_iounit_pg1;
 	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
 	u16 depth;
-	int sz;
 	int rc = 0;
 
 	ioc->max_wideport_qd = MPT3SAS_SAS_QUEUE_DEPTH;
@@ -5374,28 +5373,21 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	if (!ioc->is_gen35_ioc)
 		goto out;
 	/* sas iounit page 1 */
-	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData);
-	sas_iounit_pg1 = kzalloc(sizeof(Mpi2SasIOUnitPage1_t), GFP_KERNEL);
-	if (!sas_iounit_pg1) {
-		pr_err("%s: failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		return rc;
-	}
 	rc = mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
-	    sas_iounit_pg1, sz);
+	    &sas_iounit_pg1, sizeof(Mpi2SasIOUnitPage1_t));
 	if (rc) {
 		pr_err("%s: failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out;
 	}
 
-	depth = le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth);
+	depth = le16_to_cpu(sas_iounit_pg1.SASWideMaxQueueDepth);
 	ioc->max_wideport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
 
-	depth = le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth);
+	depth = le16_to_cpu(sas_iounit_pg1.SASNarrowMaxQueueDepth);
 	ioc->max_narrowport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
 
-	depth = sas_iounit_pg1->SATAMaxQDepth;
+	depth = sas_iounit_pg1.SATAMaxQDepth;
 	ioc->max_sata_qd = (depth ? depth : MPT3SAS_SATA_QUEUE_DEPTH);
 
 	/* pcie iounit page 1 */
@@ -5414,7 +5406,6 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	    "MaxWidePortQD: 0x%x MaxNarrowPortQD: 0x%x MaxSataQD: 0x%x MaxNvmeQD: 0x%x\n",
 	    ioc->max_wideport_qd, ioc->max_narrowport_qd,
 	    ioc->max_sata_qd, ioc->max_nvme_qd));
-	kfree(sas_iounit_pg1);
 	return rc;
 }
 
-- 
2.39.2

