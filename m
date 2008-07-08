From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_GET_VERSION_NUM and SG_IO issue
Date: Tue, 08 Jul 2008 11:38:34 -0400
Message-ID: <487389FA.9000006@torque.net>
References: <670709.40869.qm@web35402.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:58402 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYGHPip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 11:38:45 -0400
In-Reply-To: <670709.40869.qm@web35402.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kantorzsolt@yahoo.com
Cc: linux-scsi@vger.kernel.org

Kantor Zsolt wrote:
> Hi, I have a strange problem with the SG_GET_VERSION_NUM, and the SG_IO ioctl
> I have blacklisted and renamed all my SCSI subsystem drivers, so the kernel can't load them. I have checked with lsmod, and yes the drivers are not loaded. All my SCSI subsystem is compiled as modules for my running kernel (CONFIG_SCSI=m, CONFIG_CHR_DEV_SG=m, CONFIG_BLK_DEV_SD=m . . .), I checked that in the running kernel config file in the /boot directory.
> In my initrd image the SCSI drivers are not present either.    
> Even so, if the SCSI susbsystem is not loaded at all I can execute successfully the SG_GET_VERSION_NUM ioctl and I can even send commands via the SG_IO ioctl. How is that possible if there are no SCSI drivers loaded ??
> My kernel version is 2.6.18-6-k7 and I'm using Debian etch, if this information is helpful 

That is because the SG_IO ioctl is implemented in the block
layer in block/scsi_ioctl.c (and earlier in
drivers/block/scsi_ioctl.c) which is outside the SCSI subsystem.
That code also "fakes" some of the sg driver's other ioctls such
as SG_GET_VERSION_NUM . [It only fakes the ones needed to fool
cdrecord, so try some other sg ioctls ...].

Interesting that there seems to be no way to turn off the SCSI
pass-through (or restrict it to CAP_SYS_RAWIO or root user)
with this design.

Doug Gilbert
