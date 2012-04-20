From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/6] libfcoe: fix VN2VN N_Port_ID Beacon source MAC
Date: Fri, 20 Apr 2012 12:16:49 -0700
Message-ID: <20120420191649.4634.26012.stgit@localhost6.localdomain6>
References: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44406 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2DTTQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 15:16:49 -0400
In-Reply-To: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

FC-BB-6 v1.04 7.9.8.14 N_Port_ID Beacon:

"A N_Port_ID Beacon is multicast and uses the VN_Port MAC address as source
address."

Currently, libfcoe is using ENode MAC, this seems ok and functionality wise
not a problem in my back to back testing setup, however, just fix this to
make libfcoe VN2VN support more spec compliant.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 249a106..5a4c725 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1883,7 +1883,13 @@ static void fcoe_ctlr_vn_send(struct fcoe_ctlr *fip,
 	frame = (struct fip_frame *)skb->data;
 	memset(frame, 0, len);
 	memcpy(frame->eth.h_dest, dest, ETH_ALEN);
-	memcpy(frame->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
+
+	if (sub == FIP_SC_VN_BEACON) {
+		hton24(frame->eth.h_source, FIP_VN_FC_MAP);
+		hton24(frame->eth.h_source + 3, fip->port_id);
+	} else {
+		memcpy(frame->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
+	}
 	frame->eth.h_proto = htons(ETH_P_FIP);
 
 	frame->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);

