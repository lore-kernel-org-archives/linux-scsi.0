From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] megaraid_sas: Fix LD/VF affiliation parsing
Date: Fri, 11 Jul 2014 02:55:54 -0700
Message-ID: <20140711095554.GA4216@infradead.org>
References: <1404944278-11535-1-git-send-email-aradford@gmail.com>
 <1404944278-11535-4-git-send-email-aradford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaGKJzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 05:55:54 -0400
Content-Disposition: inline
In-Reply-To: <1404944278-11535-4-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

On Wed, Jul 09, 2014 at 03:17:56PM -0700, Adam Radford wrote:
> The following patch for megaraid_sas fixes the LD/VF affiliation policy parsing
> code to account for LD targetId's and Hidden LD's (not yet affiliated with any
> Virtual Functions).  This also breaks megasas_get_ld_vf_affiliation() into 2
> separate functions:  megasas_get_ld_vf_affiliation_111() and
> megasas_get_ld_Vf_affiliation_12() to reduce indentation levels.
> 
> Signed-off-by: Adam Radford <aradford@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h      |   1 +
>  drivers/scsi/megaraid/megaraid_sas_base.c | 318 +++++++++++++++++++-----------
>  2 files changed, 208 insertions(+), 111 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 7d722fb..2e2fcb2 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1659,6 +1659,7 @@ struct MR_LD_VF_AFFILIATION {
>  /* Plasma 1.11 FW backward compatibility structures */
>  #define IOV_111_OFFSET 0x7CE
>  #define MAX_VIRTUAL_FUNCTIONS 8
> +#define MR_LD_ACCESS_HIDDEN 15
>  
>  struct IOV_111 {
>  	u8 maxVFsSupported;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 112799b..b4c032c 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1825,16 +1825,12 @@ void megasas_do_ocr(struct megasas_instance *instance)
>  	process_fw_state_change_wq(&instance->work_init);
>  }
>  
> -/* This function will get the current SR-IOV LD/VF affiliation */
> -static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
> -	int initial)
> +static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
> +					    int initial)
>  {
>  	struct megasas_cmd *cmd;
>  	struct megasas_dcmd_frame *dcmd;
> -	struct MR_LD_VF_AFFILIATION *new_affiliation = NULL;
>  	struct MR_LD_VF_AFFILIATION_111 *new_affiliation_111 = NULL;
> -	struct MR_LD_VF_MAP *newmap = NULL, *savedmap = NULL;
> -	dma_addr_t new_affiliation_h;
>  	dma_addr_t new_affiliation_111_h;
>  	int ld, retval = 0;
>  	u8 thisVf;
> @@ -1842,15 +1838,15 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
>  	cmd = megasas_get_cmd(instance);
>  
>  	if (!cmd) {
> -		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_"
> -		       "affiliation: Failed to get cmd for scsi%d.\n",
> +		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation_111:"

You'd make your life easier if you just used __func__ to print the
function name.

I also think the initial variant should have their own set of functions,
but I'm not going to held this series over over these bits:

Reviewed-by: Christoph Hellwig <hch@lst.de>
