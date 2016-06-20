From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] SCSI EH cleanup
Date: Mon, 20 Jun 2016 11:35:35 +0200
Message-ID: <1466415340-104465-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbcFTJfv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 05:35:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset to cleanup SCSI EH. The main point is that we should
finally drop the no_async_abort flag; up to now we haven't had any
issues with the asynchronous aborts, and the flag was never used.

As usual, comments and reviews are welcome.

Christoph Hellwig (1):
  libsas: allow async aborts

Hannes Reinecke (4):
  scsi: make scsi_eh_scmd_add() always succeed
  scsi: make eh_eflags persistent
  scsi: make asynchronous aborts mandatory
  scsi: Do not escalate failed EH command

 Documentation/scsi/scsi_eh.txt      |  31 ++++-----
 drivers/scsi/libsas/sas_scsi_host.c |   3 -
 drivers/scsi/scsi_error.c           | 127 +++++-------------------------------
 drivers/scsi/scsi_lib.c             |   4 +-
 drivers/scsi/scsi_priv.h            |   3 +-
 include/scsi/scsi_eh.h              |   1 +
 include/scsi/scsi_host.h            |   5 --
 7 files changed, 35 insertions(+), 139 deletions(-)

-- 
1.8.5.6

