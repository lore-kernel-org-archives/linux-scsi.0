From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid bad queuecommand return
Date: Fri, 19 Nov 2004 07:32:34 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B6947FE@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:9441 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261372AbUKSMch convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 07:32:37 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

In the patch I supplied, I dropped the result setting and aac_io_done
and let the midlayer retry on the none-zero return.

Which is more efficient?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jens Axboe
Sent: Friday, November 19, 2004 3:59 AM
To: linux-scsi@vger.kernel.org; James Bottomley
Subject: [PATCH] aacraid bad queuecommand return

Hi,

aac_read() and aac_write() may complete a command but return -1, which
is propagated through aac_scsi_cmd() to the mid layer through
->queuecommand. If the command has been completed, it must return 0.

Signed-off-by: Jens Axboe <axboe@suse.de>


===== drivers/scsi/aacraid/aachba.c 1.29 vs edited =====
--- 1.29/drivers/scsi/aacraid/aachba.c	2004-10-01 17:10:08 +02:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-11-18 23:10:40
+01:00
@@ -894,7 +894,7 @@ int aac_read(struct scsi_cmnd * scsicmd,
 	aac_io_done(scsicmd);
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
-	return -1;
+	return 0;
 }
 
 static int aac_write(struct scsi_cmnd * scsicmd, int cid)
@@ -928,7 +928,7 @@ static int aac_write(struct scsi_cmnd * 
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
 		scsicmd->result = DID_ERROR << 16;
 		aac_io_done(scsicmd);
-		return -1;
+		return 0;
 	}
 	fib_init(cmd_fibcontext);
 
@@ -1004,7 +1004,7 @@ static int aac_write(struct scsi_cmnd * 
 
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
-	return -1;
+	return 0;
 }
 
 
-- 
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
