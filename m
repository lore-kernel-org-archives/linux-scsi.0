From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] fcoe-utils: Fix get_ctlr_num() for large ctlr_* indices
Date: Tue, 19 Sep 2017 11:50:26 +0200
Message-ID: <093d8f91-43e0-792b-2741-c1250000b805@suse.de>
References: <20170918143508.4659-1-Andrey.Grafin@acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47745 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751001AbdISJu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 05:50:29 -0400
In-Reply-To: <20170918143508.4659-1-Andrey.Grafin@acronis.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Grafin <Andrey.Grafin@acronis.com>, linux-scsi@vger.kernel.org

On 09/18/2017 04:35 PM, Andrey Grafin wrote:
> Each creation of a FCoE device increases counter which is used as a suffix
> in a FCoE device name in sysfs (i.e. /sys/bus/fcoe/devices/ctlr_1).
> Once this counter reaches the value of two digits (10 and larger),
> get_ctlr_num() stopped working properly and a command like `fcoeadm -i`
> which depends on get_ctlr_num() call doesn't show anything.
> This patch solves this problem.
> 
> Signed-off-by: Andrey Grafin <Andrey.Grafin@acronis.com>
> ---
>  lib/sysfs_hba.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/sysfs_hba.c b/lib/sysfs_hba.c
> index 5cb7fd3fa5d..786215440ba 100644
> --- a/lib/sysfs_hba.c
> +++ b/lib/sysfs_hba.c
> @@ -606,7 +606,7 @@ static int get_ctlr_num(const char *netdev)
>  		if (!ctlr)
>  			continue;
>  
> -		ctlr_num = atoi(&ctlr[strlen(ctlr) - 1]);
> +		ctlr_num = atoi(&ctlr[sizeof("ctlr_") - 1]);
>  		break;
>  	}
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
