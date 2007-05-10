From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: HDIO_DRIVE_CMD and hdparm
Date: Thu, 10 May 2007 14:12:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36159 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759194AbXEJMNB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2007 08:13:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

	Hi,

`hdparm -t' uses HDIO_DRIVE_CMD(null) to flush the disk's buffer.
When using it on my own block device (the new PS3 disk storage driver), hdparm
gives the following error message:

| HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Inappropriate ioctl for device

When using it on an ATA or SCSI device, no such error message is printed.

According to the hdparm sources, hdparm expects the HDIO_DRIVE_CMD(null) ioctl
to either succeed, or to fail with errno EINVAL.

Apparently handling of ioctls is different for the different device types:
  - ATA/SATA handle HDIO_DRIVE_CMD(null) (and a few other variants)
    => fine for hdparm
  - SCSI doesn't handle HDIO_DRIVE_CMD(null), and returns EINVAL
    => fine for hdparm
  - If a block device doesn't support the ioctl, blkdev_driver_ioctl() returns
    ENOTTY
    => hdparm error message

Which one is correct?
  - blkdev_ioctl()/blkdev_driver_ioctl() return -ENOTTY
  - scsi_cmd_ioctl() returns -ENOTTY
  - scsi_ioctl() returns -EINVAL
  - cdrom_ioctl() returns -ENOSYS to mean not handled, continue
  - some block layer routines return -ENOIOCTLCMD to mean not handled, continue

This causes constructs with different tests like e.g.:

	sr_block_ioctl()
	{
		...
		ret = cdrom_ioctl(...);
		if (ret != -ENOSYS)
			return ret;
		...
		return scsi_ioctl(...);
	}

	cdrom_ioctl()
	{
		...
		ret = scsi_cmd_ioctl(...);
		if (ret != -ENOTTY)
			return ret;
		...
		return -ENOSYS;
	}

	blkdev_ioctl()
	{
		...
		ret = blkdev_locked_ioctl(...);
		...
		if (ret != -ENOIOCTLCMD)
			return ret;

		return blkdev_driver_ioctl(...);
	}

My questions:
  1. Does any of these have to be fixed?
  2. Shall I add a dummy HDIO_DRIVE_CMD(null) handler to my block device to
     return -EINVAL?
  3. Shall I just ignore the hdparm error message?

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
