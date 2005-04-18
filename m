From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 02/07] scsi: make scsi_send_eh_cmnd use
	its own timer instead of scmd->eh_timeout
Date: Mon, 18 Apr 2005 10:33:21 -0500
Message-ID: <1113838401.4998.27.camel@mulgrave>
References: <20050410184214.4AAD0992@htj.dyndns.org>
	 <20050410184214.B68C4CBA@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:33000 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262106AbVDRPdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 11:33:36 -0400
In-Reply-To: <20050410184214.B68C4CBA@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, 2005-04-11 at 03:45 +0900, Tejun Heo wrote:
> 	scmd->eh_timeout is used to resolve the race between command
> 	completion and timeout.  However, during error handling,
> 	scsi_send_eh_cmnd uses scmd->eh_timeout.  This creates a race
> 	condition between eh and normal completion for a request which
> 	has timed out and in the process of error handling.  If the
> 	request completes while scmd->eh_timeout is being used by eh,
> 	eh timeout is lost and the command will be handled by both eh
> 	and completion path.  This patch fixes the race by making
> 	scsi_send_eh_cmnd() use its own timer.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

The logic is wrong in there.

The problem is you cannot rely on the timer being pending as a signal
that the command completed normally.  The kernel doesn't define the
elapsed time between the eh_action semaphore going up and the process
waiting for it being scheduled.  If the timer fires within that
undefined interval, you'll think the command timed out when it, in fact,
completed normally.

James


