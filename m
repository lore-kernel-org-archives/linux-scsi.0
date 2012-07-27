From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v4 0/7] ZPODD patches
Date: Fri, 27 Jul 2012 17:00:43 +0800
Message-ID: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Sergei Shtylyov <sshtylyov@mvista.com>, Oliver Neukum <oneukum@suse.de>
Cc: Jeff Wu <jeff.wu@amd.com>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

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
  scsi: sr: check support for device busy class events
  scsi: pm: add interface to autosuspend scsi device
  scsi: sr: support zero power ODD(ZPODD)
  scsi: sr: block events when runtime suspended
  scsi: pm: use runtime resume callback if available
  scsi: sr: balance sr disk events block depth
  block: genhd: add an interface to set disk's poll interval

 block/genhd.c              |  25 +++++--
 drivers/ata/libata-acpi.c  |   4 +-
 drivers/scsi/scsi_pm.c     |  22 ++++--
 drivers/scsi/sr.c          | 179 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sr.h          |   3 +
 include/linux/cdrom.h      |  43 +++++++++++
 include/linux/genhd.h      |   1 +
 include/scsi/scsi_device.h |   3 +
 8 files changed, 267 insertions(+), 13 deletions(-)

-- 
1.7.11.3
