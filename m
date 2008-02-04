From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
	padding in favour of that provided by the block layer
Date: Mon, 04 Feb 2008 09:43:19 -0600
Message-ID: <1202139799.3096.11.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <1200698057.3111.68.camel@localhost.localdomain>
	 <1201894847.3134.59.camel@localhost.localdomain>
	 <47A37AF3.3030503@garzik.org>
	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>
	 <1202013174.3187.69.camel@localhost.localdomain>
	 <47A56F2B.4040904@gmail.com>
	 <1202049511.3318.13.camel@localhost.localdomain>
	 <47A5DA5F.3070209@gmail.com>
	 <1202055156.3318.58.camel@localhost.localdomain>
	 <47A66A39.7090800@gmail.com>  <47A6D9F2.5060102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47A6D9F2.5060102@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-02-04 at 18:25 +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > Some ATA controllers including SFF BMDMA and libata PIO HSM need the
> > number of bytes mapped in the sg table.  Yeah, it can be calculated with
> > a simple macro but it also is a fundamentally confusing dual-sizing
> > which should be made as clear as possible.  Plus, it can be difficult to
> > find out when somebody used the wrong thing, so what I'm saying is that
> > we need to make it easy.  Anyways, please lemme work on it a bit.  I'll
> > get back to you guys soon.
> 
> Okay, here's first draft combined patch.  Only compile tested (expect
> it to be broken) but it should be functionally equivalent to
> ata_sg_setup_extra() based implementation albeit with shorter drain
> buffer size.  Several things to note...

I noticed you posted an update ... I'll go over the code in that one.

> * fsl last sg check isn't included here.  Will split it out and post
>   it separately.
> 
> * rq->raw_data_len added.  Rationales...
> 
>   - All these padding and draining are to prevent controllers from
>     crapping themselves when data buffer is shorter than it likes it
>     to be.  Any controller which talks MMC (or SPC for that matter)
>     should be ready for transfers shorter than buffer so feeding
>     enlarged buffer size is inherently safter than feeding the length,
>     so the primary data length field, rq->data_len, contains the
>     adjusted length.

Actually, no they don't.  Overrun termination is pretty much standard in
most HBAs that do MMC (including the strange block one).  Allowing an
overrun is simply unsafe and a security risk, so all apart from the ATA
ones allow us to terminate the transaction safely.

>   - raw_data_len can't be easily deduced from data_len.  The other way
>     is possible but with both aligning and draining and command
>     filtering, calculating it later is messy.

Like I said, it's simply the command size plus the drain buffer which
you get from the queue.  I'll redo your patches to show how it can be
done without adding the extra space to every request.

> * Draining configuration is done in sr as it's the driver for MMC.  It
>   can move both ways - either into SCSI midlayer as SPC and other
>   commands do variable length responses too or into libata if all
>   non-ATA controllers are happy without such workarounds.  If you ask
>   me, I'm inclined to move it into SCSI midlayer as the added overhead
>   is insignificant (especially with drain_needed added) and it won't
>   break anything (well, theoretically, at least).

Let me think about this one.  The only consumer of draining is libata.
It might make sense to process the drains in sr.c but it certainly
doesn't make sense to turn them on indiscriminately in there because
*none* of the SCSI users needs them.

> * Padding via alinging seems a bit too hacky to me.  It doesn't even
>   cover all sg cases.  I think we'll need improvements there, well,
>   but for the time being, this should do.

That's essentially what the dma_aligment parameter was designed for ...
we can always make the way it's handled differently; I just updated
block to use what exists already.

> I'll test and report in a few hours.

Great, thanks.

James


