From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/16] fcoe: prep work to start consolidate the usage of
 fcoe_netdev
Date: Wed, 12 Dec 2012 15:22:51 -0800
Message-ID: <20121212232251.13084.55507.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:10650 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab2LLXWw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:22:52 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Currently, in the default kernel fcoe driver, it is needed to get to the underlying
private per fcoe transport's private structure, e.g., fcoe_interface in
fcoe.ko, and returns the associated netdev. The similar logic exists in other
fcoe drivers, e.g., bnx2fc, so we add a function pointer into the common
fcoe_port struct to allow individual fcoe transport implementaion (fcoe
and bnx2fc) to get the corresponding netdev associated with a give lport.

Then a inline fcoe_get_netdev() is added as part of libfcoe for all underlying
fcoe transport drivers to use regardless of its individual fcoe transport
driver, and also allows move more common code such as fcoe_link_speed_update or
fcoe_ctlr_get_lesb to be in libfcoe, rather than specific to fcoe.

This patch is a prep work that adds aforementioned fucntion pointer, and
followed by the actual code changes to make use of it.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 include/scsi/libfcoe.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 6add37a..52bba71 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -351,6 +351,7 @@ struct fcoe_port {
 	struct timer_list     timer;
 	struct work_struct    destroy_work;
 	u8		      data_src_addr[ETH_ALEN];
+	struct net_device * (*get_netdev)(const struct fc_lport *lport);
 };
 void fcoe_clean_pending_queue(struct fc_lport *);
 void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb);

