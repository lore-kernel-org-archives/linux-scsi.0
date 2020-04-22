Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41BFC5518C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6FD2076E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VqKoE9f3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbgDVKsG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:48:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41631 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729600AbgDVKOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:14:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587550493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R6sdZCQAxQf83Mu3PKMcKS1ipiSEkhOFY9DlQfL3c5s=;
        b=VqKoE9f3v9DxW1jMyNuwSPVjJQwWwCvLYjrCFsGY6yZhhBiGQVJ3jbzZbVWo1WmrF9rw1w
        W9RXGO26TMrGftcf3xiKsOqL32SC1zUrUmSHKQGVi/A8ODCdCQMIn9SJEgVv8fPVW/pfhm
        j4jf6Zztoaz3h/58LI2+Z6OSapbPhFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-g51FBZSCPoysjz4ugZogXQ-1; Wed, 22 Apr 2020 06:14:49 -0400
X-MC-Unique: g51FBZSCPoysjz4ugZogXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BB388017FD;
        Wed, 22 Apr 2020 10:14:48 +0000 (UTC)
Received: from localhost (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C40EF3A0;
        Wed, 22 Apr 2020 10:14:44 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Dexuan Cui <decui@microsoft.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: avoid to run synchronize_rcu for each device in scsi_host_block
Date:   Wed, 22 Apr 2020 18:14:33 +0800
Message-Id: <20200422101433.321581-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

So use scsi_internal_device_block() to implement scsi_host_block(),
and just run once synchronize_rcu() because scsi never supports
tagset of BLK_MQ_F_BLOCKING.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..089ac92ac6c3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2841,11 +2841,22 @@ scsi_host_block(struct Scsi_Host *shost)
 	struct scsi_device *sdev;
 	int ret =3D 0;
=20
+	/*
+	 * Call scsi_internal_device_block_nowait then we can avoid to
+	 * run synchronize_rcu() one time for every LUN.
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
+	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
+
+	if (!ret)
+		synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_host_block);
--=20
2.25.2

