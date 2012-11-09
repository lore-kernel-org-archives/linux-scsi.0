From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio-scsi: Fix incorrect lock release order in virtscsi_kick_cmd
Date: Sat, 10 Nov 2012 00:37:30 +0100
Message-ID: <509D93BA.2090202@redhat.com>
References: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>  <509CC210.8090908@redhat.com> <1352489476.29589.544.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352489476.29589.544.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 09/11/2012 20:31, Nicholas A. Bellinger ha scritto:
>> That's done on purpose.  After you do virtqueue_add_buf, you don't need
>> the sg list anymore, nor the lock that protects it.  The cover letter is
>> at https://lkml.org/lkml/2012/6/13/295 and had this text:
>>
>>   This series reorganizes the locking in virtio-scsi, introducing
>>   separate scatterlists for each target and "pipelining" the locks so
>>   that one command can be queued while the other is prepared.  This
>>   improves performance when there are multiple in-flight operations.
>>
>> In fact, the patch _introduces_ wrong locking because
>> virtqueue_kick_prepare needs the vq_lock.
>>
>> Perhaps what you want is separate local_irq_save/local_irq_restore?
> 
> Ahh, that makes more sense now.
> 
> Just noticed this while reviewing code that using one spinlock flag's to
> release the other looks suspicious, minus the ordering bit..
> 
> Using local_irq_* would probably be cleaner than swapping flags between
> different locks, and a short comment here would be helpful to explain
> the locking order context.

Well, my plan is to improve the virtio API so I can reuse the higher
layer's scatterlist, and get rid of the lock (not just of the funny
order) altogether. :)  Queuing requests is really performance-sensitive,
and it can use any optimization.

But if I can't get to it quick, I'll queue a cleanup using local_irq_*.

Paolo
