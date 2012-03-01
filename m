From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH v2 0/8] ACPI D3Cold state and SATA ZPODD support
Date: Thu,  1 Mar 2012 17:02:49 +0800
Message-ID: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

This is the v2 RFC patches to add ACPI D3Cold state and SATA ZPODD support.

v2:
- _PR3 indicates D3Cold support
- move can_power_off flag to pm_subsys_data
- allow all combinations of power resource and device
- split patches into smaller ones to make review easy

v1:
https://lkml.org/lkml/2012/2/13/86

[PATCH 1/8] ACPI: Introduce ACPI D3_COLD state support
[PATCH 2/8] ACPI: Add interface to register/unregister device to/from power resources
[PATCH 3/8] PCI: Move acpi_dev_run_wake to acpi core
[PATCH 4/8] libata-acpi: set acpi state for SATA port
[PATCH 5/8] libata-acpi: add ata port runtime D3Cold support
[PATCH 6/8] libata-acpi: register/unregister device to/from power resource
[PATCH 7/8] PM / Runtime: Add can_power_off flag to subsys data
[PATCH 8/8] [SCSI] sr: check and enable Zero-power ODD support

 drivers/acpi/power.c       |  166 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/scan.c        |    7 ++
 drivers/acpi/sleep.c       |   35 +++++++++
 drivers/ata/libata-acpi.c  |  137 +++++++++++++++++++++++++++++++++----
 drivers/ata/libata-scsi.c  |    6 +-
 drivers/ata/libata.h       |    8 +-
 drivers/pci/pci-acpi.c     |   40 +----------
 drivers/scsi/scsi_pm.c     |    8 ++
 drivers/scsi/sr.c          |   46 ++++++++++++
 drivers/scsi/sr.h          |    3 +
 include/acpi/acpi_bus.h    |    7 ++
 include/linux/pm.h         |    1 +
 include/scsi/scsi_device.h |    2 +
 13 files changed, 407 insertions(+), 59 deletions(-)

Thanks for any comment.
Lin Ming
