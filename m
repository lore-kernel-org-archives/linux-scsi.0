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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9FDC4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4359461181
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244093AbhHFJNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:13:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51164 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244036AbhHFJNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:13:10 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D03DF2026A;
        Fri,  6 Aug 2021 09:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628241173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAeldvO7dTzrN6fn6LOP7lgAwMU97Di/pUkABHS84v4=;
        b=Xm3YVdoGk4rqPiO5LibeOjIY7bBg3RQtysMKKjmPDxUvrdEQ5Qt/StrP6KYL3kpN3+ZepX
        j89oaXPBBdKkJlsB2SJlg2BJ4NDKrqwAXR+T5GQImRHTouLhhCHSJvoL0h1NxR6epNPmB9
        /jHa28LVxhfcM2ml+etPbu+7pCccivM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628241173;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAeldvO7dTzrN6fn6LOP7lgAwMU97Di/pUkABHS84v4=;
        b=YpdKSLd6CW5J372XtNRyUptRJTsfAbK0jIusTNJCo9B3PYszlENXhR/6uFk6P2+WDwnvk4
        mvnXrvxY6mCcLYBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 93CE413A62;
        Fri,  6 Aug 2021 09:12:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dsZPIxX9DGE6bAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 06 Aug 2021 09:12:53 +0000
Subject: Re: [PATCH v2 9/9] scsi: mpt3sas: Introduce sas_ncq_prio_supported
 sysfs sttribute
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-10-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <af5b7e6c-c27a-f0f4-692e-df39240c98e0@suse.de>
Date:   Fri, 6 Aug 2021 11:12:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806074252.398482-10-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 9:42 AM, Damien Le Moal wrote:
> Similarly to AHCI, introduce the device sysfs attribute
> sas_ncq_prio_supported to advertize if a SATA device supports the NCQ
> priority feature. Without this new attribute, the user can only
> discover if a SATA device supports NCQ priority by trying to enable
> the feature use with the sas_ncq_prio_enable sysfs device attribute,
> which fails when the device does not support high priroity commands.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index b66140e4c370..f83d4d32d459 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -3918,6 +3918,24 @@ sas_device_handle_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(sas_device_handle);
>  
> +/**
> + * sas_ncq_prio_supported_show - Indicate if device supports NCQ priority
> + * @dev: pointer to embedded device
> + * @attr: sas_ncq_prio_supported attribute descriptor
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' sdev attribute, only works with SATA
> + */
> +static ssize_t
> +sas_ncq_prio_supported_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
> +	return sysfs_emit(buf, "%d\n", scsih_ncq_prio_supp(sdev));
> +}
> +static DEVICE_ATTR_RO(sas_ncq_prio_supported);
> +
>  /**
>   * sas_ncq_prio_enable_show - send prioritized io commands to device
>   * @dev: pointer to embedded device
> @@ -3960,6 +3978,7 @@ static DEVICE_ATTR_RW(sas_ncq_prio_enable);
>  struct device_attribute *mpt3sas_dev_attrs[] = {
>  	&dev_attr_sas_address,
>  	&dev_attr_sas_device_handle,
> +	&dev_attr_sas_ncq_prio_supported,
>  	&dev_attr_sas_ncq_prio_enable,
>  	NULL,
>  };
> 
One wonders where the relationship to the previous patches are, but hey:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
