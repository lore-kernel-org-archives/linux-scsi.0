From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: sending ioctl warnings for a partition
Date: Sun, 05 Feb 2012 00:30:50 +0100
Message-ID: <4F2DBFAA.1040702@redhat.com>
References: <CANDSw5hvEwgCaXsk+OxBQ_xL+WiTLbTrVhB9H_W4NuU86bCNLQ@mail.gmail.com> <4F2D78D5.6050703@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47471 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2BDXay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2012 18:30:54 -0500
Received: by wics10 with SMTP id s10so3420889wic.19
        for <linux-scsi@vger.kernel.org>; Sat, 04 Feb 2012 15:30:53 -0800 (PST)
In-Reply-To: <4F2D78D5.6050703@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, tdovera@gmail.com, zfs-fuse@sehe.nl

On 02/04/2012 07:28 PM, Douglas Gilbert wrote:
>
> If I'm not mistaken, the whole point of a series of patches
> titled: "fail SCSI passthrough ioctls on partition devices"
> was to flag and ultimately break any user space code that
> attempted to use the SG_IO ioctl on a partition block
> device (e.g. send a SCSI INQUIRY via SG_IO to /dev/sda2).
>
> This is for security reasons. So when the kernel enforces
> that, zfs-fuse will break. Please alert the zfs-fuse
> maintainers.

That's correct.  zfs-fuse is trying to send a SYNCHRONIZE CACHE command, 
they should just use BLKFLSBUF (which will also give a warning due to a 
quirk in block/ioctl.c, but it's a false positive and the warning will 
go away soonish).

In principle, SYNCHRONIZE CACHE is "safe" even if sent to a partition 
and doesn't really leak anything, but I'm not sure we want to look into 
the CDB in scsi_ioctl.c.

Paolo
