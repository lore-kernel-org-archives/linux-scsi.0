From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] aha1542: add kmalloc type
Date: Sat, 24 Jan 2004 21:58:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040124215801.5db5368d.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:55989 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263620AbUAYGeq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2004 01:34:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb <james.bottomley@steeleye.com>


Hi,
Please apply to 2.6.current.

Thanks,
--
~Randy


From: Timmy Yee <shoujun@masterofpi.org>


Hi,

In drivers/scsi/aha1542.c, kmalloc() is called with no memtype (i.e.
without some flag like GFP_KERNEL). The following patch will fix that.

diff -puN drivers/scsi/aha1542.c~aha1542_kmalloc_type drivers/scsi/aha1542.c


 linux-262-rc1-bk1-rddunlap/drivers/scsi/aha1542.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aha1542.c~aha1542_kmalloc_type drivers/scsi/aha1542.c
--- linux-262-rc1-bk1/drivers/scsi/aha1542.c~aha1542_kmalloc_type	2004-01-23 15:50:19.000000000 -0800
+++ linux-262-rc1-bk1-rddunlap/drivers/scsi/aha1542.c	2004-01-23 15:50:19.000000000 -0800
@@ -704,7 +704,7 @@ static int aha1542_queuecommand(Scsi_Cmn
 #endif
 		int i;
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
-		SCpnt->host_scribble = (unsigned char *) kmalloc(512, GFP_DMA);
+		SCpnt->host_scribble = (unsigned char *) kmalloc(512, GFP_KERNEL | GFP_DMA);
 		sgpnt = (struct scatterlist *) SCpnt->request_buffer;
 		cptr = (struct chain *) SCpnt->host_scribble;
 		if (cptr == NULL)

_
