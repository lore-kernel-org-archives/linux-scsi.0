From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Sat, 28 Sep 2002 22:48:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209290248.g8T2mbx02015@localhost.localdomain>
References: <luben@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id TAA05397
	for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2002 19:48:49 -0700
In-Reply-To: Message from Luben Tuikov <luben@splentec.com>
   of "Sat, 28 Sep 2002 19:25:39 EDT." <3D963A73.F593F5F7@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

luben@splentec.com said:
> TCQ goes hand in hand with Task Attributes. I.e. a tagged task is an
> I_T_L_Q nexus and has a task attribute (Simple, Ordered, Head of
> Queue, ACA; cf. SAM-3, 4.9.1). 

I believe the point I was making is that our only current expectation is 
simple tag, which is unordered.

> aybe the generator of tags (block layer, user process through sg, etc)
> should also set the tag attribute of the task, as per SAM-3. Most
> often (as currently implicitly) this would be a Simple task attribute.
> Why not the block layer borrow the idea from SAM-3, I see IDE only
> coming closer to SCSI...

> This way there'd be no need for explicit barriers. They can be
> implemented through Ordered and Head of Queue Tasks, everything else
> is Simple attribute task (IO scheduler can play with those as it
> wishes).

> This would provide for a more general basis the whole game (IO
> scheduling, TCQ, IO barriers, etc). 

That would be rather the wrong approach.  As the layers move up from the 
physical hardware, the level of abstraction becomes greater, so the current 
proposal is (descending the abstractions):

journal transaction->REQ_BARRIER->cache synchronise (ide) or ordered tag (scsi)

Most of the implementation is in ll_rw_blk.c if you want to take a look

James


