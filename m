From: akpm@linux-foundation.org
Subject: [patch 18/19] scsi: remove unnecessary NULL test
Date: Mon, 21 Dec 2009 16:27:55 -0800
Message-ID: <200912220027.nBM0Rt0N005428@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbZLVAfG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2009 19:35:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz, jirislaby@gmail.com, michaelc@cs.wisc.edu

From: Jiri Slaby <jslaby@suse.cz>
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/cxgb3i/cxgb3i_pdu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/cxgb3i/cxgb3i_pdu.c~scsi-remove-unnecessary-null-test drivers/scsi/cxgb3i/cxgb3i_pdu.c
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c~scsi-remove-unnecessary-null-test
+++ a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -461,10 +461,8 @@ void cxgb3i_conn_pdu_ready(struct s3_con
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
_
