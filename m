Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF39C17445
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 16:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6BF214E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 16:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKKQH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 11:07:59 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42898 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKQH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 11:07:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so10957164pfh.9
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 08:07:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qqDen71cPMe0deJ6I8e5k0Pf17UIFsIti+gPspjz738=;
        b=ijijq414uUv8mZdMYBPMKr8afq0UkHZ5meJEUCKsDmxY9iUrAf2DA1ygDORuEdeHfA
         +5kmWUwxceOFt0XSQSrpXVj84nCodJy8hSkKQ5bhB1RaTxVY+ireAV816fxtBrES2SX6
         z1sw7qH+eW3Rs49pZfN1IImnWIIPphoZdg+CtMorETGk2exR02wX47IkyYPPUbp8miJA
         +3H2LOacxtFshS2lUMXVCf6i2eV+mMbpgeEhK14a2i0Kx7KNYRzLsIwL/KWUjf7X8qjO
         4ZHbGgh7ZdDfjxfUzTRkDoSI/DORd5tNrFaQ+ROzoR30W8u+A7tHBYO8Enq//qIzidWg
         a13w==
X-Gm-Message-State: APjAAAW1Kk2FrNFLUMRN0FrFlOI0I3OZK7Nwc0nSiNSQW2ym6sWly3DT
        W4zeMNbK3GAvNDhSPL7mgPZy63uP
X-Google-Smtp-Source: APXvYqxBu5IBe0AGnnyAvcxWLoTqX0pikT4Upsieco9hPDBI2rkvsDPK82S9oVVJKQ5LsdsLyoQI4Q==
X-Received: by 2002:a62:7847:: with SMTP id t68mr21439325pfc.140.1573488475549;
        Mon, 11 Nov 2019 08:07:55 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w2sm14963048pfj.22.2019.11.11.08.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 08:07:54 -0800 (PST)
Subject: Re: [PATCH] scsi_dh_rdac: avoid crash during rescan
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191111104522.99531-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4d66f2de-aa31-1e94-61b7-f8fc6a4af677@acm.org>
Date:   Mon, 11 Nov 2019 08:07:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111104522.99531-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/19 2:45 AM, Hannes Reinecke wrote:
> During rescanning the device might already have been removed, so
> we should drop the BUG_ON and just ignore the non-existing device.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/device_handler/scsi_dh_rdac.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index 5efc959493ec..33a71df5ee59 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -424,8 +424,8 @@ static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
>   		rcu_read_lock();
>   		list_for_each_entry_rcu(tmp, &h->ctlr->dh_list, node) {
>   			/* h->sdev should always be valid */
> -			BUG_ON(!tmp->sdev);
> -			tmp->sdev->access_state = access_state;
> +			if (tmp->sdev) {
> +				tmp->sdev->access_state = access_state;
>   		}
>   		rcu_read_unlock();
>   		err = SCSI_DH_OK;

Since rdac_bus_detach() may clear h->sdev concurrently with the above 
code I think READ_ONCE() is needed to make the above code safe.

Has it been considered to change the kfree() call in rdac_bus_detach() 
into a kfree_rcu() call? I think otherwise the above 
list_for_each_entry_rcu() loop may trigger a use-after-free.

Thanks,

Bart.


