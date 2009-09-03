From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: fix oops in the error path in sg_build_indirect()
Date: Thu, 03 Sep 2009 09:54:37 -0400
Message-ID: <4A9FCA9D.8010702@interlog.com>
References: <20090903033945.GA20755@gherkin.frus.com> <20090903142708.0b820ca1@leela>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52527 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZICNyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 09:54:40 -0400
In-Reply-To: <20090903142708.0b820ca1@leela>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-scsi@vger.kernel.org, Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org, stable@kernel.org

Michal Schmidt wrote:
> When the allocation fails in sg_build_indirect(), an oops happens in
> the error path. It's caused by an obvious typo.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Reported-by: Bob Tracy <rct@gherkin.frus.com>
> ---
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 9230402..4968c4c 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1811,7 +1811,7 @@ retry:
>  	return 0;
>  out:
>  	for (i = 0; i < k; i++)
> -		__free_pages(schp->pages[k], order);
> +		__free_pages(schp->pages[i], order);
>  
>  	if (--order >= 0)
>  		goto retry;
> --

Ouch.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
