From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] bnx2i : Fix "cid #n not valid" issue
Date: Tue, 18 Aug 2009 12:48:06 -0500
Message-ID: <4A8AE956.502@cs.wisc.edu>
References: <1248929411.26650.350.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38967 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbZHRRsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 13:48:15 -0400
In-Reply-To: <1248929411.26650.350.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, mchan@broadcom.com

On 07/29/2009 11:50 PM, Anil Veerabhadrappa wrote:
>
>      * when bnx2i_adapter_ready() fails, connection handle(cid) = 0 is
>        wrongly freed because 'cid' is not yet allocated for the endpoint
>      * Fix is to initialize bnx2i_ep->ep_iscsi_cid to '-1' in bnx2i_alloc_ep()
>        and not in bnx2i_ep_connect() to avoid releasing invalid 'cid'
>      * There is already a check in bnx2i_free_iscsi_cid() not to free
>        invalid iscsi connection handle (-1)
>
> Signed-off-by: Anil Veerabhadrappa<anilgv@broadcom.com>

This looks ok, but I think I got a review comment to change some of my 
code to use the definitions in kernel.h. So below you would want to use 
USHORT_MAX.

I am not sure if it will prevent the patch from getting merged or not 
since it will work either way.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>



> ---
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 9535bb6..08d0bfc 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -387,6 +387,7 @@ static struct iscsi_endpoint *bnx2i_alloc_ep(struct bnx2i_hba *hba)
>   	bnx2i_ep = ep->dd_data;
>   	INIT_LIST_HEAD(&bnx2i_ep->link);
>   	bnx2i_ep->state = EP_STATE_IDLE;
> +	bnx2i_ep->ep_iscsi_cid = (u16) -1;
>   	bnx2i_ep->hba = hba;
>   	bnx2i_ep->hba_age = hba->age;
>   	hba->ofld_conns_active++;
> @@ -1678,8 +1679,6 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
>   		goto net_if_down;
>   	}
>
> -	bnx2i_ep->state = EP_STATE_IDLE;
> -	bnx2i_ep->ep_iscsi_cid = (u16) -1;
>   	bnx2i_ep->num_active_cmds = 0;
>   	iscsi_cid = bnx2i_alloc_iscsi_cid(hba);
>   	if (iscsi_cid == -1) {

