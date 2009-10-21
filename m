From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/20] libfc: Fix wrong scsi return status under FC_DATA_UNDRUN
Date: Wed, 21 Oct 2009 16:27:12 -0700
Message-ID: <20091021232712.12986.29197.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZJUX1R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:27:17 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

This bug is exposed when there is a link flap in LLD. Particularly, when it
happens right after a SCSI write command is sent out, no FCP_DATA is sent,
causing fsp->status_code to be set as FC_DATA_UNDRUN in fc_fcp_complete_locked
even no SCSI status is received. Consequently, fc_io_compl treats this as DID_OK.
This results in SCSI returning successful to the initial I/O request even
there is no DATA actually sent. Particularly, if you run an I/O tool w/ data
verification on, the read back for verification is gonna fail.

This is fixed here by checking when FC_DATA_UNDRUN happens, SCSI status is
received w/ FC_SRB_RCV_STATUS set in fsp->state.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index ade962d..40ed744 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1849,7 +1849,8 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 * scsi status is good but transport level
 			 * underrun.
 			 */
-			sc_cmd->result = DID_OK << 16;
+			sc_cmd->result = (fsp->state & FC_SRB_RCV_STATUS ?
+					  DID_OK : DID_ERROR) << 16;
 		} else {
 			/*
 			 * scsi got underrun, this is an error

