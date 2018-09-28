From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 0/2] scsi: ufs: Enable bInitPowerMode of sleep
Date: Fri, 28 Sep 2018 16:02:01 -0700
Message-ID: <20180928230203.905-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Adrian Hunter <adrian.hunter@intel.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change enables Linux to enumerate UFS devices that have been configured
to start in an initial power mode (bInitPowerMode) of sleep. The UFS spec
indicates that for devices in sleep mode, a START_STOP_UNIT SCSI command
must be sent to them to wake them up before doing other initialization tasks
like getting the device or geometry descriptors. This is not trivial to do
in the UFS driver, since it assumes that SCSI commands are only needed once
low level initialization of the device is complete.

These patches 1) Enable sending SCSI commands before the actual SCSI targets
are created, and 2) Sends the needed commands for devices in sleep mode.

This can be tested locally by setting byte 5 of the Configuration Descriptor
(bInitPowerMode) to zero, and rebooting. I discovered this bug by accidentally
zeroing out too many fields while I was testing provisioning functionality.

Note: This series is unrelated to (and independent of) the competing UFS
provisioning patches that have been floating around the list lately.

Changes since v1:
	* Split into two patches for easier comprehension. Can recombine to one
if this split is too contrived.
	* Fixed a leftover raw printk.

Evan Green (2):
  scsi: ufs: Allow SCSI commands early during init
  scsi: ufs: Execute START_STOP_UNIT during init

 drivers/scsi/ufs/ufshcd.c | 208 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h |  11 +++
 2 files changed, 206 insertions(+), 13 deletions(-)

-- 
2.16.4
