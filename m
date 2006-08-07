From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [PATCH] megaraid: Use the proper type to hold the irq number.
Date: Mon, 07 Aug 2006 09:28:58 -0600
Message-ID: <m1ejvsfttx.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:16260 "EHLO
	ebiederm.dsl.xmission.com") by vger.kernel.org with ESMTP
	id S932158AbWHGPaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:30:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Neela Syam Kolli <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, "Protasevich, Natalie" <Natalie.Protasevich@UNISYS.com>, linux-kernel@vger.kernel.org


When testing on a Unisys machine it was discovered that
the megaraid driver would not initialize as it was
requesting irq 162 instead of irq 1442 it was assigned.
The problem was the irq number had been truncated by being
stored in an unsigned char.

This patches fixes that problem and the driver now appears
to work.

The ioctl interface appears fundamentally broken as it exports
the irq number to user space in an unsigned char. 

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/scsi/megaraid/mega_common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 8cd0bd1..b50e27e 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -175,7 +175,7 @@ typedef struct {
 	uint8_t			max_lun;
 
 	uint32_t		unique_id;
-	uint8_t			irq;
+	int			irq;
 	uint8_t			ito;
 	caddr_t			ibuf;
 	dma_addr_t		ibuf_dma_h;
-- 
1.4.2.rc3.g7e18e

