From: akpm@linux-foundation.org
Subject: [patch 17/19] SCSI: aacraid, fix memory leak
Date: Mon, 21 Dec 2009 16:27:54 -0800
Message-ID: <200912220027.nBM0Rsh8005425@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbZLVAcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2009 19:32:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jirislaby@gmail.com

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a memory leak on one fail path in aac_send_raw_srb. Add kfree
there.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commctrl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/aacraid/commctrl.c~scsi-aacraid-fix-memory-leak drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c~scsi-aacraid-fix-memory-leak
+++ a/drivers/scsi/aacraid/commctrl.c
@@ -649,6 +649,7 @@ static int aac_send_raw_srb(struct aac_d
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536) {
+					kfree(usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}
_
