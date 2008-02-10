From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi: Drivers not ready for sg-chaining
Date: Sun, 10 Feb 2008 09:42:46 -0600
Message-ID: <1202658166.3136.44.camel@localhost.localdomain>
References: <478F8435.5000907@panasas.com>  <478F878F.6040807@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42936 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYBJPmy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 10:42:54 -0500
In-Reply-To: <478F878F.6040807@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2008-01-17 at 18:51 +0200, Boaz Harrosh wrote:
> All below drivers are not sg-chain ready do to incomplete software.
>   Once fixed they can move back to SG_ALL. For now they are stuck on
>   SCSI_MAX_SG_SEGMENTS.
> 
>   Affected drivers/files:
> 	drivers/scsi/aha152x.c

This seems to process an element at a time and should be fixed by
sg_next()

> 	drivers/scsi/esp_scsi.[ch]

As does this.

> 	drivers/scsi/imm.c

And this.

> 	drivers/scsi/in2000.h

And this (.c not .h)

> 	drivers/scsi/pcmcia/nsp_cs.c

This uses a software table, so should be fine.

> 	drivers/scsi/ppa.c

This does element at a time, so should be fixed by sg_next()

> 	drivers/scsi/tmscsim.c

as does this.

Given where we are in the cycle, it's probably best just to set SG_ALL
to 128 so there's no possibility of problems.  Individual drivers can
make the tradeoff on how they handle larger lists going beyond this.

James

---

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d1299e9..530ff4c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <scsi/scsi.h>
 
 struct request_queue;
 struct block_device;
@@ -25,12 +26,15 @@ struct blk_queue_tags;
  * NONE: Self evident.	Host adapter is not capable of scatter-gather.
  * ALL:	 Means that the host adapter module can do scatter-gather,
  *	 and that there is no limit to the size of the table to which
- *	 we scatter/gather data.
+ *	 we scatter/gather data.  The value we set here is the maximum
+ *	 single element sglist.  To use chained sglists, the adapter
+ *	 has to set a value beyond ALL (and correctly use the chain
+ *	 handling API.
  * Anything else:  Indicates the maximum number of chains that can be
  *	 used in one scatter-gather request.
  */
 #define SG_NONE 0
-#define SG_ALL 0xff
+#define SG_ALL	SCSI_MAX_SG_SEGMENTS
 
 #define MODE_UNKNOWN 0x00
 #define MODE_INITIATOR 0x01


James


