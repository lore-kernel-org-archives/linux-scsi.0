From: Luben Tuikov <tluben@rogers.com>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 14:50:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC53307.5070908@rogers.com>
References: <20030515230223.GA516@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-mail.bloor.is.net.cable.rogers.com ([66.185.86.72]:8049
	"EHLO fep02-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S264547AbTEPSiG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2003 14:38:06 -0400
In-Reply-To: <20030515230223.GA516@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> In terms of a userspace interface for my ata-over-scsi gadget, I would
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The main point.

> prefer to use /dev/sg instead of inventing a totally new interface.
> That, in turn, implies a need for a "do ata taskfile" scsi command,
> which is sorta like ATAPI in reverse:  we are wrapping a raw ata
> taskfile inside a scsi cdb.
> 
> My question is, does an existing standard or spec exist for such an idea?
> 
> If not, I'll just roll my own.

I read the whole thread.

It seems like you want what the 3ware LLDD is doing.  The format
and specs are closed, but the implementation is open: ioctl
and a char device ioctl.

What you lose is the block/scsi synchronizaion, but if you want
to support _closed_ vendor extensions, that's what you get.

Unless what you want to support has a command mapping already
in SCSI?  Did you check SBC-2, SMC-2, SCC-2, SES-2?  Wouldn't
you find any CDB's there which would fit in?  My guess is not.

Did you also check the mode pages, etc?

-- 
Luben




