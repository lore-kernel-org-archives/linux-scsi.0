From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] bnx2fc: fix incorrect DMA memory mapping in bnx2fc_map_sg()
Date: Fri, 22 Aug 2014 20:12:42 +0200
Message-ID: <53F7881A.1070808@redhat.com>
References: <1407140413-4561-1-git-send-email-mlombard@redhat.com> <1408556122.10706.20.camel@lbirv-waie-lx2.broadcom.com> <53F7091C.1080400@redhat.com> <alpine.OSX.2.00.1408220805170.360@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824AbaHVSNC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 14:13:02 -0400
In-Reply-To: <alpine.OSX.2.00.1408220805170.360@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@lst.de

Hi Chad,

On 08/22/2014 02:08 PM, Chad Dupuis wrote:
> Eddie, Maurizio,
> 
> Since it looks like there can be a difference in the pdev would it make sense instead to convert the unmap function to use the bare DMA API so we're consistent in our use of hba->pcidev->dev?  Maybe something like this:

I looked at what the bnx2i driver code does, it has a hba->pcidev pointer too but makes use of scsi_map_sg()/scsi_unmap_sg().
So, from my point of view, it is the bnx2fc's map operation (that bypasses scsi_map_sg() and uses dma_map_sg()) to look like a suspicious exception and I decided to change it.

So far, I didn't get any error or strange behaviour after this change.
Eddie, what do you think about it?

Regards,
Maurizio Lombardi

> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 32a5e0a..8b4adcf 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1700,9 +1700,12 @@ static int bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req)
>  static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
>  {
>         struct scsi_cmnd *sc = io_req->sc_cmd;
> +       struct bnx2fc_interface *interface = io_req->port->priv;
> +       struct bnx2fc_hba *hba = interface->hba;
> 
> -       if (io_req->bd_tbl->bd_valid && sc) {
> -               scsi_dma_unmap(sc);
> +       if (io_req->bd_tbl->bd_valid && sc && scsi_sg_count(sc)) {
> +               dma_unmap_sg(&hba->pcidev->dev, scsi_sglist(sc),
> +                   scsi_sg_count(sc), sc->sc_data_direction);
>                 io_req->bd_tbl->bd_valid = 0;
>         }
>  }
> 
> On Fri, 22 Aug 2014, Maurizio Lombardi wrote:
> 
>> Hi Eddie,
>>
>> On 08/20/2014 07:35 PM, Eddie Wai wrote:
>>> On Mon, 2014-08-04 at 10:20 +0200, Maurizio Lombardi wrote:
>>>> In the bnx2fc_map_sg() function, the original behaviour is to
>>>> allocate the DMA memory by directly calling dma_map_sg()
>>>> instead of using scsi_dma_map().
>>>>
>>>> In contrast, bnx2fc_unmap_sg_list() calls scsi_dma_unmap().
>>>>
>>>> The problem is that bnx2fc_map_sg() passes to the dma_map_sg() function
>>>> the pointer to the "device" structure taken from pci_dev
>>>> and not from Scsi_Host (as scsi_dma_map/unmap() do).
>>>>
>>> Great find, Maurizio, Thanks again.
>>
>> Thanks :)
>>
>>>
>>>> In some circumstances, the two devices may be different and the
>>>> DMA library will be unable to find the correct entry
>>>> when freeing the memory.
>>>>
>>> I'm curious at how the hba->pcidev->dev in the dma_map_sg call could end
>>> up being different from the scsi_cmnd's device->host->dma_dev...  Can
>>> you share the test scenario?
>>
>> It happens every time you set up an fcoe interface, so you just have to compile the
>> kernel with the DMA API debug option.
>> It is 100% reproducible with RHEL6, RHEL7 and the latest mainline kernel also.
>>
>>>
>>> I see that scsi_dma_map could possibly return a -ENOMEM.  It would be
>>> best if we also add the check for sg_count being < 0 and return the
>>> bd_count or 0.
>>>
>>>>      scsi_for_each_sg(sc, sg, sg_count, i) {
>>>>          sg_len = sg_dma_len(sg);
>>>>          addr = sg_dma_address(sg);
>>
>> True, but sg_count is only used for the "scsi_for_each()",
>> if it is 0 or -ENOMEM it will simply skip the loop and will execute "return bd_count".
>>
>> Regards,
>> Maurizio Lombardi
>>
