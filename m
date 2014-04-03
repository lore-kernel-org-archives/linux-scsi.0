From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] nsp32: fix an off by one
Date: Thu, 3 Apr 2014 10:28:53 +0300
Message-ID: <20140403072853.GC14286@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This off by one bug will cause memory corruption when we use every
sglun.

The problem is that NSP32_SG_TABLE_SIZE is too small.  Here is how
it's caculated in the original code:

	sizeof(nsp32_sgtable) * NSP32_SG_SIZE * MAX_TARGET * MAX_LUN

But the problem is that the NSP32_SG_SIZE should be (NSP32_SG_SIZE + 1)
like this:

	sizeof(nsp32_sgtable) * (NSP32_SG_SIZE + 1) * MAX_TARGET * MAX_LUN

Or another more intuitive way to write it would be:

	sizeof(nsp32_sglun) * MAX_TARGET * MAX_LUN

We use NSP32_SG_TABLE_SIZE to allocate data->sg_list which is an array
of nsp32_sglun structs.  The array has MAX_TARGET * MAX_LUN elements.

MAX_TARGET (8) * MAX_LUN (8) = 64 elements.  The missing "+ 1" means
that we only allocate enough space for 63 elements.  In terms of bytes,
the old code allocated 65536 bytes and now it allocates 66048 bytes.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.

diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
index c022182..d94f4cd 100644
--- a/drivers/scsi/nsp32.h
+++ b/drivers/scsi/nsp32.h
@@ -454,7 +454,7 @@ typedef struct _nsp32_sgtable {
 typedef struct _nsp32_sglun {
 	nsp32_sgtable sgt[NSP32_SG_SIZE+1];	/* SG table */
 } __attribute__ ((packed)) nsp32_sglun;
-#define NSP32_SG_TABLE_SIZE (sizeof(nsp32_sgtable) * NSP32_SG_SIZE * MAX_TARGET * MAX_LUN)
+#define NSP32_SG_TABLE_SIZE (sizeof(nsp32_sglun) * MAX_TARGET * MAX_LUN)
 
 /* Auto parameter mode memory map.   */
 /* All values must be little endian. */
