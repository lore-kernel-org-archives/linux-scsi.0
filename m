From: Otto Meta <otto.kernel.02e4af24@sister-shadow.de>
Subject: Re: [PATCH] [SCSI] sr: Fix multi-drive performance by using per-device
 mutexes
Date: Fri, 04 Jan 2013 00:11:29 +0100
Message-ID: <50E61021.20709@sister-shadow.de>
References: <50E2F09A.6030606@sister-shadow.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.planet-school.de ([194.116.187.5]:40248 "EHLO
	turboconrad.planet-school.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390Ab3ACXLe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 18:11:34 -0500
Received: from turboconrad.planet-school.de (srv004.service.ps-server.net [194.116.186.79])
	by turboconrad.planet-school.de (Postfix) with ESMTP id 0D6C2B6A013
	for <linux-scsi@vger.kernel.org>; Fri,  4 Jan 2013 00:11:31 +0100 (CET)
Received: from [192.168.0.9] (i59F54D5C.versanet.de [89.245.77.92])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: thisaccountwillneverbechecked@sister-shadow.de)
	by turboconrad.planet-school.de (Postfix) with ESMTPSA id DBD0BB6A010
	for <linux-scsi@vger.kernel.org>; Fri,  4 Jan 2013 00:11:30 +0100 (CET)
In-Reply-To: <50E2F09A.6030606@sister-shadow.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Otto Meta wrote:
> The single mutex for the sr module, introduced as a BKL replacement,
> globally serialises all sr ioctls, which hurts multi-drive performance.
> 
> This patch replaces sr_mutex with per-device mutexes in struct scsi_cd,
> allowing concurrent ioctls on different sr devices.

Unfortunately it wasn't as easy as that. The patch seems to introduce
a race condition that corrupts a drive's state under certain circumstances.

When two drives (e.g. sr0 and sr1) are attached to the same IDE cable, one
drive has its door locked, which will usually be the case after any operation
on the drive with inserted media (and whenever it feels like it, even with
dev.cdrom.lock=0), and the other drive is unlocked, then executing

  $ eject sr0 & eject sr1

will eject the unlocked drive and the locked drive will return

  eject: unable to eject, last error: Inappropriate ioctl for device


Other drivers down the road probably don't expect concurrent ioctls, so this
patch cannot be applied safely at this time. Sorry about the noise.

For the record: Tested with kernels 3.2.35 and 3.8.0-rc1, using IDE CD/DVD
drives connected via the drivers ata_piix and pata_pdc202xx_old.
