From: Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 12:30:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAC6CE5.5020503@us.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040300090706060504070307"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040300090706060504070307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jeffery, David wrote:
> Dave,
> 
> Here's a patch that should restore the queue depths to what they were before
> the
> queue depths change was merged in.  Hopefully this well restore your lost
> performance.  If I don't hear or find anything bad about it, it will be
> going
> to Linus shortly.
> 
> And thanks goes to Mike Anderson for his initial version.  That made writing
> this patch all the easier.

Thank you for taking care of that so quickly.  I've tested it and it 
shows that I'm within 0.5% of where I was before.  this is well within 
the margin of error for my test.

On another (completely cosmetic)  note, ips.c is spitting out warnings 
because of the IPS_*LOCK_RESTORE macros which don't use the flags 
argument in 2.5.  If you're sending an update to Linus, could you 
include something like what I've attached to get rid of them?
-- 
Dave Hansen
haveblue@us.ibm.com

--------------040300090706060504070307
Content-Type: text/plain;
 name="ips-warning-fix-2.5.42+bk-0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ips-warning-fix-2.5.42+bk-0.patch"

--- ips.c.orig	Tue Oct 15 12:24:25 2002
+++ ips.c	Tue Oct 15 12:25:24 2002
@@ -248,8 +248,8 @@
 #else
     #define IPS_SG_ADDRESS(sg)      (page_address((sg)->page) ? \
                                      page_address((sg)->page)+(sg)->offset : 0)
-    #define IPS_LOCK_SAVE(lock,flags) spin_lock(lock)
-    #define IPS_UNLOCK_RESTORE(lock,flags) spin_unlock(lock)
+    #define IPS_LOCK_SAVE(lock,flags) do { spin_lock(lock); (void)flags } while (0)
+    #define IPS_UNLOCK_RESTORE(lock,flags) { spin_unlock(lock); (void)flags } while (0)
 #endif
 
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \

--------------040300090706060504070307--

