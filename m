From: Clem Pryke <pryke@focus.uchicago.edu>
Subject: filesystem corruption with md raid6
Date: Thu, 26 Apr 2007 13:27:33 -0500
Message-ID: <200704261827.l3QIRX0T023077@focus.uchicago.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from focus.uchicago.edu ([128.135.70.184]:40447 "EHLO
	focus.uchicago.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031447AbXDZSuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 14:50:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: pryke@focus.uchicago.edu

I have a system with 12 SATA disks attached via SAS. When copying into the 
array during re-sync I get filesystem errors and corruption for raid6 but not 
for raid5. This problem is repeatable. I actually have 2 separate 12 disk 
arrays and get the same behavior on both.

Does this sound familiar to anyone?

Here's a little more detail:

- 8 core AMD64 system running RHEL4U4 kernel 2.6.9-42.0.3.ELsmp
- 12 Seagate ST3750640NS disks via LSI SAS1068 card and mptsas driver provided 
with kernel. Disk chassis is Promise VTrak J300s
- build raid5/6 arrays using mdadm in the normal way
- build filesystem using e2fs in the normal way
- mount the array
- fail out and re-add a disk using "mdadm -f/-r/-a /dev/sdd1"
- while re-sync in progress start an rsync to copy large amount of data into 
the array

For raid 5 array while rsync is running re-sync slows down enormously (as 
shown in /proc/mdstat), then speeds up again once rsync complete and all is 
good. Unmounting the array and running e2fsck shows no errors.

For raid 6 re-sync slows down once rsync starts, but then after a few minutes 
I see the errors below and rsync stops. In this case unmounting and running 
e2fsck shows loads of errors.

Apr 26 11:30:50 spt kernel: attempt to access beyond end of device
Apr 26 11:30:50 spt kernel: md0: rw=1, want=14801215240, limit=14651489280
Apr 26 11:30:50 spt kernel: Aborting journal on device md0.
Apr 26 11:30:50 spt kernel: ext3_abort called.
Apr 26 11:30:50 spt kernel: EXT3-fs error (device md0): ext3_journal_start_sb: 
Detected aborted journal
Apr 26 11:30:50 spt kernel: Remounting filesystem read-only
Apr 26 11:30:50 spt kernel: EXT3-fs error (device md0) in start_transaction: 
Journal has aborted

-- 
**********************************************************************
Clem Pryke - Assistant Professor - Astronomy and Astrophysics
University of Chicago,
Room 120, LASR, 933 East 56th Street, Chicago, Illinois 60637, USA
Tel: 773 702-7853  Fax: 773 702-6645  email: pryke@focus.uchicago.edu
**********************************************************************


