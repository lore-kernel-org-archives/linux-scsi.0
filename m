From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 3/5] ipr: Inquiry IOA page 0xC4 during
 initialization.
Date: Wed, 04 Nov 2015 13:51:04 -0500
Message-ID: <20151104135104.Horde.pt18bvV1lFI9l6hBPnuzOA1@ltc.linux.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446575170-18656-3-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:49346 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031041AbbKDSvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 13:51:07 -0500
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 4 Nov 2015 13:51:06 -0500
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 61253C9003C
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2015 13:39:15 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA4Ip4jK50593938
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 18:51:04 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA4Ip4Sg002318
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 13:51:04 -0500
In-Reply-To: <1446575170-18656-3-git-send-email-krisman@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>:

> Add an IOA Inquiry command for Page 0xC4 during IOA initialization to
> collect cache capabilities, particularly to check if Sync IOA Write
> Cache is supported.
>
> Inquiry will happen right after Cap Inquiry on page 0xD0; and will
> execute only if the "Supported Pages" field in Inquiry Page 0x0 shows
> support for Page 0xC4.  Otherwise, assume Sync IOA Write Cache is
> not supported.
>
> Changes since v1:
>         - Fix checkpatch.pl warnings.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c | 35 ++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ipr.h | 11 +++++++++++
>  2 files changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 6849b7f..5efc7ef 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -7726,6 +7726,39 @@ static int ipr_inquiry_page_supported(struct  
> ipr_inquiry_page0 *page0, u8 page)
>  }
>
>  /**
> + * ipr_ioafp_pageC4_inquiry - Send a Page 0xC4 Inquiry to the adapter.
> + * @ipr_cmd:	ipr command struct
> + *
> + * This function sends a Page 0xC4 inquiry to the adapter
> + * to retrieve software VPD information.
> + *
> + * Return value:
> + *	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
> + **/
> +static int ipr_ioafp_pageC4_inquiry(struct ipr_cmnd *ipr_cmd)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	struct ipr_inquiry_page0 *page0 = &ioa_cfg->vpd_cbs->page0_data;
> +	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
> +
> +	ENTER;
> +	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
> +	memset(pageC4, 0, sizeof(*pageC4));
> +
> +	if (ipr_inquiry_page_supported(page0, 0xC4)) {
> +		ipr_ioafp_inquiry(ipr_cmd, 1, 0xC4,
> +				  (ioa_cfg->vpd_cbs_dma
> +				   + offsetof(struct ipr_misc_cbs,
> +					      pageC4_data)),
> +				  sizeof(struct ipr_inquiry_pageC4));
> +		return IPR_RC_JOB_RETURN;
> +	}
> +
> +	LEAVE;
> +	return IPR_RC_JOB_CONTINUE;
> +}
> +
> +/**
>   * ipr_ioafp_cap_inquiry - Send a Page 0xD0 Inquiry to the adapter.
>   * @ipr_cmd:	ipr command struct
>   *
> @@ -7742,7 +7775,7 @@ static int ipr_ioafp_cap_inquiry(struct  
> ipr_cmnd *ipr_cmd)
>  	struct ipr_inquiry_cap *cap = &ioa_cfg->vpd_cbs->cap;
>
>  	ENTER;
> -	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
> +	ipr_cmd->job_step = ipr_ioafp_pageC4_inquiry;
>  	memset(cap, 0, sizeof(*cap));
>
>  	if (ipr_inquiry_page_supported(page0, 0xD0)) {
> diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
> index 69257c4..7be1271 100644
> --- a/drivers/scsi/ipr.h
> +++ b/drivers/scsi/ipr.h
> @@ -849,6 +849,16 @@ struct ipr_inquiry_page0 {
>  	u8 page[IPR_INQUIRY_PAGE0_ENTRIES];
>  }__attribute__((packed));
>
> +struct ipr_inquiry_pageC4 {
> +	u8 peri_qual_dev_type;
> +	u8 page_code;
> +	u8 reserved1;
> +	u8 len;
> +	u8 cache_cap[4];
> +#define IPR_CAP_SYNC_CACHE		0x08
> +	u8 reserved2[20];
> +} __packed;
> +
>  struct ipr_hostrcb_device_data_entry {
>  	struct ipr_vpd vpd;
>  	struct ipr_res_addr dev_res_addr;
> @@ -1322,6 +1332,7 @@ struct ipr_misc_cbs {
>  	struct ipr_inquiry_page0 page0_data;
>  	struct ipr_inquiry_page3 page3_data;
>  	struct ipr_inquiry_cap cap;
> +	struct ipr_inquiry_pageC4 pageC4_data;
>  	struct ipr_mode_pages mode_pages;
>  	struct ipr_supported_device supp_dev;
>  };
> --
> 2.1.0


