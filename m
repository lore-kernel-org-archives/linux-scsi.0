From: Aaron Lu <aaron.lu@intel.com>
Subject: [RFC PATCH 0/2] Rework ATA ACPI binding code
Date: Thu, 25 Jul 2013 13:47:01 +0800
Message-ID: <1374731223-28685-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10534 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab3GYFqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 01:46:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Wu <jeff.wu@amd.com>, Shane Huang <shane.huang@amd.com>, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Aaron Lu <aaron.lu@intel.com>, Zhang Rui <rui.zhang@intel.com>, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org

Binding ACPI handle to SCSI device has several drawbacks, namely:
1 During ATA device initialization time, ACPI handle will be needed
  while SCSI devices are not created yet. So each time ACPI handle is
  needed, instead of retrieving the handle by ACPI_HANDLE macro,
  a namespace scan is performed to find the handle for the corresponding
  ATA device. This is inefficient, and also expose a restriction on
  calling path not holding any lock.
2 The binding to SCSI device tree makes code complex, while in the
  meantime doesn't buy us anything. All ACPI handlings are still done
  in ATA module, not in SCSI.

This patchset does ACPI binding to ATA transport port/devices when the
devices are created, so that all later operations that require ACPI
handle will simply be a pointer access by the ACPI_HANDLE macro.
This simplies code a lot and also removes the restriction of calling
thread has to be sleep-able.

With the new binding, when ACPI handle will be needed in a function, ATA
transport device should be used like in acpi_pm_device_run_wake etc. When
runtime PM API is used, the SCSI device object should be used. In a word,
runtime PM is still triggered from SCSI device tree, but all ACPI handling
are done in ATA with ATA transport devices.

Tested on an Intel platform, ZPODD and runtime power off of a SATA disk
works OK. More testing by other people is needed/appreciated.

Aaron Lu (2):
  ata: acpi: remove dead code for ata_acpi_(un)bind
  ata: acpi: rework the ata acpi bind support

 drivers/ata/libata-acpi.c      | 278 ++++++++++++-----------------------------
 drivers/ata/libata-core.c      |   5 -
 drivers/ata/libata-scsi.c      |  13 +-
 drivers/ata/libata-transport.c |   2 +
 drivers/ata/libata-zpodd.c     |  12 +-
 drivers/ata/libata.h           |  20 +--
 drivers/ata/pata_acpi.c        |   4 +-
 drivers/scsi/scsi_lib.c        |  22 ----
 include/linux/libata.h         |   2 -
 9 files changed, 106 insertions(+), 252 deletions(-)

-- 
1.8.3.2.10.g43d11f4

