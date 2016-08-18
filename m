From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/5] block-cciss: Replace three kzalloc() calls by kcalloc()
Date: Thu, 18 Aug 2016 12:03:28 +0200
Message-ID: <8f32c3e7-bfb6-f88b-4894-338b94a0d1da@users.sourceforge.net>
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
Date: Thu, 18 Aug 2016 11:26:18 +0200

* The script "checkpatch.pl" can point information out like the following.

  WARNING: Prefer kcalloc over kzalloc with multiply

  Thus fix the affected source code places.

* Replace the specification of data structures by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b08bfb7..3502a3a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1604,12 +1604,12 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 		status = -EINVAL;
 		goto free_ioc;
 	}
-	buff_size = kmalloc(MAXSGENTRIES * sizeof(int), GFP_KERNEL);
+	buff_size = kcalloc(MAXSGENTRIES, sizeof(*buff_size), GFP_KERNEL);
 	if (!buff_size) {
 		status = -ENOMEM;
 		goto free_ioc;
 	}
-	buff = kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);
+	buff = kcalloc(MAXSGENTRIES, sizeof(*buff), GFP_KERNEL);
 	if (!buff) {
 		status = -ENOMEM;
 		goto free_size;
@@ -4838,8 +4838,9 @@ static int cciss_allocate_scatterlists(ctlr_info_t *h)
 	int i;
 
 	/* zero it, so that on free we need not know how many were alloc'ed */
-	h->scatter_list = kzalloc(h->max_commands *
-				sizeof(struct scatterlist *), GFP_KERNEL);
+	h->scatter_list = kcalloc(h->max_commands,
+				  sizeof(*h->scatter_list),
+				  GFP_KERNEL);
 	if (!h->scatter_list)
 		return -ENOMEM;
 
-- 
2.9.3
