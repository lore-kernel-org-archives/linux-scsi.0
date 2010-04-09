From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/12] fnic: Change fnic_flush_tx() to flush tx instead of rx
	queue
Date: Fri, 09 Apr 2010 14:22:49 -0700
Message-ID: <20100409212249.1968.92840.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41770 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab0DIVWu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:50 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Brian Uchino <buchino@cisco.com>, Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Brian Uchino <buchino@cisco.com>

fnic_flush_tx() is used to send frames held while fabric login
is in progress.  The frames are held in tx_queue, but
fnic_flush_tx() was incorrectly flushing from recv_queue which
is used for received frames.

Signed-off-by:  Brian Uchino <buchino@cisco.com>
Signed-off-by:  Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic_fcs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 5259888..2b48d79 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -617,7 +617,7 @@ void fnic_flush_tx(struct fnic *fnic)
 	struct sk_buff *skb;
 	struct fc_frame *fp;
 
-	while ((skb = skb_dequeue(&fnic->frame_queue))) {
+	while ((skb = skb_dequeue(&fnic->tx_queue))) {
 		fp = (struct fc_frame *)skb;
 		fnic_send_frame(fnic, fp);
 	}

