From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/4] scsi: hpsa: Move a variable assignment in
 hpsa_big_passthru_ioctl()
Date: Mon, 5 Mar 2018 09:34:36 +0100
Message-ID: <b82cc1e8-bea0-c899-6a11-6b54732bdb6f@users.sourceforge.net>
References: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Don Brace <don.brace@microsemi.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 4 Mar 2018 22:16:05 +0100

Move an assignment for the local variable "sg_used" so that its setting
will only be performed after corresponding memory allocations succeeded
by this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/hpsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 86d371ab39e7..bb6df194ac31 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6380,7 +6380,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	unsigned char **buff;
 	int *buff_size;
 	u64 temp64;
-	BYTE sg_used = 0;
+	BYTE sg_used;
 	int status;
 	u32 left;
 	u32 sz;
@@ -6420,6 +6420,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	}
 	left = ioc->buf_size;
 	data_ptr = ioc->buf;
+	sg_used = 0;
 	while (left) {
 		sz = (left > ioc->malloc_size) ? ioc->malloc_size : left;
 		buff_size[sg_used] = sz;
-- 
2.16.2
