From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 1/4] g_NCR5380: Check for chip presence before calling
 NCR5380_init()
Date: Mon,  5 Dec 2016 01:07:19 -0500 (EST)
Message-ID: <da3aa376f3d93cfef8c7c03793f3ad8a0121e97c.1480917789.git.fthain@telegraphics.com.au>
References: <cover.1480917789.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50466 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbcLEGHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 01:07:22 -0500
In-Reply-To: <cover.1480917789.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Write and read back mode register to check that a chip is really there.
If no card is present, reads result in 0xff.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index de5147a..76e3745 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -248,6 +248,13 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 		}
 	}
 
+	/* Check for vacant slot */
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
2.7.3

