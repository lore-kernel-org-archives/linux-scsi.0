From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 00/30] aacraid: Refactor for sas transport and bug fixes
Date: Tue, 26 Dec 2017 20:34:21 -0800
Message-ID: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0040.outbound.protection.outlook.com ([104.47.33.40]:15232
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751278AbdL0Ee5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:34:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

This patchset primarily lays the foundation for adding sas transport
support to the aacraid driver. Being said these patches are mainly code
refactors, bug fixes and improvements.

 - Fixed a udev inquiry race condition
 - Fixed a kdump hang issue which occurs in case of error recovery in kdump
 - Made improvements to ioctl reset and reset_host sysfs reset paths
 - Changed the code to retrieve lun information into stand alone functions.
 - Merged container and hba hotplug event processing (device addition and
   and removal into single function)
 - Removed scsi_scan_host for safw devices and now explicitly add devices
   retrieved from the fw.
 - Reschedule scan in driver fails to retrieve lun information from fw.
   (usually works in a few attempts)
 - Rescan worker waits for any pending EH recovery before rescanning
 - Do not trigger rescan worker in kdump kernel

Changes in V2:
 - Added kmemdup intead of kmalloc and memcpy
 - Changed incorrect reported-by credit
 - Fixed missing colon in function doc
 - Used get_unaligned_be32
 - Removed unused phy_luns variable
 - Removed unnecessary bus variable check and assignment
 - Added patch to increment driver version to 50877 (Missed that one)

Raghava Aditya Renukunta (30):
  scsi: aacraid: Fix udev inquiry race condition
  scsi: aacraid: Do not attempt abort when Fw panicked
  scsi: aacraid: Fix hang in kdump
  scsi: aacraid: Do not remove offlined devices
  scsi: aacraid: Fix ioctl reset hang
  scsi: aacraid: Allow reset_host sysfs var to recover Panicked Fw
  scsi: aacraid: Refactor reset_host store function
  scsi: aacraid: Move code to wait for IO completion to shutdown func
  scsi: aacraid: Create bmic submission function from bmic identify
  scsi: aacraid: Change phy luns function to use common bmic function
  scsi: aacraid: Refactor and rename to make mirror existing changes
  scsi: aacraid: Add target setup helper function
  scsi: aacraid: Untangle targets setup from report phy luns
  scsi: aacraid: Move function around to match existing code
  scsi: aacraid: Create helper functions to get lun info
  scsi: aacraid: Save bmic phy information for each phy
  scsi: aacraid: Add helper function to set queue depth
  scsi: aacraid: Merge func to get container information
  scsi: aacraid: Process hba and container hot plug events in single
    function
  scsi: aacraid: Added macros to help loop through known buses and
    targets
  scsi: aacraid: Refactor resolve luns code and scsi functions
  scsi: aacraid: Merge adapter setup with resolve luns
  scsi: aacraid: Block concurrent hotplug event handling
  scsi: aacraid: Use hotplug handling function in place of
    scsi_scan_host
  scsi: aacraid: Reschedule host scan in case of failure
  scsi: aacraid: Fix hang while scanning in eh recovery
  scsi: aacraid: Skip schedule rescan in case of kdump
  scsi: aacraid: Remove unused rescan variable
  scsi: aacraid: Remove AAC_HIDE_DISK check in queue command
  scsi: aacraid: Update driver version to 50877

 drivers/scsi/aacraid/aachba.c   | 468 +++++++++++++++++++++++++++-------------
 drivers/scsi/aacraid/aacraid.h  |  54 ++++-
 drivers/scsi/aacraid/commctrl.c |   6 +-
 drivers/scsi/aacraid/comminit.c |  49 ++++-
 drivers/scsi/aacraid/commsup.c  | 220 ++++++++++---------
 drivers/scsi/aacraid/linit.c    |  23 +-
 6 files changed, 547 insertions(+), 273 deletions(-)

-- 
2.9.4
