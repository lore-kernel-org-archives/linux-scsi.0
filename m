From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: new scsi sense handling
Date: Wed, 06 Feb 2008 09:55:23 +0900
Message-ID: <20080206095523F.fujita.tomonori@lab.ntt.co.jp>
References: <20080205225409O.tomof@acm.org>
	<224941.31369.qm@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:52889 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYBFA6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 19:58:00 -0500
In-Reply-To: <224941.31369.qm@web31810.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, jens.axboe@oracle.com, jeff@garzik.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bharrosh@panasas.com

On Tue, 5 Feb 2008 11:43:58 -0800 (PST)
Luben Tuikov <ltuikov@yahoo.com> wrote:

> --- On Tue, 2/5/08, FUJITA Tomonori <tomof@acm.org> wrote:
> > On Mon, 4 Feb 2008 18:39:22 -0800 (PST)
> > Luben Tuikov <ltuikov@yahoo.com> wrote:
> > 
> > > --- On Mon, 2/4/08, Boaz Harrosh
> > <bharrosh@panasas.com> wrote:
> > > > There are 3 usages of sense handling in drivers
> > > > 
> > > > 1. sense is available in driver internal
> > structure and is
> > > > mem-copied to upper level
> > > > 2. A CHECK_CONDITION status was returned and the
> > driver
> > > > uses the scsi_eh_prep_cmnd()
> > > >    for a REQUEST_SENSE invocation to the target.
> > Then
> > > > returning the sense in 
> > > >    scsi_eh_return_cmnd(). A variation on this is
> > when the
> > > > driver does nothing the queue
> > > >    is frozen an the scsi watchdog timer does the
> > above.
> > > > 3. The underline host adapter does the
> > REQUEST_SENSE and a
> > > > pre-allocated and DMA mapped
> > > >    sense buffer receives the sense information
> > from HW.
> > > 
> > > Many years ago when "ACA" had a constructive
> > meaning,
> > > so did "Autosense".  Then about 5 years ago,
> > "Autosense"
> > > disappeared completely since it became the de facto
> > > implementation of the then SCSI Execute Command
> > "RPC",
> > > now just SCSI Execute Command procedure call.
> > > 
> > > At that point in time, the SCSI mid-layer decided
> > > to embrace this model and give the LLDD a scsi command
> > > structure which included the sense data buffer to
> > > a size that the SCSI mid-layer was interested in,
> > > at the moment 96 bytes, macro defined in
> > > include/scsi/scsi_cmnd.h.
> > > 
> > > The concept of "Autosense" was off-loaded to
> > LLDD
> > > to emulate it if the specific target device to
> > > which the command was issued, didn't supply the
> > > sense data on CHECK CONDITION, and more so
> > > relevant to target devices which implemented
> > > queuing, thus the ACA.
> > > 
> > > And the mid-layer would consider extracting
> > > the sense data via REQUEST SENSE command
> > > as a _special case_ if the LLDD/transport layer
> > > didn't implement the "autosense" model.
> > 
> > Only SPI and USB?
> 
> I don't understand this question.

I meant, 'what transport protocols are categorized into the transport
protocol that doesn't implement the "autosense" model?'


> > The most of LLDs using the transport protocol that we care
> > about today
> > uses sense buffer in their own internal structure.
> 
> Yes.
> 
> > 
> > I think that the issue to solve to kill
> > scsi_cmnd:sense_buffer is how
> > to share (or export) such sense buffer with the scsi
> > mid-layer.
> 
> And therein lies the problem.  Sense data is SCSI specific,
> it should be left to SCSI, unless of course you can
> stipulate that _all_ block devices return sense data.

Yeah, sense data is SCSI specific and it should be left to SCSI. But
I'm not sure we need to stipulate that _all_ block devices return
sense data. Today the block layer users (sg, bsg, etc) use it only
when it's appropriate (or only if they want to use it).


> If that's not the case and you move it to the block
> layer, then you get a whole bunch of other problems,
> like does this device want/use it, should we allocate
> it, etc. OTOH, if that _is_ the case, then you don't
> have to worry about this and the model is pretty
> much as the SCSI mid-layer has it, i.e. sense buffer
> always present.  So I guess the question is, can
> you stipulate that _all_ block devices return sense data?
