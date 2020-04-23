Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FB7C55185
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF8B2080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfBWywL/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDWCHa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:07:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53524 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgDWCHa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 22:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587607649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=//7YW1x3+JgMEWAUDpLNrKAjc3EeAPwNIBGi1cqkx4U=;
        b=hfBWywL/wN3sIv+6/d/4wdsEIYtvvLSKhi6OKQjiJRhaEM5SP7H2ByHtJ8pno9VkOqnUN4
        357J/X9mMJ4G5v48ROhcbpYL1dnJtYW6xv/tmYRCG6fLTZW6weOrfgJ0YEq4n1oWng/ry0
        nOA/XQfHuJOWnZ6wnqwKXGjYTQfYNSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-8b0ZtdvCOOatEGRgozBDIQ-1; Wed, 22 Apr 2020 22:07:25 -0400
X-MC-Unique: 8b0ZtdvCOOatEGRgozBDIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD6A48015CE;
        Thu, 23 Apr 2020 02:07:23 +0000 (UTC)
Received: from localhost (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FA575C290;
        Thu, 23 Apr 2020 02:07:20 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Dexuan Cui <decui@microsoft.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V2] scsi: avoid to run synchronize_rcu for each device in scsi_host_block
Date:   Thu, 23 Apr 2020 10:07:13 +0800
Message-Id: <20200423020713.332743-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_host_block() calls scsi_internal_device_block() for each
scsi_device, and scsi_internal_device_block() calls
blk_mq_quiesce_queue() for each LUN. However synchronize_rcu is
run from blk_mq_quiesce_queue().

This way may become unnecessary slow in case of lots of LUNs.

Use scsi_internal_device_block_nowait() to implement scsi_host_block(),
so it is enough to run synchronize_rcu() once since scsi never
supports blk-mq's BLK_MQ_F_BLOCKING.

Cc: Steffen Maier <maier@linux.ibm.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- fix commit log as pointed by Steffen
	- add comment on BLK_MQ_F_BLOCKING as suggested by Bart

 drivers/scsi/scsi_lib.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..86007a523145 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2841,11 +2841,26 @@ scsi_host_block(struct Scsi_Host *shost)
 	struct scsi_device *sdev;
 	int ret =3D 0;
=20
+	/*
+	 * Call scsi_internal_device_block_nowait then we can avoid to
+	 * run synchronize_rcu() for each LUN
+	 */
 	shost_for_each_device(sdev, shost) {
-		ret =3D scsi_internal_device_block(sdev);
+		mutex_lock(&sdev->state_mutex);
+		ret =3D scsi_internal_device_block_nowait(sdev);
+		mutex_unlock(&sdev->state_mutex);
 		if (ret)
 			break;
 	}
+
+	/*
+	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING, so run
+	 * synchronize_rcu() once is enough
+	 */
+	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
+
+	if (!ret)
+		synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_host_block);
--=20
2.25.2

