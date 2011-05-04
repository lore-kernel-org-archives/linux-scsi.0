From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: 2.6.39-rc6: cdrecord oops
Date: Wed, 4 May 2011 22:07:07 +0300
Message-ID: <20110504190707.GA4521@p183>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45906 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1EDTJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 15:09:07 -0400
Received: by fxm17 with SMTP id 17so1052606fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2011 12:09:06 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk

Got one at the very end of burning session (haven't tried to reproduce yet).
Apparently happened when cdrecord tried to open the door.

	__lock_acquire
	lock_acquire
	_raw_spin_lock_irq
	blk_get_request
	scsi_execute
	scsi_set_medium_removal
	sr_lock_door
	cdrom_release
	sr_block_release
	__blk_dev_put
	blkdev_put
	blkdev_close
	fput
	filp_close
	sys_close

comm: cdrecord
RAX was small number like 0x46(?)
RBX 6b6b6b6b6b6b6b83
RDI 6b6b6b6b6b6b6b83

	scsi 8:0:0:0: CD-ROM            Optiarc  DVD RW AD-7700S 1.03 PQ: 0 ANSI: 0
	sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray

This model is USB device.
