From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2 0/5] Migrate SCSI drivers to use dev_pm_ops
Date: Thu, 11 Oct 2012 13:08:06 +0800
Message-ID: <1349932091-6856-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3751 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab2JKFIk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2012 01:08:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

v2:
Change the runtime suspend behaviour of sd driver by putting the device
into stopped power state.
Revert 2 patches which are no longer needed as pointed out by Alan Stern.
Find out device callbacks in bus callbacks as suggested by Alan Stern.

Due to these changes, patch number grows from 2 -> 5.

v1:
The 2 patches will migrate SCSI drivers to use the pm callbacks defined
in dev_pm_ops as pm_message is deprecated and should not be used by driver.
Bus level callback is changed to use callbacks defined in dev_pm_ops when
needed and sd's pm callback is updated to use what are defined in dev_pm_ops.

Aaron Lu (5):
  sd: put to stopped power state when runtime suspend
  Revert "[SCSI] scsi_pm: set device runtime state before parent
    suspended"
  Revert "[SCSI] runtime resume parent for child's system-resume"
  pm: use callbacks from dev_pm_ops for scsi devices
  sd: update sd to use the new pm callbacks

 drivers/scsi/scsi_pm.c | 138 +++++++++++++++++++++++++++++--------------------
 drivers/scsi/sd.c      |  18 +++++--
 2 files changed, 96 insertions(+), 60 deletions(-)

-- 
1.7.12.21.g871e293

