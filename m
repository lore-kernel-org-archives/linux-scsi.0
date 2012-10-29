From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 00/11] ZPODD Patches
Date: Mon, 29 Oct 2012 17:01:27 +0800
Message-ID: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

v8:
This version is a redesign, it doesn't have much to do with previous
versions. The ZPODD implementation is done almost entirely in ATA layer
now, except 2 helper functions from SCSI sr driver to block disk events.

The basic idea is that, when ata port is runtime suspended, it will
check if the ODD is ready to be powered off. And if yes, events is
blocked and power omitted; if not, ODD's power supply remains unchanged
by keeping ACPI state at D0.

Some background knowledge about ZPODD is added below v1 history log.

v7:
Re work of runtime pm of sr driver, based on ideas of Alan Stern and
Oliver Neukum.

Jeff, due to the ready_to_power_off flag added, there is a small
change in [PATCH v7 6/6] libata: acpi: respect may_power_off flag,
please check if I can still get your ack, thanks.

v6:
When user changes may_power_off flag through sysfs entry and if device
is already runtime suspended, resume resume it so that it can respect
this flag next time it is runtime suspended as suggested by Alan Stern.
Call scsi_autopm_get/put_device once in sr_check_events as suggested by
Alan Stern.

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

Some background knowledge about ZPODD:
ODD means Optical Disc Drive.
ZPODD means Zero Power ODD, it is a mechanism to place the ODD into
zero power state when the system is running at S0 system state without
user's awareness.
It achieved this by ACPI and SATA device attention pin. For power off,
normal ACPI control method is used to place the device into D3 cold
ACPI device state, aka. device power supply omitted. For power on, when
user press the eject button of a drawer type ODD or when user inserts
an ODD into a slot type ODD, the device attention pin will trigger. In
the current x86 implementation, this pin will connect to a GPE, and the
GPE will trigger an ACPI interrupt. With our pre-registered ACPI
notification code, the device can be runtime resumed, and we place the
device back to full power state by setting its ACPI state to D0. The
whole process is transparent to the end user.

Aaron Lu (11):
  scsi: sr: support runtime pm
  ata: zpodd: Add CONFIG_SATA_ZPODD
  ata: zpodd: identify and init ZPODD devices
  libata: acpi: move acpi notification code to sata_zpodd
  libata-eh: allow defer in ata_exec_internal
  ata: zpodd: check loading mechanism for ODD
  libata: separate ATAPI code
  ata: zpodd: check zero power ready status
  block: add a new interface to block events
  scsi: sr: support (un)block events
  ata: zpodd: handle power transition of ODD

 block/genhd.c              |  26 ++++
 drivers/ata/Kconfig        |  12 ++
 drivers/ata/Makefile       |   3 +-
 drivers/ata/libata-acpi.c  | 143 +++++++++-----------
 drivers/ata/libata-atapi.c |  88 +++++++++++++
 drivers/ata/libata-atapi.h |   7 +
 drivers/ata/libata-core.c  |  54 ++++++--
 drivers/ata/libata-eh.c    |  86 +-----------
 drivers/ata/libata-scsi.c  |   5 +
 drivers/ata/sata_zpodd.c   | 321 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_zpodd.h   |  37 ++++++
 drivers/scsi/Makefile      |   1 +
 drivers/scsi/sr.c          |  30 ++++-
 drivers/scsi/sr_zpodd.c    |  21 +++
 drivers/scsi/sr_zpodd.h    |   9 ++
 include/linux/cdrom.h      |  35 +++++
 include/linux/genhd.h      |   1 +
 17 files changed, 695 insertions(+), 184 deletions(-)
 create mode 100644 drivers/ata/libata-atapi.c
 create mode 100644 drivers/ata/libata-atapi.h
 create mode 100644 drivers/ata/sata_zpodd.c
 create mode 100644 drivers/ata/sata_zpodd.h
 create mode 100644 drivers/scsi/sr_zpodd.c
 create mode 100644 drivers/scsi/sr_zpodd.h

-- 
1.7.12.4

