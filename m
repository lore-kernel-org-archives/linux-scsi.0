From: Colin King <colin.king@canonical.com>
Subject: [PATCH] csi: libcxgbi: remove redundant check and close on csk
Date: Thu,  7 Sep 2017 14:51:33 +0100
Message-ID: <20170907135133.16636-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

csk is always null on the error return path and so the non-null
check and call to cxgbi_sock_closed on csk is redundant and
can be removed.

Detected by: CoverityScan CID#114329 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 512c8f1ea5b0..da36c2de069e 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -688,8 +688,6 @@ cxgbi_check_route(struct sockaddr *dst_addr, int ifindex)
 
 rel_rt:
 	ip_rt_put(rt);
-	if (csk)
-		cxgbi_sock_closed(csk);
 err_out:
 	return ERR_PTR(err);
 }
-- 
2.14.1
