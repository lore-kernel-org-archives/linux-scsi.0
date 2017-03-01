From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/6] SCSI EH cleanup
Date: Wed,  1 Mar 2017 10:15:14 +0100
Message-ID: <1488359720-130871-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbdCAJfc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Mar 2017 04:35:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is a resend of a small patchset for cleaning up SCSI EH.
Primary goal is to make asynchronous aborts mandatory; there hasn't
been a single report so far where asynchronous abort won't work, so
the 'no_async_abort' flag has never been used and will be removed
with this patchset.
Additionally there's a cleanup for handle failed EH commands, and
to detect retries of failed commands.
I've also included the patch to correctly reset the media access
timeout counter to avoid it being triggered inadvertedly by several
commands timing out for the same device.

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from Christoph

Changes to v2:
- Include reviews from Bart
- Add medium access timeout patch


Christoph Hellwig (1):
  libsas: allow async aborts

Hannes Reinecke (5):
  scsi_error: count medium access timeout only once per EH run
  scsi: make eh_eflags persistent
  scsi_error: do not escalate failed EH command
  scsi: make scsi_eh_scmd_add() always succeed
  scsi: make asynchronous aborts mandatory

 Documentation/scsi/scsi_eh.txt      |  30 +++-----
 drivers/scsi/libsas/sas_scsi_host.c |   5 --
 drivers/scsi/scsi_error.c           | 143 +++++++++---------------------------
 drivers/scsi/scsi_lib.c             |   4 +-
 drivers/scsi/scsi_priv.h            |   3 +-
 drivers/scsi/sd.c                   |  21 +++++-
 drivers/scsi/sd.h                   |   1 +
 include/scsi/scsi_driver.h          |   2 +-
 include/scsi/scsi_eh.h              |   1 +
 include/scsi/scsi_host.h            |   5 --
 10 files changed, 68 insertions(+), 147 deletions(-)

-- 
1.8.5.6
