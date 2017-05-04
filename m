From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 00/14] hpsa updates
Date: Thu, 4 May 2017 14:08:01 -0500
Message-ID: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0089.outbound.protection.outlook.com ([104.47.42.89]:50624
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752152AbdEDTIG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 15:08:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

These patches are for:
 - RedHat BZ: 1404073 - [HPE 7.3 Bug] multipath failover not reliable
 - Multipath failover support in general.

The changes are:
 - update identify physical device structure
   - align with FW
 - stop getting enclosure info for externals
   - no BMIC support
 - update reset handler
   - update to match out of box driver
 - do not reset enclosures
   - reset can sometimes hang
 - rescan later if reset in progress
   - wait for devices to settle.
 - correct resets on retried commands
   - was not calling scsi_done on retried completion
 - correct queue depth for externals
   - Code not in correct function
 - separate monitor events from rescan worker
   - allows driver to check for controller events more frequently
     without affecting controller lockup detection or check
     for changes on PTRAID devices.
 - send ioaccel requests with 0 length down raid path
   - avoid hang issues for customers running older firmware.
 - remove abort handler
   - align driver with our out of box driver
 - bump driver version
   - align version with out of box driver for multi-path changes

Changes since V1:
 - includes changes based on Martin Wilck <mwilck@suse.com> reviews.
    - cleanup reset handler
      - added spin_lock protection around h->reset_in_progress
        - this has helped solve a multipath issue, thanks Martin.
    - renamed patch hpsa-separate-monitor-events-from-hearbeat-worker to
      hpsa-separate-monitor-events-from-rescan-worker to more correctly
         convey the patches intent.
      - split out some commonality between the rescan worker and the
        event monitor worker.
      - updated the patch description.

Changes since V2:
 - includes a change based on Tomas Henzl <thenzl@redhat.com> review
   - Corrected placement of spin_unlock_irqrestore in patch
     hpsa-clean-up-reset-handler
     - Thanks for your attention to hpsa Tomas

---

Don Brace (13):
      hpsa: update pci ids
      hpsa: change driver version
      hpsa: update identify physical device structure
      hpsa: do not get enclosure info for external devices
      hpsa: update reset handler
      hpsa: do not reset enclosures
      hpsa: rescan later if reset in progress
      hpsa: correct resets on retried commands
      hpsa: cleanup reset handler
      hpsa: correct queue depth for externals
      hpsa: send ioaccel requests with 0 length down raid path
      hpsa: remove abort handler
      hpsa: bump driver version

Scott Teel (1):
      hpsa: separate monitor events from rescan worker


 drivers/scsi/hpsa.c     |  853 +++++++++++------------------------------------
 drivers/scsi/hpsa.h     |    4 
 drivers/scsi/hpsa_cmd.h |   20 +
 3 files changed, 212 insertions(+), 665 deletions(-)

--
Signature
