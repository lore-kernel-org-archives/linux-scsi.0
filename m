From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 13:13:56 -0600
Message-ID: <1165432436.2810.66.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612061354150.3298-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36621 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937381AbWLFTUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 14:20:21 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612061354150.3298-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 2006-12-06 at 13:58 -0500, Alan Stern wrote:
> I'd love to do that -- but blkdev_ioctl() wants inode->i_bdev to be set, 
> and blkdev_locked_ioctl() uses it as the argument to bdev_get_queue().  So 
> it won't work with sg, which uses character device nodes.

Well, even sg has the queue ... and what we're looking for are the queue
parameters.  In block/ioctl.c the bdev is just used for getting the
queue parameters (mainly via bdev->bd_disk->queue), so I could see if
Jens might be amenable to refactoring the queue ioctls so we can get at
them simply with a struct request_queue parameter.

> How about adding BLKSECTGET to the list of commands accepted by 
> sg_ioctl()?

That's certainly a possible hack ... although I'd prefer to see the full
queue ioctls exposed.

James


