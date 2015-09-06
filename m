From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/1] Update scsi hosts to use idr for host number mgmt
Date: Sun, 6 Sep 2015 10:34:55 +0300
Message-ID: <55EBEC9F.7020600@dev.mellanox.co.il>
References: <cover.1441412268.git.lduncan@suse.com>
 <05a1b95993cbb2b0ce9be8e088203c23f0e49107.1441412269.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33803 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbIFHen (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Sep 2015 03:34:43 -0400
Received: by wicfx3 with SMTP id fx3so58391412wic.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2015 00:34:42 -0700 (PDT)
In-Reply-To: <05a1b95993cbb2b0ce9be8e088203c23f0e49107.1441412269.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com

On 9/5/2015 11:44 PM, Lee Duncan wrote:
> Each Scsi_host instance gets a host number starting
> at 0, but this was implemented with an atomic integer,
> and rollover wasn't considered. Another problem with
> this design is that scsi host numbers used by iscsi
> are never reused, thereby making rollover more likely.
> This patch converts Scsi_host instances to use idr
> to manage their instance numbers and to simplify
> instance number to pointer lookups.
>
> This also means that host instance numbers will be
> reused, when available.
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/hosts.c | 59 +++++++++++++++++++++++++---------------------------
>   1 file changed, 28 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8bb173e01084..1127a50e5942 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -33,7 +33,7 @@
>   #include <linux/transport_class.h>
>   #include <linux/platform_device.h>
>   #include <linux/pm_runtime.h>
> -
> +#include <linux/idr.h>
>   #include <scsi/scsi_device.h>
>   #include <scsi/scsi_host.h>
>   #include <scsi/scsi_transport.h>
> @@ -41,8 +41,8 @@
>   #include "scsi_priv.h"
>   #include "scsi_logging.h"
>
> -
> -static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
> +static DEFINE_SPINLOCK(host_index_lock);
> +static DEFINE_IDR(host_index_idr);
>
>
>   static void scsi_host_cls_release(struct device *dev)
> @@ -337,6 +337,10 @@ static void scsi_host_dev_release(struct device *dev)
>
>   	kfree(shost->shost_data);
>
> +	spin_lock(&host_index_lock);
> +	idr_remove(&host_index_idr, shost->host_no);
> +	spin_unlock(&host_index_lock);
> +

Did you change your mind on having host_[get|put]_idx() helpers?
