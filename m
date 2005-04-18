From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 02/07] scsi: make scsi_send_eh_cmnd use
 its own timer instead of scmd->eh_timeout
Date: Tue, 19 Apr 2005 08:25:22 +0900
Message-ID: <426441E2.1010900@gmail.com>
References: <20050410184214.4AAD0992@htj.dyndns.org>	 <20050410184214.B68C4CBA@htj.dyndns.org>	 <1113838401.4998.27.camel@mulgrave> <20050418223114.GA32478@htj.dyndns.org> <1113864917.4998.89.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.204]:3766 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261191AbVDRXZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 19:25:29 -0400
Received: by rproxy.gmail.com with SMTP id j1so1094728rnf
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2005 16:25:29 -0700 (PDT)
In-Reply-To: <1113864917.4998.89.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2005-04-19 at 07:31 +0900, Tejun Heo wrote:
> 
>> The original code also uses timer pending status as a signal that
>>command completed normally in scsi_eh_done() function, and the same
>>race also exists in the original code, no matter what we do, unless we
>>make timer expiration and removal of the command atomic, there will be
>>a window in which command completes normally but considered to have
>>timed out as long as we use timer pending status as tie breaker.
> 
> 
> True enough; it's a race between the driver calling scsi_done() and the
> timer expiring.  However, that's an acceptable race, since the timer
> values are usually in the order of a few seconds and the command usually
> completes in milliseconds.  the done function is called in interrupt
> context after command completion, so it's as close as possible to the
> actual command completion
> 
> 
>> The patch moves the test out of scsi_eh_done() into
>>scsi_send_eh_cmnd() and this does widen the window by delaying removal
>>of timer until after the original thread gets scheduled, but usually
>>not by much and that's how timers are done in many cases (through out
>>the kernel, timer removals are done with intervening scheduling and no
>>one considers those incorrect).  So...
> 
> 
> The time between a thread being marked ready to run and actually running
> has been measured in seconds on a heavily loaded system.  That makes the
> race window potentially as wide as the timer, which is unacceptable.

 Hmm, okay, agreed.  I'll rework it.  I think I can do it by just adding
a private struct scsi_eh_timer_arg to pass along the timer and the cmd
pointer.  I'll repost the patchset soon.

 Thanks a lot.

-- 
tejun

