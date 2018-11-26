From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V3
Date: Mon, 26 Nov 2018 19:11:10 +0200
Message-ID: <4f4b6aff-6726-c500-e3e4-f8b73d641851@electrozaur.com>
References: <20181111133211.13926-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111133211.13926-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/11/18 15:32, Christoph Hellwig wrote:
> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and we
> removed it 1.5 years ago.  Exofs is just a simple example without
> real life users.
> 

You have failed to say what is your motivation for this patchset? What
is it you are trying to fix/improve.

For the sake of "not used much" I fail to see the risk taking of
this removal.

> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, so I think it's finally time to drop it.
> 
> Quote from Boaz:
> 
> "As I said then. It is used in Universities for studies and experiments.
> Every once in a while. I get an email with questions and reports.
> 
> But yes feel free to remove the all thing!!
> 
> I guess I can put it up on github. In a public tree.
> 
> Just that I will need to forward port it myself, til now you guys
> been doing this for me ;-)"
> 

Yes I wrote that for V1. But I wrote the *opposite* thing in a later mail.
Which nullifies this statement above. So please remove this quote in future
submits.

Here is what I wrote later as response of V2 of this set:

<Re: remove exofs and the T10 OSD code V2>

I think I'm changing my mind about this.

Because of two reasons:

One: I see 3 thousands bit-rots in the Kernel and particularly SCSI drivers
that are much older and fat-and-ugliness consuming then the clean osd
stack. For example the all ISA bus and ZONE_DMA stuff.

Two: I have offered many times, every time this came up. That if
anyone has a major (or even minor) change to the block and/or scsi layers
that he/she has done. And that now breaks the compilation/run time of
OSD or exofs.
  I'm personally willing to spend my weekends and fix it myself. Send me
  a URL of the tree with the work done, and I will send the patches needed
  to revitalize OSD/exofs as part of that change set.

I have never received any such requests to date.

So I would please like to protest on two of Christoph's statements above.

"The code has been mostly unmaintained for years and is getting in the
 way of block / SCSI changes"

1. What does "maintained" means? I have for all these years been immediately
   responsive to any inquiries and patches to the code in question.
   And am listed as MAINTAINER of this code.
2. I have regularly, for ever, every kernel release around the RC3-RC4
   time frame, compiled and ran my almost automatic setup and made sure
   the things still run as expected (No regressions).

So Yes the code has not seen any new fixtures for years. But it is regularly
tested and proven to work, on latest kernel. So it fails the definition 
of a "bit rot"

Christoph you've been saying for so long "getting in the way of block/SCSI
changes". And every time and again this time please tell me, you never answered
before. What are these changes you want to make? can I please help?

Send me any tree where exofs/osd compilation is broken and I will personally
fix it in "ONE WEEK" time.

(If compilation is fine but you know runtime will break, its nice to have an
 heads up, but if not my automatic system will detect it anyway)

Lets say that if in the FUTURE a change-set is submitted that breaks OSD/EXOFS
compilation, and I failed to respond with a fix within "ONE WEEK". Then
this goes in as part of that change-set. And not with the argument of
"Not used, not maintained" - But as "Breaks compilation of the following changes"
I promise I will gladly ACK it then.

So for now. A personal NACK from me on the grounds that. You never told me
why / what this is breaking.

Thanks
Boaz

</Re: remove exofs and the T10 OSD code V2>

> Now the last time this caused a bit of a stir, but still no actual users,
> not even for SG_IO passthrough commands.  So here we go again, this time
> including removing everything in the scsi and block layer supporting it,
> and thus shrinking struct request.
> 

Again. T10-OSD or not. Bidi is currently actively used. By Linus rules
You are not allowed to remove it.

Two use paths:
1. Management CDBS of private vendors yes via iscsi. virt_io and usb-scsi
2. Target mode support of WRITE-RETURN-XOR, and COMPARE_AND_WRITE

---
You guys should do what you feel best. Even not answering my questions and
of course not agreeing with my advise, .i.e about breaking people's setups.

But please remove the wrong quote from me. Please quote my objection
of the matter. (pretty please because you may surly ignore that request as
well)

[I am not fighting about this at all. Please do what you need to do.
 Just want to set the record strait that's all]

Cheers :-)
Boaz
