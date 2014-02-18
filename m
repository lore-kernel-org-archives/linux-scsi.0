From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/35] hpsa February 2014 driver updates
Date: Tue, 18 Feb 2014 13:55:01 -0600
Message-ID: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43488 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaBRT4o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:56:44 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id CFCC8615F6
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:56:43 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

This is a big patch series.  Most of the changes have to do
with enabling alternate command submission paths for certain i/os
to bypass the Smart Array RAID firmware stack and submit i/o's
more directly to physical devices -- solid state disks --
for increased performance.

---

Hannes Reinecke (1):
      hpsa: fixup MSI-X registration

Matt Gates (3):
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

Stephen M. Cameron (17):
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
 drivers/scsi/hpsa.c                             | 2292 ++++++++++++++++++++++-
 drivers/scsi/hpsa.h                             |  121 +
 drivers/scsi/hpsa_cmd.h                         |  251 ++-
 include/linux/pci_ids.h                         |    1 
 5 files changed, 2557 insertions(+), 124 deletions(-)

-- 
-- steve

