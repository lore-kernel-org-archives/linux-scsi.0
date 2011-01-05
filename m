From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 6/8] BNX2I: Added jumbo MTU support for the no shost
 case
Date: Wed, 5 Jan 2011 12:44:25 -0800
Message-ID: <1294260267-17413-7-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4815 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1AEUlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:41:55 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

For scenarios where the shost is not being passed to bnx2i for the
iSCSI offload connection request, the code would consult the routing
table to select the CNIC device.
This code path will erroneously error out if the corresponding L2
interface's MTU has been setup to > 1500.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index cc7ebc1..bd64ba3 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -360,7 +360,7 @@ struct bnx2i_hba {
 		#define ADAPTER_STATE_LINK_DOWN		2
 		#define ADAPTER_STATE_INIT_FAILED	31
 	unsigned int mtu_supported;
-		#define BNX2I_MAX_MTU_SUPPORTED		1500
+		#define BNX2I_MAX_MTU_SUPPORTED		9000
 
 	struct Scsi_Host *shost;
 
-- 
1.7.0.5


