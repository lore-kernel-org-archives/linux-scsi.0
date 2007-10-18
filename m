From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/aic7xxx_old.c: fix NULL check
Date: Thu, 18 Oct 2007 12:52:07 +0200
Message-ID: <20071018105207.GK3778@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44758 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762473AbXJRKvk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 06:51:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Commit bbfbbbc1182f8b44c8cc4c99f4a3f3a512149022 accidentally reversed 
the logic of this NULL check.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ee645f41f64ebeb782a0ca2e724dff929f854b68 
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 4025608..8f8db5f 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -8417,7 +8417,7 @@ aic7xxx_alloc(struct scsi_host_template *sht, struct aic7xxx_host *temp)
     p->host = host;
 
     p->scb_data = kzalloc(sizeof(scb_data_type), GFP_ATOMIC);
-    if (!p->scb_data)
+    if (p->scb_data)
     {
       scbq_init (&p->scb_data->free_scbs);
     }

