From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] fix potential return of uninitialized variable in scsi_scan   (resend)
Date: Sat, 18 Mar 2006 22:42:52 +0100
Message-ID: <200603182242.52507.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.193]:49695 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751026AbWCRVm0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 16:42:26 -0500
Received: by nproxy.gmail.com with SMTP id d4so603094nfe
        for <linux-scsi@vger.kernel.org>; Sat, 18 Mar 2006 13:42:22 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eric Youngdale <eric@andante.org>, "James E. J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Jesper Juhl <jesper.juhl@gmail.com>

( The patch below was already send on March 9, 2006. )
( This is a resend, re-diff'ed against 2.6.16-rc6    )


The coverity checker found out that we potentially return sdev uninitialized.
This should fix coverity #879

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/scsi_scan.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.16-rc6-orig/drivers/scsi/scsi_scan.c	2006-03-12 14:19:00.000000000 +0100
+++ linux-2.6.16-rc6/drivers/scsi/scsi_scan.c	2006-03-18 22:37:53.000000000 +0100
@@ -1277,7 +1277,9 @@ struct scsi_device *__scsi_add_device(st
 					     hostdata);
 		if (res != SCSI_SCAN_LUN_PRESENT)
 			sdev = ERR_PTR(-ENODEV);
-	}
+	} else 
+		sdev = ERR_PTR(-EACCES);
+
 	mutex_unlock(&shost->scan_mutex);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);


