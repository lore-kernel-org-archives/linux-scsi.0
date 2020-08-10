Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BBDC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8178D2073E
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgHJGYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:24:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:39454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgHJGYm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 02:24:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9AD27AC1D;
        Mon, 10 Aug 2020 06:25:00 +0000 (UTC)
Subject: Re: [PATCH 5/5] scsi_transport_fc: Added a new sysfs attribute
 noretries_abort
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-6-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b5469eef-08cf-267a-77e7-5e4a3640f4f3@suse.de>
Date:   Mon, 10 Aug 2020 08:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596595862-11075-6-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/20 4:51 AM, Muneendra wrote:
> Added a new sysfs attribute noretries_abort under fc_transport/target*/
> 
> This interface will set SCMD_NORETRIES_ABORT bit in scmd->state for all
> the pending io's on the scsi device associated with target port.
> 
> Below is the interface provided to abort the io
> echo 1 >> /sys/class/fc_transport/targetX\:Y\:Z/noretries_abort
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>   drivers/scsi/scsi_transport_fc.c | 49 ++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 2732fa6..f7b00ae 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -305,7 +305,7 @@ struct device_attribute device_attr_##_prefix##_##_name = 	\
>    * Attribute counts pre object type...
>    * Increase these values if you add attributes
>    */
> -#define FC_STARGET_NUM_ATTRS 	3
> +#define FC_STARGET_NUM_ATTRS	4
>   #define FC_RPORT_NUM_ATTRS	10
>   #define FC_VPORT_NUM_ATTRS	9
>   #define FC_HOST_NUM_ATTRS	29
> @@ -994,6 +994,44 @@ static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
>   /*
>    * FC SCSI Target Attribute Management
>    */
> +static void scsi_target_set_noretries_abort(struct scsi_target *starget)
> +{
> +	struct scsi_device *sdev, *tmp;
> +	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_for_each_entry_safe(sdev, tmp, &starget->devices, same_target_siblings) {
> +		if (sdev->sdev_state == SDEV_DEL)
> +			continue;
> +		if (scsi_device_get(sdev))
> +			continue;
> +
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		scsi_set_noretries_abort_io_device(sdev);
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		scsi_device_put(sdev);
> +	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +
> +/*
> + * Sets  no retries on abort in scmd->state for all
> + * outstanding io of all the scsi_devs
> + * write 1 to set the bit for all outstanding io's
> + */
> +static ssize_t fc_target_set_noretries_abort(struct device *dev,
> +						struct device_attribute *attr,
> +						const char *buf, size_t count)
> +{
> +	struct scsi_target *starget = transport_class_to_starget(dev);
> +
> +	scsi_target_set_noretries_abort(starget);
> +	return count;
> +}
> +
> +static FC_DEVICE_ATTR(starget, noretries_abort, 0200,
> +		NULL, fc_target_set_noretries_abort);
>   
>   /*
>    * Note: in the target show function we recognize when the remote
> @@ -1036,6 +1074,13 @@ static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
>   	if (i->f->show_starget_##field)					\
>   		count++
>   
> +#define SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(field)			\
> +do {									\
> +	i->private_starget_attrs[count] = device_attr_starget_##field; \
> +	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
> +	count++;							\
> +} while (0)
> +
>   #define SETUP_STARGET_ATTRIBUTE_RW(field)				\
>   	i->private_starget_attrs[count] = device_attr_starget_##field; \
>   	if (!i->f->set_starget_##field) {				\
> @@ -2197,7 +2242,7 @@ struct scsi_transport_template *
>   	SETUP_STARGET_ATTRIBUTE_RD(node_name);
>   	SETUP_STARGET_ATTRIBUTE_RD(port_name);
>   	SETUP_STARGET_ATTRIBUTE_RD(port_id);
> -
> +	SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(noretries_abort);
>   	BUG_ON(count > FC_STARGET_NUM_ATTRS);
>   
>   	i->starget_attrs[count] = NULL;
> 
Hmm. Wouldn't it make more sense to introduce a new port state 
'marginal' for this? We might want/need to introduce additional error 
recovery mechanisms here, so having a new state might be easier in the 
long run ...

Additionally, from my understanding the FPIN events will be generated 
with a certain frequency. So we could model the new 'marginal' state 
similar to the dev_loss_tmo mechanism; start a timer whenever the 
'marginal' state is being set, and clear the state back to 'running' if 
the state hasn't been refreshed within that timeframe.
That would give us an automatic state reset back to running, and quite 
easy to implement from userland.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
