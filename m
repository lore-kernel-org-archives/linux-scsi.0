From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Sun, 29 Aug 2004 10:36:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413124F3.6090505@torque.net>
References: <412EF74A.1070106@torque.net> <4130129F.40503@torque.net> <20040828202335.GA18962@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:44737 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267457AbUH2Agr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 20:36:47 -0400
In-Reply-To: <20040828202335.GA18962@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Christoph Hellwig wrote:
> On Sat, Aug 28, 2004 at 03:05:35PM +1000, Douglas Gilbert wrote:
> 
>>Here is a second cut of the patch.
>>
>>If James accepts it naturally he is free to enforce the
>>appropriate coding style.
>>
>>I believe that cleaning up scsi error processing is going
>>to be a "work in progress" for a while.
> 
> 
> Here's a version with a few small adjustments:
> 
>  - moved the code to the scsi_error.c/scsi_eh.c
>  - small style cleanups
>  - added the two helpers I suggested
>  - don't do the memset if we return failure, callers shouldn't look at
>    it then
> 
> --- linux-2.6.9-rc1-mm1/drivers/scsi/scsi_error.c	2004-08-28 12:17:33.000000000 +0200
> +++ linux-2.6.9-rc1-mm1-hch/drivers/scsi/scsi_error.c	2004-08-28 13:20:30.000000000 +0200
> @@ -1850,3 +1850,79 @@
>  	scsi_next_command(scmd);
>  	return rtn;
>  }
> +
> +/**
> + * scsi_normalize_sense - normalize main elements from either fixed or
> + *			descriptor sense data format into a common format.
> + *
> + * @sense_buffer:	byte array containing sense data returned by device
> + * @sb_len:		number of valid bytes in sense_buffer
> + * @sshdr:		pointer to instance of structure that common
> + *			elements are written to. Ignored if NULL.

Christoph,
I'm happy with this patch. Now it's my turn to be a reviewer ...
The "Ignored if NULL." sentence above is no longer correct and
should be removed. Actually it's my oversight.


So if this could be applied we could refine an error reporting
policy after the comments from Kai. Obviously if the midlevel
issues the command then it should handle all of the errors/alerts
(e.g. midlevel device discovery). At the other extreme are
pass through interfaces which want no retries and all errors
and alerts "returned to sender". Then there are the cases in
between.

Doug Gilbert
