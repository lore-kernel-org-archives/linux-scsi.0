From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: Further aacraid work
Date: 17 Jun 2004 14:16:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087499793.1795.55.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2402C@otce2k03.adaptec.com>
	<1087484107.2090.42.camel@mulgrave>
	<20040617145808.GA29938@devserv.devel.redhat.com>
	<1087485308.2711.36.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:25784 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261897AbUFQTQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 15:16:44 -0400
In-Reply-To: <1087485308.2711.36.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Alan Cox <alan@redhat.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-06-17 at 10:15, Arjan van de Ven wrote:
> probably because of the buddy grouping/ungrouping;

Actually, doesn't seem to be.  I instrumented clustering in 53c700 with
the patch below and then tried a BK based I/O stress test on a freshly
booted system (although any driver that is capable of coping with
clustering can be instrumented like this).

The results were 20 segments coalesced without the patch and 16 with it,
so I'd say within the margins of error that your patch has no effect on
trying to make the system allocate contiguous pages.

I suppose someone who has more time should try a longer running test.

James

===== drivers/scsi/53c700.c 1.50 vs edited =====
--- 1.50/drivers/scsi/53c700.c	Sun Mar 14 11:09:55 2004
+++ edited/drivers/scsi/53c700.c	Thu Jun 17 13:40:48 2004
@@ -329,7 +329,7 @@
 	tpnt->can_queue = NCR_700_COMMAND_SLOTS_PER_HOST;
 	tpnt->sg_tablesize = NCR_700_SG_SEGMENTS;
 	tpnt->cmd_per_lun = NCR_700_CMD_PER_LUN;
-	tpnt->use_clustering = DISABLE_CLUSTERING;
+	tpnt->use_clustering = ENABLE_CLUSTERING;
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
 	
@@ -1872,8 +1872,20 @@
 		__u32 count = 0;
 
 		if(SCp->use_sg) {
+			static int total = 0;
+			int diff = 0,i;
+			for (i=0; i<SCp->use_sg; i++) {
+				struct scatterlist *sg = &((struct scatterlist *)SCp->buffer)[i];
+				int size = sg->length + sg->offset;
+				if(size > PAGE_SIZE)
+					diff += size / PAGE_SIZE;
+			}
 			sg_count = dma_map_sg(hostdata->dev, SCp->buffer,
 					      SCp->use_sg, direction);
+			total += diff;
+			if(diff)
+				printk("SG Coalesced %d segments (total %d)\n",
+				       diff, total);
 		} else {
 			vPtr = dma_map_single(hostdata->dev,
 					      SCp->request_buffer, 

