From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v5 0/7] ZPODD patches
Date: Fri, 31 Aug 2012 17:42:28 +0800
Message-ID: <1346406155-4768-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab2HaJnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2012 05:43:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

v5:
Add may_power_off flag to scsi device.
Alan Stern suggested that I should not mess runtime suspend with
runtime power off, but the current zpodd implementation made it not
easy to seperate. So I re-wrote the zpodd implementation, the end
result is, normal ODD can also enter runtime suspended state, but
their power won't be removed.

v4:
Rebase on top of Linus' tree, due to this, the problem of a missing
flag in v3 is gone;
Add a new function scsi_autopm_put_device_autosuspend to first mark
last busy for the device and then put autosuspend it as suggested by
Oliver Neukum.
Typo fix as pointed by Sergei Shtylyov.
Check can_power_off flag before any runtime pm operations in sr.

v3:
Rebase on top of scsi-misc tree;
Add the sr related patches previously in Jeff's libata tree;
Re-organize the sr patches.
A problem for now: for patch
scsi: sr: support zero power ODD(ZPODD)
I can't set a flag in libata-acpi.c since a related function is
missing in scsi-misc tree. Will fix this when 3.6-rc1 released.

v2:
Bug fix for v1;
Use scsi_autopm_* in sr driver instead of pm_runtime_*;

v1:
Here are some patches to make ZPODD easier to use for end users and
a fix for using ZPODD with system suspend.


Aaron Lu (7):
  scsi: sr: support runtime pm for ODD
  block: genhd: export disk_(un)block_events
  scsi: sr: block events checking when suspended for zpodd
  libata: acpi: set can_power_off for both ODD and HD
  scsi: pm: add may_power_off flag
  scsi: sr: use may_power_off
  libata: acpi: respect may_power_off flag

 block/genhd.c              |  2 ++
 drivers/ata/libata-acpi.c  | 35 +++++++++++++------
 drivers/scsi/scsi_sysfs.c  | 10 +++---
 drivers/scsi/sr.c          | 85 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sr.h          |  1 +
 include/scsi/scsi_device.h |  2 ++
 6 files changed, 120 insertions(+), 15 deletions(-)

-- 
1.7.11.5

