From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Wed, 16 Jun 2004 11:48:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D06BD7.1050605@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com><1087313492.1796.37.camel@mulgrave> <40CF4A15.9060005@adaptec.com><1087329285.2048.94.camel@mulgrave>  <20040616152758.GB4288@us.ibm.com> <1087400228.1747.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:40411 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264061AbUFPPtC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 11:49:02 -0400
In-Reply-To: <1087400228.1747.16.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2004-06-16 at 10:27, Mike Anderson wrote:
>  > Does this mean scsi_times_out will complete the command by calling a
>  > SCSI mid layer internal form of the scsi_done function (less the
>  > scsi_delete_timer call) or that the LLDD will call scsi_done and we will
>  > need to modify scsi_done to accept these no timer running cases.
> 
> Yes.  We'll just abstract all of scsi_done() bar the timer check into
> __scsi_done, which will be private, and called in this instance.

So, now, there will be a 2nd, "fuzzy" way of returning a command
back to SCSI Core:

a) LLDD calls scsi_done() when all went well, an antagonist to the 
   one and only queuecommand(),
XOR
b) command timed out, LLDD's eh_cmd_timed_out() was called and returned
   EH_HANDLED, and then _SCSI_Core_ calls __scsi_done().

I.e. in b) the LLDD _never_ gets to call scsi_done() (or a completion method)
on that command.

Anyway, do we have a patch for *this* solution?

>  > >
>  > > c. I need more time, reset the timer and notify me again when it 
> fails.
>  > >
>  > > For (c), I propose that we use the same timeout period, but increment
>  > > the retry count (and do this up to allowed retries plus one [so that
>  > > no-retry commands have one crack at being recovered by the LLD]) when
>  > > retries are exhausted, normal error handling would proceed on timer
>  > > expiry leading to certain failure of the command since it would be
>  > > ineligible to be retried.
>  >
>  > The comment on the no-retry commands appears counter to the intent of
>  > FASTFAIL. On a multi-ported device if there really is a port / 
> controller
>  > issue we have increased the failover time 2x the timeout value which
>  > IIRC was one case that FASTFAIL wished to address.
> 
> Well ... perhaps the solution's to shorten the timers then for this
> case?

-- 
Luben


