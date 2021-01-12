Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66566C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 04:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3735D222B3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 04:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbhALEjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 23:39:37 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:33339 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731028AbhALEjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 23:39:37 -0500
Received: by mail-pj1-f51.google.com with SMTP id w1so956426pjc.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 20:39:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x5qgj+EZIYvLDvAjcB8kuUG7MhawOyKr3/XQ5AmQv4M=;
        b=bOjcERujQQ+S1eXRC7i5qxoP3tX+7LziCcisr2X3Zjz9OjG0L3Iik6nx3c3uj2QKFI
         fYqz1ZUmW8/1QHfhOgvsOSODA3GSOyBQhDTKpLwmKWWpqokSKBpyNSXI/1UIUG0f/stW
         EeLXpumRatTpKTTwu53CYzpyqHyjJNYYjQePxcTKMBKEMAIO7CsKYAdm3U0V7PcWxqx5
         qf+OEHz2adDHq6wS5lrOuSxTpuVg2LqnPI5MCID2ZH6zBp4CHPele/UNOklazHcwbUbt
         Q0gExIE8x7lfHsBtBaY6wrlkdUmXeVCaoI+YEfSOe2n21eAYDPBtSfxYNJ41/5mm5+7q
         f2rA==
X-Gm-Message-State: AOAM533BhY8gtvnFWchl05kkyoX1HweHspHXodZXwRVz3dDLxyczq/bS
        2EjVSSgIlmZW9eEytaLI9cYmSeRV8UM=
X-Google-Smtp-Source: ABdhPJz6yE3uQY53MAebv49EXmZQplmUCtK7waxtxIRIt7dp8uBnXWpgWQQhKuhYpkkNi98IXEOWfw==
X-Received: by 2002:a17:902:8203:b029:dc:3371:6b04 with SMTP id x3-20020a1709028203b02900dc33716b04mr2813806pln.81.1610426336170;
        Mon, 11 Jan 2021 20:38:56 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n28sm1310038pfq.61.2021.01.11.20.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 20:38:55 -0800 (PST)
Subject: Re: [PATCH] scsi: scsi_transport_srp: don't block target in failfast
 state
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
References: <20210111142541.21534-1-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <98b70265-83b6-2e1f-3f71-c39989ba581f@acm.org>
Date:   Mon, 11 Jan 2021 20:38:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111142541.21534-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/11/21 6:25 AM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If the port is in SRP_RPORT_FAIL_FAST state when srp_reconnect_rport()
> is entered, a transition to SDEV_BLOCK would be illegal, and a kernel
> WARNING would be triggered. Skip scsi_target_block() in this case.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/scsi_transport_srp.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index cba1cf6a1c12..1e939a2a387f 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -541,7 +541,14 @@ int srp_reconnect_rport(struct srp_rport *rport)
>  	res = mutex_lock_interruptible(&rport->mutex);
>  	if (res)
>  		goto out;
> -	scsi_target_block(&shost->shost_gendev);
> +	if (rport->state != SRP_RPORT_FAIL_FAST)
> +		/*
> +		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
> +		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
> +		 * later is ok though, scsi_internal_device_unblock_nowait()
> +		 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
> +		 */
> +		scsi_target_block(&shost->shost_gendev);
>  	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
>  	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
>  		 dev_name(&shost->shost_gendev), rport->state, res);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
