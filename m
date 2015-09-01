From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] Update scsi host to use ida for host number
Date: Tue, 1 Sep 2015 11:23:04 +0300
Message-ID: <55E56068.2090605@dev.mellanox.co.il>
References: <1441052890-3600-1-git-send-email-leeman.duncan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35457 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbbIAIWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2015 04:22:53 -0400
Received: by wibq14 with SMTP id q14so23509356wib.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2015 01:22:52 -0700 (PDT)
In-Reply-To: <1441052890-3600-1-git-send-email-leeman.duncan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: leeman.duncan@gmail.com, linux-scsi@vger.kernel.org
Cc: hare@suse.com, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

On 8/31/2015 11:28 PM, leeman.duncan@gmail.com wrote:
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
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/hosts.c | 43 +++++++++++++++++++++++++++++++++++--------
>   1 file changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8bb173e01084..dade75478541 100644
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

Why not get it in a symmetrical host_put_index()
