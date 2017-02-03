From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi, block: fix memory leak of sdpk on when gd fails to allocate
Date: Fri,  3 Feb 2017 19:38:54 +0000
Message-ID: <20170203193854.6782-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

On an allocation failure of gd, the current exit path is via out_free_devt
which leaves sdpk still allocated and hence it gets leaked. Fix this by
correcting the order of resource free'ing with a change in the error exit
path labels.

Detected by CoverityScan, CID#1399519 ("Resource Leak")

Fixes: 0dba1314d4f81115dc ("scsi, block: fix duplicate bdi name registration crashes")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb6e68d..99e1206 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3213,10 +3213,10 @@ static int sd_probe(struct device *dev)
 	sd_devt = NULL;
  out_put:
 	put_disk(gd);
- out_free:
-	kfree(sdkp);
  out_free_devt:
 	kfree(sd_devt);
+ out_free:
+	kfree(sdkp);
  out:
 	scsi_autopm_put_device(sdp);
 	return error;
-- 
2.10.2
