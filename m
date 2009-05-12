From: akpm@linux-foundation.org
Subject: [patch 9/9] scsi tape: fix gcc 4.4 warning
Date: Tue, 12 May 2009 13:49:48 -0700
Message-ID: <200905122109.n4CL94nv011440@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbZELVk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 17:40:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, kai.makisara@kolumbus.fi, sergey.senozhatsky@mail.by

From: Kai Makisara <Kai.Makisara@kolumbus.fi>

This patch fixes the GCC 4.4 warning reported by David Binderman and Sergey
Senozhatsky. The old version was working correctly but was not easy to read.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/st.c~scsi-tape-fix-gcc-44-warning drivers/scsi/st.c
--- a/drivers/scsi/st.c~scsi-tape-fix-gcc-44-warning
+++ a/drivers/scsi/st.c
@@ -2964,7 +2964,7 @@ static int st_int_ioctl(struct scsi_tape
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
-				STp->use_pf = !STp->use_pf | PF_TESTED;
+				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
 				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
_
