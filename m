From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/28] libfc: fix slowpath error from WARN_ON in
	fc_fcp_send_data
Date: Tue, 20 Jul 2010 15:19:10 -0700
Message-ID: <20100720221910.17116.28671.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761864Ab0GTWTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:11 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

This is exposed by a mpio test using EMC CLARiiON targets when LUN
tresspassing happens, the burst length from the XFER_READY for the
MODE SELECT(10) is 19 bytes, much smaller than FC_MIN_MAX_PAYLOAD as
256 bytes. This patch removes the related two WARN_ON()s.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 8914f1e..a0a3ae7 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -580,10 +580,8 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 			   fsp, seq_blen, lport->lso_max, t_blen);
 	}
 
-	WARN_ON(t_blen < FC_MIN_MAX_PAYLOAD);
 	if (t_blen > 512)
 		t_blen &= ~(512 - 1);	/* round down to block size */
-	WARN_ON(t_blen < FC_MIN_MAX_PAYLOAD);	/* won't go below 256 */
 	sc = fsp->cmd;
 
 	remaining = seq_blen;

