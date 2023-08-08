Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D34C001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 16:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjHHQEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjHHQDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 12:03:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50341659D
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 08:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691509467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+NLl0HWC1rjA2zoBp3evkIVtVVCQOGJ99N11skgClg=;
        b=RKKOzlykW9xa7qyjlB2C86qF/JApAb0mHc8ZZStTEPHTuWK8cMazsa2VORfPF8Y9k4k/xH
        dPTP9cpv+yNarYWmXRNcE9Ygfmn7/+B6cokeztentWTeNxFtkytiETw+WG5Bgr5PUivZl5
        XMhWigSkE4kvPs/UyyEBq5lxxefSMC0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-MhQueYY_PJC-llP_5SeNaw-1; Tue, 08 Aug 2023 06:43:27 -0400
X-MC-Unique: MhQueYY_PJC-llP_5SeNaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7404B801FA0;
        Tue,  8 Aug 2023 10:43:26 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69ED140C2077;
        Tue,  8 Aug 2023 10:43:25 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.g.garry@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH V3 11/14] scsi: hisi: take blk_mq_max_nr_hw_queues() into account for calculating io vectors
Date:   Tue,  8 Aug 2023 18:42:36 +0800
Message-Id: <20230808104239.146085-12-ming.lei@redhat.com>
In-Reply-To: <20230808104239.146085-1-ming.lei@redhat.com>
References: <20230808104239.146085-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

Cc: John Garry <john.g.garry@oracle.com>
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

