From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 18:00:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF7191.3020703@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave> <20040615181536.GA12611@us.ibm.com> <40CF4207.9050108@adaptec.com> <20040615192045.GA13704@us.ibm.com> <40CF5396.1030303@adaptec.com> <20040615205715.GB13704@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33498 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265981AbUFOWAx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 18:00:53 -0400
In-Reply-To: <20040615205715.GB13704@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> The patch is adding an interface that adds two capabilities. A LLDD
> callout to possibly handle timed out commands and another capability to
> control when command timers start / stop.

Yes, I know -- I wrote it. ;-)
 
> If a LLDD wanted to just get called to possibly handle timed out
> commands it must also take care of starting and stopping command timers.
> This is all I was saying in the previous comment.

Yes, it does take care of that -- see my comment before
int (* eh_cmd_timed_out)(struct scsi_cmnd *);
 
> Why does the LLDD not have to consult the same information that the SCSI

Because 
1. It's closed to the hardware/LU than SCSI Core is.
2. Because this is NOT the SAM interface. See SAM TMF.
   SCSI Core calls a TMF telling LU via LLDD what to do.
   LLDD doesn't consult each and every time SCSI Core what to do.
   It's a suble difference, but a difference nevertheless.

> mid layer does on retries (i.e., scmd->allowed, blk_noretry_request). Is
> there no idempotent issue to worry about? While SPI topologies may lead
> to LLDD retries being successful in completing the command a major of
> the time, there are other transport topologies that lead to the success
> of the IO only through the re-driving of the IO through a disjoint path
> (i.e., different LLDD instance, port, etc.) which would be done outside
> the scope of the LLDD.

And, _again_, the LLDD would *know* about and can return EH_NONE, to
have SCSI Core/Application client try another path.
 
>  >
>  > That is, if IO is NOT to be continued, then SCSI Core should call
>  > a TMF, ABORT TASK or ABORT TASK SET, via eh_abort_handler(<cmd>).
>  > (Yes, the eh interface doesn't do 1:1 TMF mapping.)
>  >
> 
> The scsi mid layer would only call the eh_abort_handler post a timeout
> event (there are other rare case in scsi_decide_disposition that wake

The reason for calling TMF ABORT TASK is beyond the point, whether it be
timeout of application client failure.  The importance is the mechanism.

> the error handler) which is being handled by the eh_cmd_timed_out
> function of the LLDD so there would be no way for the scsi mid layer to
> abort the IO.

There is: call the appropriate TMF.
We need to implement TMF ABORT TASK entry, et al, into SCSI Core
and into LLDD, as TMF are Application Client --> SCSI transport.
 
> I think the template callout in scsi_times_out is good. I believe there
> is still debate on controlling the timers that is why I suggested maybe
> the two capabilities could be separated.

I'm rather opposed to another separation, as this bloats up SCSI Core
and makes it more complicated, unecessarily so.  scsi_done() and
queuecommand() are quite simple an interface currently and I'd
rather keep it like that.
 
> I believe the callout as per my previous query last week may help in
> some failover / failback case involing device mapper multipath. I
> think it would be good for SCSI core to have this callout interface or
> one like it.
> 
> -andmike
> -- 
> Michael Anderson
> andmike@us.ibm.com
> 

-- 
Luben


