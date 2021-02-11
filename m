Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B76AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 13:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD1064EC0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 13:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhBKNHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 08:07:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231660AbhBKNEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 08:04:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613048601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RgYeth96asLjSdxqzX+bicEvZRy6cX+sEf+GmW7KKqo=;
        b=P3RvOUzIZm97zDHQXCVXns+bh39obFMlaj07bct1fXf7E85lFDhmxhrIkTeERJdFLXyaVM
        CvKwwNLTkXqFGX3OlDpmxuLi+lBjfQgUJ3Sz0/mKn52yY+CsQiZmxQhzwQiLPWBqzHFkV/
        u+nosF9DFxQrTaFAOl5vT4oTPvGWwkY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-iiq99K4nP8aNBK7--ojozA-1; Thu, 11 Feb 2021 08:03:19 -0500
X-MC-Unique: iiq99K4nP8aNBK7--ojozA-1
Received: by mail-pg1-f200.google.com with SMTP id c30so4352144pgl.15
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 05:03:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RgYeth96asLjSdxqzX+bicEvZRy6cX+sEf+GmW7KKqo=;
        b=BrbSvw3XLtQnt77GZMuUwJJuwBr0H3Eic1N0xxJZq8ZB9kQf033mY7G6chGIHbunYy
         OLji0pQN5fr3rHfHxVX4aNRSXYGpjAJmKWEciflX+2KdxTeM40DmXtZNYTkOmt9QSPJE
         8rHpWjQjCvqxYbdsTqar4D3UBghonVfbVm1o96gyMselSalnbOtvONXqKVKQhHYWunLB
         +QwOZJ9jmUr8XGaTlxoiRZc/tnJLVXCJT6Fv02KajU8lZyeIcXmw+xEcknYxgy90F79X
         MwjFqVu5ZHQ+KESt+dGnIwrQpQ4hX0xFFfBed9G0LAaXHucZNOUh26J2ybA2MUZT/p1u
         wWlA==
X-Gm-Message-State: AOAM531rDy3eiOW+ZSM3E2U1/7GC69wHkK4j/MTXyV4Uwa39V41Ss+rc
        K07VhDUGiHlAZykhjjxZvdum137arYlt9aMJo4mFrBPUmu3hYN6sU+0RM0joK3Ygwp38Atw6qJd
        9+qLuOhpKecFC32hZBYwlaA==
X-Received: by 2002:a17:90a:6048:: with SMTP id h8mr3965512pjm.139.1613048597683;
        Thu, 11 Feb 2021 05:03:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1WIDQt5WM+CZCT8YfL5YV4V4piqMpArUu6Zp1IVhq68pCRGfD0UjmYYQ7P98JAgczop3cQQ==
X-Received: by 2002:a17:90a:6048:: with SMTP id h8mr3965485pjm.139.1613048597351;
        Thu, 11 Feb 2021 05:03:17 -0800 (PST)
Received: from [172.24.0.1] ([171.50.216.159])
        by smtp.gmail.com with ESMTPSA id h11sm4994767pjg.46.2021.02.11.05.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 05:03:16 -0800 (PST)
Subject: Re: [PATCH] scsi: qla2xxx: Removed extra space in variable
 declaration.
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
To:     kernel-janitors@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20210211093552.GA5375@machine1>
Organization: Red Hat
Message-ID: <6266f3b1-1890-d69b-eeed-cb60ee8d02bb@redhat.com>
Date:   Thu, 11 Feb 2021 18:33:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20210211093552.GA5375@machine1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Apologies for missing a note about change. Will correct it now and send updated version.

On 2/11/21 3:05 PM, Milan P. Gandhi wrote:
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index ab45ac1e5a72..7f2db8badb6d 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -226,7 +226,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
>  	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
>  	    struct device, kobj)));
>  	struct qla_hw_data *ha = vha->hw;
> -	uint16_t	cnt;
> +	uint16_t cnt;
>  
>  	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size ||
>  	    !ha->isp_ops->write_nvram)
> 

