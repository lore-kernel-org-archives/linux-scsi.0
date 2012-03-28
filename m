From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 0/7] SATA ZPODD support
Date: Wed, 28 Mar 2012 14:21:55 +0800
Message-ID: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

This is the v3 patches to add SATA ZPODD support.

I split the ACPI D3Cold state support patches out.
You can find it here:

[PATCH v2 0/2] ACPI D3Cold state support
https://lkml.org/lkml/2012/3/27/52

v3:
- Split the ACPI D3Cold state support patches out
- Adds "Device Attention" bit check

v2:
- _PR3 indicates D3Cold support
- move can_power_off flag to pm_subsys_data
- allow all combinations of power resource and device
- split patches into smaller ones to make review easy

v1:
https://lkml.org/lkml/2012/2/13/86

[PATCH v3 1/7] libata-acpi: set acpi state for SATA port
[PATCH v3 2/7] libata-acpi: add ata port runtime D3Cold support
[PATCH v3 3/7] libata-acpi: register/unregister device to/from power resource
[PATCH v3 4/7] libata: detech Device Attention support
[PATCH v3 5/7] libata: tell scsi layer device supports runtime power off
[PATCH v3 6/7] PM / Runtime: Add can_power_off flag to subsys data
[PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support

 drivers/ata/libata-acpi.c  |  137 +++++++++++++++++++++++++++++++++++++++----
 drivers/ata/libata-core.c  |    3 +
 drivers/ata/libata-scsi.c  |    8 ++-
 drivers/ata/libata.h       |    8 +-
 drivers/scsi/scsi_pm.c     |    8 +++
 drivers/scsi/sr.c          |   44 ++++++++++++++
 drivers/scsi/sr.h          |    2 +
 include/linux/ata.h        |    1 +
 include/linux/libata.h     |    2 +
 include/linux/pm.h         |    1 +
 include/scsi/scsi_device.h |    3 +
 11 files changed, 197 insertions(+), 20 deletions(-)

