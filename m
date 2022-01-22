Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49744C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiAVLMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234261AbiAVLMg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qxxh2m6PuB2dHP6HEE7eZbZqAl8fy6fCQ0SrIpnMil4=;
        b=bJqd3UH1G+i5OXAyPATOqLkkNj5eAGP9TfcI0d+6SewRzXXzUO4didO3uXhMRZjfyyDLeu
        jEEgx+8RjdpZPIgPBQrSz2v123nfv20nq8LtH8f0dL0Gpb3QGwBXJCAQLTxZMaU93c2r4y
        NNjI0zJ1zGOtjS+c9uKeqov/lsu4W7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-3_Ai3tyWNYGEhkRQpEXpnA-1; Sat, 22 Jan 2022 06:12:32 -0500
X-MC-Unique: 3_Ai3tyWNYGEhkRQpEXpnA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D0C814243;
        Sat, 22 Jan 2022 11:12:31 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C92847B9D3;
        Sat, 22 Jan 2022 11:12:24 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 09/13] scsi: force unfreezing queue into atomic mode
Date:   Sat, 22 Jan 2022 19:10:50 +0800
Message-Id: <20220122111054.1126146-10-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In scsi_disk_release() request queue is frozen for clearing
disk->private_data, and there can't be any FS IO issued to
this queue, and only private passthrough request will be handled, so
force unfreezing queue into atomic mode.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0e73c3f2f381..27f04c860f00 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3670,7 +3670,7 @@ static void scsi_disk_release(struct device *dev)
 	 * in case multiple processes open a /dev/sd... node concurrently.
 	 */
 	blk_mq_freeze_queue(q);
-	blk_mq_unfreeze_queue(q);
+	__blk_mq_unfreeze_queue(q, true);
 
 	disk->private_data = NULL;
 	put_disk(disk);
-- 
2.31.1

