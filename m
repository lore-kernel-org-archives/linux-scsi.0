From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/5] ipr: Don't set NO_ULEN_CHK bit when resource is
 a vset.
Date: Wed, 04 Nov 2015 13:50:44 -0500
Message-ID: <20151104135044.Horde.vmNxsxBpevHr-wv905pwIg3@ltc.linux.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446575170-18656-2-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:49122 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031041AbbKDSut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 13:50:49 -0500
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 4 Nov 2015 13:50:48 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 541AB6E803C
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2015 13:38:56 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA4IojVh63438888
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 18:50:45 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA4IoiUs019289
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 13:50:45 -0500
In-Reply-To: <1446575170-18656-2-git-send-email-krisman@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>:

> According to the IPR specification, Inhibit Underlength Checking bit
> must be disabled when issuing commands to vsets.  Enabling it in this
> case might cause SCSI commands to fail with an Illegal Request, so make
> sure we keep this bit cleared when resource is a vset.
>
> Changes since v1:
> 	- Put gsci exclusive stuff in a separate block.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 238efab..6849b7f 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -6363,15 +6363,19 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
>  	ipr_cmd->scsi_cmd = scsi_cmd;
>  	ipr_cmd->done = ipr_scsi_eh_done;
>
> -	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
> +	if (ipr_is_gscsi(res)) {
>  		if (scsi_cmd->underflow == 0)
>  			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
>
> -		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
> -		if (ipr_is_gscsi(res) && res->reset_occurred) {
> +		if (res->reset_occurred) {
>  			res->reset_occurred = 0;
>  			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
>  		}
> +	}
> +
> +	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
> +		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
> +
>  		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_ALIGNED_BFR;
>  		if (scsi_cmd->flags & SCMD_TAGGED)
>  			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_SIMPLE_TASK;
> --
> 2.1.0


