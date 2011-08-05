From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 14/18] bnx2fc: Drop incoming ABTS
Date: Thu, 4 Aug 2011 17:38:48 -0700
Message-ID: <1312504732-4572-15-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4919 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab1HEAjV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:21 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

As an initiator, driver need not handle incoming ABTS. It initiates an ABTS if
any IO requests time out.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ca2e206..62c0e94 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -547,6 +547,14 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 			break;
 		}
 	}
+
+	if (fh->fh_r_ctl == FC_RCTL_BA_ABTS) {
+		/* Drop incoming ABTS */
+		put_cpu();
+		kfree_skb(skb);
+		return;
+	}
+
 	if (le32_to_cpu(fr_crc(fp)) !=
 			~crc32(~0, skb->data, fr_len)) {
 		if (stats->InvalidCRCCount < 5)
-- 
1.7.0.6


