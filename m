From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 3/4] scsi_debug: vfree is null safe so drop the check
Date: Mon, 23 Feb 2015 13:23:18 -0500
Message-ID: <54EB7016.7000203@interlog.com>
References: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com> <1424298699-2581-4-git-send-email-tomas.winkler@intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51887 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbbBWSXe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 13:23:34 -0500
In-Reply-To: <1424298699-2581-4-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 15-02-18 05:31 PM, Tomas Winkler wrote:
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

James and Christoph,
Please ignore this patch. I have just acked a more comprehensive
patch on this code from SF Markus Elfring.

Doug Gilbert

> ---
>   drivers/scsi/scsi_debug.c | 10 +++-------
>   1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 11774cd1741a..80410f9588ba 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4959,10 +4959,8 @@ bus_unreg:
>   dev_unreg:
>   	root_device_unregister(pseudo_primary);
>   free_vm:
> -	if (map_storep)
> -		vfree(map_storep);
> -	if (dif_storep)
> -		vfree(dif_storep);
> +	vfree(map_storep);
> +	vfree(dif_storep);
>   	vfree(fake_storep);
>
>   	return ret;
> @@ -4980,9 +4978,7 @@ static void __exit scsi_debug_exit(void)
>   	bus_unregister(&pseudo_lld_bus);
>   	root_device_unregister(pseudo_primary);
>
> -	if (dif_storep)
> -		vfree(dif_storep);
> -
> +	vfree(dif_storep);
>   	vfree(fake_storep);
>   }
>
>

