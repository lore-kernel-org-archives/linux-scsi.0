From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: printk the cdb's that interest me
Date: 24 Sep 2003 09:07:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064416021.28767.10.camel@patehci2>
References: <1064331642.10473.23.camel@patehci2>
	 <20030923095248.A9896@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:41684 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261347AbTIXPGd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 11:06:33 -0400
In-Reply-To: <20030923095248.A9896@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: linux-scsi@vger.kernel.org

> > ... I have no confident idea of what the cdb was, ...
> 
> From: Patrick Mansfield <patmans@us.ibm.com>
> Date:  Tue, 23 Sep 2003 09:52:48 -0700	
>
> It got a DID_NO_CONNECT (host busy 0x01),
> so there should be no sense data. Or do you mean ...

Whoops, bonehead newbie error, sorry, specifically:

!!! I did not know this cdb had not reached the drive. !!!

Yet another reason for me to want a trace of cdb's that do reach the
drive.

Tuesday I launched a separate linux-scsi thread titled "max GiB written
per boot" to log my exploration of why, without actually unplugging my
drive, I reliably end up dying in:
dd: opening `/dev/scd1': No such device or address

> All scsi core cdb's ...
> via the host->queuecommand, ...
> only two callers ... in 2.6 ...
> ...
> [most] sent to the LLDD
> go out via scsi_dispatch_cmd, and
> come back via scsi_softirq...

Great nuggets, thanks.

Tuesday [usb-storage] worked out how to trace all cdb's that pass thru
to usb-storage.ko bInterfaceProtocol = '\x50' = *"Pat".  Here I think I
have enough clues to trace at the Scsi level as well ... and then the
Scsi and Usb traces should agree.

> Ignoring the non-auto sense request and TUR
> in scsi_error.c, ...

I'll go discover what this means, unless someone tells me.

Pat LaVarre



