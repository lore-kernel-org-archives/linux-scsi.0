From: akpm@osdl.org
Subject: [patch 15/28] megaraid: Use the proper type to hold the irq number.
Date: Mon, 25 Sep 2006 16:59:01 -0700
Message-ID: <200609252359.k8PNx1QD003497@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29371 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751760AbWIYX7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, ebiederm@xmission.com, Neela.Kolli@engenio.com, Seokmann.Ju@lsil.com

From: Eric W. Biederman <ebiederm@xmission.com>

When testing on a Unisys machine it was discovered that the megaraid driver
would not initialize as it was requesting irq 162 instead of irq 1442 it
was assigned.  The problem was the irq number had been truncated by being
stored in an unsigned char.

This patches fixes that problem and the driver now appears to work.

The ioctl interface appears fundamentally broken as it exports the irq
number to user space in an unsigned char.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Neela Syam Kolli<Neela.Kolli@engenio.com>
Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid/mega_common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/mega_common.h~megaraid-use-the-proper-type-to-hold-the-irq-number drivers/scsi/megaraid/mega_common.h
--- a/drivers/scsi/megaraid/mega_common.h~megaraid-use-the-proper-type-to-hold-the-irq-number
+++ a/drivers/scsi/megaraid/mega_common.h
@@ -175,7 +175,7 @@ typedef struct {
 	uint8_t			max_lun;
 
 	uint32_t		unique_id;
-	uint8_t			irq;
+	int			irq;
 	uint8_t			ito;
 	caddr_t			ibuf;
 	dma_addr_t		ibuf_dma_h;
_
