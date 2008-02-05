From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: new scsi sense handling
Date: Tue, 5 Feb 2008 11:43:58 -0800 (PST)
Message-ID: <224941.31369.qm@web31810.mail.mud.yahoo.com>
References: <20080205225409O.tomof@acm.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:25876 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754860AbYBETn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 14:43:59 -0500
In-Reply-To: <20080205225409O.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, jens.axboe@oracle.com, jeff@garzik.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bharrosh@panasas.com

--- On Tue, 2/5/08, FUJITA Tomonori <tomof@acm.org> wrote:
> On Mon, 4 Feb 2008 18:39:22 -0800 (PST)
> Luben Tuikov <ltuikov@yahoo.com> wrote:
> 
> > --- On Mon, 2/4/08, Boaz Harrosh
> <bharrosh@panasas.com> wrote:
> > > There are 3 usages of sense handling in drivers
> > > 
> > > 1. sense is available in driver internal
> structure and is
> > > mem-copied to upper level
> > > 2. A CHECK_CONDITION status was returned and the
> driver
> > > uses the scsi_eh_prep_cmnd()
> > >    for a REQUEST_SENSE invocation to the target.
> Then
> > > returning the sense in 
> > >    scsi_eh_return_cmnd(). A variation on this is
> when the
> > > driver does nothing the queue
> > >    is frozen an the scsi watchdog timer does the
> above.
> > > 3. The underline host adapter does the
> REQUEST_SENSE and a
> > > pre-allocated and DMA mapped
> > >    sense buffer receives the sense information
> from HW.
> > 
> > Many years ago when "ACA" had a constructive
> meaning,
> > so did "Autosense".  Then about 5 years ago,
> "Autosense"
> > disappeared completely since it became the de facto
> > implementation of the then SCSI Execute Command
> "RPC",
> > now just SCSI Execute Command procedure call.
> > 
> > At that point in time, the SCSI mid-layer decided
> > to embrace this model and give the LLDD a scsi command
> > structure which included the sense data buffer to
> > a size that the SCSI mid-layer was interested in,
> > at the moment 96 bytes, macro defined in
> > include/scsi/scsi_cmnd.h.
> > 
> > The concept of "Autosense" was off-loaded to
> LLDD
> > to emulate it if the specific target device to
> > which the command was issued, didn't supply the
> > sense data on CHECK CONDITION, and more so
> > relevant to target devices which implemented
> > queuing, thus the ACA.
> > 
> > And the mid-layer would consider extracting
> > the sense data via REQUEST SENSE command
> > as a _special case_ if the LLDD/transport layer
> > didn't implement the "autosense" model.
> 
> Only SPI and USB?

I don't understand this question.

> 
> The most of LLDs using the transport protocol that we care
> about today
> uses sense buffer in their own internal structure.

Yes.

> 
> I think that the issue to solve to kill
> scsi_cmnd:sense_buffer is how
> to share (or export) such sense buffer with the scsi
> mid-layer.

And therein lies the problem.  Sense data is SCSI specific,
it should be left to SCSI, unless of course you can
stipulate that _all_ block devices return sense data.
If that's not the case and you move it to the block
layer, then you get a whole bunch of other problems,
like does this device want/use it, should we allocate
it, etc. OTOH, if that _is_ the case, then you don't
have to worry about this and the model is pretty
much as the SCSI mid-layer has it, i.e. sense buffer
always present.  So I guess the question is, can
you stipulate that _all_ block devices return sense data?

    Luben

