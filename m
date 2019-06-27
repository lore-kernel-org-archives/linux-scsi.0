From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 71/87] scsi: 3w-xxxx: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:46:12 +0800
Message-ID: <20190627174612.6366-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/3w-9xxx.c | 2 --
 drivers/scsi/3w-xxxx.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..da17d9104e6b 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -534,8 +534,6 @@ static int twa_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
 		goto out;
 	}
 
-	memset(cpu_addr, 0, size*TW_Q_LENGTH);
-
 	for (i = 0; i < TW_Q_LENGTH; i++) {
 		switch(which) {
 		case 0:
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 2b1e0d503020..26703ef52a2e 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -848,8 +848,6 @@ static int tw_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
 		return 1;
 	}
 
-	memset(cpu_addr, 0, size*TW_Q_LENGTH);
-
 	for (i=0;i<TW_Q_LENGTH;i++) {
 		switch(which) {
 		case 0:
-- 
2.11.0
