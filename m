From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 07/24] arm: scsi convert to accessors and !use_sg	cleanup
Date: Sun, 16 Dec 2007 17:28:33 +0200
Message-ID: <47654421.1030704@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72AE7.4030507@panasas.com>	 <20070912074205.GB2653@flint.arm.linux.org.uk>	 <46EFE8FF.3010907@panasas.com> <1197678458.3154.119.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19161 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093AbXLPPeg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Dec 2007 10:34:36 -0500
In-Reply-To: <1197678458.3154.119.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Russell King <rmk@arm.linux.org.uk>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>, linux-arm <linux-arm@vger.kernel.org>

On Sat, Dec 15 2007 at 2:27 +0200, James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2007-09-18 at 17:04 +0200, Boaz Harrosh wrote:
>> On Wed, Sep 12 2007 at 10:42 +0300, Russell King <rmk@arm.linux.org.uk> wrote:
>>> On Wed, Sep 12, 2007 at 02:55:19AM +0300, Boaz Harrosh wrote:
>>>> -		if (SCpnt->request_bufflen != len)
>>>> +		if (scsi_bufflen(SCpnt) != len) {
>>>> +			WARN_ON(1);
>>> NAK.  The call trace generally doesn't provide any additional information
>>> on the cause of the error.
>>>
>> In my opinion this can not happen any more. If it does, I want to see that
>> it is not through the regular scsi-ml .queuecommand mechanism.
>> But if you insist than sure I will remove it.
>>
>>>>  			printk(KERN_WARNING "scsi%d.%c: bad request buffer "
>>>>  			       "length %d, should be %ld\n", SCpnt->device->host->host_no,
>>>> -			       '0' + SCpnt->device->id, SCpnt->request_bufflen, len);
>>>> -		SCpnt->request_bufflen = len;
>>>> +			       '0' + SCpnt->device->id, scsi_bufflen(SCpnt), len);
>>>> +		}
>>>>  #endif
>>>>  	} else {
>>>> -		SCpnt->SCp.ptr = (unsigned char *)SCpnt->request_buffer;
>>>> -		SCpnt->SCp.this_residual = SCpnt->request_bufflen;
>>>> -		SCpnt->SCp.phase = SCpnt->request_bufflen;
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * If the upper SCSI layers pass a buffer, but zero length,
>>>> -	 * we aren't interested in the buffer pointer.
>>>> -	 */
>>>> -	if (SCpnt->SCp.this_residual == 0 && SCpnt->SCp.ptr) {
>>>> -#if 0 //def BELT_AND_BRACES
>>>> -		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
>>>> -		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
>>>> -		__scsi_print_command(SCpnt->cmnd);
>>>> -#endif
>>>>  		SCpnt->SCp.ptr = NULL;
>>>> +		SCpnt->SCp.this_residual = 0;
>>>> +		SCpnt->SCp.phase = 0;
>>>>  	}
>>>>  }
>>> Also NAK.  This was added due to bad behaviour of the SCSI layer and
>>> was found to be necessary.
>>>
>> No! This check is no longer Relevant. The master if() is on bufflen() now,
>> and only than do we ever set SCp.ptr. The else will always set both to Zero.
>> (Which is what you want)
>>
>> In any way this check is done in scsi-ml, and since 2.6.18 only scsi-ml
>> can allocate and issue commands. All other sources of commands where removed.
>> All upper layers issue requests now.
> 
> Russell, could you respond to this, please?  Boaz's points seem valid to
> me and this conversion must be done soon otherwise these drivers will
> break.
> 
> James
> 
> 

Reinspecting this code in view of the overall arm-scsi, I conclude that arm
is CURRENTLY BROKEN in 2.6.24-rcx tree. With or without this patch.

Resubmitted in this mail is the sg-safe version of this patch. Maybe
with the bug fixes it will finally be acknowledged by the arm people.

The reason it is currently broken is because of copy_SCp_to_sg() which I did not previously
touched. It is broken both on the account of the wrong assumption about the sg-list 
coming from scsi at SCp.buffer, and because inspecting the code, the sg-list pointed 
to by destination sg is later passed to a DMA mapper and it is not initialized properly.
These and more are fixed in the new patch.

After the new patch, arm drivers are not yet safe for chaining. But the 
arm-scsi-mid-layer is. Meaning, good behaving arm drivers will no longer 
suffer from bugs at the mid-level.

Russell or any other arm person. Please first see if this compiles at all, as I do
not have a cross compiler set up, and please check that this code works.
(Should apply on top of Linus latest)

------
>From f02d6f44c9043258f8aa63c7dfe56c9a67db3fcf Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 9 Sep 2007 21:31:21 +0300
Subject: [PATCH] [SCSI] arm:  sg bugfixes and convert to accessors

 - convert to accessors and !use_sg cleanup
 - fix for sg_chaining bugs

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 drivers/scsi/arm/acornscsi.c |   14 +++---
 drivers/scsi/arm/scsi.h      |   86 ++++++++++++++++++++++++-----------------
 2 files changed, 57 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index eceacf6..3bedf24 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -1790,7 +1790,7 @@ int acornscsi_starttransfer(AS_Host *host)
 	return 0;
     }
 
-    residual = host->SCpnt->request_bufflen - host->scsi.SCp.scsi_xferred;
+    residual = scsi_bufflen(host->SCpnt) - host->scsi.SCp.scsi_xferred;
 
     sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
     sbic_arm_writenext(host->scsi.io_port, residual >> 16);
