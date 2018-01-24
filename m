From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] bnx2fc: Fix check in SCSI completion handler when
 reqeust has already timed out.
Date: Wed, 24 Jan 2018 11:12:12 -0500
Message-ID: <1516810332.30372.1.camel@redhat.com>
References: <20180124160706.32700-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33073 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934021AbeAXQMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 11:12:14 -0500
Received: by mail-qt0-f196.google.com with SMTP id d8so11656755qtm.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 08:12:14 -0800 (PST)
In-Reply-To: <20180124160706.32700-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

On Wed, 2018-01-24 at 08:07 -0800, Chad Dupuis wrote:
> When a request times out we set the io_req flag BNX2FC_FLAG_IO_COMPL
> so
> that if a subsequent completion comes in on that task ID we will
> ignore
> it.  The issue is that in the check for this flag there is a missing
> return so we will continue to process a request which may have
> already
> been returned to the ownership of the SCSI layer.  This can cause
> unpredictable results.
> 
> Solution is to add in the missing return.
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
> b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 8e2f767147cb..5a645b8b9af1 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1889,6 +1889,7 @@ void bnx2fc_process_scsi_cmd_compl(struct
> bnx2fc_cmd *io_req,
>  		/* we will not receive ABTS response for this IO */
>  		BNX2FC_IO_DBG(io_req, "Timer context finished
> processing "
>  			   "this scsi cmd\n");
> +		return;
>  	}
>  
>  	/* Cancel the timeout_work, as we received IO completion */

Hello

This was added after the race showed up for the first issue we fixed.
Its been running stable in our lab and at the customer.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by:   Laurence Oberman <loberman@redhat.com>

Thanks
Laurence
