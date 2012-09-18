From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2 0/4] Support runtime power off of HDD
Date: Tue, 18 Sep 2012 15:00:27 +0800
Message-ID: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984Ab2IRHAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 03:00:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Oliver Neukum <oneukum@suse.de>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

v2:
Introduced a new flag sync_before_stop as scsi_stop =
ata_flush_cache + ata_standby_immediate. This flag specifies
that when stop command is to send to this device, please issue
an additional synchronize cache command to it before the stop
command.
Put device into stop power condition on runtime suspend.

v1:
This patch set is baed on v7 ZPODD patches.

Aaron Lu (4):
  scsi: introduce sync_before_stop flag
  scsi: sd: enter stop power condition on runtime suspend
  scsi: sd: set ready_to_power_off for scsi disk
  libata: acpi: set can_power_off for both ODD and HDD

 drivers/ata/libata-acpi.c  | 25 +++++++++++++++++--------
 drivers/ata/libata-scsi.c  |  1 +
 drivers/scsi/sd.c          | 11 +++++++++--
 include/scsi/scsi_device.h |  1 +
 4 files changed, 28 insertions(+), 10 deletions(-)

-- 
1.7.12.21.g871e293

