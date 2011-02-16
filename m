From: michaelc@cs.wisc.edu
Subject: [PATCH 02/17] BNX2I: Fixed the 32-bit swapping of the LUN field for nopouts for 5771X
Date: Wed, 16 Feb 2011 15:04:26 -0600
Message-ID: <1297890281-9076-3-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1BPVEc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:32 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4W2G009057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:32 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tsp004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:31 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Eddie Wai <eddie.wai@broadcom.com>

Fixed a bug where the 64-bit LUN field for nopouts were 32-bit swapped.
This only pertains to 5771X devices.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 603db9d..c8eff57 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -498,10 +498,10 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
 
 	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
-		u32 tmp = nopout_hdr->lun[0];
+		u32 tmp = nopout_wqe->lun[0];
 		/* 57710 requires LUN field to be swapped */
-		nopout_hdr->lun[0] = nopout_hdr->lun[1];
-		nopout_hdr->lun[1] = tmp;
+		nopout_wqe->lun[0] = nopout_wqe->lun[1];
+		nopout_wqe->lun[1] = tmp;
 	}
 
 	nopout_wqe->itt = ((u16)task->itt |
-- 
1.7.2.3

