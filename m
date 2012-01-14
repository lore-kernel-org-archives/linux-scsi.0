From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/4] fcoe: fix regression on offload em matching function for
 initiator/target
Date: Fri, 13 Jan 2012 17:26:15 -0800
Message-ID: <20120114012615.19185.84753.stgit@localhost6.localdomain6>
References: <20120114012609.19185.66603.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27969 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab2ANB0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2012 20:26:16 -0500
In-Reply-To: <20120114012609.19185.66603.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

This is a regression introduced by commit 1ff9918b625457ce20d450d00f9ed0a12ba191b7
The else statement here is breaking the initiator logic of allocating xid from the
offloaded em xid pool for READ I/O only to use DDP, as shown by the snippet of
trace below, where the WRITE is using xid 0x5 from the offloaded em xid pool:

Protocol VID Len S_ID        D_ID     OX_ID  RX_ID  Summary
..
*FCP     228 96  0b.08.01 -> 01.0f.00 0x0005 0xffff SCSI: Write(10) LUN: 0x00
 FCP     228 76  01.0f.00 -> 0b.08.01 0x0005 0x828d XFER_RDY
...

The bug is in the else statement, for both initiator and target, the
new command will have FC frame header bit 23 (FC_FC_EX_CTX) cleared as it was
originated from the initiator. Also, this is assuming the frame header is
already filled up, which is only true for target since for initiator, this is a
new frame and oem_match gets called when em tries get xid for this i/o before
it is filled up and sent out.

The fix is to check if there is a fc_fcp_pkt associated w/ this frame from
fr_fsp(fp), since fr_fsp(fp) is NULL for tcm_fc target and non-I/O frame in
initiator. This should also return true for target only if it is an
FC_RCTL_DD_UNSOL_CMD and rx_id is not allocated.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index e535f95..507504b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -756,11 +756,12 @@ bool fcoe_oem_match(struct fc_frame *fp)
 	if (fc_fcp_is_read(fr_fsp(fp)) &&
 	    (fr_fsp(fp)->data_len > fcoe_ddp_min))
 		return true;
-	else if (!(ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)) {
+	else if ((fr_fsp(fp) == NULL) &&
+		 (fh->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD) &&
+		 (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN)) {
 		fcp = fc_frame_payload_get(fp, sizeof(*fcp));
-		if (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN &&
-		    fcp && (ntohl(fcp->fc_dl) > fcoe_ddp_min) &&
-		    (fcp->fc_flags & FCP_CFL_WRDATA))
+		if ((fcp->fc_flags & FCP_CFL_WRDATA) &&
+		    (ntohl(fcp->fc_dl) > fcoe_ddp_min))
 			return true;
 	}
 	return false;

