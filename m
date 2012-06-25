From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v6 00/11] SATA ZPODD support
Date: Mon, 25 Jun 2012 16:13:01 +0800
Message-ID: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

This is the v6 patches to add SATA ZPODD support, to try it:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd

Holger and Mathtew,
Patch 1 to Patch 3 are the libata acpi binding patches from you.
I removed dock related code from your original version.

v6:
- rebase to v3.5-rc4
- merge patch 4("libata: use correct PCI devices") with patch 2 (Dan Williams)
- makes ata_acpi_find_device mostly independent of the topology,
  gives some type safety, and drops some redundant work finding the ata_port
  (Dan Williams)

v5:
http://lkml.org/lkml/2012/6/18/62
- rebase to v3.5-rc3
- fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu)
- rename is_pci_ata to compat_pci_ata (Alan Cox)

v4:
https://lkml.org/lkml/2012/5/28/11
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

Aaron Lu (4):
      libata: tell scsi layer device supports runtime power off
      [SCSI] sr: check support for device busy class events
      [SCSI] sr: support zero power ODD
      [SCSI] sr: make sure ODD is in resumed state in block ioctl

Holger Macht (1):
      [SCSI]: add wrapper to access and set scsi_bus_type in struct acpi_bus_type

Lin Ming (4):
      libata-acpi: set acpi state for SATA port
      libata-acpi: add ata port runtime D3Cold support
      libata-acpi: register/unregister device to/from power resource
      libata: detect Device Attention support

Matthew Garrett (2):
      libata: bind the Linux device tree to the ACPI device tree
      libata: migrate ACPI code over to new bindings

 drivers/acpi/glue.c        |    4 +-
 drivers/acpi/power.c       |    2 +
 drivers/acpi/sleep.c       |    2 +
 drivers/ata/libata-acpi.c  |  410 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 drivers/ata/libata-core.c  |   11 +--
 drivers/ata/libata-pmp.c   |    4 -
 drivers/ata/libata-scsi.c  |    3 +
 drivers/ata/libata.h       |   15 ++--
 drivers/ata/pata_acpi.c    |    4 +-
 drivers/scsi/scsi_lib.c    |   17 ++++
 drivers/scsi/sr.c          |  160 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/sr.h          |    3 +
 include/linux/ata.h        |    1 +
 include/linux/cdrom.h      |   43 ++++++++++
 include/linux/libata.h     |    9 +-
 include/scsi/scsi.h        |   10 +++
 include/scsi/scsi_device.h |    2 +
 17 files changed, 560 insertions(+), 140 deletions(-)


