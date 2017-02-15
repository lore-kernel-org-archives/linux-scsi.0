From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 05/16] aacraid: Fix memory leak in fib init path
Date: Wed, 15 Feb 2017 09:31:35 +0100
Message-ID: <23eeae24-16d7-1671-2fde-edb17305574a@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-6-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdBOIbh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:31:37 -0500
In-Reply-To: <20170214204446.14808-6-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> aac_fib_map_free frees misaligned fib dma memory, additionally it does not
> free up the whole memory.
> 
> Fixed by changing the  code to free up the correct and full memory
> allocation.
> 
> Cc: stable@vger.kernel.org
> Fixes: e8b12f0fb835223 ([SCSI] aacraid: Add new code for PMC-Sierra's SRC based controller family)
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> ---
>  drivers/scsi/aacraid/commsup.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index f7a3bcb..863c98d 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -97,8 +97,8 @@ void aac_fib_map_free(struct aac_dev *dev)
>  {
>  	if (dev->hw_fib_va && dev->max_cmd_size) {
>  		pci_free_consistent(dev->pdev,
> -		(dev->max_cmd_size *
> -		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)),
> +		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
> +		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + 31,
>  		dev->hw_fib_va, dev->hw_fib_pa);

Can you please do something like:

size_t alloc_size;
int numtags;

numtags = dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
alloc_size = (dev->max_cmd_size + sizeof(struct aac_fib_xporthdr)) *
		numtags + 31;
pci_free_consistent(dev->pdev, alloc_size, dev->hw_fib_va,
		    dev->hw_fib_pa);

And please indent correctly. If it indentation doesn't work correctly
because you hit the 80 chars limit, that's a sign something should be
reconsidered.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
