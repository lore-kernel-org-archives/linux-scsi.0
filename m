From: Dan Carpenter <error27@gmail.com>
Subject: [patch 1/2] be2iscsi: memory leak on error path
Date: Thu, 10 Jun 2010 09:52:21 +0200
Message-ID: <20100610075221.GI5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab0FJHws (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2010 03:52:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

I added a kfree(pwrb_arr) in front of the return.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index dd5b105..779e1d1 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2750,6 +2750,7 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 		if (status != 0) {
 			shost_printk(KERN_ERR, phba->shost,
 				     "wrbq create failed.");
+			kfree(pwrb_arr);
 			return status;
 		}
 		phwi_ctrlr->wrb_context[i * 2].cid = phwi_context->be_wrbq[i].
