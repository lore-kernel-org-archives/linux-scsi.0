From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] improvement of fastfail operation
Date: 27 Mar 2004 10:57:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080403035.2078.10.camel@mulgrave>
References: <200403240038.AA03092@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:27040 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261795AbUC0P5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 10:57:22 -0500
In-Reply-To: <200403240038.AA03092@fukuchi.jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-03-23 at 19:38, Masao Fukuchi wrote:
> We propose the following improvements for fastfail.
> 
> 1.Validate fastfail flag for command timeout.
>   Currently fastfail flag is not valid for command timeout and repeats
>   4 times.
> 2.Set timeout value to 10sec.
>   Currently timeout value is set to 30sec.
> 3.Set wait time for bus reset/host reset to 5sec.
>   Currently wait time is set to 10sec.
>   (In many cases, abort task command fails for command timeout and it needs
>   bus reset or host reset operation)
> 
> Each timeout values come from:
>   timeout(10sec)+Abort/Bus reset(5sec+)+alt retry timeout(10sec) < 30sec
> 
> This is one idea for quick response on device/path error.
> If you have any comments or idea for this improvements, please let me know.

This isn't the right thing to do.  These timeouts control transport
recovery; if it's safe to lower them in the fastfail case, then it would
also be safe to lower them in the general case.

The correct thing for what you want to do would be to return the command
with a transient transport error (which we don't actually have yet)
*before* beginning transport recovery.  This is not going to be easy
because we need to return a command we're also going to do error
recovery on (so it can't be freed as normal).  I'd suggest the best way
to do this would be to refcount the commands.

James



