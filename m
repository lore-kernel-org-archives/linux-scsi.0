From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio-scsi: Fix incorrect lock release order in virtscsi_kick_cmd
Date: Fri, 09 Nov 2012 09:42:56 +0100
Message-ID: <509CC210.8090908@redhat.com>
References: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62065 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KIInB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2012 03:43:01 -0500
In-Reply-To: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

Il 09/11/2012 07:29, Nicholas A. Bellinger ha scritto:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes a regression bug in virtscsi_kick_cmd() that relinquishes
> the acquired spinlocks in the incorrect order using the wrong spin_unlock
> macros, namely releasing vq->vq_lock before tgt->tgt_lock while invoking
> the calls to virtio_ring.c:virtqueue_add_buf() and friends.
> 
> This bug was originally introduced in v3.5-rc7 code with:
> 
> commit 2bd37f0fde99cbf8b78fb55f1128e8c3a63cf1da
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Wed Jun 13 16:56:34 2012 +0200
> 
>     [SCSI] virtio-scsi: split scatterlist per target
> 
> Go ahead and make sure that vq->vq_lock is relinquished w/ spin_unlock
> first, then release tgt->tgt_lock w/ spin_unlock_irqrestore.

That's done on purpose.  After you do virtqueue_add_buf, you don't need
the sg list anymore, nor the lock that protects it.  The cover letter is
at https://lkml.org/lkml/2012/6/13/295 and had this text:

  This series reorganizes the locking in virtio-scsi, introducing
  separate scatterlists for each target and "pipelining" the locks so
  that one command can be queued while the other is prepared.  This
  improves performance when there are multiple in-flight operations.

In fact, the patch _introduces_ wrong locking because
virtqueue_kick_prepare needs the vq_lock.

Perhaps what you want is separate local_irq_save/local_irq_restore?

Paolo

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/virtio_scsi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 595af1a..b2abb8a 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -417,11 +417,11 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
>  
>  	spin_lock(&vq->vq_lock);
>  	ret = virtqueue_add_buf(vq->vq, tgt->sg, out_num, in_num, cmd, gfp);
> -	spin_unlock(&tgt->tgt_lock);
> +	spin_unlock(&vq->vq_lock);
>  	if (ret >= 0)
>  		ret = virtqueue_kick_prepare(vq->vq);
>  
> -	spin_unlock_irqrestore(&vq->vq_lock, flags);
> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>  
>  	if (ret > 0)
>  		virtqueue_notify(vq->vq);
> 

