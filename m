From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
	padding in favour of that provided by the block layer
Date: Sun, 03 Feb 2008 11:12:16 -0600
Message-ID: <1202058736.3318.75.camel@localhost.localdomain>
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
	 <47A5EE22.30001@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47A5EE22.30001@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org


On Sun, 2008-02-03 at 11:38 -0500, Jeff Garzik wrote:
> James Bottomley wrote:
> > The aic94xx sequencer has a very finely honed sense of DMA transfers.
> > It's fully automated, and handles both ATA DMA and ATA PIO in the
> > sequencer engine (so all the driver sees is DMA).
> 
> ditto AHCI, and most other DMA engines
> 
> 
> > It reports both underrun and overrun conditions.  For DMA underrun
> 
> ditto AHCI, and most other DMA engines
> 
> 
> > (device transfers less than expected, it just returns what it has and
> > how much was missing as the residual) for DMA overrun (as in device
> > tried to take more than it was programmed to send on either read or
> > write) for PIO it does seem to zero fill or discard and then simply
> > report task complete with overrun and let libsas sort it out.  I suspect
> > for DMA it first tries DMAT before taking other actions, but I'd need a
> > protocol analyser (or the sequencer docs) to be sure.
> 
> Almost every other DMA engine on the planet besides aic94xx is pretty 
> much the same...  you set up an s/g tables, and it reports overrun or 
> underrun via an interrupt + status register bit.
> 
> It sounds like aic94xx might do more work in the firmware -- that counts 
> as "advanced", since some of the DMA engine cleanup clearly occurs in 
> firmware, rather than pushed to kernel software.
> 
> Nowhere do I see anything about AHCI that is "broken."  It has standard 
> DMA engine behavior found in storage and non-storage hardware.

I'm only really going by what Tejun says about AHCI.  The problem as I
understand it is data overrun on PIO mode commands.  AHCI apparently
(like aic94xx) processes these internally and doesn't actually use the
libata pio handlers, so it just uses an internal buffer to receive the
PIO and DMA it into memory.  However, Tejun says (and he'll correct me
if I'm paraphrasing wrongly, since this was on IRC a while ago) that jmb
ahci and sata_sil24 both error out in different (but fairly nasty) ways
if they get extra PIO data that there's no place in the SG list to
deposit.  This seems to be why he wants to introduce a DMA drain in
addition to the existing PIO drain.  I'd certainly characterise this
behaviour as "broken" ... especially as not all AHCI implementations
apparently have the bug ... some do exactly the right thing on PIO
overruns and don't need the drain element.

> > We handle overruns as error conditions in both SAS and ATA at the
> > moment, but the point is that the ATAPI device is fully happy and
> > quiesced when we do this.
> 
> That may be the result of aic94xx handling extra FIS's in the firmware, 
> something we cannot depend on for purely silicon-based devices.
> 
> mvsas, broadsas, ahci, sata_sil24, and others behave similarly... 
> Please don't mistake lack of firmware cleanup as "broken hardware."

OK, well this is probably me coming from the SCSI world.  Data overruns
happen (especially if you allow users to control the command
parameters), and just discarding the overrun has been common practice
for decades.

Correct me if I'm wrong, but I think ATAPI7v3 covers the PIO overrun
case in 20.4 and indicates precisely how the HBA should handle the
problem.  ACHI also includes the PxIS.OFS bits precisly for this case.
The problem seems to come when using this mechanism hangs the device (as
it apparently does in a limited number of ACHI implementations) and we
just have to take the data in via DMA from the HBA (hence the need for a
drain buffer).

James


