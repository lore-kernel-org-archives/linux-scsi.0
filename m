Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F768CCA473
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 12:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiGFM75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 08:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiGFM75 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 08:59:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F9E213F55
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 05:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657112395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z9GmFXKulJgNRiwUHEzmdBETprSRaCi3MtHplNfrlgo=;
        b=EYFonYyOL9td0ThvF1P2+Uefhf/adFznZA2VTfo2LeKA7qugNv/gT0rNL5shy6q7n7EI2w
        7dtxSvvS5ZDffb9g2u1SxVdhA3apIyHr/BiDJKM/cT2fosmlLJ81JAMwrqvJ45st6/zhn+
        ZhnffCtYqxjqcDET5PGZZvkV/poEmF8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-eagCCqWtP-a8_6l-gy9hEw-1; Wed, 06 Jul 2022 08:59:51 -0400
X-MC-Unique: eagCCqWtP-a8_6l-gy9hEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ECE4299E74E;
        Wed,  6 Jul 2022 12:59:51 +0000 (UTC)
Received: from localhost (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D06040D282F;
        Wed,  6 Jul 2022 12:59:49 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Guangwu Zhang <guazhang@redhat.com>
Subject: [PATCH] scsi: megaraid: clear READ queue map's nr_queues
Date:   Wed,  6 Jul 2022 20:59:42 +0800
Message-Id: <20220706125942.528533-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

megaraid scsi driver sets set->nr_maps as 3 if poll_queues is > 0, and
blk-mq actually initializes each map's nr_queues as nr_hw_queues, so
megaraid driver has to clear READ queue map's nr_queues, otherwise queue
map becomes broken if poll_queues is set as non-zero.

Fixes: 9e4bec5b2a23 ("scsi: megaraid_sas: mq_poll support")
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sumit.saxena@broadcom.com
Cc: chandrakanth.patil@broadcom.com
Cc: linux-block@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Tested-by: Guangwu Zhang <guazhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c95360a3c186..0917b05059b4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3195,6 +3195,9 @@ static int megasas_map_queues(struct Scsi_Host *shost)
 	qoff += map->nr_queues;
 	offset += map->nr_queues;
 
+	/* we never use READ queue, so can't cheat blk-mq */
+	shost->tag_set.map[HCTX_TYPE_READ].nr_queues = 0;
+
 	/* Setup Poll hctx */
 	map = &shost->tag_set.map[HCTX_TYPE_POLL];
 	map->nr_queues = instance->iopoll_q_count;
-- 
2.31.1

