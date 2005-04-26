From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Fix adapter open error (resend)
Date: Tue, 26 Apr 2005 14:58:05 -0700
Message-ID: <1114552685.14717.27.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:37331 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261810AbVDZV6J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2005 17:58:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Re-send of a recent patch diffed against the scsi-misc-2.6 git tree.

This fixes an error on the device open code that allows a non-existent
device to be opened causing later panic problems.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

diff -Nru -X scsi-misc-2.6/Documentation/dontdiff -x .git scsi-misc-2.6/drivers/scsi/aacraid/linit.c scsi-misc-work/drivers/scsi/aacraid/linit.c
--- scsi-misc-2.6/drivers/scsi/aacraid/linit.c	2005-04-26 11:24:01.000000000 -0700
+++ scsi-misc-work/drivers/scsi/aacraid/linit.c	2005-04-26 14:40:35.000000000 -0700
@@ -450,7 +450,7 @@
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 /**

-- 
Mark Haverkamp <markh@osdl.org>

