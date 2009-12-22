From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [patch 18/19] scsi: remove unnecessary NULL test
Date: Mon, 21 Dec 2009 17:10:07 -0800
Message-ID: <8A71B368A89016469F72CD08050AD334070E5070@maui.asicdesigners.com>
References: <200912220027.nBM0Rt0N005428@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:8236 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZLVBD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 20:03:28 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, jslaby@suse.cz, jirislaby@gmail.com, michaelc@cs.wisc.edu

Acked-by: Karen Xie <kxie@chelsio.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
akpm@linux-foundation.org
Sent: Monday, December 21, 2009 4:28 PM
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org;
jslaby@suse.cz; jirislaby@gmail.com; michaelc@cs.wisc.edu
Subject: [patch 18/19] scsi: remove unnecessary NULL test

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

diff -puN
drivers/scsi/cxgb3i/cxgb3i_pdu.c~scsi-remove-unnecessary-null-test
drivers/scsi/cxgb3i/cxgb3i_pdu.c
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
