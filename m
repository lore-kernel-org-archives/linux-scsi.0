Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1580C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiBVPEP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiBVPEB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:04:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3447C10E075
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645542215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=L1nqBbIfdOOQW1lKSqDH71PuMFjRvZ0K33hcpesTDcY=;
        b=L4xmxg5/ONsVmQHic0VqZbWo9ZVih05JjqdftLRDOcWNOTq/HU67qfUpSljo02np3oxSJz
        GB83IBz3L1JA3adhc9MNARU3iyOCjTBNQczunvV8I+Yy4vrbOVU7+ZdwLRMkA6wD/b/rPO
        DXJteLUpUrLuiVExG3KlegRxaCtX9n0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-P29aioR6Mme_cTC_v5wTsA-1; Tue, 22 Feb 2022 10:03:32 -0500
X-MC-Unique: P29aioR6Mme_cTC_v5wTsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D42611091DA0;
        Tue, 22 Feb 2022 15:03:30 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.17.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87CE47D3E5;
        Tue, 22 Feb 2022 15:03:29 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        loberman@redhat.com, djeffery@redhat.com,
        John Pittman <jpittman@redhat.com>
Subject: [PATCH] scsi: mpt3sas: decrease potential frequency of scsi_dma_map errors
Date:   Tue, 22 Feb 2022 10:03:19 -0500
Message-Id: <20220222150319.28397-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When scsi_dma_map() fails by returning a sges_left value less than
zero, the amount of logging can be extremely high.  In a recent
end-user environment, 1200 messages per second were being sent to
the log buffer.  This eventually overwhelmed the system and it
stalled.  As the messages are almost all identical, use
pr_err_ratelimited() instead of sdev_printk() to print the
scsi_dma_map failure messages.

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 511726f92d9a..ac9ccde6f3f8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2594,9 +2594,8 @@ _base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
 	/* Get the SG list pointer and info. */
 	sges_left = scsi_dma_map(scmd);
 	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+		pr_err_ratelimited("sd %s: scsi_dma_map failed: request for %d bytes!\n",
+			dev_name(&scmd->device->sdev_gendev), scsi_bufflen(scmd));
 		return 1;
 	}
 
@@ -2706,9 +2705,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
 	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-		 "scsi_dma_map failed: request for %d bytes!\n",
-		 scsi_bufflen(scmd));
+		pr_err_ratelimited("sd %s: scsi_dma_map failed: request for %d bytes!\n",
+			dev_name(&scmd->device->sdev_gendev), scsi_bufflen(scmd));
 		return -ENOMEM;
 	}
 
@@ -2854,9 +2852,8 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
 	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+		pr_err_ratelimited("sd %s: scsi_dma_map failed: request for %d bytes!\n",
+			dev_name(&scmd->device->sdev_gendev), scsi_bufflen(scmd));
 		return -ENOMEM;
 	}
 
-- 
2.17.2

