From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 14/27] drivers/scsi: Use memdup_user
Date: Sat, 22 May 2010 10:22:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005221022180.13021@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/sg.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef752b2..277ace6 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1676,14 +1676,9 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		int len, size = sizeof(struct sg_iovec) * iov_count;
 		struct iovec *iov;
 
-		iov = kmalloc(size, GFP_ATOMIC);
-		if (!iov)
-			return -ENOMEM;
-
-		if (copy_from_user(iov, hp->dxferp, size)) {
-			kfree(iov);
-			return -EFAULT;
-		}
+		iov = memdup_user(hp->dxferp, size);
+		if (IS_ERR(iov))
+			return PTR_ERR(iov);
 
 		len = iov_length(iov, iov_count);
 		if (hp->dxfer_len < len) {
