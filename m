From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] janitor: sg_register error handling
Date: Wed, 17 Sep 2003 14:44:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030917144431.65f6eebd.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:23262 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262878AbTIQWKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Sep 2003 18:10:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: jejb <james.bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


Hi,
Please apply to 2.6.0-test5-current.


From: Daniele Bellucci <bellucda@tiscali.it>

handle register error, call unregister;


 linux-260-test5-kj-rddunlap/drivers/scsi/sg.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sg.c~sgregister drivers/scsi/sg.c
--- linux-260-test5-kj/drivers/scsi/sg.c~sgregister	2003-09-10 15:28:01.000000000 -0700
+++ linux-260-test5-kj-rddunlap/drivers/scsi/sg.c	2003-09-10 15:30:00.000000000 -0700
@@ -1514,8 +1514,10 @@ init_sg(void)
 	if (rc)
 		return rc;
 	rc = scsi_register_interface(&sg_interface);
-	if (rc)
+	if (rc) {
+		unregister_chrdev(SCSI_GENERIC_MAJOR, "sg");
 		return rc;
+	}
 #ifdef CONFIG_SCSI_PROC_FS
 	sg_proc_init();
 #endif				/* CONFIG_SCSI_PROC_FS */

_


--
~Randy
