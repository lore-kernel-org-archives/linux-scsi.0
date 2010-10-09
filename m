From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 7/8] libfcoe: VN2VN connection setup causing stack memory
	corruption.
Date: Fri, 08 Oct 2010 17:12:41 -0700
Message-ID: <20101009001241.7744.14524.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAMm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:42 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Fix: When FIP frame is received, function fcoe_ctlr_vn_recv calls function
fcoe_ctlr_vn_parse which does memset for addr (&buf.rdata) which leads to
memory corruption. Code was trying to treat "buf" as struct but it was defined
as union. Fix is to change from union to struct for "buf" in function fcoe_ctlr_vn_recv.

Technical Details: N/A

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Acked-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index aa503d8..bc17c71 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -2296,7 +2296,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct fip_header *fiph;
 	enum fip_vn2vn_subcode sub;
-	union {
+	struct {
 		struct fc_rport_priv rdata;
 		struct fcoe_rport frport;
 	} buf;

