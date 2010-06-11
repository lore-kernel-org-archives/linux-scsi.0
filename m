From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/17] libfcoe: Avoid hang when receiving non-critical
	descriptors
Date: Fri, 11 Jun 2010 16:43:38 -0700
Message-ID: <20100611234338.4616.65719.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879Ab0FKXnu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:43:50 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Avoid infinite loop while processing FIP ELS or discovery
advertisement with non-critical descriptors.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Acked-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index cc5e886..66120f1 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -703,7 +703,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 			/* standard says ignore unknown descriptors >= 128 */
 			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
 				return -EINVAL;
-			continue;
+			break;
 		}
 		desc = (struct fip_desc *)((char *)desc + dlen);
 		rlen -= dlen;
@@ -885,7 +885,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			/* standard says ignore unknown descriptors >= 128 */
 			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
 				goto drop;
-			continue;
+			break;
 		}
 		desc = (struct fip_desc *)((char *)desc + dlen);
 		rlen -= dlen;

