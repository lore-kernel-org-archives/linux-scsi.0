From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH] Re: cciss: warning: right shift count >= width of type
Date: Sun, 12 Aug 2007 21:55:02 +0200
Message-ID: <46BF6596.8040803@gmail.com>
References: <200708120228.26234.jesper.juhl@gmail.com> <46BE60B5.7010708@gmail.com> <20070812065806.GC21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010508030805030203090308"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46662 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934581AbXHLT6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 15:58:37 -0400
In-Reply-To: <20070812065806.GC21089@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010508030805030203090308
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 08/12/2007 08:58 AM, Al Viro wrote:

> On Sun, Aug 12, 2007 at 03:21:57AM +0200, Rene Herman wrote:

>> +			c->Request.CDB[2]= ((u64)start_blk >> 56) & 0xff;	//MSB
>> +			c->Request.CDB[3]= ((u64)start_blk >> 48) & 0xff;
>> +			c->Request.CDB[4]= ((u64)start_blk >> 40) & 0xff;
>> +			c->Request.CDB[5]= ((u64)start_blk >> 32) & 0xff;
>> +			c->Request.CDB[6]= ((u64)start_blk >> 24) & 0xff;
>> +			c->Request.CDB[7]= ((u64)start_blk >> 16) & 0xff;
>> +			c->Request.CDB[8]= ((u64)start_blk >>  8) & 0xff;
> 
> 	put_unaligned(cpu_to_be64(start_blk), &c->Request.CDB[2]);
> 
> which is what's happening here anyway.

Well, yes. There are a few more of these in the driver and this wants a 
maintainer (whom I can't reach @hp.com) comment.

Is that 16-bit one for CCISS_READ_10 really right? Either:

put_unaligned(cpu_to_be32(creq->nr_sectors), &c->Request.CDB[6]);

or possibly:

put_unaligned(cpu_to_be16(creq->nr_sectors), &c->Request.CDB[8]);

would look less surprising than the current 16-bit in 24-bit thing and the 
"sect >> 24" comment there seems to imply the first?

(the implcit downcasting in that case is fine, right?)

Rene.

--------------010508030805030203090308
Content-Type: text/plain;
 name="cciss.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cciss.diff"

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5acc6c4..9fb6b3c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -40,6 +40,7 @@
 #include <linux/blktrace_api.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm/unaligned.h>
 
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
@@ -1711,10 +1712,7 @@ static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff, size_
 			c->Request.Type.Direction = XFER_READ;
 			c->Request.Timeout = 0;
 			c->Request.CDB[0] = cmd;
-			c->Request.CDB[6] = (size >> 24) & 0xFF;	//MSB
-			c->Request.CDB[7] = (size >> 16) & 0xFF;
-			c->Request.CDB[8] = (size >> 8) & 0xFF;
-			c->Request.CDB[9] = size & 0xFF;
+			put_unaligned(cpu_to_be32(size), &c->Request.CDB[6]);
 			break;
 
 		case CCISS_READ_CAPACITY:
@@ -1735,12 +1733,7 @@ static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff, size_
 			c->Request.Timeout = 0;
 			c->Request.CDB[0] = cmd;
 			c->Request.CDB[1] = 0x10;
-			c->Request.CDB[10] = (size >> 24) & 0xFF;
-			c->Request.CDB[11] = (size >> 16) & 0xFF;
-			c->Request.CDB[12] = (size >> 8) & 0xFF;
-			c->Request.CDB[13] = size & 0xFF;
-			c->Request.Timeout = 0;
-			c->Request.CDB[0] = cmd;
+			put_unaligned(cpu_to_be32(size), &c->Request.CDB[10]);
 			break;
 		case CCISS_CACHE_FLUSH:
 			c->Request.CDBLen = 12;
@@ -2598,29 +2591,15 @@ static void do_cciss_request(request_queue_t *q)
 	if (likely(blk_fs_request(creq))) {
 		if(h->cciss_read == CCISS_READ_10) {
 			c->Request.CDB[1] = 0;
-			c->Request.CDB[2] = (start_blk >> 24) & 0xff;	//MSB
-			c->Request.CDB[3] = (start_blk >> 16) & 0xff;
-			c->Request.CDB[4] = (start_blk >> 8) & 0xff;
-			c->Request.CDB[5] = start_blk & 0xff;
-			c->Request.CDB[6] = 0;	// (sect >> 24) & 0xff; MSB
-			c->Request.CDB[7] = (creq->nr_sectors >> 8) & 0xff;
-			c->Request.CDB[8] = creq->nr_sectors & 0xff;
+			put_unaligned(cpu_to_be32(start_blk), &c->Request.CDB[2]);
+			c->Request.CDB[6] = 0;
+			put_unaligned(cpu_to_be16(creq->nr_sectors), &c->Request.CDB[7]);
 			c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
 		} else {
 			c->Request.CDBLen = 16;
 			c->Request.CDB[1]= 0;
-			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
-			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
-			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
-			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
-			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
-			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
-			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
-			c->Request.CDB[9]= start_blk & 0xff;
-			c->Request.CDB[10]= (creq->nr_sectors >>  24) & 0xff;
-			c->Request.CDB[11]= (creq->nr_sectors >>  16) & 0xff;
-			c->Request.CDB[12]= (creq->nr_sectors >>  8) & 0xff;
-			c->Request.CDB[13]= creq->nr_sectors & 0xff;
+			put_unaligned(cpu_to_be64(start_blk), &c->Request.CDB[2]);
+			put_unaligned(cpu_to_be32(creq->nr_sectors), &c->Request.CDB[10]);
 			c->Request.CDB[14] = c->Request.CDB[15] = 0;
 		}
 	} else if (blk_pc_request(creq)) {

--------------010508030805030203090308--
