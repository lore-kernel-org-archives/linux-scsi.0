From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Fri, 27 Jul 2012 10:11:26 +0200
Message-ID: <50124D2E.7050407@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com> <50104614.3080002@panasas.com> <501051DF.5040907@redhat.com> <50105F60.8050707@panasas.com> <5010F07E.7050506@redhat.com> <5010F831.9030300@panasas.com> <5010F896.8090409@redhat.com> <501140A3.9090908@redhat.com> <874notoh02.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <874notoh02.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Il 27/07/2012 08:27, Rusty Russell ha scritto:
>> > +int virtqueue_add_buf_sg(struct virtqueue *_vq,
>> > +			 struct scatterlist *sg_out,
>> > +			 unsigned int out,
>> > +			 struct scatterlist *sg_in,
>> > +			 unsigned int in,
>> > +			 void *data,
>> > +			 gfp_t gfp)
> The point of chained scatterlists is they're self-terminated, so the
> in & out counts should be calculated.
> 
> Counting them is not *that* bad, since we're about to read them all
> anyway.
> 
> (Yes, the chained scatterlist stuff is complete crack, but I lost that
> debate years ago.)
> 
> Here's my variant.  Networking, console and block seem OK, at least
> (ie. it booted!).

I hate the for loops, even though we're about indeed to read all the
scatterlists anyway... all they do is lengthen critical sections.  Also,
being the first user of chained scatterlist doesn't exactly give me warm
fuzzies.

I think it's simpler if we provide an API to add individual buffers to
the virtqueue, so that you can do multiple virtqueue_add_buf_more
(whatever) before kicking the virtqueue.  The idea is that I can still
use indirect buffers for the scatterlists that come from the block layer
or from an skb, but I will use direct buffers for the request/response
descriptors.  The direct buffers are always a small number (usually 2),
so you can balance the effect by making the virtqueue bigger.  And for
small reads and writes, you save a kmalloc on a very hot path.

(BTW, scatterlists will have separate entries for each page; we do not
need this in virtio buffers.  Collapsing physically-adjacent entries
will speed up QEMU and will also help avoiding indirect buffers).

Paolo
