From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/28] libfc: dereferencing ERR_PTR in fc_tm_done()
Date: Fri, 28 Jan 2011 16:03:31 -0800
Message-ID: <20110129000331.1784.80388.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9625 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1A2ADc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:32 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>

From: Dan Carpenter <error27@gmail.com>

If we goto out, then it tries to call kfree_skb() on an ERR_PTR which
will oops.  Just return directly.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index ba639fa..f4eb1ab 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1323,7 +1323,7 @@ static void fc_tm_done(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		 *
 		 * scsi-eh will escalate for when either happens.
 		 */
-		goto out;
+		return;
 	}
 
 	if (fc_fcp_lock_pkt(fsp))

