Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2AAC0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 09:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjGZJlx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 05:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjGZJlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 05:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA75097
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 02:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690364451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XUAbwUholcdP/E78pjIWjWfXWvuCT6ODN3CqmEOBnlY=;
        b=EEFORplBiEhopXrfaGAEcYSeCrghMnuWVbZDPuQM1r1uHw4bG6isPlizHgQc0idjj5wt9X
        w0teKbF2IfugL9AsWoLfvsD/QBBx6Wvv3pmInpXfDgkdiUsFhRCPqLD2ASZ3s1uF7BV+sE
        11CarqhGOkFi15Ko1BAqAi9Hc6wOEgo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-oQFhGE4cMQWWMo61YsirzA-1; Wed, 26 Jul 2023 05:40:46 -0400
X-MC-Unique: oQFhGE4cMQWWMo61YsirzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EB1888D583;
        Wed, 26 Jul 2023 09:40:46 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CF031401C2E;
        Wed, 26 Jul 2023 09:40:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 3/9] scsi: core: add helper of scsi_max_nr_hw_queues()
Date:   Wed, 26 Jul 2023 17:40:21 +0800
Message-Id: <20230726094027.535126-4-ming.lei@redhat.com>
In-Reply-To: <20230726094027.535126-1-ming.lei@redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_mq_alloc_tag_set() may change nr_hw_queues for kdump kernel, so
driver has to take blk-mq max supported nr_hw_queues into account
when figuring out nr_hw_queues from hardware info, for avoiding
inconsistency between scsi driver and blk-mq.

Add helper of scsi_max_nr_hw_queues() for avoiding nr_hw_queues
inconsistency between scsi driver and blk-mq.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/scsi/scsi_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 70b7475dcf56..2273f855940f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -803,6 +803,11 @@ extern int scsi_host_unblock(struct Scsi_Host *shost, int new_state);
 void scsi_host_busy_iter(struct Scsi_Host *,
 			 bool (*fn)(struct scsi_cmnd *, void *), void *priv);
 
+static inline unsigned int scsi_max_nr_hw_queues(void)
+{
+	return blk_mq_max_nr_hw_queues();
+}
+
 struct class_container;
 
 /*
-- 
2.40.1

