From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Add Promise SuperTrak EX 'stex' driver
Date: Tue, 08 Aug 2006 21:37:14 -0400
Message-ID: <44D93C4A.2030106@garzik.org>
References: <20060808120507.GA20032@havoc.gtf.org>	 <1155053479.26517.20.camel@mulgrave.il.steeleye.com>	 <44D91667.8030000@garzik.org> <1155079576.26517.91.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080604090507070107020205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51605 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030402AbWHIBhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2006 21:37:17 -0400
In-Reply-To: <1155079576.26517.91.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, promise_linux@promise.com, akpm@osdl.org

This is a multi-part message in MIME format.
--------------080604090507070107020205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> However, I'll take on some of this ... I'll convert the aic7xxx driver
> which is our current shared host tag driver ... then you only need copy
> it to do stex.

No, that approach still has the problems outlined for stex.

You are taking a WORKING, IN-TREE driver and modifying it.  Thus 'git 
bisect' can easily identify any problems you introduce.

As has been stated repeatedly, stex should have the same conditions you 
are giving yourself:  take a working, in-tree driver and update it to 
use host-wide tags.

Otherwise, you deny testers and developers the utility of 'git bisect' 
if there are problems that do not show up immediately.


> No, sorry, misquoted ... the above comment applies to the case
> PASSTHRU_CMD, which has the same problem (it would repeat a malformed
> command).

DID_ERROR is not flagging a malformed command.

PASSTHRU_CMD either (a) passes the command to the firmware, using normal 
queue/complete paths, or (b) handles the command in the driver.

For the (b) case, DID_ERROR is only asserted if scsi_kmap_atomic_sg() 
returns NULL -- presumably a transient condition.


>>> This should be dma_alloc_coherent, not pci_alloc_consistent.
>> This is perfectly normal and proper in a PCI-only driver.  pci_xxx is 
>> not a deprecated API, it is a convenience API.
>>
>> Using dma_xxx only causes needless work.
> 
> What work?  it's an exact drop in replacement.  However, the only usage

No, it's not.  Using struct device rather than struct pci_dev introduces 
additional indirection into the driver, rather than hiding it in a 
convenience layer.  Nice and clean 'pdev' reference becomes '&pdev->dev' 
or 'to_pci_dev(dev)'.


> of pci_xxx I'm requiring to be fixed is the pci_alloc_consistent,
> primarily because pci_alloc_consistent *is* deprecated: it forces a
> GFP_ATOMIC allocation of a potentially large amount of data.
> dma_alloc_coherent allows you to specify gfp flags, which, in this case,
> should be GFP_KERNEL.

Good point, I had forgotten about GFP_KERNEL.  Agreed.  Updated as shown 
in the attached patch.

Sounds like we need a pci_{alloc,free}_coherent wrapper API.

	Jeff




--------------080604090507070107020205
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

commit 5b5464d78665b1b2199b02d827a3c5f85dbe2c4b
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Aug 8 21:34:17 2006 -0400

    [SCSI] stex: use dma_alloc_coherent()

    pci_alloc_consistent() API prevents us from using GFP_KERNEL.

5b5464d78665b1b2199b02d827a3c5f85dbe2c4b
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f35833a..fceae17 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1112,8 +1112,8 @@ stex_probe(struct pci_dev *pdev, const s
 		goto out_iounmap;
 	}
 
-	hba->dma_mem = pci_alloc_consistent(pdev,
-		STEX_BUFFER_SIZE, &hba->dma_handle);
+	hba->dma_mem = dma_alloc_coherent(&pdev->dev,
+		STEX_BUFFER_SIZE, &hba->dma_handle, GFP_KERNEL);
 	if (!hba->dma_mem) {
 		err = -ENOMEM;
 		printk(KERN_ERR DRV_NAME "(%s): dma mem alloc failed\n",
@@ -1168,8 +1168,8 @@ stex_probe(struct pci_dev *pdev, const s
 out_free_irq:
 	free_irq(pdev->irq, hba);
 out_pci_free:
-	pci_free_consistent(pdev, STEX_BUFFER_SIZE,
-		hba->dma_mem, hba->dma_handle);
+	dma_free_coherent(&pdev->dev, STEX_BUFFER_SIZE,
+			  hba->dma_mem, hba->dma_handle);
 out_iounmap:
 	iounmap(hba->mmio_base);
 out_release_regions:
@@ -1219,8 +1219,8 @@ static void stex_hba_free(struct st_hba 
 
 	pci_release_regions(hba->pdev);
 
-	pci_free_consistent(hba->pdev, STEX_BUFFER_SIZE,
-			hba->dma_mem, hba->dma_handle);
+	dma_free_coherent(&hba->pdev->dev, STEX_BUFFER_SIZE,
+			  hba->dma_mem, hba->dma_handle);
 }
 
 static void stex_remove(struct pci_dev *pdev)

--------------080604090507070107020205--
