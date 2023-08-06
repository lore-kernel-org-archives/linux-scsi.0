Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C921C001DF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Aug 2023 17:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjHFRJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Aug 2023 13:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjHFRJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Aug 2023 13:09:31 -0400
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CBB1FF9
        for <linux-scsi@vger.kernel.org>; Sun,  6 Aug 2023 10:09:04 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1691341744; x=1691348944; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=Z0opASYUz6LctbNrdtddIZ9BGqfdgcDobcXe4QnYUs0=;
 b=ky23itxruQ7IOXbieBs8VfsXvsMjZ7sgdz83+MD4n4C7h0+JDVnTl3lfn/8H5SNqAPWRyKXXLQJGcK2erbG6bshSDaOXmMut2aUqSzTk7MV6Qky+/AXR0AOQHjH9vHjNgrS0Lu15FqxPQ1zjoxDxOnnbtHeAJrMgB2XWAal6joUEuR16mudll6OuhFBx9cJRjuRIXFAOxGQ7F9Fbf7lQrn2NTFNQpl0qCf8CuOXAoMb5R5JEpaZTFyK0hznHe14IdEkt8W+vqVzP868htsHmevmfUShPuN8eVwoCAlLUomLkhxzw0VaxS8YS3FfI875z7VfFgDLGjdt08C0EcdIalw==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 84b908e48f47 with SMTP id
 64cfd3b0eb8a643885484ded (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 06 Aug 2023 17:09:04 GMT
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
Subject: [PATCH v2 11/12] scsi: mpt3sas: Replace a dynamic allocation with a local variable
Date:   Sun,  6 Aug 2023 10:06:03 -0700
Message-Id: <20230806170604.16143-12-james@equiv.tech>
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mpt3sas_base.c:_base_update_diag_trigger_pages() allocates and
fetches a MPI2_CONFIG_PAGE_SASIOUNIT_1 struct (Mpi2SasIOUnitPage_t),
but does not include the terminal flexible array member in the
struct size calculation, fetch that member, or otherwise use that
member in any way.

This dynamic allocation can be replaced with a local variable.

Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e43e82e5caf9..1639cbf7c141 100644
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

