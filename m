From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 11:54:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC509A1.10503@pobox.com>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:61129 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264461AbTEPPlt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 11:41:49 -0400
In-Reply-To: <20030516060324.GT812@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, May 15 2003, Jeff Garzik wrote:
> 
>>In terms of a userspace interface for my ata-over-scsi gadget, I would
>>prefer to use /dev/sg instead of inventing a totally new interface.
>>That, in turn, implies a need for a "do ata taskfile" scsi command,
>>which is sorta like ATAPI in reverse:  we are wrapping a raw ata
>>taskfile inside a scsi cdb.
>>
>>My question is, does an existing standard or spec exist for such an idea?
>>
>>If not, I'll just roll my own.
> 
> 
> For ATAPI/SCSI like stuff, you have SG_IO. No need to invent yet another
> submission interface for that. For ata, you have HDIO_DRIVE_TASKFILE
> which is getting to be sane on the kernel side after Bart cleaned it up.


While technically what you say is correct, I think you're missing what 
I'm aiming for.

Think about it this way:  The SCSI layer provides two or three ways to 
send a SCSI command to a target.  The driver I'm working on presents all 
devices as SCSI, be they ATA or ATAPI.  And underneath the "scsi 
presentation layer", you have ATA[PI] taskfiles as the lower layer.

Userspace has easy and obvious access to the presentation layer.
But how does one directly access the lower layer?

If you like HDIO_DRIVE_TASKFILE, then my preference would be to support 
that ioctl for sending lower layer commands directly to the device, for 
both ATA and ATAPI.  But I don't like HDIO_DRIVE_TASKFILE in this case 
:) and here's why:

ioctl(2) interface itself is very poor and slow compared to 
SCSI-generic's mmap(2) interface.  Also, if you go back to last year 
when Linus was describing his ideal drive command submission interface, 
it purposefully avoided ioctl(2) in favor of a read(2)/write(2) 
interface -- which can be easily extended in one's mind to mmap(2).

So, the goal is to allow efficient userspace access to the taskfile 
submission/response mechanism in my driver, regardless of whether the 
attached device is ATA or ATAPI.  The solution that requires the least 
amount of code, both in the kernel and in userspace, is having a "do 
ata" scsi command.  Because send-scsi-command mechanisms are already 
plentiful in the kernel and userspace, because some of those mechanisms 
are faster than ioctl(2), and because that's heading towards the "Linus 
ideal."

I did consider hdio_drive_taskfile, but that's more code for less 
flexibility, as I see it.  In my case specifically, send-scsi-command is 
essentially talking directly to the low-level driver's standard code path...

The only downside (AFAICS) is that I need to add maybe 50-100 lines of 
code to hdparm.  But I think that's a small price to pay if the keeps 
the driver much more simple.

	Jeff



