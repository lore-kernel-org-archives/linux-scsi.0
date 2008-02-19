From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Tue, 19 Feb 2008 09:11:21 +0900
Message-ID: <20080219091121I.fujita.tomonori@lab.ntt.co.jp>
References: <20080217233701.GA30994@tpepper-t42p.dolavim.us>
	<20080218223246I.tomof@acm.org>
	<20080218233057.GC12905@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:44747 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYBSAZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 19:25:43 -0500
In-Reply-To: <20080218233057.GC12905@tpepper-t42p.dolavim.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Mon, 18 Feb 2008 15:30:58 -0800
Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> On Mon 18 Feb at 22:32:46 +0900 tomof@acm.org said:
> > 
> > diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> > index 05bb6ea..39cdd68 100644
> > --- a/drivers/scsi/ips.c
> > +++ b/drivers/scsi/ips.c
> > @@ -6906,7 +6906,7 @@ ips_register_scsi(int index)
> >  	sh->max_channel = ha->nbus - 1;
> >  	sh->can_queue = ha->max_cmds - 1;
> > 
> > -	scsi_add_host(sh, NULL);
> > +	scsi_add_host(sh, &ha->pcidev->dev);
> >  	scsi_scan_host(sh);
> > 
> >  	return 0;
> 
> Fujita-san,
> 
> This applies and runs well on top of your 0005 patch!  The rest of the
> patches also then apply in order and run successfully.

Great, thanks a lot!


> Just to confirm, I applied the above alone to a clean 2.6.24 and things
> again build and run successfully.  For completeness I also reproduced
> the problem against 2.6.23.16 and verified the above patch fixes on that
> kernel version as well.

Nice. There is another bug on 2.6.24 but we rarely hit this so 2.6.24
works most of the time:

http://marc.info/?l=linux-scsi&m=120303487528875&w=2


> Assuming this patch is accepted for 2.6.25, please also queue it for
> the 2.6.23/24 stable trees.

Yes, I will take care about it.

Can you please help me just once more? 2.6.25-rc2 fixed this bug in a
bit different way by chance. Please test 2.6.25-rc2 with the attached
patch to make sure that ips in 2.6.25 works well.


> Thank you very much for your help in tracking this issue down!

No problem. I should have fixed it long time ago. Really sorry about
it.


diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bb152fb..429592a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1576,7 +1576,7 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 	METHOD_TRACE("ips_make_passthru", 1);
 
         scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
-                length += sg[i].length;
+                length += sg->length;
 
 	if (length < sizeof (ips_passthru_t)) {
 		/* wrong size */
@@ -3510,15 +3510,16 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
         struct scatterlist *sg = scsi_sglist(scmd);
 
         for (i = 0, xfer_cnt = 0;
-             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
-                min_cnt = min(count - xfer_cnt, sg[i].length);
+             (i < scsi_sg_count(scmd)) && (xfer_cnt < count);
+             i++, sg = sg_next(sg)) {
+                min_cnt = min(count - xfer_cnt, sg->length);
 
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
                 memcpy(buffer, &cdata[xfer_cnt], min_cnt);
-                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
                 local_irq_restore(flags);
 
                 xfer_cnt += min_cnt;
@@ -3543,15 +3544,16 @@ ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
         struct scatterlist *sg = scsi_sglist(scmd);
 
         for (i = 0, xfer_cnt = 0;
-             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
-                min_cnt = min(count - xfer_cnt, sg[i].length);
+             (i < scsi_sg_count(scmd)) && (xfer_cnt < count);
+             i++, sg = sg_next(sg)) {
+                min_cnt = min(count - xfer_cnt, sg->length);
 
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
                 memcpy(&cdata[xfer_cnt], buffer, min_cnt);
-                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
                 local_irq_restore(flags);
 
                 xfer_cnt += min_cnt;
