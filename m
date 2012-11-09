From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] virtio-scsi: Fix incorrect lock release order in
 virtscsi_kick_cmd
Date: Fri, 09 Nov 2012 11:31:16 -0800
Message-ID: <1352489476.29589.544.camel@haakon2.linux-iscsi.org>
References: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>
	 <509CC210.8090908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <509CC210.8090908@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Paolo,

On Fri, 2012-11-09 at 09:42 +0100, Paolo Bonzini wrote:
> Il 09/11/2012 07:29, Nicholas A. Bellinger ha scritto:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch fixes a regression bug in virtscsi_kick_cmd() that relinquishes
> > the acquired spinlocks in the incorrect order using the wrong spin_unlock
> > macros, namely releasing vq->vq_lock before tgt->tgt_lock while invoking
> > the calls to virtio_ring.c:virtqueue_add_buf() and friends.
> > 
> > This bug was originally introduced in v3.5-rc7 code with:
> > 
> > commit 2bd37f0fde99cbf8b78fb55f1128e8c3a63cf1da
> > Author: Paolo Bonzini <pbonzini@redhat.com>
> > Date:   Wed Jun 13 16:56:34 2012 +0200
> > 
> >     [SCSI] virtio-scsi: split scatterlist per target
> > 
> > Go ahead and make sure that vq->vq_lock is relinquished w/ spin_unlock
> > first, then release tgt->tgt_lock w/ spin_unlock_irqrestore.
> 
> That's done on purpose.  After you do virtqueue_add_buf, you don't need
> the sg list anymore, nor the lock that protects it.  The cover letter is
> at https://lkml.org/lkml/2012/6/13/295 and had this text:
> 
>   This series reorganizes the locking in virtio-scsi, introducing
>   separate scatterlists for each target and "pipelining" the locks so
>   that one command can be queued while the other is prepared.  This
>   improves performance when there are multiple in-flight operations.
> 
> In fact, the patch _introduces_ wrong locking because
> virtqueue_kick_prepare needs the vq_lock.
> 
> Perhaps what you want is separate local_irq_save/local_irq_restore?
> 

Ahh, that makes more sense now.

Just noticed this while reviewing code that using one spinlock flag's to
release the other looks suspicious, minus the ordering bit..

Using local_irq_* would probably be cleaner than swapping flags between
different locks, and a short comment here would be helpful to explain
the locking order context.

Anyways, no big deal.  Thanks for the explanation.

--nab
