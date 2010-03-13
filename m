From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/16] fcoe: remove an unused variable in fcoe_recv_frame()
Date: Fri, 12 Mar 2010 16:08:18 -0800
Message-ID: <20100313000818.22251.86923.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41281 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAIT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:19 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Remove an unused variable, mac, in fcoe_recv_frame().

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 546e69a..feddb53 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1564,7 +1564,6 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	struct fc_frame_header *fh;
 	struct fcoe_crc_eof crc_eof;
 	struct fc_frame *fp;
-	u8 *mac = NULL;
 	struct fcoe_port *port;
 	struct fcoe_hdr *hp;
 
@@ -1584,13 +1583,9 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 			skb_end_pointer(skb), skb->csum,
 			skb->dev ? skb->dev->name : "<NULL>");
 
-	/*
-	 * Save source MAC address before discarding header.
-	 */
 	port = lport_priv(lport);
 	if (skb_is_nonlinear(skb))
 		skb_linearize(skb);	/* not ideal */
-	mac = eth_hdr(skb)->h_source;
 
 	/*
 	 * Frame length checks and setting up the header pointers

