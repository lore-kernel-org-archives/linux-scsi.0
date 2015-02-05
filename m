From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] scsi: eata: fix sparse warning
Date: Thu,  5 Feb 2015 12:21:57 +0000
Message-ID: <1423138917-19285-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warning:

eata.c:2049:5: warning: symbol 'eata2x_bios_param' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next (gcc  version 4.9.2,
 sparse version  0.4.5-rc1)and applies on top linux-next.

 drivers/scsi/eata.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c..e178325 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2046,8 +2046,9 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 	return SUCCESS;
 }
 
-int eata2x_bios_param(struct scsi_device *sdev, struct block_device *bdev,
-		      sector_t capacity, int *dkinfo)
+static int
+eata2x_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+		  sector_t capacity, int *dkinfo)
 {
 	unsigned int size = capacity;
 
-- 
1.9.1
