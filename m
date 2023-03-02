Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3925C7EE32
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 15:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjCBPta (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjCBPtW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 10:49:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD7119695
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 07:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JhUYLyZwZuUhpnWFnebVE++9cb4qmQcum/DaC5jAenI=;
        b=ZHXB9Naci288Jc9pgt3gbIRpbGMYZcqCdi6pox4TapkgbmC+y58Skysd1zGDsokMeeCUAf
        75WpE/KV9IRGdZG7LfbiVw0q58Hkc4pwGaQEummbYNND26Ikq+T3owBYd74k8Hu6fs1Dic
        HwJAKYZZGq4ycaayzthCEbHclPPJggI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-JYrwV7_2P-C5jMQFYJtX6Q-1; Thu, 02 Mar 2023 10:48:32 -0500
X-MC-Unique: JYrwV7_2P-C5jMQFYJtX6Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C682804BAF;
        Thu,  2 Mar 2023 15:48:31 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9FFC492B00;
        Thu,  2 Mar 2023 15:48:30 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH 4/6] scsi: mpi3mr: fix a memory leak
Date:   Thu,  2 Mar 2023 16:48:24 +0100
Message-Id: <20230302154826.5862-5-thenzl@redhat.com>
In-Reply-To: <20230302154826.5862-1-thenzl@redhat.com>
References: <20230302154826.5862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Free mrioc->sas_hba.phy at .remove.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 85bd45563686..8f17a7953eb4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5162,6 +5162,12 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	}
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
 
+	if (mrioc->sas_hba.num_phys) {
+		kfree(mrioc->sas_hba.phy);
+		mrioc->sas_hba.phy = NULL;
+		mrioc->sas_hba.num_phys = 0;
+	}
+
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
-- 
2.39.1

