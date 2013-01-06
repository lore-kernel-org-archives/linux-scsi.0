From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 0/9] ZPODD Patches
Date: Sun,  6 Jan 2013 10:48:20 +0800
Message-ID: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

v11:
Introduce event_driven flag in scsi_device to silence the media event
poll after ODD is powered off;
Removed ata layer PM QOS control, instead, simply limit ACPI state to
D3_HOT when choosing state;
Make the power off delay a module param named zpodd_poweroff_delay,
defaults to 30 seconds.

v10:
Introduce PM_QOS_NO_POLL flag to skip calling disk's events_check
callback;
Do not use zero power ready hint information from event poll;
Check attached device in port's runtime idle callback to decide if
suspend is desired;
Address various comments from Tejun Heo.

v9:
Build ZPODD as part of libata instead of another standalone module
as it is tightly related to other libata files.
Identify and init ZPODD during probe time instead of after SCSI
device is created as suggested by Tejun Heo.
Make use of pm qos flag to give ACPI hint when choosing ACPI state.
Expose qos flag to give user control of whether power off is allowed.

This patchset used Rafael's pm-qos work:
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-qos

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

Aaron Lu (9):
  scsi: sr: support runtime pm
  libata: Add CONFIG_SATA_ZPODD
  libata: identify and init ZPODD devices
  libata: move acpi notification code to zpodd
  libata: check zero power ready status for ZPODD
  libata: handle power transition of ODD
  libata: expose pm qos flags for ata device
  libata: no poll when ODD is powered off
  libata: do not suspend port if normal ODD is attached

 drivers/ata/Kconfig        |  13 +++
 drivers/ata/Makefile       |   1 +
 drivers/ata/libata-acpi.c  | 111 +++++-------------
 drivers/ata/libata-core.c  |  23 +++-
 drivers/ata/libata-eh.c    |  12 +-
 drivers/ata/libata-zpodd.c | 281 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |  27 +++++
 drivers/scsi/sr.c          |  36 +++++-
 include/linux/libata.h     |   3 +
 include/scsi/scsi_device.h |   1 +
 include/uapi/linux/cdrom.h |  34 ++++++
 11 files changed, 452 insertions(+), 90 deletions(-)
 create mode 100644 drivers/ata/libata-zpodd.c

-- 
1.7.11.7

