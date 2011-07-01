From: Andi Kleen <andi@firstfloor.org>
Subject: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 1 Jul 2011 10:05:31 -0700
Message-ID: <20110701170531.GA3693@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29879 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1GARGy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2011 13:06:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rjw@sisk.pl

Hi,

I found I can reliably crash a 3.0 system by pulling the
USB cable of a mounted USB cdrom (or rather a USB device which
has a builtin fake CD-ROM) 

I suspect it's a regression too.

It ends with a NULL pointer reference on a NULL sdev in 
scsi_prep_state_check. 

Here's a somewhat incomplete backtrace (written down by hand)

scsi_prep_state_check
scsi_setup_blk_pc_cmnd
blk_peek_request
...
scsi_request_fn
...
ioctl_internal_command
...
scsi_set_medium_removal
sr_lock_door
cdrom_release
...
umount

I tried adding a 

	if (!sdev) 
		return BLKPREP_KILL;

to scsi_prep_state_check, but that caused a RCU CPU stall 
and a generally unhappy system instead.

The sdev must be still there in scsi_set_medium_removal because it's 
referenced, so it must get lost somewhere in SCSI or in the block layer.

Any ideas how to fix this?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
