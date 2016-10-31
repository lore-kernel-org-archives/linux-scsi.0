From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 3/6] g_NCR5380: Check for chip presence before calling NCR5380_init()
Date: Mon, 31 Oct 2016 21:18:29 +0100
Message-ID: <1477945112-25659-4-git-send-email-linux@rainbow-software.org>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:36104 "EHLO gsystem.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S946328AbcJaUSt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Oct 2016 16:18:49 -0400
In-Reply-To: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Write and read back MODE_REG to check if the chip is really there
before doing more initialization.

This prevents hang when incorrect I/O address was specified by user (in
the most common case where no device is present there so all reads
result in 0xff).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 0d1f6ad..e713dba 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -322,6 +322,13 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 		}
 	}
 
+	/* check if the chip is really there */
+	NCR5380_write(MODE_REG, 0);
+	if (NCR5380_read(MODE_REG) != 0) {
+		ret = -ENODEV;
+		goto out_unregister;
+	}
+
 	ret = NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP);
 	if (ret)
 		goto out_unregister;
-- 
Ondrej Zary

