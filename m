From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/41] hpsa January 2014 driver updates
Date: Wed, 15 Jan 2014 16:36:17 -0600
Message-ID: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:60622 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaAOVnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:43:04 -0500
Received: from g5t0007.atlanta.hp.com (g5t0007.atlanta.hp.com [15.192.0.44])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 75E956161C
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2014 21:36:29 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

This series applies to kernel/git/jejb/scsi.git for-next branch

This is a big patch series.  Most of the changes have to do
with enabling alternate command submission paths for certain i/os
to bypass the Smart Array RAID firmware stack and submit i/o's
more directly to physical devices -- solid state disks --
for increased performance.

---

Matt Gates (4):
      hpsa: allow SCSI mid layer to handle unit attention
      hpsa: use extended report luns command for HP SSD SmartPath
      hpsa: mark last scatter gather element as the last
      hpsa: add support for 'fastpath' i/o

Mike MIller (1):
      hpsa: get physical device handles for io accel mode 2 as well as mode 1

Mike Miller (1):
      hpsa: add ioaccel mode 2 structure definitions

Scott Teel (12):
      hpsa: fix task management for mode-1 ioaccell path
      hpsa: add hp_ssd_smart_path_enabled sysfs attribute
      hpsa: complain if physical or logical aborts are not supported
      hpsa: get ioaccel mode 2 i/o working
      hpsa: teach hpsa_device_reset to do either target or lun reset
      hpsa: add task management for ioaccel mode 2
      hpsa: complete the ioaccel raidmap code
      hpsa: allow user to disable accelerated i/o path
      hpsa: rescan devices on ioaccel2 error
      hpsa: retry certain ioaccel error cases on the RAID path
      hpsa: update source file copyrights
      hpsa: add controller base data-at-rest encryption compatibility ioaccel2

Stephen M. Cameron (23):
      hpsa: revert bring logical drives online when format completes
      hpsa: revert hide logical drives with format in progress from linux
      hpsa: use workqueue instead of kernel thread for lockup detection
      hpsa: rename scsi prefetch field
      hpsa: enable unit attention reporting
      hpsa: do not require board "not ready" status after hard reset
      hpsa: only allow REQ_TYPE_FS to use fast path
      hpsa: add ioaccell mode 1 RAID offload support.
      hpsa: update raid offload status on device rescan
      hpsa: poll controller to detect device change event
      hpsa: do not rescan controllers known to be locked up
      hpsa: Acknowledge controller events in ioaccell mode 2 as well as mode 1
      hpsa: do ioaccel mode 2 resource allocations
      hpsa: initialize controller to perform io accelerator mode 2
      hpsa: make device update copy the raid map also
      hpsa: allow VPD page zero to be queried
      hpsa: do not inquire for unsupported ioaccel status vpd page
      hpsa: when switching out of accel mode await only accel command completions
      hpsa: only do device rescan for certain events
      hpsa: improve error messages for driver initiated commands
      hpsa add sysfs debug switch for raid map debugging messages
      pci: add HP/3PAR vendor id to pci_ids.h
      hpsa: Add support for a few HP Storage controllers


 Documentation/ABI/testing/sysfs-class-scsi_host |   16 
 drivers/scsi/hpsa.c                             | 2584 ++++++++++++++++++++---
 drivers/scsi/hpsa.h                             |  138 +
 drivers/scsi/hpsa_cmd.h                         |  255 ++
 include/linux/pci_ids.h                         |    1 
 5 files changed, 2591 insertions(+), 403 deletions(-)

-- 
-- steve

