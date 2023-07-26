Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34B5C04A94
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 09:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjGZJl5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 05:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjGZJlr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 05:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED53111F
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 02:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690364457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tpdmXVrSFhq/BTLlYN4vy8lpJH7u5Vwwe/yeAm4djqM=;
        b=Upwl+OcNHHghyTNwr03FR+rgAr+5Oipc1V0Bt9VInVlRl1tbaf4XIO4hGSVmBQacRLxC+U
        OCEWeqm6yn0augRRKvqKTey4qXT3FqUtibxxXy8ux6mUSlEIJDDpAYDkBRtyDHWQIFanQA
        C706BRsxBjqMzxqUgRAtgAqc+Nk06+Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-0nPrqDWGMH-CodtW9dOuMg-1; Wed, 26 Jul 2023 05:40:53 -0400
X-MC-Unique: 0nPrqDWGMH-CodtW9dOuMg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36142104458B;
        Wed, 26 Jul 2023 09:40:53 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21C23200B41D;
        Wed, 26 Jul 2023 09:40:51 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH V2 5/9] scsi: hisi: take blk_mq_max_nr_hw_queues() into account for calculating io vectors
Date:   Wed, 26 Jul 2023 17:40:23 +0800
Message-Id: <20230726094027.535126-6-ming.lei@redhat.com>
In-Reply-To: <20230726094027.535126-1-ming.lei@redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Take blk-mq's knowledge into account for calculating io queues.

Fix wrong queue mapping in case of kdump kernel.

On arm and ppc64, 'maxcpus=1' is passed to kdump kernel command line,
see `Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
still returns all CPUs because 'maxcpus=1' just bring up one single
cpu core during booting.

blk-mq sees single queue in kdump kernel, and in driver's viewpoint
there are still multiple queues, this inconsistency causes driver to apply
wrong queue mapping for handling IO, and IO timeout is triggered.

Meantime, single queue makes much less resource utilization, and reduce
risk of kernel failure.

Cc: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 20e1607c6282..60d2301e7f9d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2550,6 +2550,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 
 
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
+	if (hisi_hba->cq_nvecs > scsi_max_nr_hw_queues())
+		hisi_hba->cq_nvecs = scsi_max_nr_hw_queues();
+
 	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;
 
 	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
-- 
2.40.1

