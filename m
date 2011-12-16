From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fcoe: remove double check if skb is nonlinear
Date: Fri, 16 Dec 2011 14:24:49 -0800
Message-ID: <20111216222449.24177.48242.stgit@localhost6.localdomain6>
References: <20111216222444.24177.32377.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1LPWYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 17:24:52 -0500
In-Reply-To: <20111216222444.24177.32377.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: patrick kelle <patrick.kelle81@gmail.com>

skb_linearize already has a check for skb_is_nonlinear,
there is no need to duplicate the check in fcoe.c. This
patch simply removes the unnecessary check and calls
skb_linearize unconditionally.

Reported-by: patrick kelle <patrick.kelle81@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Acked-by: patrick kelle <patrick.kelle81@gmail.com>
---
 drivers/scsi/fcoe/fcoe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c18e201..b40d11d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1670,8 +1670,7 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 			skb->dev ? skb->dev->name : "<NULL>");
 
 	port = lport_priv(lport);
-	if (skb_is_nonlinear(skb))
-		skb_linearize(skb);	/* not ideal */
+	skb_linearize(skb); /* check for skb_is_nonlinear is within skb_linearize */
 
 	/*
 	 * Frame length checks and setting up the header pointers

