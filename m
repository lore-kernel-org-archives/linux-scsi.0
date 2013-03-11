From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: fix addition of abort command to HRRQ free queue
Date: Mon, 11 Mar 2013 16:40:16 -0300
Message-ID: <513E3320.4030101@linux.vnet.ibm.com>
References: <1363030382-29007-1-git-send-email-klebers@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:41579 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3CKTkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Mar 2013 15:40:23 -0400
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <klebers@linux.vnet.ibm.com>;
	Mon, 11 Mar 2013 16:40:21 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 5E36C3520065
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 15:40:19 -0400 (EDT)
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
	by d24relay02.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r2BJdWBL18809046
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 16:39:33 -0300
Received: from d24av05.br.ibm.com (loopback [127.0.0.1])
	by d24av05.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r2BJeIJq030352
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 16:40:18 -0300
In-Reply-To: <1363030382-29007-1-git-send-email-klebers@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, brking@linux.vnet.ibm.com
Cc: wenxiong@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Please ignore this one. Messed up with send-email --annotate.


Thanks,
Kleber

On 03/11/2013 04:33 PM, Kleber Sacilotto de Souza wrote:
> Brian/Wendy,
> 
> This is a patch for bug #89324. We were not using the right HRRQ pointer,
> so we were adding the command to the wrong free queue, which can be
> not initialized and cause a null-pointer dereference when calling
> list_add_tail().
> 
> Kleber
> 
> ---
> The abort command issued by ipr_cancel_op() is being added to the wrong
> HRRQ free queue after the command returns. Fix it by using the HRRQ
> pointer in the ipr command struct itself.
> 
> Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index f328089..b222dae 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -5148,7 +5148,7 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
>  		ipr_trace;
>  	}
> 
> -	list_add_tail(&ipr_cmd->queue, &hrrq->hrrq_free_q);
> +	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  	if (!ipr_is_naca_model(res))
>  		res->needs_sync_complete = 1;
> 


-- 
Kleber Sacilotto de Souza
IBM Linux Technology Center

