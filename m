From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] virtio_scsi: remove ACCESS_ONCE() in virtscsi_pick_vq
Date: Wed,  7 May 2014 22:12:45 +0800
Message-ID: <1399471966-17715-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58738 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaEGONF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 10:13:05 -0400
Received: by mail-pa0-f52.google.com with SMTP id kx10so1267574pab.11
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2014 07:13:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <tom.leiming@gmail.com>

Access to tgt->req_vq is strictly serialized by spin_lock
of tgt->tgt_lock, so the ACCESS_ONCE() isn't necessary.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 16bfd50..aead20f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -565,7 +565,7 @@ static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
 	 * the smp_read_barrier_depends() in virtscsi_req_done.
 	 */
 	if (atomic_inc_return(&tgt->reqs) > 1)
-		vq = ACCESS_ONCE(tgt->req_vq);
+		vq = tgt->req_vq;
 	else {
 		queue_num = smp_processor_id();
 		while (unlikely(queue_num >= vscsi->num_queues))
-- 
1.7.9.5

