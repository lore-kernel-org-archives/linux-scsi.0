From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Fw: data disclosure in ioctl sg inquiry
Date: Sun, 2 Sep 2007 23:14:52 +0900
Message-ID: <20070902140541P.tomof@acm.org>
References: <20070902045601.5a18ae56.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:53936 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbXIBOPU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Sep 2007 10:15:20 -0400
In-Reply-To: <20070902045601.5a18ae56.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: strange@nsk.no-ip.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

On Sun, 2 Sep 2007 04:56:01 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> 
> Begin forwarded message:
> 
> Date: Mon, 27 Aug 2007 15:01:33 +0100
> From: Luciano Rocha <strange@nsk.no-ip.org>
> To: linux-kernel@vger.kernel.org
> Subject: data disclosure in ioctl sg inquiry
> 
> 
> 
> (Please keep me CC'ed. Thanks.)
> 
> Hello,
> 
> While testing the SG INQUIRY command to a locked hard drive, connected
> with USB, I noted that the command result included garbage that seemed
> part of some other's process memory. Like bash functions, command
> arguments, etc..
> 
> I make sure to memset the buffers before running the ioctl, so this seem
> to be data leaked from the kernel.
> 
> Most of the code is verbatim from the example in the SCSI Generic HOWTO
> (<http://tldp.org/HOWTO/SCSI-Generic-HOWTO/pexample.html>).
> 
> I include the code I used and sample output with data from running
> processes (or files?).
> 
> I can't reproduce this on a firewire connected HDD, but I can with
> another USB connecte one (not locked).

$ ./keytool /dev/sdb
Some of the INQUIRY command's response:
00 00 00 00 1f 00 00 00 4d 41 58 54 4f 52 20 53  ........MAXTOR S
54 4d 33 32 35 30 38 32 30 41 20 20 20 20 20 20  TM3250820A      
33 2e 41 41 11 00 00 00 23 31 31 38 38 32 32 32  3.AA....#1188222
33 34 30 00 11 00 00 00 48 00 12 08 28 00 12 08  340.....H...(...
00 00 00 00 59 00 00 00 64 69 66 66 20 2d 75 72  ....Y...diff -ur
20 2d 2d 65 78 63 6c 75 64 65 20 2e 73 76 6e 20   --exclude .svn 
INQUIRY duration=3 millisecs, resid=60

Note that resid is 60. So, in your case, only the first 36 bytes are
valid. But I guess that it's not good to leak random kernel data to
user-space.

Can you try this patch?

---
>From 2529dbda52ac2302eab9838910d59e13dedeb3bd Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sun, 2 Sep 2007 13:32:33 +0100
Subject: [PATCH] bio_copy_user use zeroed pages

bio_uncopy_user copies garbage to user-space buffer when the actual
transferred length is shorter than dxfer_len.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 fs/bio.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 29a44c1..26a7669 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -550,11 +550,16 @@ struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
 	ret = 0;
 	while (len) {
 		unsigned int bytes = PAGE_SIZE;
+		gfp_t mask;
 
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | GFP_KERNEL);
+		mask = q->bounce_gfp | GFP_KERNEL;
+		if (write_to_vm)
+			mask |= __GFP_ZERO;
+
+		page = alloc_page(mask);
 		if (!page) {
 			ret = -ENOMEM;
 			break;
-- 
1.5.2.4


