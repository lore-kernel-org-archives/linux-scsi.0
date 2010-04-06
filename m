From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: sense data for status GOOD
Date: Tue, 06 Apr 2010 15:15:58 +0300
Message-ID: <4BBB25FE.2000906@panasas.com>
References: <4BB2203F.1060409@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:61515 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404Ab0DFMQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 08:16:03 -0400
In-Reply-To: <4BB2203F.1060409@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

On 03/30/2010 07:01 PM, Douglas Gilbert wrote:
> The folk at t10.org slipped this innocuous looking
> addition into sam5r04 section 5.3.1 on status codes.
> 
> "Sense data may be delivered in the buffer defined by
> the Sense Data argument of the Execute Command
> procedure call (see 5.1) for any status code."
> 
> Previously sense data was only valid for status
> CHECK_CONDITION [0x2] (and the obsolete
> COMMAND_TERMINATED [0x22]). The quoted section in
> the previous paragraph means that sense data could
> arrive with any status code.
> 
> And now with draft sbc3r22 there is an example:
> status=GOOD, sense_key=COMPLETED (recently added)
> additional_sense_qualifier="INSPECT REFERRALS
> SENSE DESCRIPTORS". Referrals are new and explained
> in sbc3r22. IMO only a very small audience would
> be interested in them. However it does indicate
> a new trend.
> 
> 
> So the question for the Linux scsi subsystem is
> does it (or can it without many changes) convey
> "non CHECK_CONDITION" sense data back up from
> an initiator (LLD) to code that might care?
> 

scsi_cmnd->sense_buffer has an hard coded max_size and no associated
current_size member. the scsi-ml, given a CHECK_CONDITION, will
analyse the ->sense_buffer and determine it's size, then will copy
the content and set the size into request's sense members. All this
you already know.

Now what do you want to happen?
A. Only LLD knows when sense is available through host specific flags.
  In that case:
   I propose a new scsi_set_sense() that will just set the proper
   request members. It should be called only if != CHECK_CONDITION,
   since in that case it will just be over-written by the scsi-ml again.
   (Or not that can be changed as well).
   [This is a simple change, but needs LLD specific code every time]

B. The protocol defines when a sense is available, by status + cmnd
   combination, the sense is set by the target, the LLD has no special
   knowledge if sense is present or not. In this case scsi-ml can just
   inspect for these conditions and copy sense up the stack as before.

Next step is for some ULD, to actually inspect these fields.

> Doug Gilbert
> 

It does not look too complicated either way.

Boaz
