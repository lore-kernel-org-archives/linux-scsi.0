From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 0/8] SCSI EH cleanup
Date: Thu,  6 Apr 2017 15:36:28 +0200
Message-ID: <1491485796-44411-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38427 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934740AbdDFNgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Apr 2017 09:36:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is a resend of a small patchset for cleaning up SCSI EH.
Primary goal is to make asynchronous aborts mandatory; there hasn't
been a single report so far where asynchronous abort won't work, so
the 'no_async_abort' flag has never been used and will be removed
with this patchset.
Additionally there's a cleanup to detect retries of failed commands and
to inline commands aborts.
I've also included the patch to correctly reset the media access
timeout counter to avoid it being triggered inadvertedly by several
commands timing out for the same device.

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from Christoph

Changes to v2:
- Include reviews from Bart
- Add medium access timeout patch

Changes to v3:
- Add patch to inline command abort as per suggestion from Christoph
- Drop patch to not escalate failed EH commands

Changes to v4:
- Split off sdrv->eh_action into two functions

Changes to v5:
- Simplify 'scsi: inline command aborts'
- Add Reviewed-by tags

Christoph Hellwig (1):
  libsas: allow async aborts

Hannes Reinecke (7):
  scsi_error: count medium access timeout only once per EH run
  sd: Return SUCCESS in sd_eh_action() after device offline
  scsi: always send command aborts
  scsi: make eh_eflags persistent
  scsi: make scsi_eh_scmd_add() always succeed
  scsi: make asynchronous aborts mandatory
  scsi: inline command aborts

 Documentation/scsi/scsi_eh.txt      |  30 ++---
 drivers/scsi/libsas/sas_scsi_host.c |   5 -
 drivers/scsi/scsi.c                 |   2 -
 drivers/scsi/scsi_error.c           | 213 ++++++++++++------------------------
 drivers/scsi/scsi_lib.c             |   6 +-
 drivers/scsi/scsi_priv.h            |   4 +-
 drivers/scsi/sd.c                   |  29 ++++-
 drivers/scsi/sd.h                   |   1 +
 include/scsi/scsi_cmnd.h            |   1 -
 include/scsi/scsi_driver.h          |   1 +
 include/scsi/scsi_eh.h              |   1 +
 include/scsi/scsi_host.h            |   5 -
 12 files changed, 113 insertions(+), 185 deletions(-)

-- 
1.8.5.6
