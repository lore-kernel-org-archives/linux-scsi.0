From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Fix adapter open error
Date: Wed, 13 Apr 2005 10:38:01 -0700
Message-ID: <1113413882.1509.20.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:45960 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261170AbVDMRiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 13:38:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Ralf =?ISO-8859-1?Q?M=FCller?= <ralf@bj-ig.de>

This fixes an error on the device open code that allows a non-existent
device to be opened causing later panic problems.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/linit.c 1.47 vs edited =====
--- 1.47/drivers/scsi/aacraid/linit.c	2005-03-10 10:36:35 -08:00
+++ edited/drivers/scsi/aacraid/linit.c	2005-04-13 10:34:12 -07:00
@@ -450,7 +450,7 @@
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 /**

-- 
Mark Haverkamp <markh@osdl.org>