@@ -2270,7 +2270,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA IN -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_readstatusbyte(host);
@@ -2281,7 +2281,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA IN -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_sendmessage(host);
@@ -2291,7 +2291,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA IN -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_message(host);	/* -> PHASE_MSGIN, PHASE_DISCONNECT		*/
@@ -2319,7 +2319,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA OUT -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2331,7 +2331,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA OUT -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2342,7 +2342,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA OUT -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
index bb6550e..ce7d3d3 100644
--- a/drivers/scsi/arm/scsi.h
+++ b/drivers/scsi/arm/scsi.h
@@ -18,17 +18,32 @@
  * The scatter-gather list handling.  This contains all
  * the yucky stuff that needs to be fixed properly.
  */
+
+/*
+ * copy_SCp_to_sg() Assumes contiguous allocation at @sg of at-most @max
+ * entries of uninitialized memory. SCp is from scsi-ml and has a valid
+ * (possibly chained) sg-list
+ */
 static inline int copy_SCp_to_sg(struct scatterlist *sg, struct scsi_pointer *SCp, int max)
 {
 	int bufs = SCp->buffers_residual;
 
+	/* FIXME: It should be easy for drivers to loop on copy_SCp_to_sg().
+	 * and to remove this BUG_ON. Use min() in-its-place
+	 */
 	BUG_ON(bufs + 1 > max);
 
 	sg_set_buf(sg, SCp->ptr, SCp->this_residual);
 
-	if (bufs)
-		memcpy(sg + 1, SCp->buffer + 1,
-		       sizeof(struct scatterlist) * bufs);
+	if (bufs) {
+		struct scatterlist *src_sg;
+		unsigned i;
+
+		for_each_sg(sg_next(SCp->buffer), src_sg, bufs, i)
+			*(++sg) = *src_sg;
+		sg_mark_end(sg);
+	}
+
 	return bufs + 1;
 }
 
@@ -36,7 +51,7 @@ static inline int next_SCp(struct scsi_pointer *SCp)
 {
 	int ret = SCp->buffers_residual;
 	if (ret) {
-		SCp->buffer++;
+		SCp->buffer = sg_next(SCp->buffer);
 		SCp->buffers_residual--;
 		SCp->ptr = sg_virt(SCp->buffer);
 		SCp->this_residual = SCp->buffer->length;
@@ -68,46 +83,45 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
 {
 	memset(&SCpnt->SCp, 0, sizeof(struct scsi_pointer));
 
-	if (SCpnt->use_sg) {
+	if (scsi_bufflen(SCpnt)) {
 		unsigned long len = 0;
-		int buf;
 
-		SCpnt->SCp.buffer = (struct scatterlist *) SCpnt->request_buffer;
-		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
+		SCpnt->SCp.buffer = scsi_sglist(SCpnt);
+		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
 		SCpnt->SCp.ptr = sg_virt(SCpnt->SCp.buffer);
 		SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.phase = SCpnt->request_bufflen;
+		SCpnt->SCp.phase = scsi_bufflen(SCpnt);
 
 #ifdef BELT_AND_BRACES
-		/*
-		 * Calculate correct buffer length.  Some commands
-		 * come in with the wrong request_bufflen.
-		 */
-		for (buf = 0; buf <= SCpnt->SCp.buffers_residual; buf++)
-			len += SCpnt->SCp.buffer[buf].length;
-
-		if (SCpnt->request_bufflen != len)
-			printk(KERN_WARNING "scsi%d.%c: bad request buffer "
-			       "length %d, should be %ld\n", SCpnt->device->host->host_no,
-			       '0' + SCpnt->device->id, SCpnt->request_bufflen, len);
-		SCpnt->request_bufflen = len;
+		{	/*
+			 * Calculate correct buffer length.  Some commands
+			 * come in with the wrong scsi_bufflen.
+			 */
+			struct scatterlist *sg;
+			unsigned i, sg_count = scsi_sg_count(SCpnt);
+
+			scsi_for_each_sg(SCpnt, sg, sg_count, i)
+				len += sg->length;
+
+			if (scsi_bufflen(SCpnt) != len) {
+				printk(KERN_WARNING
+				       "scsi%d.%c: bad request buffer "
+				       "length %d, should be %ld\n",
+					SCpnt->device->host->host_no,
+					'0' + SCpnt->device->id,
+					scsi_bufflen(SCpnt), len);
+				/*
+				 * FIXME: Totaly naive fixup. We should abort
+				 * with error
+				 */
+				SCpnt->SCp.phase =
+					min(len, scsi_bufflen(SCpnt));
+			}
+		}
 #endif
 	} else {
-		SCpnt->SCp.ptr = (unsigned char *)SCpnt->request_buffer;
-		SCpnt->SCp.this_residual = SCpnt->request_bufflen;
-		SCpnt->SCp.phase = SCpnt->request_bufflen;
-	}
-
-	/*
-	 * If the upper SCSI layers pass a buffer, but zero length,
-	 * we aren't interested in the buffer pointer.
-	 */
-	if (SCpnt->SCp.this_residual == 0 && SCpnt->SCp.ptr) {
-#if 0 //def BELT_AND_BRACES
-		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
-		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
-		__scsi_print_command(SCpnt->cmnd);
-#endif
 		SCpnt->SCp.ptr = NULL;
+		SCpnt->SCp.this_residual = 0;
+		SCpnt->SCp.phase = 0;
 	}
 }
-- 
1.5.3.3

