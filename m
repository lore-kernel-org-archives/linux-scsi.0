From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/5] block-cciss: Move an assignment for the variable
 "sg_used" in cciss_bigpassthru()
Date: Thu, 18 Aug 2016 12:02:10 +0200
Message-ID: <5a957717-4d29-55e1-87a5-c8c9c701ea03@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: esc.storagedev@microsemi.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 17 Aug 2016 23:04:46 +0200

Move the assignment for the local variable "sg_used" behind the source code
for some memory allocations by this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 10e1b0a..b08bfb7 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1575,7 +1575,7 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 	unsigned char **buff;
 	int *buff_size;
 	u64bit temp64;
-	BYTE sg_used = 0;
+	BYTE sg_used;
 	int status;
 	int i;
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -1616,6 +1616,7 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 	}
 	left = ioc->buf_size;
 	data_ptr = ioc->buf;
+	sg_used = 0;
 	while (left) {
 		sz = (left > ioc->malloc_size) ? ioc->malloc_size : left;
 		buff_size[sg_used] = sz;
-- 
2.9.3
