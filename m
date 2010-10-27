From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Subject: Re: MD RAID1 deadlock on failed disk
Date: Wed, 27 Oct 2010 10:44:02 GMT
Message-ID: <0AFEJ5E11@briare1.fullpliant.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from briare1.fullpliant.org ([78.227.24.35]:34339 "HELO
	briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752651Ab0J0Jio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 05:38:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>

Hi,

The configuration is:
Perc H200 controller configured with no RAID (mpt2sas driver),
2 SATA disks (sda and sdb),
Linux MD Sofware RAID1 (md0),
stock Linux 2.6.35.7 kernel.

I hotunplug the second (sdb) disk, and the result is:
. as expected, I can read sda device,
. as expected, any read to sdb device fails,
. unexpectedly, any read to md0 never returns.

No oops or thing like that in the kernel log.
I did not try the same with other kernel releases.

2.6.32.24 kernel worked fine.

Neil Brown asked for /proc/sysrq-trigger ouput,
and concluded that the problem is related to 'fw_event0'.
See his answer bellow.

Regards,
Hubert Tonneau


Neil Brown wrote:
>
> The fw_event0 process is interesting.
> It seems to be hung trying to 'sync' the drive that has just been pulled.
> If that is somehow causing some IO request from the md/raid1 to be delayed
> then that would certainly hang the array.
> 
> There is a section in the middle of the trace which is missing - presumably
> the sysrq-trigger output overflowed a buffer - that isn't uncommon.
> 
> So I cannot see all the timing clearly.
> How long after pulling the drive was this trace taken?
> 
> I suspect that you need to post this to linux-scsi@vger.kernel.org
> and ask about that fw_event0 thread - whether that should happen, whether it
> has been fixed, and whether it could delay pending IO requests.
> 
> NeilBrown

