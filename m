From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/11] fcoe: kfree() -> kfree_skb()
Date: Tue, 21 Apr 2009 16:27:25 -0700
Message-ID: <20090421232724.8165.38828.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbZDUX10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:27:26 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Robert Love <robert.w.love@intel.com>

From: Dan Carpenter <error27@gmail.com>

sk_buff pointers should use kfree_skb() instead of vanilla kfree().

Sorry if this is the wrong CC list.
Found by smatch (http://repo.or.cz/w/smatch.git).

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 94e1e31..13a0a6f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1011,7 +1011,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	wlen = skb->len / FCOE_WORD_TO_BYTE;
 
 	if (!lp->link_up) {
-		kfree(skb);
+		kfree_skb(skb);
 		return 0;
 	}
 

