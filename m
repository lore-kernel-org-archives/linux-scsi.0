Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A137C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D42610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhJUPDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 11:03:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231207AbhJUPDg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 11:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634828480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ECaxQdQKnklt0rj4YD4/JOyPjuoL6n2hzDdfNl+Em4E=;
        b=R9zpqrEelX2FtW/KGvTZ0fBA8kJilrsU53Hbo+NmelCIs6IdPWq/bnYkk5Qzqoz79r4GqN
        o3fgUND0ER1S7YsZSrdDXfRPR4Cg+qkAVB+kTEvInldBYwapivdbk2FjqWexUpzpb8oPjR
        AZjCRB5MVeclWM/SrNMYbf/dNUi9StM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-W8WTIcBMM2i3RTGww9x_sA-1; Thu, 21 Oct 2021 11:01:19 -0400
X-MC-Unique: W8WTIcBMM2i3RTGww9x_sA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93B168EE59;
        Thu, 21 Oct 2021 15:00:43 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 807F25F4E9;
        Thu, 21 Oct 2021 15:00:40 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/3] dm: don't stop request queue after the dm device is suspended
Date:   Thu, 21 Oct 2021 22:59:18 +0800
Message-Id: <20211021145918.2691762-4-ming.lei@redhat.com>
In-Reply-To: <20211021145918.2691762-1-ming.lei@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For fixing queue quiesce race between driver and block layer(elevator
switch, update nr_requests, ...), we need to support concurrent quiesce
and unquiesce, which requires the two call to be balanced.

__bind() is only called from dm_swap_table() in which dm device has been
suspended already, so not necessary to stop queue again. With this way,
request queue quiesce and unquiesce can be balanced.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7870e6460633..727282d79b26 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1927,16 +1927,6 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	dm_table_event_callback(t, event_callback, md);
 
-	/*
-	 * The queue hasn't been stopped yet, if the old table type wasn't
-	 * for request-based during suspension.  So stop it to prevent
-	 * I/O mapping before resume.
-	 * This must be done before setting the queue restrictions,
-	 * because request-based dm may be run just after the setting.
-	 */
-	if (request_based)
-		dm_stop_queue(q);
-
 	if (request_based) {
 		/*
 		 * Leverage the fact that request-based DM targets are
-- 
2.31.1

