Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8EDC636D6
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 15:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjBGPXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Feb 2023 10:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjBGPXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2023 10:23:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D451351F
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2023 07:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675783325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=feSz/X5iUY8wqwtujlu72isnV1clj2jfKkriey/zgmQ=;
        b=g+wDAUo/ubQ0ONGdmfDGJBVD2pgKd9P4DLRt+QSpeeBqNsXzbj476G4HRiEqGDnK8Gom1T
        vdgWK44HQUXCCPVZp5qAopYQvGKBTfmr84TwWT/a5nHMTCl6WZlIHfC4YOgdMvzM+nlpYx
        QrWC7hrzupKAlEhizd62YJqurX5XSHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-GLgymanuOVu_Y93Pz69CXQ-1; Tue, 07 Feb 2023 10:22:01 -0500
X-MC-Unique: GLgymanuOVu_Y93Pz69CXQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42C6A18A6465;
        Tue,  7 Feb 2023 15:22:01 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-194-255.brq.redhat.com [10.40.194.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C859492B22;
        Tue,  7 Feb 2023 15:22:00 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Subject: [PATCH] mpt3sas: fix a memory leak
Date:   Tue,  7 Feb 2023 16:21:59 +0100
Message-Id: <20230207152159.18627-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a forgotten kfree

Fixes: dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4e981ccaac41..f4083ff74895 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5850,6 +5850,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
 	}
+	kfree(ioc->pcie_sg_lookup);
+	ioc->pcie_sg_lookup = NULL;
+
 	if (ioc->config_page) {
 		dexitprintk(ioc,
 			    ioc_info(ioc, "config_page(0x%p): free\n",
-- 
2.38.1

