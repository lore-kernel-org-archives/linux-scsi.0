From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 00/37] smartpqi updates
Date: Tue, 25 Apr 2017 14:45:51 -0500
Message-ID: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0073.outbound.protection.outlook.com ([104.47.37.73]:34902
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031978AbdDYTqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:46:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:

 - correct remove SCSI devices
   - Remove spin-lock
 - cleanup interrupt management
   - minor cleanup to align with in-house driver
 - set PCI completion timeout 
 - add in controller checkpoint for controller lockups.
   - helps debug rare lockup conditions
 - ensure controller is in SIS mode at driver init
   - needed for kdump/kexec
 - add supporting events
   - manage event changes from controller
 - enhance resets
   - wait for all outstanding I/Os to complete
 - add suspend and resume support
   - Support S3/S4 system power states
 - add heartbeat check
   - add check for controller lockups
 - correct bdma hw bug
   - workaround for BDMA hardware bug 
 - add pqi_wait_for_completion_io
   - add check for controller lockup
 - change functions to inline
   - align code with in-house driver
 - make pdev pointer names consistent
   - align code with in-house driver
 - eliminate redundant error messages
 - correct BMIC identify physical drive
 - minor driver cleanup
   - align code with in-house driver
 - add new PCI device IDs
 - cleanup messages
 - update copyright
 - add ptraid support
   - RBOD support
 - change return value for LUN reset operations
 - enhance kdump
 - remove qdepth calculations for logical volumes
 - add lockup action
 - correct AIO error path
   - send commands down RAID path when they fail
     on AIO path
 - update device offline
   - improve off-lined device detection.
 - update rescan worker
 - cleanup controller branding
   - make more generic
 - map more raid errors to SCSI errors
   - map RAID path errors to Linux SCSI errors
 - update timeout on admin commands
 - enhance device add and remove messages
 - make AIO references consistent
 - add raid level show sysfs entry
 - cleanup list initialization
 - add module parameters
   - heat-beat and controller management
 - remove writeq/readq function definitions
   - from Corentin Labbe <clabbe.montjoie@gmail.com>
 - bump driver version

---

Corentin Labbe (1):
      smartpqi: remove writeq/readq function definitions

Kevin Barnett (36):
      smartpqi: correct remove scsi devices
      smartpqi: cleanup interrupt management
      smartpqi: set pci completion timeout
      smartpqi: add in controller checkpoint for controller lockups.
      smartpqi: ensure controller is in SIS mode at init
      smartpqi: add supporting events
      smartpqi: enhance resets
      smartpqi: add suspend and resume support
      smartpqi: add heartbeat check
      smartpqi: correct bdma hw bug
      smartpqi: add pqi_wait_for_completion_io
      smartpqi: change functions to inline
      smartpqi: make pdev pointer names consistent
      smartpqi: eliminate redundant error messages
      smartpqi: correct BMIC identify physical drive
      smartpqi: minor driver cleanup
      smartpqi: add new PCI device IDs
      smartpqi: cleanup messages
      smartpqi: update copyright
      smartpqi: add ptraid support
      smartpqi: change return value for LUN reset operations
      smartpqi: enhance kdump
      smartpqi: remove qdepth calculations for logical volumes
      smartpqi: add lockup action
      smartpqi: correct aio error path
      smartpqi: update device offline
      smartpqi: controller offline improvements
      smartpqi: cleanup controller branding
      smartpqi: map more raid errors to SCSI errors
      smartpqi: update timeout on admin commands
      smartpqi: enhance device add and remove messages
      smartpqi: make raid bypass references consistent
      smartpqi: add raid level show
      smartpqi: cleanup list initialization
      smartpqi: add module parameters
      smartpqi: bump driver version


 drivers/scsi/smartpqi/smartpqi.h               |  192 +-
 drivers/scsi/smartpqi/smartpqi_init.c          | 2430 ++++++++++++++++++------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 
 drivers/scsi/smartpqi/smartpqi_sis.c           |  109 +
 drivers/scsi/smartpqi/smartpqi_sis.h           |    7 
 5 files changed, 2051 insertions(+), 689 deletions(-)

--
Signature
