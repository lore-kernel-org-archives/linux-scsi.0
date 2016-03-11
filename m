From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 07/11] scsi/fcoe: drop the crc_eof page early
Date: Fri, 11 Mar 2016 16:28:59 +0100
Message-ID: <1457710143-29182-8-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37902 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbcCKP3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:24 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

On cleanup we free the crc_eof_page after all skbs are freed. There is
no reason why it can't be done earlier. We hold a reference to that page
and each skb does.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/fcoe/fcoe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 15826094cc65..4a877ab95d44 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1299,6 +1299,8 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	p->crc_eof_offset = 0;
 	spin_unlock_bh(&p->fcoe_rx_list.lock);
 
+	if (crc_eof)
+		put_page(crc_eof);
 	/*
 	 * Don't bother moving the skb's if this context is running
 	 * on the same CPU that is having its thread destroyed. This
@@ -1342,9 +1344,6 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 
 	if (thread)
 		kthread_stop(thread);
-
-	if (crc_eof)
-		put_page(crc_eof);
 }
 
 /**
-- 
2.7.0

