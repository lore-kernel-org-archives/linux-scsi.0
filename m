From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] sym53c8xx_2: Fix validation (Fix hotplug support).
Date: Sun, 17 Aug 2008 22:32:01 -0500
Message-ID: <1219030321.3917.44.camel@localhost.localdomain>
References: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53356 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbYHRDcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 23:32:09 -0400
In-Reply-To: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nsn.com>, Matthew Wilcox <matthew@wil.cx>

On Sun, 2008-08-17 at 15:18 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> The patch and description is from Aaro Koskinen. He sent us the
> patch against our fedora kernel, but he is short on time and did not have
> time to send it upstream, so I am sending it for him so it does not sit in
> just our trees.
> 
> This patch applies to scsi-fc-fixes.

One of the things that's missing from this is really the problem it's
trying to solve ... the below is just an analysis of potential bugs in
the sym2 code.

> >From Aaro Koskinen:
> 
> Principles for SCSI negotiation:
> 
> If the driver and a target have a different idea of the transfer
> parameters, all data transfers will fail. Usually either the driver or the
> target will hang during the data phase, or commands are being rejected due
> to extraneous data etc.
> 
> (a) To prevent this, targets report check condition/unit attention before
> any data transfer whenever there has been a device reset (only way to
> invalidate all negotiations). So, this can be used to trigger
> renegotiation.
> 
> (b) An exception to above, INQUIRY and REQUEST SENSE commands are always
> executed immediately by targets, so with these commands the driver can
> never be sure what the negotiation values are, so there must be a
> renegotiation before sending the command.

Actually, not necessarily a renegotiation.  What usually happens is that
a driver simply adds in the negotiation messages to these two commands
with the parameters it thinks its currently operating at.  The specs
require confirmatory replies to this.

> Couple notes about the patch:
> 
> - It seems there is a bug in the current driver (in the beforementioned
> kernels), the sym_sir_bad_scsi_status()/S_CHECK_COND branch is actually
> NOT starting a new negotiation, although it definitely should. The patch
> fixes that.

This seems to be a bug in sym_prepare_nego(), yes ... it should do
either a PPR or WDTR/SDTR sequence ... there is a case where it won't do
anything when asked.

> - The patch deletes code from sym_sir_task_recovery()/M_RESET branch. It's
> unnecessary to reset negotiation status there, since any reset eventually
> triggers S_CHECK_COND.

It looks like a reasonable safety feature against problem drives ... I'd
be hesitant to remove it.

> - It seems that the SPI "domain validation" consists solely of INQUIRY
> commands.

Actually, no.  DV uses Inquiry solely for non DT negotiations because of
potential echo buffer problems in certain drives but it uses the echo
buffer for DT verification.

>  As a result, if (b) is followed, targets that support PPR would
> never get to the point of doing PPR transfers during domain validation
> (but immediately after on the next command following the dv), since each
> INQUIRY re-starts the negotiation cycle. This patch solves this by making
> it possible to do the negotiation cycle WIDE -> SYNC -> PPR during a
> single SCSI command.

I don't quite follow this.  The way SPI DV works is that we start out
fully async for the first INQUIRY, then move to wide async (to check no
bus width domain problems, which are the most common) then jump to the
highest speed supported by the device and transport.  i.e. we always do

async -> WDTR -> SDTR

or

async -> WDTR -> PPR

we never go

async -> WDTR -> SDTR -> PPR.

What's the actual problem you are seeing?

James


