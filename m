From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/5] stex: Fix for potential invalid response
Date: Mon, 26 Jan 2009 06:31:46 -0500
Message-ID: <497D9F22.3080901@garzik.org>
References: <85ABFDC4641C4847BA6088F2982EFD8F01DC8300@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39772 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZAZLbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 06:31:50 -0500
In-Reply-To: <85ABFDC4641C4847BA6088F2982EFD8F01DC8300@nonamew.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin - PTU <ed.lin@promise.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>

Ed Lin - PTU wrote:
> The interrupt routine is good for normal cases. However, if the firmware
> is abnormal and returns an invalid response, the driver may reuse a
> ccb structure which has already been handled. This may cause problem.
> Fix this by setting the req member to NULL. Next time we know the
> response is invalid and handle accordingly if req is NULL.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>
> ---
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index a3a18ad..6129db4 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -746,6 +746,7 @@ static void stex_mu_intr(struct st_hba *hba, u32
> doorbell)
>  				stex_copy_data(ccb, resp, size);
>  		}
>  
> +		ccb->req = NULL;
>  		ccb->srb_status = resp->srb_status;
>  		ccb->scsi_status = resp->scsi_status;

ACK patches 1-5


