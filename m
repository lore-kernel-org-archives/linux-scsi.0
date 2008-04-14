From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/st.c: rename flush_write_buffer()
Date: Mon, 14 Apr 2008 17:17:16 +0300
Message-ID: <20080414141716.GH6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41790 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760824AbYDNOSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 10:18:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes the following namespace collision with 
include/asm-avr32/cacheflush.h :

<--  snip  -->

...
  CC [M]  drivers/scsi/st.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/st.c:629:53: error: macro "flush_write_buffer" passed 1 arguments, but takes just 0
...
make[3]: *** [drivers/scsi/st.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/st.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

3b2cc5fd1bf80d197305c4cffcc029046195c8b2 diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0a52d9d..5b4ab7f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -626,7 +626,7 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 
 
 /* Flush the write buffer (never need to write if variable blocksize). */
-static int flush_write_buffer(struct scsi_tape * STp)
+static int st_flush_write_buffer(struct scsi_tape * STp)
 {
 	int offset, transfer, blks;
 	int result;
@@ -717,7 +717,7 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 		return 0;
 	STps = &(STp->ps[STp->partition]);
 	if (STps->rw == ST_WRITING)	/* Writing */
-		return flush_write_buffer(STp);
+		return st_flush_write_buffer(STp);
 
 	if (STp->block_size == 0)
 		return 0;
@@ -1211,7 +1211,7 @@ static int st_flush(struct file *filp, fl_owner_t id)
 		return 0;
 
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
-		result = flush_write_buffer(STp);
+		result = st_flush_write_buffer(STp);
 		if (result != 0 && result != (-ENOSPC))
 			goto out;
 	}

