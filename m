From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] aha1542: queuecommand: change panic() to return
Date: Sat, 24 Jan 2004 22:00:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040124220006.48dd7746.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:56501 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263637AbUAYGer (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2004 01:34:47 -0500
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

The aha1542 driver calls panic() if kmalloc() fails, which it shouldn't
do. This patch changes that by having the code return a nonzero value, so
it tells the SCSI mid-layer to retry the command, as suggested by Randy.

diff -puN drivers/scsi/aha1542.c~aha1542_qcommand_return drivers/scsi/aha1542.c


 linux-262-rc1-bk1-rddunlap/drivers/scsi/aha1542.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aha1542.c~aha1542_qcommand_return drivers/scsi/aha1542.c
--- linux-262-rc1-bk1/drivers/scsi/aha1542.c~aha1542_qcommand_return	2004-01-23 15:51:47.000000000 -0800
+++ linux-262-rc1-bk1-rddunlap/drivers/scsi/aha1542.c	2004-01-23 15:51:47.000000000 -0800
@@ -708,7 +708,7 @@ static int aha1542_queuecommand(Scsi_Cmn
 		sgpnt = (struct scatterlist *) SCpnt->request_buffer;
 		cptr = (struct chain *) SCpnt->host_scribble;
 		if (cptr == NULL)
-			panic("aha1542.c: unable to allocate DMA memory\n");
+			return 1;
 		for (i = 0; i < SCpnt->use_sg; i++) {
 			if (sgpnt[i].length == 0 || SCpnt->use_sg > 16 ||
 			    (((int) sgpnt[i].offset) & 1) || (sgpnt[i].length & 1)) {

_
