From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi_error: disable eh_deadline if no
 host_reset_handler is set
Date: Tue, 07 Jan 2014 08:33:45 -0500
Message-ID: <1389101625.3817.1042.camel@localhost.localdomain>
References: <1386846513-122051-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaAGNdv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 08:33:51 -0500
In-Reply-To: <1386846513-122051-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Thu, 2013-12-12 at 12:08 +0100, Hannes Reinecke wrote:
> When the host template doesn't declare an eh_host_reset_handler
> the eh_deadline mechanism is pointless and will set the
> device to offline. So disable eh_deadline if no
> eh_host_reset_handler is present.
> 
> Cc: Ewan Milne <emilne@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/hosts.c      | 2 +-
>  drivers/scsi/scsi_sysfs.c | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 6966def..351afa4 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -396,7 +396,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> -	if (shost_eh_deadline == -1)
> +	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
>  		shost->eh_deadline = -1;
>  	else if ((ulong) shost_eh_deadline * HZ > INT_MAX) {
>  		shost_printk(KERN_WARNING, shost,
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 9117d0b..7434e26 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -300,7 +300,9 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
>  	int ret = -EINVAL;
>  	unsigned long deadline, flags;
>  
> -	if (shost->transportt && shost->transportt->eh_strategy_handler)
> +	if (shost->transportt &&
> +	    (shost->transportt->eh_strategy_handler ||
> +	     !shost->transportt->eh_host_reset_handler))

I think this bit is supposed to be:

        if ((shost->transportt &&
             shost->transportt->eh_strategy_handler) ||
            !shost->hostt->eh_host_reset_handler)
                return ret;

because the field is in the scsi_host_template structure, right?

But, otherwise, this patch is necessary because some drivers don't
implement host reset (e.g. hpsa).

-Ewan

>  		return ret;
>  
>  	if (!strncmp(buf, "off", strlen("off")))


