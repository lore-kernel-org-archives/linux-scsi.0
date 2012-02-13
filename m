From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC] ACPI D3Cold state and SATA ZPODD support
Date: Mon, 13 Feb 2012 17:11:05 +0800
Message-ID: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

This patchset adds support for ACPI D3Cold state and ZPODD(Zero Power
Optical Disk Drive).

ZPODD is a new feature in SATA 3.1 specification. It provides a way to
power off unused CDROM.

CDROM is powered on/off by executing ACPI power resource's _ON/_OFF
method. It enters ACPI D3Cold state when powered off.

PATCH 1 to 4: Adds ACPI D3Cold state support
PATCH 5 to 6: Adds ZPODD support

Applied on top of libata/ALL branch.

[PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
[PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
[PATCH 3/6] ACPI: Runtime resume all devices covered by a power resource
[PATCH 4/6] PM / Runtime: Introduce flag can_power_off
[PATCH 5/6] PCI: Move acpi_dev_run_wake to acpi core
[PATCH 6/6] libata: add ZPODD support

 drivers/acpi/power.c       |  141 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/scan.c        |   10 +++-
 drivers/acpi/sleep.c       |   35 +++++++++++
 drivers/ata/libata-acpi.c  |   64 ++++++++++++++++----
 drivers/pci/pci-acpi.c     |   40 +------------
 drivers/scsi/sr.c          |   39 ++++++++++++
 drivers/scsi/sr.h          |    3 +
 include/acpi/acpi_bus.h    |    7 ++
 include/linux/pm.h         |    1 +
 include/linux/pm_runtime.h |   30 +++++++++
 10 files changed, 319 insertions(+), 51 deletions(-)

Thanks for any comments.

Lin Ming
