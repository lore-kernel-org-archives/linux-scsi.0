From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 0/3] possible privilege escalation via SG_IO ioctl
 (CVE-2011-4127)
Date: Sun, 15 Jan 2012 20:04:30 -0500
Message-ID: <4F13779E.1070807@interlog.com>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52952 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab2APBEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2012 20:04:41 -0500
In-Reply-To: <1326380489-9044-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>

On 12-01-12 10:01 AM, Paolo Bonzini wrote:
> Partition block devices or LVM volumes can be sent SCSI commands via
> SG_IO, which are then passed down to the underlying device; it's
> been this way forever, it was mentioned in 2004 in LKML at
> https://lkml.org/lkml/2004/8/12/218 and it is even documented in the
> sg_dd man page:
>
>      blk_sgio=1
>                when set to 0, block devices (e.g. /dev/sda) are treated
>                like normal files (i.e. read(2) and write(2) are used for
>                IO). When set to 1, block devices are assumed to accept the
>                SG_IO ioctl and  SCSI commands are issued for IO. [...]
>                If the input or output device is a block device partition
>                (e.g. /dev/sda3) then setting this option causes the
>                partition information to be ignored (since access is
>                directly to the underlying device).

The ability to use the SG_IO ioctl on a block device was added at
the start of the lk 2.6 series. It should have been restricted to
non-partition block device nodes (e.g. allowed on /dev/sda,
disallowed on /dev/sda3).

The successor to sg_dd is called ddpt which will abort a copy when
the pass-through (requested by "iflag=pt") is used on a partition
node:

# ddpt if=/dev/sda3 iflag=pt bs=512 of=/dev/null count=1
 >> warning: Size of input block device is different from pt size.
 >> Pass-through on block partition can give unexpected offsets.
 >> Abort copy, use iflag=force to override.

ddpt is ported to FreeBSD and Win32. The ability to call a pass-through
on a partition node is a Linux specific problem.

> This is problematic because "safe" SCSI commands, including READ or WRITE,
> can be sent to the disk without any particular capability.  All that is
> required is having a file descriptor for the block device, and permission
> to send a ioctl.  However, when a user lets a program access /dev/sda2,
> it still should not be able to read/write /dev/sda outside the boundaries
> of that partition.
>
> Encryption on the host is a mitigating factor, but it does not provide
> a full solution.  In particular it doesn't protect against DoS (write
> random data), replay attacks (reinstate old ciphertext sectors), or
> writes to unencrypted areas including the MBR, the partition table, or
> /boot.
>
> The patches implement a simple global whitelist for both partitions
> and partial disk mappings.  Patch 1 refactors the code to prepare for
> introduction of the whitelist, while patch 2 actually implements it for
> the SCSI ioctls.  Logical volumes are also affected if they have only one
> target, and this target can pass ioctls to the underlying block device.
> Patch 3 thus adds the whitelist to logical volumes as well.
>
> This should be entirely independent of capabilities.  Continuing the
> previous example, if the same user gives CAP_SYS_RAWIO to the program and
> write access to /dev/sdb, the program should be able to send arbitrary
> SCSI commands to /dev/sdb, but still should not be able to access /dev/sda
> outside the boundaries of /dev/sda2.  However, for now when the program
> has CAP_SYS_RAWIO the ioctls are let through (while still being logged
> to dmesg).
>
> drivers/ide/ has several ioctls that should only be restricted to the full
> block device (for example HDIO_SET_*, HDIO_DRIVE_CMD, HDIO_DRIVE_TASK,
> HDIO_DRIVE_RESET).  However, all of them require either CAP_SYS_ADMIN
> or CAP_SYS_RAWIO, so they do not need any change given the above interim
> measure.
>
> Tested on top of 3.2 + Linus's patch to sanitize ioctl return values.

Is that a fixed version of patch at the end of this post:
     http://marc.info/?l=linux-kernel&m=132578310403616&w=2
The fix being
   s/ENOIOCTLCMD/-ENOIOCTLCMD/
in is_unrecognized_ioctl() ?

If not could you post the patch you are referring to the linux-scsi
list. Also could you post "PATCH v2 3/3 ..." to this list as well so
we have a complete set?

Doug Gilbert



