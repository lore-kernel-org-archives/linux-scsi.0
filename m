From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 00/12] hpsa updates
Date: Fri, 7 Apr 2017 15:05:43 -0500
Message-ID: <149159483812.15658.615814291766210537.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0077.outbound.protection.outlook.com ([104.47.33.77]:59259
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755922AbdDGUFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 16:05:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

These patches are for:
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
 - separate monitor events from heartbeat worker
   - allows driver to check for changes more frequently
     without affecting controller lockup detection.
 - send ioaccel requests with 0 length down raid path
   - avoid hang issues for customers running older FW.
 - remove abort handler
   - align driver with our out of box driver
 - bump driver version
   - align version with out of box driver for multi-path changes

---

Don Brace (11):
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
      hpsa: separate monitor events from heartbeat worker


 drivers/scsi/hpsa.c     |  790 +++++++++--------------------------------------
 drivers/scsi/hpsa.h     |    3 
 drivers/scsi/hpsa_cmd.h |   20 +
 3 files changed, 164 insertions(+), 649 deletions(-)

--
Signature
