From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 19:16:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098469018.19463.26.camel@localhost.localdomain>
References: <4178244E.1060906@rtr.ca> <20041022040423.GA28782@havoc.gtf.org>
	 <41791728.7060106@rtr.ca>  <41793E68.6010000@pobox.com>
	 <1098461668.19463.22.camel@localhost.localdomain>
	 <41794158.9010308@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:21474 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S266366AbUJVTUJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 15:20:09 -0400
In-Reply-To: <41794158.9010308@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Gwe, 2004-10-22 at 18:20, Jeff Garzik wrote:
> > -EOPNOTSUPP is saying "I do know what is going on but its broken so
> > fail it totally".
> 
> Are you describing behavior mandated in some standard?

Yes. ENOTTY means "the ioctl you threw at me isn't one I understand",
always has been in Unix proper.

-EINVAL: "I recognize this ioctl but the arguments are bogus"
-ENOTTY: "I don't recognize this ioctl at all"
-ENOIOCTLCMD: Internal (never user visible) used by some driver layers 
to pass down "please do the defaults". This one might be a sane addition
to the block layer list.

> Because that differs with _tons_ of existing ioctl code, whose default 
> return code is EOPNOTSUPP when no known operation is found in a C 
> "switch(cmd)" statement.
> 
> grep for it...

We are slowly fixing the abusers of -EINVAL/-EOPNOTSUPP. Note btw that
networking stuff is in many places a little different in its returns.

Alan

