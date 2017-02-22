From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/5] SCSI EH cleanup
Date: Wed, 22 Feb 2017 17:07:25 +0100
Message-ID: <1487779650-1338-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58761 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754803AbdBVQHe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 11:07:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is a resend of a small patchset for cleaning up SCSI EH.
Primary goal is to make asynchronous aborts mandatory; there hasn't
been a single report so far where asynchronous abort won't work, so
the 'no_async_abort' flag has never been used and will be removed
with this patchset.
Additionally there's a cleanup for handle failed EH commands, and
to detect retries of failed commands.

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from Christoph

Christoph Hellwig (1):
  libsas: allow async aborts

Hannes Reinecke (4):
  scsi: make eh_eflags persistent
  scsi_error: do not escalate failed EH command
  scsi: make scsi_eh_scmd_add() always succeed
  scsi: make asynchronous aborts mandatory

 Documentation/scsi/scsi_eh.txt      |  30 ++++-----
 drivers/scsi/libsas/sas_scsi_host.c |   3 -
 drivers/scsi/scsi_error.c           | 125 ++++++------------------------------
 drivers/scsi/scsi_lib.c             |   4 +-
 drivers/scsi/scsi_priv.h            |   3 +-
 include/scsi/scsi_eh.h              |   1 +
 include/scsi/scsi_host.h            |   5 --
 7 files changed, 34 insertions(+), 137 deletions(-)

-- 
1.8.5.6
