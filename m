From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 00/12] hpsa updates
Date: Fri, 20 Oct 2017 16:51:02 -0500
Message-ID: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0055.outbound.protection.outlook.com ([104.47.41.55]:22449
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753388AbdJTVvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:51:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:

hpsa: update discovery polling
 - Correct corner case for RBODs with no initial volumes.

hpsa: add controller checkpoint
 - Provide method to generate a controller checkpoint.

hpsa: change timeout for internal cmds
 - There are times when the default time-out value has
   proven to be too small.

hpsa: correct smart path enabled
 - Correct some corner cases where the ioaccel path is not
   re-enabled after a multipath failover or a transformation.

hpsa: update queue depth for externals
 - A re-scan can change the queue-depth of external
   logical volumes.

hpsa: reduce warning messages on device removal
 - Repeated warnings are not necessary.

hpsa: correct logical volume removal
 - Also check for outstanding commands during logical volume removal.

hpsa: add enclosure logical identifier
 - Populate sysfs enclosure_identifier.

hpsa: destroy sas transport properties before scsi_host
 - This patch was proposed by Martin Wilck on 10/21/2016:
   https://www.spinics.net/lists/linux-scsi/msg102085.html
 - but had no effect until Hannes's patch:
   commit 9441284fbc39 ("scsi-fixup-kernel-warning-during-rmmod")
   was applied to the kernel.
 - Re-submitting with Martin Wilck's permission.

hpsa: cleanup sas_phy structures in sysfs when unloading
 - This patch was proposed by Martin Wilck on 10/21/2016:
   https://www.spinics.net/lists/linux-scsi/msg102083.html
 - cleans up dangling symlinks in sysfs.
 - Re-submitting with Martin Wilck's permission.

hpsa: clear tmpdevice in scan thread
 - Clean up some meta data issues for devices during a re-scan.

hpsa: bump driver version

---

Bader Ali Saleh (1):
      hpsa: update discovery polling

Don Brace (8):
      hpsa: add controller checkpoint
      hpsa: change timeout for internal cmds
      hpsa: correct smart path enabled
      hpsa: update queue depth for externals
      hpsa: reduce warning messages on device removal
      hpsa: correct logical volume removal
      hpsa: add enclosure logical identifier
      hpsa: bump driver version

Martin Wilck (2):
      hpsa: destroy sas transport properties before scsi_host
      hpsa: cleanup sas_phy structures in sysfs when unloading

Scott Teel (1):
      hpsa: clear tmpdevice in scan thread


 drivers/scsi/hpsa.c     |  356 +++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/hpsa_cmd.h |    3 
 2 files changed, 284 insertions(+), 75 deletions(-)

--
Signature
