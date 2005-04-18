From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 02/07] scsi: make scsi_send_eh_cmnd use
	its own timer instead of scmd->eh_timeout
Date: Mon, 18 Apr 2005 17:55:16 -0500
Message-ID: <1113864917.4998.89.camel@mulgrave>
References: <20050410184214.4AAD0992@htj.dyndns.org>
	 <20050410184214.B68C4CBA@htj.dyndns.org>
	 <1113838401.4998.27.camel@mulgrave> <20050418223114.GA32478@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:14720 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261182AbVDRWze (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 18:55:34 -0400
In-Reply-To: <20050418223114.GA32478@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-04-19 at 07:31 +0900, Tejun Heo wrote:
>  The original code also uses timer pending status as a signal that
> command completed normally in scsi_eh_done() function, and the same
> race also exists in the original code, no matter what we do, unless we
> make timer expiration and removal of the command atomic, there will be
> a window in which command completes normally but considered to have
> timed out as long as we use timer pending status as tie breaker.

True enough; it's a race between the driver calling scsi_done() and the
timer expiring.  However, that's an acceptable race, since the timer
values are usually in the order of a few seconds and the command usually
completes in milliseconds.  the done function is called in interrupt
context after command completion, so it's as close as possible to the
actual command completion

>  The patch moves the test out of scsi_eh_done() into
> scsi_send_eh_cmnd() and this does widen the window by delaying removal
> of timer until after the original thread gets scheduled, but usually
> not by much and that's how timers are done in many cases (through out
> the kernel, timer removals are done with intervening scheduling and no
> one considers those incorrect).  So...

The time between a thread being marked ready to run and actually running
has been measured in seconds on a heavily loaded system.  That makes the
race window potentially as wide as the timer, which is unacceptable.

James


