From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] Fix problem with size of allocation in libsas
Date: Mon, 12 Nov 2007 00:24:54 +0100
Message-ID: <200711120024.54773.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:44303 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbXKKX33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Nov 2007 18:29:29 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1253683mue
        for <linux-scsi@vger.kernel.org>; Sun, 11 Nov 2007 15:29:28 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>

From: Jesper Juhl <jesper.juhl@gmail.com>

in sas_get_phy_change_count(), the line
	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
will allocate 56 bytes due to this define:
	#define DISCOVER_RESP_SIZE 56
But, the struct is actually 60 bytes in size.

So change the define to be 
	#define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
so we always get the correct size even when people 
fiddle with the structure.

This change also fixes the same problem in 
sas_get_phy_attached_sas_addr()

(Found by the Coverity checker. Compile tested only)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 sas_expander.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 8727436..a666cb1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -211,7 +211,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 }
 
 #define DISCOVER_REQ_SIZE  16
-#define DISCOVER_RESP_SIZE 56
+#define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
 
 static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 				      u8 *disc_resp, int single)



