From: akpm@linux-foundation.org
Subject: [patch 24/27] drivers/scsi: use memdup_user
Date: Tue, 20 Jul 2010 15:29:04 -0700
Message-ID: <201007202229.o6KMT4oq021794@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932733Ab0GTWiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:38:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, bharrosh@panasas.com, dgilbert@interlog.com

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
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/sg.c~drivers-scsi-use-memdup_user drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~drivers-scsi-use-memdup_user
+++ a/drivers/scsi/sg.c
@@ -1676,14 +1676,9 @@ static int sg_start_req(Sg_request *srp,
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
_
