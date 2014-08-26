From: Eddie Wai <eddie.wai@broadcom.com>
Subject: Re: [PATCH] bnx2fc: fix incorrect DMA memory mapping in
 bnx2fc_map_sg()
Date: Tue, 26 Aug 2014 11:35:23 -0700
Message-ID: <1409078123.18812.5.camel@lbirv-waie-lx2.broadcom.com>
References: <1407140413-4561-1-git-send-email-mlombard@redhat.com>
	 <1408556122.10706.20.camel@lbirv-waie-lx2.broadcom.com>
	 <53F7091C.1080400@redhat.com>
	 <alpine.OSX.2.00.1408220805170.360@administrators-macbook-pro.local>
	 <53F7881A.1070808@redhat.com>
	 <1408747587.3876.40.camel@lbirv-waie-lx2.broadcom.com>
	 <alpine.OSX.2.00.1408251511290.1834@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:37327 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaHZSlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 14:41:53 -0400
In-Reply-To: <alpine.OSX.2.00.1408251511290.1834@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@lst.de

On Mon, 2014-08-25 at 15:15 -0400, Chad Dupuis wrote:
> 
> On Fri, 22 Aug 2014, Eddie Wai wrote:
> 
> > On Fri, 2014-08-22 at 20:12 +0200, Maurizio Lombardi wrote:
> >> Hi Chad,
> >>
> >> On 08/22/2014 02:08 PM, Chad Dupuis wrote:
> >>> Eddie, Maurizio,
> >>>
> >>> Since it looks like there can be a difference in the pdev would it make sense instead to convert the unmap function to use the bare DMA API so we're consistent in our use of hba->pcidev->dev?  Maybe something like this:
> >>
> >> I looked at what the bnx2i driver code does, it has a hba->pcidev pointer too but makes use of scsi_map_sg()/scsi_unmap_sg().
> >> So, from my point of view, it is the bnx2fc's map operation (that bypasses scsi_map_sg() and uses dma_map_sg()) to look like a suspicious exception and I decided to change it.
> >>
> >> So far, I didn't get any error or strange behaviour after this change.
> >> Eddie, what do you think about it?
> >>
> >> Regards,
> >> Maurizio Lombardi
> >>
> >>>
> >>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> >>> index 32a5e0a..8b4adcf 100644
> >>> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> >>> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> >>> @@ -1700,9 +1700,12 @@ static int bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req)
> >>>  static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
> >>>  {
> >>>         struct scsi_cmnd *sc = io_req->sc_cmd;
> >>> +       struct bnx2fc_interface *interface = io_req->port->priv;
> >>> +       struct bnx2fc_hba *hba = interface->hba;
> >>>
> >>> -       if (io_req->bd_tbl->bd_valid && sc) {
> >>> -               scsi_dma_unmap(sc);
> >>> +       if (io_req->bd_tbl->bd_valid && sc && scsi_sg_count(sc)) {
> >>> +               dma_unmap_sg(&hba->pcidev->dev, scsi_sglist(sc),
> >>> +                   scsi_sg_count(sc), sc->sc_data_direction);
> >>>                 io_req->bd_tbl->bd_valid = 0;
> >>>         }
> >>>  }
> >>>
> >>> On Fri, 22 Aug 2014, Maurizio Lombardi wrote:
> >>>
> >>>> Hi Eddie,
> >>>>
> >>>> On 08/20/2014 07:35 PM, Eddie Wai wrote:
> >>>>> On Mon, 2014-08-04 at 10:20 +0200, Maurizio Lombardi wrote:
> >>>>>> In the bnx2fc_map_sg() function, the original behaviour is to
> >>>>>> allocate the DMA memory by directly calling dma_map_sg()
> >>>>>> instead of using scsi_dma_map().
> >>>>>>
> >>>>>> In contrast, bnx2fc_unmap_sg_list() calls scsi_dma_unmap().
> >>>>>>
> >>>>>> The problem is that bnx2fc_map_sg() passes to the dma_map_sg() function
> >>>>>> the pointer to the "device" structure taken from pci_dev
> >>>>>> and not from Scsi_Host (as scsi_dma_map/unmap() do).
> >>>>>>
> >>>>> Great find, Maurizio, Thanks again.
> >>>>
> >>>> Thanks :)
> >>>>
> >>>>>
> >>>>>> In some circumstances, the two devices may be different and the
> >>>>>> DMA library will be unable to find the correct entry
> >>>>>> when freeing the memory.
> >>>>>>
> >>>>> I'm curious at how the hba->pcidev->dev in the dma_map_sg call could end
> >>>>> up being different from the scsi_cmnd's device->host->dma_dev...  Can
> >>>>> you share the test scenario?
> >>>>
> >>>> It happens every time you set up an fcoe interface, so you just have to compile the
> >>>> kernel with the DMA API debug option.
> >>>> It is 100% reproducible with RHEL6, RHEL7 and the latest mainline kernel also.
> >
> > This got me thinking that the scsi_host's dma_dev must have been changed
> > recently and I think I found the culprit:
> > http://www.spinics.net/lists/linux-scsi/msg65225.html
> >
> > So back when, we changed the scsi_host's parent from hba->pcidev->dev to
> > the fcoe_ctlr_device's dev to basically align with the soft fcoe code to
> > fix a fcoemon expectation.  Although this was changed correctly, the sg
> > DMA mapping routine did not adapt to it; hence the mismatch.
> >
> > Prior to this change, both sg dma map and unmap were done to the
> > hba->pcidev->dev along with all other DMA mapping routines.  I also see
> > that even though bnx2i uses the scsi_map_sg/scsi_unmap_sg pairs,
> > ultimately, they were operating on the hba->pcidev->dev device.
> >
> > My opinion is that it would probably be in our best interest to have all
> > DMA mapping/unmapping routines continue to operate on the
> > hba->pcidev->dev directly to prevent any unforeseen DMA problems.
> >
> 
> Thanks Eddie.  Would my original patch work then (I added comments per 
> Christoph's request):
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c 
> b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 32a5e0a..6a61a0d 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1651,6 +1651,10 @@ static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
>          u64 addr;
>          int i;
> 
> +       /*
> +        * Use dma_map_sg directly to ensure we're using the correct
> +        * dev struct off of pcidev.
> +        */
>          sg_count = dma_map_sg(&hba->pcidev->dev, scsi_sglist(sc),
>                                scsi_sg_count(sc), sc->sc_data_direction);
>          scsi_for_each_sg(sc, sg, sg_count, i) {
> @@ -1700,9 +1704,16 @@ static int bnx2fc_build_bd_list_from_sg(struct 
> bnx2fc_cmd *io_req)
>   static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
>   {
>          struct scsi_cmnd *sc = io_req->sc_cmd;
> +       struct bnx2fc_interface *interface = io_req->port->priv;
> +       struct bnx2fc_hba *hba = interface->hba;
> 
> -       if (io_req->bd_tbl->bd_valid && sc) {
> -               scsi_dma_unmap(sc);
> +       /*
> +        * Use dma_unmap_sg directly to ensure we're using the correct
> +        * dev struct off of pcidev.
> +        */
> +       if (io_req->bd_tbl->bd_valid && sc && scsi_sg_count(sc)) {
> +               dma_unmap_sg(&hba->pcidev->dev, scsi_sglist(sc),
> +                   scsi_sg_count(sc), sc->sc_data_direction);
>                  io_req->bd_tbl->bd_valid = 0;
>          }
>   }
> 
Chad, the patch looks fine to me.  Thanks for verifying it.  I asked for
some test coverage earlier only because I was afraid that there might be
corner cases where the hba might not be available during the unmap
process.

Acked-by: Eddie Wai <eddie.wai@broadcom.com>



