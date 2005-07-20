From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Kernel 2.4.26 cannot umount CD: device or resource busy (no fuser)
Date: Wed, 20 Jul 2005 14:28:43 +1000
Message-ID: <42DDD2FB.5020306@torque.net>
References: <29450.1121817356@www6.gmx.net> <29775.1121817486@www15.gmx.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:10392 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261586AbVGTE2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2005 00:28:30 -0400
In-Reply-To: <29775.1121817486@www15.gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jim <jim999@gmx.net>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jim wrote:
> Symptom: Cannot umount a CD-Rom in my CD-Roaster/Burner/Toaster whatever
> 
> Reason to write to ide AND Scsi-List: Its an IDE - Drive, but with
> scsi-emulation running. So my 4 questions: WHY is the drive locked? And
> HOW to work arround it other than to reboot the system? Can't a forced    
> umount be implemented for other cases than just for NFS (as manpage 
> sais)? Or is my system just too old and buggy? (because it is, besides from
> updates)
> 
> And yes: It's more than once this happened:
> 
> # umount /mnt/toaster
> umount: /mnt/toaster: device is busy
> # fuser  -v -m /mnt/toaster/
> # mount | grep toaster
> /dev/scd0 on /mnt/toaster type iso9660 (ro,noexec,...)
> # lsof | grep -e scd0 -e toaster
> # umount /mnt/toaster
> umount: /mnt/toaster: device is busy
> # umount -f /mnt/toaster
> umount2: Device or resource busy
> umount: /dev/scd0: not mounted
> umount: /mnt/toaster: Illegal seek
> # umount /dev/scd0 || umount -f /dev/scd0
> umount: /mnt/toaster: device is busy
> umount2: Device or resource busy
> umount: /dev/scd0: not mounted
> umount: /mnt/toaster: Illegal seek
> # umount -V
> umount: mount-2.10m
> # fuser -V
> fuser from psmisc version 18
> #

Jim,
Linux uses the "prevent allow medium removal" MMC
command to effectively lock the medium (disc) in the
drive while a file system on it is mounted. The eject
linux command tries to unmount any file systems
before unlocking and ejecting the disc. If the unmount
fails (e.g. "Device or resource busy) then it won't
unlock the drive. Perhaps eject has/should_have an
option to bypass the unmount when it fails.

The lsof command may help you find which application
has a file open and therefore inhibiting the unmount.
If that doesn't work then fetch the sg3_utils package
and the sg_prevent utility in there may be of interest.
Assuming your cd/dvd drive is /dev/sg0 then this should
eject your drive in lk 2.4 :
    sg_prevent --prevent=0 /dev/sg0
    sg_start -loej /dev/sg0

In the lk 2.6 series the actual device name could be
used (e.g. /dev/hdd rather than /dev/sg0).

Soon I will release sdparm 0.94 which adds some commands.
The sequence to unlock then eject would be:
    sdparm -C unlock /dev/hdd
    sdparm -C eject /dev/hdd

BTW After the unlock operation is successful the eject
button on the drive should work.

Doug Gilbert




