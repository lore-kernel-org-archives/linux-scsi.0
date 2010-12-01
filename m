From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/27] libfc: do not fc_io_compl on fsp w/o any scsi_cmnd
	associated
Date: Tue, 30 Nov 2010 16:19:20 -0800
Message-ID: <20101201001920.18369.20232.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab0LAATU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:20 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Do not call fc_io_compl() on fsp w/o any scsi_cmnd, e.g., lun reset is built
inside fc_fcp, not from a scsi command from queuecommnd from scsi-ml, so in
in case target is buggy that is invalid flags in the FCP_RSP, as we have seen
in some SAN Blaze target where all bits in flags are 0, we do not want to call
io_compl on this fsp.

[ Comment block added by Robert Love ]

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c12994b..088ea2a 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -973,7 +973,13 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
 		}
 		lport->tt.exch_done(seq);
 	}
-	fc_io_compl(fsp);
+	/*
+	 * Some resets driven by SCSI are not I/Os and do not have
+	 * SCSI commands associated with the requests. We should not
+	 * call I/O completion if we do not have a SCSI command.
+	 */
+	if (fsp->cmd)
+		fc_io_compl(fsp);
 }
 
 /**

