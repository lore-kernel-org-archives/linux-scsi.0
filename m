Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0141EC4727F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B68C2238D7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkpqMzKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgIWBe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 21:34:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727049AbgIWBe5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Sep 2020 21:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600824896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9rNE0+J0ez+vRJhUnHjNNHKhYUmcLxWjpubeK72BSDw=;
        b=fkpqMzKDP5G+WzO9wTCHGQ1yiy0l5CARofCOwODCCZCZjwZv0lS9/hKofVKsOWgNy4mMm8
        9UzrHCa6zGtxUUD7MdrN06NpGRZUglJKvQadpC9KKFs4kzc1sNXtfRgngZidjdDSj2p9QW
        WrtEvNGtbE6V9GE5QJ7Oj8+KUw74jTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-sM4p0Kd5Nji8ytHirLZ_Eg-1; Tue, 22 Sep 2020 21:34:54 -0400
X-MC-Unique: sM4p0Kd5Nji8ytHirLZ_Eg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 094FC56BE2;
        Wed, 23 Sep 2020 01:34:53 +0000 (UTC)
Received: from localhost (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBC6919D6C;
        Wed, 23 Sep 2020 01:34:48 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V3 for 5.11 11/12] scsi: make sure sdev->queue_depth is <= shost->can_queue
Date:   Wed, 23 Sep 2020 09:33:38 +0800
Message-Id: <20200923013339.1621784-12-ming.lei@redhat.com>
In-Reply-To: <20200923013339.1621784-1-ming.lei@redhat.com>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Obviously scsi device's queue depth can't be > host's can_queue,
so make it explicitely in scsi_change_queue_depth().

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 24619c3bebd5..cc6ff1ae8c16 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -223,6 +223,8 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
+	depth = min_t(int, depth, sdev->host->can_queue);
+
 	if (depth > 0) {
 		sdev->queue_depth = depth;
 		wmb();
-- 
2.25.2

