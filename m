From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: Thu, 24 Jun 2004 22:09:41 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40DAC485.2090404@torque.net>
References: <20040508003906.GA26338@gondor.apana.org.au>	<20040519103800.GA9891@gondor.apana.org.au>	<1086026538.2004.7.camel@mulgrave> <40D69F56.2000307@torque.net>	<1087828082.1797.17.camel@mulgrave> <40D924A5.5020705@torque.net> 	<20040623141335.GA23365@infradead.org> <1088005899.1639.9.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080809020906020303020805"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:64775 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S264312AbUFXMK0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 08:10:26 -0400
In-Reply-To: <1088005899.1639.9.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080809020906020303020805
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Wed, 2004-06-23 at 09:13, Christoph Hellwig wrote:
> 
>>There were actually two patches to advansys in that timeframe.  Although
>>it's much more likely that the dma api patch is the culprit can you test
>>with the compat code cleanup patch below reversed?:
> 
> 
> I've got to say I would bet quite a lot on the DMA API conversion being
> the culpret.  Also, because the narrow board works and the wide board
> doesn't, the fault has got to be in adv_build_req().
> 
> There is a logic change in that routine that seems to be a simple
> initialisation clean up, but, since it's in a globally visible
> structure, could be altering the behaviour.  I don't have time to follow
> these structures all around the logic, but just see if this makes the
> problem go away.  (A correct fix, if this is the problem, is going to be
> a bit nasty).

James,
Your patch fixed the PCI wide problem. The attached incorporates
your fix and also fixes the ISA oops. So now all my advansys cards
work.

Changelog:
   - fix PCI wide "use_sg > 0" problem introduced in lk 2.6.7-bk2
   - fix ISA oops (present in all versions of the lk 2.6 series to date)
   - bump version to "3.3K" and add comments
   - fix compilation error when ADVANSYS_DEBUG defined

Doug Gilbert

--------------080809020906020303020805
Content-Type: text/x-patch;
 name="advansys267bk2fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="advansys267bk2fix.diff"

--- linux/drivers/scsi/advansys.c	2004-06-20 13:29:28.000000000 +1000
+++ linux/drivers/scsi/advansys.c267bk2fix	2004-06-24 21:25:34.309239520 +1000
@@ -1,4 +1,4 @@
-#define ASC_VERSION "3.3GJ"    /* AdvanSys Driver Version */
+#define ASC_VERSION "3.3K"    /* AdvanSys Driver Version */
 
 /*
  * advansys.c - Linux Host Driver for AdvanSys SCSI Adapters
@@ -677,6 +677,11 @@
          1. change select_queue_depths to slave_configure
 	 2. make cmd_per_lun be sane again
 
+     3.3K [2004/06/24]:
+         1. continuing cleanup for lk 2.6 series
+         2. Fix problem in lk 2.6.7-bk2 that broke PCI wide cards
+         3. Fix problem that oopsed ISA cards
+
   I. Known Problems/Fix List (XXX)
 
      1. Need to add memory mapping workaround. Test the memory mapping.
@@ -6615,6 +6620,10 @@
      * buffer command.
      */
 
+    scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
+    scsiqp->vdata_addr = scp->request_buffer;
+    scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
+
     if (scp->use_sg == 0) {
         /*
          * CDB request of single contiguous buffer.
@@ -6643,10 +6652,6 @@
 	struct scatterlist *slp;
 	int use_sg;
 
-	scsiqp->data_cnt = 0;
-	scsiqp->vdata_addr = 0;
-	scsiqp->data_addr = 0;
-
 	slp = (struct scatterlist *)scp->request_buffer;
 	use_sg = dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
 
@@ -9198,9 +9203,7 @@
 " timeout_per_command %d, timeout_total %d, timeout %d\n",
         s->timeout_per_command, s->timeout_total, s->timeout);
 
-    printk(
-" internal_timeout %u, flags %u\n",
-        s->internal_timeout, s->flags);
+    printk(" internal_timeout %u\n", s->internal_timeout);
 
     printk(
 " scsi_done 0x%lx, done 0x%lx, host_scribble 0x%lx, result 0x%x\n",
@@ -12011,7 +12014,10 @@
     ushort              pci_device_id;
 
     iop_base = asc_dvc->iop_base;
-    pci_device_id = to_pci_dev(asc_dvc->cfg->dev)->device;
+    if (asc_dvc->cfg->dev)
+        pci_device_id = to_pci_dev(asc_dvc->cfg->dev)->device;
+    else
+	pci_device_id = 0;
     warn_code = 0;
     cfg_msw = AscGetChipCfgMsw(iop_base);
     if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {

--------------080809020906020303020805--
