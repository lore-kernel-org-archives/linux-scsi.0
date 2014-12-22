From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: gdth: fix bad integer overflow check
Date: Mon, 22 Dec 2014 10:51:52 +0300
Message-ID: <20141222075152.GB9737@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The integer overflow check was written incorrectly so it doesn't work.
Whoever wrote this clearly didn't know what they were doing.  (I suck).

Fixes: f63ae56e4e97 ('[SCSI] gdth: integer overflow in ioctl')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 71e1380..0539147 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4175,7 +4175,7 @@ static int ioc_general(void __user *arg, char *cmnd)
         return -EINVAL;
     if (gen.sense_len > INT_MAX)
         return -EINVAL;
-    if (gen.data_len + gen.sense_len > INT_MAX)
+    if (gen.data_len > INT_MAX - gen.sense_len)
         return -EINVAL;
 
     if (gen.data_len + gen.sense_len != 0) {
