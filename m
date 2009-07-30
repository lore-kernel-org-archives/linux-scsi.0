From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 1/2] bnx2i : Fix CMDSN jump issue seen during cable pull
 test
Date: Wed, 29 Jul 2009 21:49:48 -0700
Message-ID: <1248929388.26650.349.camel@anilgv-desktop>
References: <1245805860.9829.50.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4780 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZG3Et4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 00:49:56 -0400
In-Reply-To: <1245805860.9829.50.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, mchan@broadcom.com


    * Without the fix bnx2i would fail tt->xmit_task() when link is down
    * libiscsi would have already incremented session->cmdsn before calling
      bnx2i's xmit_task() entry point and will just return the command to
      SCSI-ML when xmit_task() fails. libiscsi does not retract the session->cmdsn
      as the command was never sent on wire
    * It is generally good idea for LLD, bnx2i to accept the scsi cmnd/nopout
      and let upper layer timeout and go though normal session recovery process
    * When link is down, unsolicited nopout will not be accepted by bnx2i and
      connection will never enter recovery state. This fix is required for MPIO
      to work corectly

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f741219..9535bb6 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1160,9 +1160,6 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 	struct bnx2i_cmd *cmd = task->dd_data;
 	struct iscsi_cmd *hdr = (struct iscsi_cmd *) task->hdr;
 
-	if (test_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state))
-		return -ENOTCONN;
-
 	if (!bnx2i_conn->is_bound)
 		return -ENOTCONN;
 
-- 
1.5.4.3




