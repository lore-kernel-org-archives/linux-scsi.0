From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Thu, 05 Apr 2007 19:02:19 -0500
Message-ID: <1175817739.3714.43.camel@mulgrave.il.steeleye.com>
References: <200704052213.l35MDRRR015981@cichlid.com>
	 <20070405.153649.104035809.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753406AbXDFAD6@vger.kernel.org>
In-Reply-To: <20070405.153649.104035809.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: aab@cichlid.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2007-04-05 at 15:36 -0700, David Miller wrote:
> From: Andrew Burgess <aab@cichlid.com>
> Date: Thu, 5 Apr 2007 15:13:27 -0700
> 
> > David, do you see any other problems with scsi_send_eh_cmnd?
> > 
> > I've switched back to 2.6.18 which seems to not oops 
> > and am happy to try patches.
> 
> Does 2.6.20 with my patch OOPS too?  Does reverting my patch
> make the oops go away?
> 
> If reverting my patch makes the OOPS go away, we need to
> verify if page_address() is returning crap for some reason
> or the length is wrong.

Assuming this does turn out to be the problem, we should just junk the
page allocation ... it's completely unnecessary; when the slab allocated
commands were done, we made sure the actual sense_buffer is at the
correct location, so this should be the final fix:

James

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index adb40f2..997532b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -18,12 +18,12 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/string.h>
-#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -641,16 +641,8 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	memcpy(scmd->cmnd, cmnd, cmnd_size);
 
 	if (copy_sense) {
-		gfp_t gfp_mask = GFP_ATOMIC;
-
-		if (shost->hostt->unchecked_isa_dma)
-			gfp_mask |= __GFP_DMA;
-
-		sgl.page = alloc_page(gfp_mask);
-		if (!sgl.page)
-			return FAILED;
-		sgl.offset = 0;
-		sgl.length = 252;
+		sg_init_one(&sgl, scmd->sense_buffer,
+			    sizeof(scmd->sense_buffer));
 
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->request_bufflen = sgl.length;
@@ -721,18 +713,6 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 
 	/*
-	 * Last chance to have valid sense data.
-	 */
-	if (copy_sense) {
-		if (!SCSI_SENSE_VALID(scmd)) {
-			memcpy(scmd->sense_buffer, page_address(sgl.page),
-			       sizeof(scmd->sense_buffer));
-		}
-		__free_page(sgl.page);
-	}
-
-
-	/*
 	 * Restore original data
 	 */
 	scmd->request_buffer = old_buffer;
