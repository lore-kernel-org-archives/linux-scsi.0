From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v14 0/3] ZPODD Patches
Date: Wed, 23 Jan 2013 15:09:30 +0800
Message-ID: <1358924973-18269-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

v14:
Patches 2-6 and 8 of v13 are already taken by Jeff into libata/upstream,
so we just have 3 patches left:
patch 1 in v13 -> patch 1 in v14
patch 7 in v13 -> patch 2 in v14
patch 9 in v13 -> patch 3 in v14

Update sr's runtime PM code to take care of audio play as pointed out by
Alan Stern in patch 1;
Due to the above changes to patch 1, patch 2 was rediffed accordingly,
with no functionality changes.

Hi Jeff,

I've prepaed several git branches for your convenience:
https://github.com/aaronlu/linux.git
Branch zpodd_v14 has the three patches submitted here;
Branch fix-smatch has the fix patch for a smatch warning;
Branch for-jeff has the above two branches merged;
Branch zpodd has all the 9 patches on top of libata/upstream branch, but
with all zpodd related patches in that branch removed first.

v13:
Use atomic type for disk_events_disable_depth, so that disabling can
stack and has its own synchronization rule as suggested by Tejun Heo;

Set zp_ready to false whenever we found the ODD is not in ZP ready state
due to support of NO_POWEROFF qos flag. This change is made in patch 6
instead of patch 4 so that it is clear why this change is necessary.

v12:
Suggestions by Tejun Heo:
Fold patch 2 into patch 3;
Do not use bitfields in zpodd structure;
Call zpodd_exit in ata_scsi_remove_dev;
Remove run_atapi_cmd, use ata_exec_internal directly;
Use enum to return ODD loading mechanism type information;
Added some comments.

Typo fix:
Fixed some mis-spellings as pointed out by Sergei Shtylyov.

Several function name changes:
Rename zpodd_pre_poweroff to zpodd_enable_run_wake, zpodd_pre_poweron
to zpodd_disable_run_wake. This feels clearer and people can get what
the two functions are supposed to do by their names;
Rename zpodd_post_resume to zpodd_post_poweron, since this function is
only useful when the ODD is powered off during suspend.
I decided to rename these functions when I'm adding comments for them
as suggested by Tejun Heo, and I felt I didn't name them well...

QOS no_poweroff flag:
Only export qos flag for ZPODD devices, disks that can be runtime
powered off should also export this interface, but it doesn't belong
to this patchset so will be done in other patches.

A new patch:
Added a patch to remove a no more useful scsi_device flag can_power_off.

A git repo for it:
https://github.com/aaronlu/linux.git zpodd_v12

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

Aaron Lu (3):
  scsi: sr: support runtime pm
  libata: scsi: no poll when ODD is powered off
  scsi: remove can_power_off flag from scsi_device

 drivers/ata/libata-zpodd.c |  7 +++++++
 drivers/scsi/scsi_lib.c    | 14 ++++++++++++++
 drivers/scsi/sr.c          | 46 +++++++++++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_device.h |  5 ++++-
 4 files changed, 68 insertions(+), 4 deletions(-)

-- 
1.8.1

