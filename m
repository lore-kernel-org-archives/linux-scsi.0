From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [Q] 2.4.x: how to handle driver aborts in sd/sr
Date: Fri, 10 May 2002 17:28:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205101536.g4AFa9L136556@d12relay01.de.ibm.com>
References: <OF789CF225.896237A6-ONC1256BB1.004E87CD@de.ibm.com> <20020508090729.A5368@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12relay01.de.ibm.com (d12relay01.de.ibm.com [9.165.215.22])
	by d12lmsgate-2.de.ibm.com (8.12.3/8.12.3) with ESMTP id g4AFaNCo014890
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2002 17:36:23 +0200
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Patrick,

actually that is what is done for now. And it worked so far for disks. Couldn't
try that for tapes, yet. But I was wondering whether it would help recovery to
know a bit more about what happened exactly.
I just thought it more logical to set DID_ABORT for aborted commands. If I 
understood the SCSI-spec correctly it is just like an soft error just a bit 
more specific.

/Stefan

Patrick Mansfield wrote:

> Stefan,
> 
> Why not return DID_SOFT_ERROR? Disks (SCpnt->allowed > 0) will retry the
> IO some limited number of times, and tape (SCpnt->allowed == 0) will complete
> the IO with DID_SOFT_ERROR in the result.
> 
> Or, do you have to handle an arbitrary numbers of retries?
> 
> -- Patrick
> 
> On Wed, May 08, 2002 at 01:35:52PM +0200, Stefan Bader wrote:
>> Hi,
>> 
>> I've got some sort of error handling design question which I need some
>> advice whether
>> this might be done the way I think.
>> In some error situations our low-level driver has to abort all currently
>> active commands.
>> The device may work if the requests are retried. This works for disk for
>> now by triggering
>> the mid-layer retry mechanism. This is ok for disks but a big problem for
>> tapes which need
>> to handle this situation with more effort.
>> Now for that, the low-level driver can (and probably should) return
>> DID_ABORT and let the
>> upper layer handle the situation. But then the sd driver would fail the
>> request(s) because it
>> takes a result != 0 (aside from MEDIUM_ERROR) as 'no successful sectors'
>> (which wouldn't
>> hurt) and there is no special catch for the condition in
>> scsi_io_completion() from scsi_lib.c.
>> The desired action for the the abort case for disks would be just to
>> requeue the whole request
>> (as it is done in the case of DID_RESET).
>> The only two highlevel drivers that seem to use scsi_io-completion seem to
>> be sd.c and sr.c
>> and in the reset case the request would just requeued as well. So, would
>> there be a problem
>> in adding this to scsi_lib.c?
>> 
>> /Stefan Bader
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

