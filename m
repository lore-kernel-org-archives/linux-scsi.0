From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: adapter naming fix
Date: Thu, 10 Mar 2005 16:08:32 -0800
Message-ID: <1110499712.5857.67.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:3986 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262818AbVCKAIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2005 19:08:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

>From Mark Salyzyn at Adaptec.  

This fixes the way the aac device's id is calculated.
Applies to scsi-misc-2.6 tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/linit.c 1.46 vs edited =====
--- 1.46/drivers/scsi/aacraid/linit.c	2005-02-03 18:48:49 -08:00
+++ edited/drivers/scsi/aacraid/linit.c	2005-03-10 10:36:35 -08:00
@@ -573,10 +573,9 @@
 	int unique_id = 0;
 
 	list_for_each_entry(aac, &aac_devices, entry) {
-		if (aac->id > unique_id) {
-			insert = &aac->entry;
+		if (aac->id > unique_id)
 			break;
-		}
+		insert = &aac->entry;
 		unique_id++;
 	}
 

-- 
Mark Haverkamp <markh@osdl.org>

