From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [PATCH] Re: libata: BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 14:42:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410221942.i9MJguMR017671@falcon30.maxeymade.com>
References: <1098469018.19463.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:37868 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S267251AbUJVTnK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 15:43:10 -0400
In-reply-to: <1098469018.19463.26.camel@localhost.localdomain> 
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>


On Fri, 22 Oct 2004 19:16:59 BST, Alan Cox wrote:
>On Gwe, 2004-10-22 at 18:20, Jeff Garzik wrote:
>> > -EOPNOTSUPP is saying "I do know what is going on but its broken so
>> > fail it totally".
>> 
>> Are you describing behavior mandated in some standard?
>
>Yes. ENOTTY means "the ioctl you threw at me isn't one I understand",
>always has been in Unix proper.
>
>-EINVAL: "I recognize this ioctl but the arguments are bogus"
>-ENOTTY: "I don't recognize this ioctl at all"
>-ENOIOCTLCMD: Internal (never user visible) used by some driver layers 
>to pass down "please do the defaults". This one might be a sane addition
>to the block layer list.
>
>> Because that differs with _tons_ of existing ioctl code, whose default 
>> return code is EOPNOTSUPP when no known operation is found in a C 
>> "switch(cmd)" statement.
>> 
>> grep for it...
>
>We are slowly fixing the abusers of -EINVAL/-EOPNOTSUPP. Note btw that
>networking stuff is in many places a little different in its returns.

What about the case of "This is normally a valid command, but this
particulat device is incapable of this particular subcommand"?

Hypothetical instance: a disk drive that indicates it is not capable of 
changing it's write cache setting?


>
>Alan
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


