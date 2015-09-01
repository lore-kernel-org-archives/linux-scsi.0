From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCHv2] Update scsi host to use ida for host number
Date: Tue, 1 Sep 2015 20:49:33 +0300
Message-ID: <55E5E52D.5090009@dev.mellanox.co.il>
References: <1441129120-31398-1-git-send-email-lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34445 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbIARtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2015 13:49:23 -0400
Received: by wicjd9 with SMTP id jd9so41410657wic.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2015 10:49:22 -0700 (PDT)
In-Reply-To: <1441129120-31398-1-git-send-email-lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lduncan@suse.com, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, hare@suse.com, jthumshirn@suse.de

On 9/1/2015 8:38 PM, lduncan@suse.com wrote:
> From: Lee Duncan <lduncan@suse.com>
>
> Each Scsi_host instance gets a host number starting
> at 0, but this is implemented with an atomic integer,
> and rollover doesn't seem to have been considered.
> Another side-effect of this design is that scsi host
> numbers used by iscsi are never reused, thereby  making
> rollover more likely. This patch converts Scsi_host
> instances to use ida to manage their instance
> numbers.
>
> This also means that host instance numbers will be
> reused, when available.
>
> Changes from v1:
> * Added inline host_put_index() and its use
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   drivers/scsi/hosts.c | 47 +++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 39 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8bb173e01084..36cb65612821 100644
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
> @@ -42,7 +42,8 @@
>   #include "scsi_logging.h"
>
>
> -static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
> +static DEFINE_SPINLOCK(host_index_lock);
> +static DEFINE_IDA(host_index_ida);
>
>
>   static void scsi_host_cls_release(struct device *dev)
> @@ -337,6 +338,10 @@ static void scsi_host_dev_release(struct device *dev)
>
>   	kfree(shost->shost_data);
>
> +	spin_lock(&host_index_lock);
> +	ida_remove(&host_index_ida, shost->host_no);
> +	spin_unlock(&host_index_lock);

Why not host_put_index(index)?
