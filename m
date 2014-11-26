From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -next] scsi: ufs: don't kfree() devm_kzalloc()'ed memory
Date: Wed, 26 Nov 2014 07:51:29 -0800
Message-ID: <1417017089.2202.3.camel@HansenPartnership.com>
References: <1417016257-9693-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59136 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbaKZPva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 10:51:30 -0500
In-Reply-To: <1417016257-9693-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, Christoph Hellwig <hch@lst.de>

On Thu, 2014-11-27 at 00:37 +0900, Akinobu Mita wrote:
> In ufshcd_parse_clock_info(), temporary memory allocated by
> devm_kzalloc() is released by kfree().  The devres mechanism cannot
> track the release and it causes trouble when removing the driver.
> 
> Fix it by allocating it with plain kcalloc() instead of devm_kzalloc()
> as the temporary memory is always freed in that function.
> 
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Dolev Raviv <draviv@codeaurora.org>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Cc: Maya Erez <merez@codeaurora.org>
> Cc: Sahitya Tummala <stummala@codeaurora.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 0c030ad..67b1f6c 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -99,8 +99,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
>  		goto out;
>  	}
>  
> -	clkfreq = devm_kzalloc(dev, sz * sizeof(*clkfreq),
> -			GFP_KERNEL);
> +	clkfreq = kcalloc(sz, sizeof(*clkfreq), GFP_KERNEL);

I agree this doesn't need to be devm memory since it's copied into clki,
but where is it freed?  I think you need a kfree(clkfreq) at the bottom
of the routine.

James


