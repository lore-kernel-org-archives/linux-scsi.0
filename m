From: Adrian Bunk <bunk@stusta.de>
Subject: [patch] 2.6.10-rc1: SCSI aacraid warning
Date: Fri, 29 Oct 2004 16:37:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041029143712.GM6677@stusta.de>
References: <Pine.LNX.4.58.0410221431180.2101@ppc970.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S263375AbUJ2On0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0410221431180.2101@ppc970.osdl.org>
To: Linus Torvalds <torvalds@osdl.org>, markh@osdl.org
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2004 at 03:05:13PM -0700, Linus Torvalds wrote:
>...
> Summary of changes from v2.6.9 to v2.6.10-rc1
> ============================================
>...
> Mark Haverkamp:
>...
>   o aacraid: dynamic dev update
>...


This causes the following warning with a recent gcc:

<--  snip  -->

...
  CC      drivers/scsi/aacraid/aachba.o
drivers/scsi/aacraid/aachba.c: In function `aac_scsi_cmd':
drivers/scsi/aacraid/aachba.c:1140: warning: integer constant is too large for "long" type
...

<--  snip  -->


The fix is simple:


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm2-full/drivers/scsi/aacraid/aachba.c.old	2004-10-29 16:16:52.000000000 +0200
+++ linux-2.6.10-rc1-mm2-full/drivers/scsi/aacraid/aachba.c	2004-10-29 16:22:14.000000000 +0200
@@ -1137,7 +1137,7 @@
 		char *cp;
 
 		dprintk((KERN_DEBUG "READ CAPACITY command.\n"));
-		if (fsa_dev_ptr[cid].size <= 0x100000000)
+		if (fsa_dev_ptr[cid].size <= 0x100000000ULL)
 			capacity = fsa_dev_ptr[cid].size - 1;
 		else
 			capacity = (u32)-1;
