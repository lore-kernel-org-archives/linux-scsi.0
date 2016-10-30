From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 3/3] NCR5380: Check for chip presence in NCR5380_init()
Date: Sun, 30 Oct 2016 23:40:03 +0100
Message-ID: <1477867203-7480-3-git-send-email-linux@rainbow-software.org>
References: <1477867203-7480-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:57887 "EHLO gsystem.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752546AbcJ3WkV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Oct 2016 18:40:21 -0400
In-Reply-To: <1477867203-7480-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Read back MODE_REG after writing it in NCR5380_init() to check if the
chip is really there.

This prevents hang when incorrect I/O address was specified by user.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/NCR5380.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 01c0027..ce3156d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -495,6 +495,11 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
+	/* check if the chip is really there */
+	if (NCR5380_read(MODE_REG) != MR_BASE) {
+		NCR5380_exit(instance);
+		return -ENODEV;
+	}
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 
-- 
Ondrej Zary

