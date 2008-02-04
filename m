From: Jeff Garzik <jeff@garzik.org>
Subject: Re: dmesg spam
Date: Mon, 04 Feb 2008 15:14:20 -0500
Message-ID: <47A7721C.5020505@garzik.org>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>	<200802041524.55700.bzolnier@gmail.com> <20080204120548.79f3fe57.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52976 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbYBDUOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2008 15:14:24 -0500
In-Reply-To: <20080204120548.79f3fe57.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Andrew Morton wrote:
> On Mon, 4 Feb 2008 15:24:55 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
>> On Sunday 03 February 2008, Andrew Morton wrote:
>>> With latest -mm, running fc8 I am getting this in the logs,
>>                            ^^^
>> => SCSI/libata
>>
>> cc:ing Jeff
>>
>>> once per second.
>>>
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
>>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> 
> Well..  it's coming out of the kernel.  Presumably it's that cdrom polling
> thing in KDE.  James recently made changes to sr_ioctl.c but I've been
> buried in more terminal regressions than this one.

I don't see this in upstream...  can you isolate it to a particular git 
tree?

Clearly userland is initiating a once-per-second poll.  That is quite 
normal for 99% of CDROMs, which do not support async notification.

But also clearly that message is printk'd way too much in your case.

	Jeff




