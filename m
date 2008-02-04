From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Mon, 04 Feb 2008 10:21:38 +0900
Message-ID: <47A668A2.6030106@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>	 <1202013174.3187.69.camel@localhost.localdomain>	 <47A56F2B.4040904@gmail.com>	 <1202049511.3318.13.camel@localhost.localdomain>	 <47A5DA5F.3070209@gmail.com>	 <1202055156.3318.58.camel@localhost.localdomain>	 <47A5EE22.30001@garzik.org> <1202058736.3318.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202058736.3318.75.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> I'm only really going by what Tejun says about AHCI.  The problem as I
> understand it is data overrun on PIO mode commands.  AHCI apparently
> (like aic94xx) processes these internally and doesn't actually use the
> libata pio handlers, so it just uses an internal buffer to receive the
> PIO and DMA it into memory.  However, Tejun says (and he'll correct me
> if I'm paraphrasing wrongly, since this was on IRC a while ago) that jmb
> ahci and sata_sil24 both error out in different (but fairly nasty) ways
> if they get extra PIO data that there's no place in the SG list to
> deposit.  This seems to be why he wants to introduce a DMA drain in
> addition to the existing PIO drain.  I'd certainly characterise this
> behaviour as "broken" ... especially as not all AHCI implementations
> apparently have the bug ... some do exactly the right thing on PIO
> overruns and don't need the drain element.

JMB ahci triggers internal error (or was it timeout?  my memory is a bit
blurry now) on overflow.  ICHx ahci and sata_sil24 corrupt data by
offsetting the last FIS containing odd bytes by a byte if data buffer is
not aligned to 4bytes under certain conditions.

[and some explanations on why the aligning and draining stuff]

Also note that ignoring overflow and/or appending draining buffer
shouldn't be applied to READ/WRITE.  Over/underflow should just cause
HSM violation on RWs and friends.  We can do this for each driver or
rather each controller by enabling OFS (ahci), DRD (sil24) but the catch
is that it's pretty darn difficult to verify it actually works.  It not
only depends on specific controller but also on which ATAPI device is
attached and how it behaves depending on chunk size, transfer size in
CDB and command protocol including where it splits data FISes.

For example, IIRC, the above offset-by-one condition occurs on ICHx
ahci's (I've tested 7, 8 and 9), under PIO protocol, when the device
determines to use a separate data FIS for the last three bytes and I
don't know why it doesn't happen for DMA.  It's probably because the
ATAPI devices I have don't split FIS there but who knows?

So, I think we're far better off implementing a generic mechanism at
some higher layer.  libata core was okay.  Block layer is much better.
The overhead is insignificant and the aligning and draining aren't
needed for hot path commands anyway.

Thanks.

-- 
tejun
