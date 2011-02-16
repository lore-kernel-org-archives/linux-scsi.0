From: michaelc@cs.wisc.edu
Subject: [PATCH 05/17] BNX2I: Added jumbo MTU support for the no shost case
Date: Wed, 16 Feb 2011 15:04:29 -0600
Message-ID: <1297890281-9076-6-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1BPVEe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:34 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4YNi021087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:34 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tss004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:33 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Eddie Wai <eddie.wai@broadcom.com>

For scenarios where the shost is not being passed to bnx2i for the
iSCSI offload connection request, the code would consult the routing
table to select the CNIC device.
This code path will erroneously error out if the corresponding L2
interface's MTU has been setup to > 1500.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/bnx2i/bnx2i.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index e1ca5fe..2756853 100644
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
1.7.2.3

