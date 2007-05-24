From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
Date: Thu, 24 May 2007 09:24:53 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
References: <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:46971 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbXEXNY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 09:24:58 -0400
Content-class: urn:content-classes:message
In-reply-to: <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>
Cc: Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>

So, is the sequence:

	p = kmalloc(upsg->sg[i].count,GFP_KERNEL);
	. . .
	addr = pci_map_single(dev->pdev, p, upsg->sg[i].count,
data_dir);

Going to ensure that we have a 31 bit (not 32 bit) physical address?

If not, then I reject this patch. We can not consider replacement with
pci_alloc_consistent until it works on AMD respecting the DMA masks.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Aubrey Li
> Sent: Tuesday, May 22, 2007 10:41 PM
> To: Christoph Lameter
> Cc: Bernhard Walle; linux-scsi@vger.kernel.org; Andrew 
> Morton; linux-kernel@vger.kernel.org; James Bottomley
> Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
> 
> 
> On 5/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> > On Mon, 21 May 2007, Bernhard Walle wrote:
> >
> > > [PATCH] [scsi] Remove __GFP_DMA
> > >
> > > After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not 
> necessary to alloate a
> > > DMA buffer any more in sd.c.
> > >
> > > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> >
> > Great that avoids a DMA kmalloc slab. Any other GFP_DMAs 
> left in the scsi
> > layer?
> >
> > Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> Yes, here is another patch
> 
> Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
> ---
>  drivers/scsi/aacraid/commctrl.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/commctrl.c 
> b/drivers/scsi/aacraid/commctrl.c
> index 72b0393..405722d 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -580,8 +580,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
> void __user * arg)
>  			for (i = 0; i < upsg->count; i++) {
>  				u64 addr;
>  				void* p;
> -				/* Does this really need to be 
> GFP_DMA? */
> -				p = 
> kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
> +
> +				p = 
> kmalloc(upsg->sg[i].count,GFP_KERNEL);
>  				if(p == 0) {
>  					
> dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
> = %d buffer number %d of %d\n",
>  					  
> upsg->sg[i].count,i,upsg->count));
> @@ -624,8 +624,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
> void __user * arg)
>  			for (i = 0; i < usg->count; i++) {
>  				u64 addr;
>  				void* p;
> -				/* Does this really need to be 
> GFP_DMA? */
> -				p = 
> kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
> +
> +				p = 
> kmalloc(usg->sg[i].count,GFP_KERNEL);
>  				if(p == 0) {
>  					kfree (usg);
>  					
> dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
> = %d buffer number %d of %d\n",
> @@ -666,8 +666,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
> void __user * arg)
>  			for (i = 0; i < upsg->count; i++) {
>  				u64 addr;
>  				void* p;
> -				/* Does this really need to be 
> GFP_DMA? */
> -				p = 
> kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
> +
> +				p = 
> kmalloc(usg->sg[i].count,GFP_KERNEL);
>  				if(p == 0) {
>  					
> dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
> = %d buffer number %d of %d\n",
>  					  
> usg->sg[i].count,i,usg->count));
> -- 
> 1.5.1.1
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
