From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 01/18] bnx2fc: Reset the max receive frame size
Date: Thu, 4 Aug 2011 11:46:56 -0700
Message-ID: <1312483633-479-2-git-send-email-bprakash@broadcom.com>
References: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1301 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1HDSr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 14:47:26 -0400
In-Reply-To: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Reset max receive frame size every time before attempting FLOGI. Without this,
the stale MFS value will be used.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 7cb2cd4..ea1e6cc 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1735,6 +1735,11 @@ static void bnx2fc_start_disc(struct bnx2fc_interface *interface)
 		if (++wait_cnt > 12)
 			break;
 	}
+
+	/* Reset max receive frame size to default */
+	if (fc_set_mfs(lport, BNX2FC_MFS))
+		return;
+
 	fc_lport_init(lport);
 	fc_fabric_login(lport);
 }
-- 
1.7.0.6


