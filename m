From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5][resend 2] stex: Fix for potential invalid request
Date: Tue, 27 Jan 2009 09:11:27 -0600
Message-ID: <1233069087.3231.19.camel@localhost.localdomain>
References: <200901270636.04129.ed.lin@promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57224 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbZA0PL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 10:11:29 -0500
In-Reply-To: <200901270636.04129.ed.lin@promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ed.lin" <ed.lin@promise.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-01-27 at 06:36 +0800, ed.lin wrote:
> The interrupt routine is good for normal cases. However, if the firmware is 
> abnormal and returns an invalid response, the driver may reuse a ccb 
> structure that has already been handled. This may cause problem. Fix this by 
> setting the req member to NULL. Next time we know the response is invalid and 
> handle accordingly if req is NULL.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>
> ---
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index a3a18ad..6129db4 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -746,6 +746,7 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
>      stex_copy_data(ccb, resp, size);
>    }
>  
> +  ccb->req = NULL;
^^^^^^^^

I'm afraid all the tabs have been converted to single spaces in this
one.

Just mime attach the patches ... we can play the tune the email client
game later.

James


