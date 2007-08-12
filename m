From: Rene Herman <rene.herman@gmail.com>
Subject: [PATCH] Re: cciss: warning: right shift count >= width of type
Date: Sun, 12 Aug 2007 03:21:57 +0200
Message-ID: <46BE60B5.7010708@gmail.com>
References: <200708120228.26234.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070202030002060105020500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:42843 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbXHLBmJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Aug 2007 21:42:09 -0400
In-Reply-To: <200708120228.26234.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070202030002060105020500
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 08/12/2007 02:28 AM, Jesper Juhl wrote:

> I've been building some randconfig kernels lately and I've noticed 
> this in a few builds : 
> 
> drivers/block/cciss.c:2614: warning: right shift count >= width of type
> drivers/block/cciss.c:2615: warning: right shift count >= width of type
> drivers/block/cciss.c:2616: warning: right shift count >= width of type
> 
> The code in question is this : 
> 
> static void do_cciss_request(struct request_queue *q)
> {
> ...
>         sector_t start_blk;
> ...
>                         c->Request.CDB[2]= (start_blk >> 56) & 0xff;    //MSB
>                         c->Request.CDB[3]= (start_blk >> 48) & 0xff;
>                         c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> ...
> }
> 
> 
> The problem stems from these lines in include/linux/types.h : 
> ...
> #ifdef CONFIG_LBD
> typedef u64 sector_t;
> #else
> typedef unsigned long sector_t;
> #endif
> ...
> 
> So on a 32bit arch without CONFIG_LBD, sector_t is going to be 32 bits wide.
> Thus it seems gcc is absolutely right in complaining about those 
> 56, 48 & 40 bit shifts, since they are indeed wider than the type 
> in the "!CONFIG_LBD on a 32bit arch" case.
> 
> 
> I must admit that I have no idear what the proper way to deal with 
> that is, so I'll just report it so hopefully someone else can fix it.
> 
> By the way; I'm building current Linus git tree, head at commit 
> ac07860264bd2b18834d3fa3be47032115524cea

Well, given that it's explicitly treating start_blk as a 64-bit value, the 
proper fix is probably to cast start_blk to an actual (guaranteed) 64-bit 
value. Untested, uncompiled, and someone else may disagree:

Rene.

--------------070202030002060105020500
Content-Type: text/plain;
 name="cciss.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cciss.diff"

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5acc6c4..fa2eec8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2609,13 +2609,13 @@ static void do_cciss_request(request_queue_t *q)
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
+			c->Request.CDB[2]= ((u64)start_blk >> 56) & 0xff;	//MSB
+			c->Request.CDB[3]= ((u64)start_blk >> 48) & 0xff;
+			c->Request.CDB[4]= ((u64)start_blk >> 40) & 0xff;
+			c->Request.CDB[5]= ((u64)start_blk >> 32) & 0xff;
+			c->Request.CDB[6]= ((u64)start_blk >> 24) & 0xff;
+			c->Request.CDB[7]= ((u64)start_blk >> 16) & 0xff;
+			c->Request.CDB[8]= ((u64)start_blk >>  8) & 0xff;
 			c->Request.CDB[9]= start_blk & 0xff;
 			c->Request.CDB[10]= (creq->nr_sectors >>  24) & 0xff;
 			c->Request.CDB[11]= (creq->nr_sectors >>  16) & 0xff;

--------------070202030002060105020500--
