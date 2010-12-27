From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 7/8] IB/srp: stop sharing the host lock with SCSI
Date: Mon, 27 Dec 2010 19:56:37 +0200
Message-ID: <4D18D355.30308@panasas.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>	 <1293139893-11678-8-git-send-email-dillowda@ornl.gov> <1293472165.2896.34.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:17699 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0L0R4l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 12:56:41 -0500
In-Reply-To: <1293472165.2896.34.camel@obelisk.thedillows.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dave@thedillows.org>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

On 12/27/2010 07:49 PM, David Dillow wrote:
> On Thu, 2010-12-23 at 16:31 -0500, David Dillow wrote:
>> We don't need protection against the SCSI stack, so use our own lock to
>> allow parallel progress on separate CPUs.
> 
>> @@ -1126,7 +1125,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>>  		return 0;
>>  	}
>>  
>> -	spin_lock_irqsave(shost->host_lock, flags);
>> +	spin_lock_irqsave(&target->lock, flags);
>>  	/* This goes away once the scsi_eh routines stop testing it. */
>>  	scsi_cmd_get_serial(shost, scmnd);
>>  	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
> 
> This one may be a bit problematic -- I need to look at the required
> locking to avoid a race with the serial number. Of course, there's an
> easy fix -- if this patch lands after the patches to remove the serial
> number check from the error handler, then there's no reason to get a
> serial number in the initiator.
> 

$ git log --oneline -1 linus/master -- drivers/scsi/scsi_error.c
459dbf7 [SCSI] Eliminate error handler overload of the SCSI serial number

Cheers
