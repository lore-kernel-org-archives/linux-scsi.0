From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Fri, 18 Sep 2009 08:11:07 -0600
Message-ID: <20090918141106.GA29475@parisc-linux.org>
References: <4AB25F49.4060201@attglobal.net> <1253212785.7845.38.camel@mulgrave.site> <1253219291.7845.152.camel@mulgrave.site> <20090918215950P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41124 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIROLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 10:11:04 -0400
Content-Disposition: inline
In-Reply-To: <20090918215950P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, stunnel@attglobal.net, linux-scsi@vger.kernel.org, bo.yang@lsi.com

On Fri, Sep 18, 2009 at 10:00:53PM +0900, FUJITA Tomonori wrote:
> Let's confirm that dma_map_sg returns an invalid address.
> 
> Eddie, can you try a kernel with the following patch and send kernel
> messages?
> 
> Note that the patch doesn't fix the problem; just print debug
> information.

This is going to be quite noisy, and not give us all that much information.
Why not try this patch instead?

diff --git a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
index ac6855c..a179ff8 100644
--- a/drivers/scsi/scsi_lib_dma.c
+++ b/drivers/scsi/scsi_lib_dma.c
@@ -20,7 +20,8 @@
  */
 int scsi_dma_map(struct scsi_cmnd *cmd)
 {
-	int nseg = 0;
+	int i, nseg = 0;
+	struct scatterlist *sgl;
 
 	if (scsi_sg_count(cmd)) {
 		struct device *dev = cmd->device->host->shost_gendev.parent;
@@ -29,6 +30,11 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
 				  cmd->sc_data_direction);
 		if (unlikely(!nseg))
 			return -ENOMEM;
+		scsi_for_each_sg(cmd, sgl, nseg, i) {
+			if (sg_dma_address(sgl) > *dev->dma_mask) {
+				printk("IOMMU bug, command %d, dma mask %llx, but returned %lx %u for phys %lx\n", cmd->cmnd[0], *dev->dma_mask, (unsigned long)sg_dma_address(sgl), sg_dma_len(sgl), (unsigned long)sg_phys(sgl));
+			}
+		}
 	}
 	return nseg;
 }


> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index 234f0b7..0d0a02f 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -1391,7 +1391,12 @@ megaraid_mbox_mksgl(adapter_t *adapter, scb_t *scb)
>  
>  	scb->dma_type = MRAID_DMA_WSG;
>  
> +	printk("%x %lx\n", scp->cmnd[0],
> +	       (unsigned long)*(scp->device->host->shost_gendev.parent->dma_mask));
> +
>  	scsi_for_each_sg(scp, sgl, sgcnt, i) {
> +		printk("%lx %u\n", (unsigned long)sg_dma_address(sgl),
> +		       sg_dma_len(sgl));
>  		ccb->sgl64[i].address	= sg_dma_address(sgl);
>  		ccb->sgl64[i].length	= sg_dma_len(sgl);
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
