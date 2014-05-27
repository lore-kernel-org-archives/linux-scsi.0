From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH] virtio-scsi: replace target spinlock with seqcount
Date: Tue, 27 May 2014 09:50:31 -0700
Message-ID: <20140527165031.GA21827@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58747 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaE0Que (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 12:50:34 -0400
Received: by mail-ie0-f180.google.com with SMTP id tp5so8795021ieb.25
        for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 09:50:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tom.leiming@gmail.com, Paolo Bonzini <pbonzini@redhat.com>

Hi,

I think this patch has a small race involving just two commands:

1. The first command to a target is in virtscsi_pick_vq(), after
    atomic_inc_return(&tgt->tgt_lock)) but before write_seqcount_begin()
2. A second command to the same target enters virtscsi_pick_vq(). It
    will hit the same atomic inc, take the upper branch of the
    conditional, and read out a stale (or NULL) tgt->req_vq.

Specifically:

@@ -508,19 +507,33 @@ static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
  	unsigned long flags;
  	u32 queue_num;
  
-	spin_lock_irqsave(&tgt->tgt_lock, flags);
+	local_irq_save(flags);
+	if (atomic_inc_return(&tgt->reqs) > 1) {
+		unsigned long seq;
+
+		do {
+			seq = read_seqcount_begin(&tgt->tgt_seq);
+			vq = tgt->req_vq;
+		} while (read_seqcount_retry(&tgt->tgt_seq, seq));
+	} else {

A second virtscsi_pick_vq() here will read a stale or NULL tgt->req_vq.

+		/* no writes can be concurrent because of atomic_t */
+		write_seqcount_begin(&tgt->tgt_seq);
+
+		/* keep previous req_vq if there is reader found */
+		if (unlikely(atomic_read(&tgt->reqs) > 1)) {
+			vq = tgt->req_vq;
+			goto unlock;
+		}
  
-	if (atomic_inc_return(&tgt->reqs) > 1)
-		vq = tgt->req_vq;
-	else {
  		queue_num = smp_processor_id();
  		while (unlikely(queue_num >= vscsi->num_queues))
  			queue_num -= vscsi->num_queues;
-
  		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
+ unlock:
+		write_seqcount_end(&tgt->tgt_seq);
  	}
+	local_irq_restore(flags);
  
-	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
  	return vq;

Thanks,
-- vs;
