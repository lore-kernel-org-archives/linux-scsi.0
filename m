From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/5] drivers/message/fusion: Return -ENOMEM on memory allocation
 failure
Date: Wed, 11 Aug 2010 12:11:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008111211080.8669@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this code, 0 is returned on memory allocation failure, even though other
failures return -ENOMEM or other similar values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptbase.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d8c668d..49f8ec1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -5954,8 +5954,10 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 		goto out;
 
 	mem = kmalloc(iocpage2sz, GFP_KERNEL);
-	if (!mem)
+	if (!mem) {
+		rc = -ENOMEM;
 		goto out;
+	}
 
 	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
 	ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
