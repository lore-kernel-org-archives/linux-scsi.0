From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH/RFC] Allowing REQ_FAILFAST to be set from SG_IO
Date: Wed, 10 May 2006 13:42:49 -0400
Message-ID: <44622619.4020805@torque.net>
References: <4461EFD0.50902@suse.de>  <446217D5.3020606@torque.net> <1147279812.3671.8.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39099 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932229AbWEJRnH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 13:43:07 -0400
In-Reply-To: <1147279812.3671.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2006-05-10 at 12:41 -0400, Douglas Gilbert wrote:
> 
>>Looks good. There is no proposed change to sg.c .
>>Could SG_FLAG_FAILFAST be made to work via sg device
>>nodes?
> 
> 
> Rather than having to maintain two separate paths for SG_IO and hence
> keep running into this issue, what will it take for sg to use the block
> scsi_ioctl.c?

Methinks a large amount of code and a lot of testing.
Hannes is proposing a new SG_FLAG value that would
only be active in the block layer SG_IO. The existing
SG_FLAG values are only implemented by the sg driver.
Around that level in the sg driver, the command
injection and response processing are asynchronous
and that can be exposed to the sg user. The block
SG_IO is synchronous with no easy way to break
it down to its component parts.

On further thought if anything in the scsi midlayer
(or the block layer) is slowing down an error report
getting back to a sg user then that is most likely a
bug. The sg driver sends commands with retries set to
zero. Also settings in the read/write error recovery
mode page can effect how long a disk (or cd/drive)
spends trying to recovery from errors (and
SG_FLAG_FASTFAIL has no effect at the device (lu)
end).

Doug Gilbert

