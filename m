From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: 23 Jun 2004 10:51:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088005899.1639.9.camel@mulgrave>
References: <20040508003906.GA26338@gondor.apana.org.au>
	<20040519103800.GA9891@gondor.apana.org.au>
	<1086026538.2004.7.camel@mulgrave> <40D69F56.2000307@torque.net>
	<1087828082.1797.17.camel@mulgrave> <40D924A5.5020705@torque.net>
	<20040623141335.GA23365@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:26050 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265678AbUFWPwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 11:52:05 -0400
In-Reply-To: <20040623141335.GA23365@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-23 at 09:13, Christoph Hellwig wrote:
> There were actually two patches to advansys in that timeframe.  Although
> it's much more likely that the dma api patch is the culprit can you test
> with the compat code cleanup patch below reversed?:

I've got to say I would bet quite a lot on the DMA API conversion being
the culpret.  Also, because the narrow board works and the wide board
doesn't, the fault has got to be in adv_build_req().

There is a logic change in that routine that seems to be a simple
initialisation clean up, but, since it's in a globally visible
structure, could be altering the behaviour.  I don't have time to follow
these structures all around the logic, but just see if this makes the
problem go away.  (A correct fix, if this is the problem, is going to be
a bit nasty).

James

===== drivers/scsi/advansys.c 1.41 vs edited =====
--- 1.41/drivers/scsi/advansys.c	2004-06-04 06:19:50 -05:00
+++ edited/drivers/scsi/advansys.c	2004-06-23 10:50:01 -05:00
@@ -6615,6 +6615,10 @@
      * buffer command.
      */
 
+    scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
+    scsiqp->vdata_addr = scp->request_buffer;
+    scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
+
     if (scp->use_sg == 0) {
         /*
          * CDB request of single contiguous buffer.
@@ -6642,10 +6646,6 @@
          */
 	struct scatterlist *slp;
 	int use_sg;
-
-	scsiqp->data_cnt = 0;
-	scsiqp->vdata_addr = 0;
-	scsiqp->data_addr = 0;
 
 	slp = (struct scatterlist *)scp->request_buffer;
 	use_sg = dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);

