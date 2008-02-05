From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: new scsi sense handling
Date: Tue, 5 Feb 2008 22:54:40 +0900
Message-ID: <20080205225409O.tomof@acm.org>
References: <47A72A7F.1050301@panasas.com>
	<168902.15215.qm@web31814.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57995 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYBENzv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 08:55:51 -0500
In-Reply-To: <168902.15215.qm@web31814.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, jens.axboe@oracle.com, jeff@garzik.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bharrosh@panasas.comfujita.tomonori@lab.ntt.co.jp

On Mon, 4 Feb 2008 18:39:22 -0800 (PST)
Luben Tuikov <ltuikov@yahoo.com> wrote:

> --- On Mon, 2/4/08, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > There are 3 usages of sense handling in drivers
> > 
> > 1. sense is available in driver internal structure and is
> > mem-copied to upper level
> > 2. A CHECK_CONDITION status was returned and the driver
> > uses the scsi_eh_prep_cmnd()
> >    for a REQUEST_SENSE invocation to the target. Then
> > returning the sense in 
> >    scsi_eh_return_cmnd(). A variation on this is when the
> > driver does nothing the queue
> >    is frozen an the scsi watchdog timer does the above.
> > 3. The underline host adapter does the REQUEST_SENSE and a
> > pre-allocated and DMA mapped
> >    sense buffer receives the sense information from HW.
> 
> Many years ago when "ACA" had a constructive meaning,
> so did "Autosense".  Then about 5 years ago, "Autosense"
> disappeared completely since it became the de facto
> implementation of the then SCSI Execute Command "RPC",
> now just SCSI Execute Command procedure call.
> 
> At that point in time, the SCSI mid-layer decided
> to embrace this model and give the LLDD a scsi command
> structure which included the sense data buffer to
> a size that the SCSI mid-layer was interested in,
> at the moment 96 bytes, macro defined in
> include/scsi/scsi_cmnd.h.
> 
> The concept of "Autosense" was off-loaded to LLDD
> to emulate it if the specific target device to
> which the command was issued, didn't supply the
> sense data on CHECK CONDITION, and more so
> relevant to target devices which implemented
> queuing, thus the ACA.
> 
> And the mid-layer would consider extracting
> the sense data via REQUEST SENSE command
> as a _special case_ if the LLDD/transport layer
> didn't implement the "autosense" model.

Only SPI and USB?

The most of LLDs using the transport protocol that we care about today
uses sense buffer in their own internal structure.

I think that the issue to solve to kill scsi_cmnd:sense_buffer is how
to share (or export) such sense buffer with the scsi mid-layer.

For the old transport protocols, we could do something that James said
in this thread to to kill scsi_cmnd:sense_buffer.
