From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 00/11] isci fixes: hotplug
Date: Thu, 27 Oct 2011 15:04:45 -0700
Message-ID: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab1J0WEq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2011 18:04:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series addresses some crash and hang conditions related to device
removal, error handling, and discovery.

Patch 11 "isci: overriding max_concurr_spinup..." is a straightforward
fix for handling a module parameter, but does not directly address a
crash or hang condition (i.e. it could wait for 3.3).

Per the RFC [1] there are other libsas changes that need to occur around
eh versus discovery that are a pre-requisite for further cleanups and
fixes to isci error handling.

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=131941375221687&w=2

---

Andrzej Jakowski (1):
      isci: overriding max_concurr_spinup oem parameter by max(oem, user)

Dan Williams (1):
      isci: revert bcn filtering

Jeff Skirvin (9):
      isci: Lookup device references through requests in completions.
      isci: Immediately fail I/O to removed devices.
      isci: Fix tag leak in tasks and terminated requests.
      isci: Handle task request timeouts correctly.
      isci: No task_done callbacks in error handler paths.
      isci: Fix task management for SMP, SATA and on dev remove.
      isci: Remove redundant isci_request.ttype field.
      isci: No need to manage the pending reset bit on pending requests.
      isci: Fix hard reset timeout conditions.


 drivers/scsi/isci/host.c          |   23 +
 drivers/scsi/isci/init.c          |    2 
 drivers/scsi/isci/port.c          |  146 +++-----
 drivers/scsi/isci/port.h          |    6 
 drivers/scsi/isci/probe_roms.h    |    4 
 drivers/scsi/isci/remote_device.c |   85 -----
 drivers/scsi/isci/remote_device.h |    5 
 drivers/scsi/isci/request.c       |   52 +--
 drivers/scsi/isci/request.h       |    6 
 drivers/scsi/isci/task.c          |  698 ++++++++++++-------------------------
 drivers/scsi/isci/task.h          |   35 --
 11 files changed, 337 insertions(+), 725 deletions(-)
