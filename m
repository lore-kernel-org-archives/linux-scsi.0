From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 00/36] smartpqi updates
Date: Wed, 3 May 2017 18:52:16 -0500
Message-ID: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0082.outbound.protection.outlook.com ([104.47.34.82]:10262
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751860AbdECXwX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:52:23 -0400
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

Changes since V1
 - Changes requested by Bart Van Assche <Bart.VanAssche@sandisk.com>
   - removed unnecessary change in patch smartpqi-cleanup-interrupt-management
   - simplified function sis_is_kernel_up function in
     smartpqi-ensure-controller-in-sis-mode-during-init
   - removed patch smartpqi-change-functions-to-inline
   - provide patch description for smartpqi-minor-driver-cleanup
   - change string alignment in smartpqi-cleanup-messages
   - removed a function call in smartpqi-add-ptraid-support.

---

Corentin Labbe (1):
      smartpqi: remove writeq/readq function definitions

Kevin Barnett (35):
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
      smartpqi: update rescan worker
      smartpqi: cleanup controller branding
      smartpqi: map more raid errors to SCSI errors
      smartpqi: update timeout on admin commands
      smartpqi: enhance device add and remove messages
      smartpqi: make ioaccel references consistent
      smartpqi: add raid level show
      smartpqi: cleanup list initialization
      smartpqi: add module parameters
      smartpqi: bump driver version


 drivers/scsi/smartpqi/smartpqi.h               |  194 +-
 drivers/scsi/smartpqi/smartpqi_init.c          | 2427 ++++++++++++++++++------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 
 drivers/scsi/smartpqi/smartpqi_sis.c           |  100 +
 drivers/scsi/smartpqi/smartpqi_sis.h           |    7 
 5 files changed, 2039 insertions(+), 691 deletions(-)

--
Signature
