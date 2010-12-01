From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/27] libfc: Fix incorrect locking and unlocking in FCP
Date: Tue, 30 Nov 2010 16:18:23 -0800
Message-ID: <20101201001823.18369.34670.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0LAASX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:23 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

The error handler grabs the si->scsi_queue_lock, but
in the case where the fsp pointer is NULL it releases
the scsi_host lock. This can lead to a variety of
system hangs depending on which is used first- the
scsi_host lock or the scsi_queue_lock.

This patch simply unlocks the correct lock when fcp
is NULL.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index e340373..e82ff6e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2002,7 +2002,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	fsp = CMD_SP(sc_cmd);
 	if (!fsp) {
 		/* command completed while scsi eh was setting up */
-		spin_unlock_irqrestore(lport->host->host_lock, flags);
+		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 		return SUCCESS;
 	}
 	/* grab a ref so the fsp and sc_cmd cannot be relased from under us */

