From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -2nd repost 2/4] SCSI: remove unnecessary NULL test
Date: Wed,  4 Nov 2009 17:15:19 +0100
Message-ID: <1257351321-8281-2-git-send-email-jirislaby@gmail.com>
References: <1257351321-8281-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server1.wserver.cz ([82.113.45.157]:34196 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbZKDQPR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 11:15:17 -0500
In-Reply-To: <1257351321-8281-1-git-send-email-jirislaby@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: aacraid@adaptec.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
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
1.6.4.2

