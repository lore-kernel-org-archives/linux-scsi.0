Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9D1C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B14A610FC
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbhHFLiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:38:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50090 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241119AbhHFLiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:38:15 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 13E3C2028C;
        Fri,  6 Aug 2021 11:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628249877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BQwQz3+kp98qJQstEixKZfFGCc3tKrXNEHBzqDnF3mk=;
        b=MQ6wZ7eE6coAQ6BiRlc4chpc56lWCG1hiJ+1znCAbmyyDQ1vkEhkHiDsaPJz7SGPrlkK7o
        lhYuME4xz1wfj4aUYoNZRdTlow7GirsiqnJDtnFt2ibo4RHLtcvP0amhFNalpdb/rY1ExV
        HMcraOMtbmiwtOljuuelHTJBdsmP0Iw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628249877;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BQwQz3+kp98qJQstEixKZfFGCc3tKrXNEHBzqDnF3mk=;
        b=PdriBuCO5yZlZALP8CQdmg3ch083QFWmC9O0FtLvvPPRegsiV8KAHyoKtWh4y1LL2j9jtV
        sVXtnuYmux65oxAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 010F113A83;
        Fri,  6 Aug 2021 11:37:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lqZlOxQfDWFMFwAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 06 Aug 2021 11:37:56 +0000
Subject: Re: [PATCH v3 8/9] libahci: Introduce ncq_prio_supported sysfs
 sttribute
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
 <20210806111145.445697-9-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9ba3574f-3b46-d80e-1ff9-29a7af27cc22@suse.de>
Date:   Fri, 6 Aug 2021 13:37:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806111145.445697-9-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 1:11 PM, Damien Le Moal wrote:
> Currently, the only way a user can determine if a SATA device supports
> NCQ priority is to try to enable the use of this feature using the
> ncq_prio_enable sysfs device attribute. If enabling the feature fails,
> it is because the device does not support NCQ priority. Otherwise, the
> feature is enabled and indicates that the device supports NCQ priority.
> 
> Improve this odd interface by introducing the read-only
> ncq_prio_supported sysfs device attribute to indicate if a SATA device
> supports NCQ priority. The value of this attribute reflects if the
> device flag ATA_DFLAG_NCQ_PRIO is set or cleared.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/ata/libahci.c     |  1 +
>  drivers/ata/libata-sata.c | 24 ++++++++++++++++++++++++
>  include/linux/libata.h    |  1 +
>  3 files changed, 26 insertions(+)
> 
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index fec2e9754aed..5b3fa2cbe722 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -125,6 +125,7 @@ EXPORT_SYMBOL_GPL(ahci_shost_attrs);
>  struct device_attribute *ahci_sdev_attrs[] = {
>  	&dev_attr_sw_activity,
>  	&dev_attr_unload_heads,
> +	&dev_attr_ncq_prio_supported,
>  	&dev_attr_ncq_prio_enable,
>  	NULL
>  };
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index dc397ebda089..5566fd4bb38f 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -834,6 +834,30 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
>  	    ata_scsi_lpm_show, ata_scsi_lpm_store);
>  EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
>  
> +static ssize_t ata_ncq_prio_supported_show(struct device *device,
> +					   struct device_attribute *attr,
> +					   char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(device);
> +	struct ata_port *ap = ata_shost_to_port(sdev->host);
> +	struct ata_device *dev;
> +	bool ncq_prio_supported;
> +	int rc = 0;
> +
> +	spin_lock_irq(ap->lock);
> +	dev = ata_scsi_find_dev(ap, sdev);
> +	if (!dev)
> +		rc = -ENODEV;
> +	else
> +		ncq_prio_supported = dev->flags & ATA_DFLAG_NCQ_PRIO;
> +	spin_unlock_irq(ap->lock);
> +
> +	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_supported);
> +}
> +
> +DEVICE_ATTR(ncq_prio_supported, S_IRUGO, ata_ncq_prio_supported_show, NULL);
> +EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_supported);
> +
>  static ssize_t ata_ncq_prio_enable_show(struct device *device,
>  					struct device_attribute *attr,
>  					char *buf)
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index b23f28cfc8e0..a2d1bae7900b 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -539,6 +539,7 @@ typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes)
>  extern struct device_attribute dev_attr_unload_heads;
>  #ifdef CONFIG_SATA_HOST
>  extern struct device_attribute dev_attr_link_power_management_policy;
> +extern struct device_attribute dev_attr_ncq_prio_supported;
>  extern struct device_attribute dev_attr_ncq_prio_enable;
>  extern struct device_attribute dev_attr_em_message_type;
>  extern struct device_attribute dev_attr_em_message;
> 
Alternative would have been to make the 'ncq_prio_enable' attribute
visible only when NCQ prio is supported, but not sure if that works out.

So:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
