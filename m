From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] hpsa: precedence bug in
 hpsa_wait_for_mode_change_ack()
Date: Mon, 7 Feb 2011 19:59:58 +0300
Message-ID: <20110207165957.GG4384@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59235 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1BGRAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 12:00:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

'!' has higher precedence than '&'.  CFGTBL_ChangeReq is 0x1 so the
original code is equivelent to if (!doorbell_value) {...

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 959eeb2..f46f92a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3591,7 +3591,7 @@ static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 		spin_lock_irqsave(&h->lock, flags);
 		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
 		spin_unlock_irqrestore(&h->lock, flags);
-		if (!doorbell_value & CFGTBL_ChangeReq)
+		if (!(doorbell_value & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
 		usleep_range(10000, 20000);
