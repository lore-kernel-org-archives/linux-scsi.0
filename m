From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 13:57:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615205715.GB13704@us.ibm.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave> <20040615181536.GA12611@us.ibm.com> <40CF4207.9050108@adaptec.com> <20040615192045.GA13704@us.ibm.com> <40CF5396.1030303@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:39087 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265947AbUFOU5W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 16:57:22 -0400
Content-Disposition: inline
In-Reply-To: <40CF5396.1030303@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov [luben_tuikov@adaptec.com] wrote:
> >In the patch as is you overload the eh_cmd_timed_out template function
> 
> But this method doesn't exist. How can I be overloading it?
> 
> >to mean the LLDD wants to try to handle timed out commands plus start /
> >restart / stop the timers. This would appear to limit the interface to
> >the LLDD doing both operations which should be separate decisions?
> 
> I don't understand what you mean here.

The patch is adding an interface that adds two capabilities. A LLDD
callout to possibly handle timed out commands and another capability to
control when command timers start / stop. 

If a LLDD wanted to just get called to possibly handle timed out
commands it must also take care of starting and stopping command timers.
This is all I was saying in the previous comment.

> 
> >Also in the comments for the patch you mention that the LLDD may decide
> >to resubmit the IO which I assume is why you would want to have control
> >of the timers, but wouldn't the LLDD need to also consult if the IO
> >should be resubmitted which propagates these tests and could result in
> >inconsistent policy.
> 
> But the LLDD *does* know if the IO is to resubmitted, it doesn't have to
> consult anyone.  Hint: targets are *passive*, and thus the stipuations in 
> SAM.

Why does the LLDD not have to consult the same information that the SCSI
mid layer does on retries (i.e., scmd->allowed, blk_noretry_request). Is
there no idempotent issue to worry about? While SPI topologies may lead
to LLDD retries being successful in completing the command a major of
the time, there are other transport topologies that lead to the success
of the IO only through the re-driving of the IO through a disjoint path
(i.e., different LLDD instance, port, etc.) which would be done outside
the scope of the LLDD.

> 
> That is, if IO is NOT to be continued, then SCSI Core should call
> a TMF, ABORT TASK or ABORT TASK SET, via eh_abort_handler(<cmd>).
> (Yes, the eh interface doesn't do 1:1 TMF mapping.)
> 

The scsi mid layer would only call the eh_abort_handler post a timeout
event (there are other rare case in scsi_decide_disposition that wake
the error handler) which is being handled by the eh_cmd_timed_out
function of the LLDD so there would be no way for the scsi mid layer to
abort the IO.

> This is how SCSI Core communicates with LLDD, it's not the case that
> LLDD asks SCSI Core each and every time for each and every decision.
> First it's not by spec, and second it is unattainable both due to
> the hardware reasons mentioned by Doug and I and due to the
> recovery quirks.
> 
> I really don't see why this is such a big deal when SCSI Core
> and LLDDs are unaffected.  It is just an _optional_ method
> and will do good for SCSI Core. I promise. ;-)

I think the template callout in scsi_times_out is good. I believe there
is still debate on controlling the timers that is why I suggested maybe
the two capabilities could be separated.

I believe the callout as per my previous query last week may help in
some failover / failback case involing device mapper multipath. I
think it would be good for SCSI core to have this callout interface or
one like it.

-andmike
--
Michael Anderson
andmike@us.ibm.com

