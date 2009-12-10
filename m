From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -3rd repost 2/3] SCSI: remove unnecessary NULL test
Date: Thu, 10 Dec 2009 14:37:03 +0100
Message-ID: <1260452224-31760-2-git-send-email-jslaby@suse.cz>
References: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760695AbZLJNhM@vger.kernel.org>
In-Reply-To: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_pdu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 7091050..64bbc28 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -461,10 +461,8 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 		skb = skb_peek(&c3cn->receive_queue);
 	}
 	read_unlock(&c3cn->callback_lock);
-	if (c3cn) {
-		c3cn->copied_seq += read;
-		cxgb3i_c3cn_rx_credits(c3cn, read);
-	}
+	c3cn->copied_seq += read;
+	cxgb3i_c3cn_rx_credits(c3cn, read);
 	conn->rxdata_octets += read;
 
 	if (err) {
-- 
1.6.5.5
