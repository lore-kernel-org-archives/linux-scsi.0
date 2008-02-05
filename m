From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: new scsi sense handling
Date: Mon, 4 Feb 2008 18:39:22 -0800 (PST)
Message-ID: <168902.15215.qm@web31814.mail.mud.yahoo.com>
References: <47A72A7F.1050301@panasas.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:37361 "HELO
	web31814.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750739AbYBECj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 21:39:26 -0500
In-Reply-To: <47A72A7F.1050301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J

--- On Mon, 2/4/08, Boaz Harrosh <bharrosh@panasas.com> wrote:
> There are 3 usages of sense handling in drivers
> 
> 1. sense is available in driver internal structure and is
> mem-copied to upper level
> 2. A CHECK_CONDITION status was returned and the driver
> uses the scsi_eh_prep_cmnd()
>    for a REQUEST_SENSE invocation to the target. Then
> returning the sense in 
>    scsi_eh_return_cmnd(). A variation on this is when the
> driver does nothing the queue
>    is frozen an the scsi watchdog timer does the above.
> 3. The underline host adapter does the REQUEST_SENSE and a
> pre-allocated and DMA mapped
>    sense buffer receives the sense information from HW.

Many years ago when "ACA" had a constructive meaning,
so did "Autosense".  Then about 5 years ago, "Autosense"
disappeared completely since it became the de facto
implementation of the then SCSI Execute Command "RPC",
now just SCSI Execute Command procedure call.

At that point in time, the SCSI mid-layer decided
to embrace this model and give the LLDD a scsi command
structure which included the sense data buffer to
a size that the SCSI mid-layer was interested in,
at the moment 96 bytes, macro defined in
include/scsi/scsi_cmnd.h.

The concept of "Autosense" was off-loaded to LLDD
to emulate it if the specific target device to
which the command was issued, didn't supply the
sense data on CHECK CONDITION, and more so
relevant to target devices which implemented
queuing, thus the ACA.

And the mid-layer would consider extracting
the sense data via REQUEST SENSE command
as a _special case_ if the LLDD/transport layer
didn't implement the "autosense" model.

Your model is a regression of this as far
as sense data is concerned.  Imagine if
your model had existed in the SCSI mid-layer
and now someone would be submitting a series
of patches a la the far simpler and more
straightforward model, incidently currently
in place.

> Now since all IO requests come with a sense set at
> request->sense the buffer at 
> scsi_cmnd->sense_buffer can go away, and case 1 above
> can copy it's bits directly
> into it.

That's ok.

> for cases 2 and 3 above two new members in scsi host
> template will tell scsi-midlayer
> what the driver wants to do.

This should be shunned upon.  The LLDD/transport layer
should provide sense to the SCSI mid-layer possibly
by reissuing _its own_ SCSI command block representation
to extract sense directly into the req sense buffer,
so when the mid-layer SCSI command structure completes,
scsi_done(), the sense data is already present and
status is CHECK CONDITION.

(For example, a well written SATL would do this
for ATAPI devices which completed the command with
a sense key in the Error register different than 0.)

> .sense_buffsize  - will instruct a mempool_t to be
> allocated per host with sense buffers 
>                    of ".sense_buffsize" size.
> 
> .pre_allocate_sense - If set tells the midlayer to
> pre-allocate a sense buffer for each
>                       command. When set the code will
> behave like today. If the sense 
>                       allocation fails the command
> allocation also fails. (With one extra
>                       sense at mempool)
>                       If .pre_allocate_sense is not set,
> then mempool_t is resized to
>                       accommodate one reserved buffer for
> each target. So a call to
>                       scsi_eh_prep_cmnd() will not fail to
> allocate a sense buffer even
>                       in low memory condition.
> 
> Case 1 drivers call - scsi_eh_cpy_sense() - to transfer
> their sense information to upper
>   layer. The drivers are completely abstracted from any
> future changes at the scsi and block
>   sense handling. 
> 
> Case 3 drivers call the new
> scsi_make_sense()/scsi_return_sense() API to retrieve
>   a pointer to an extra DMAable sense buffer/return it to
> free store. scsi_return_sense()
>   will call scsi_eh_cpy_sense() to set new sense
> information into upper layer before
>   freeing the buffer back to the mempool. If the driver
> properly set the .pre_allocate_sense
>   flag & .sense_buffsize at host template then these
> calls are guaranteed to succeed.
> 
> Case 2 drivers continue to call
> scsi_eh_prep_cmnd()/scsi_eh_restore_cmnd() to reuse the
>   failing command for REQUEST_SENSE. Inside these functions
> scsi_error.c will call above
>   scsi_make_sense()/scsi_return_sense() for the actual
> sense buffer allocation. In this 
>   case there is a guarantied, one reserved buffer per
> scsi_device. (.pre_allocate_sense not set).
>   Drivers need to set proper size at .sense_buffsize in
> host template, for this to work.

Absolutely too complicated for such a trivial thing
as supplying sense data at scsi_done() time to
the SCSI mid-layer (see previous points I wrote above).
Too much complication for a such a small and trivial
concept.

Would it be the case that you're trying to accomplish
or accommodate a strange target behaviour?  If so
this should be done at the LLDD/transport protocol
layer, and the SCSI mid-layer shouldn't have to
see a scsi command complete with CHECK CONDITION
set without a valid sense data in the sense buffer.

It's hard to see the advantage of this "new scsi sense
handling" patches.

    Luben

