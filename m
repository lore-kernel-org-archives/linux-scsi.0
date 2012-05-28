From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 0/13] SATA ZPODD support
Date: Mon, 28 May 2012 13:08:27 +0800
Message-ID: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

This is the v4 patches to add SATA ZPODD support, to try it:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd

Holger and Mathtew,
Patch 1 to Patch 4 are the libata acpi binding patches from you.
I removed dock related code from your original version.
Would you help to review?

v4:
- Includes libata acpi binding patches from Holger Macht and Matthew Garrett.
- tell scsi layer device supports runtime power off
- check support for device busy class events

v3:
https://lkml.org/lkml/2012/3/28/20
- Split the ACPI D3Cold state support patches out
- Adds "Device Attention" bit check

v2:
https://lkml.org/lkml/2012/3/1/61
- _PR3 indicates D3Cold support
- move can_power_off flag to pm_subsys_data
- allow all combinations of power resource and device
- split patches into smaller ones to make review easy

v1:
https://lkml.org/lkml/2012/2/13/86


Aaron Lu (5):
      libata: tell scsi layer device supports runtime power off
      [SCSI] pm: resume device if suspend failed
      [SCSI] sr: check support for device busy class events
      [SCSI] sr: support zero power ODD
      [SCSI] sr: make sure ODD is in resumed state in block ioctl

Holger Macht (2):
      [SCSI]: add wrapper to access and set scsi_bus_type in struct acpi_bus_type
      libata: use correct PCI devices

Lin Ming (4):
      libata-acpi: set acpi state for SATA port
      libata-acpi: add ata port runtime D3Cold support
      libata-acpi: register/unregister device to/from power resource
      libata: detect Device Attention support

Matthew Garrett (2):
      libata: bind the Linux device tree to the ACPI device tree
      libata: migrate ACPI code over to new bindings


 drivers/acpi/glue.c        |    2 +
 drivers/acpi/power.c       |    2 +
 drivers/ata/libata-acpi.c  |  389 +++++++++++++++++++++++++++++++-------------
 drivers/ata/libata-core.c  |    9 +-
 drivers/ata/libata-pmp.c   |    4 -
 drivers/ata/libata-scsi.c  |    3 +
 drivers/ata/libata.h       |   13 +-
 drivers/ata/pata_acpi.c    |    4 +-
 drivers/scsi/scsi_lib.c    |   17 ++
 drivers/scsi/scsi_pm.c     |    5 +-
 drivers/scsi/sr.c          |  160 ++++++++++++++++++-
 drivers/scsi/sr.h          |    3 +
 include/linux/ata.h        |    1 +
 include/linux/cdrom.h      |   43 +++++
 include/linux/libata.h     |    9 +-
 include/scsi/scsi.h        |   10 +
 include/scsi/scsi_device.h |    2 +
 17 files changed, 538 insertions(+), 138 deletions(-)

                                                          
