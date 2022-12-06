Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E99C352A1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 18:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLFSn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 13:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiLFSn5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 13:43:57 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FA0275C1;
        Tue,  6 Dec 2022 10:43:55 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id b21so14803736plc.9;
        Tue, 06 Dec 2022 10:43:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kkdpynN3ZZxXXoC+/B2qsqOUkzGgxT1EtXnN9c8yuhc=;
        b=Ez26ppM3AGoxLi+UWLdJmHaOXDcwUpb7vXYpmdT9BZRAiwkaEJOCaNzKTOxHGGdBcc
         VWMolriUOpDcpDPHISrECRIeSVu0ihazGBqc1cUQcmpaw7b+qSe6n9bi5VVisn54g1eM
         TqnHMV4lHPijV6AMdrnj0Cwjf0gCYbRxS88uzZ/ZXj4OKlcxPH9sfoH43mWuLpg6/bXj
         rAhopEliD/ueYfMXeyW2LQ0Lv1KcPughN5lYUDEi0PhS6++Nz2ZmCiHwajtjG+HhgzJA
         MeA+3RywRJPApmML8HP7fB0P46txrCHCOLN3t7ffWzlMNV/y+EEEvB0oOjH5R7ZgTgSB
         YUDw==
X-Gm-Message-State: ANoB5pmt3WPLCf4DfFPprGgF2gy8zDozTXMFF8nfVpN5JRPw+bJZ235X
        hT49FGiPooFiB28TjKF+qgQ=
X-Google-Smtp-Source: AA0mqf7j+ouvNKByY6CjriE3yqeB9gzC2l06X8kaUAU+HcxR8ONUrkX2oxkDdJixvxaJgsfMp5zJAA==
X-Received: by 2002:a17:90a:bd96:b0:219:3553:4ff5 with SMTP id z22-20020a17090abd9600b0021935534ff5mr45767962pjr.22.1670352235149;
        Tue, 06 Dec 2022 10:43:55 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:6220:45e1:53d2:e1cb? ([2620:15c:211:201:6220:45e1:53d2:e1cb])
        by smtp.gmail.com with ESMTPSA id a1-20020a63cd41000000b0045dc85c4a5fsm10068334pgj.44.2022.12.06.10.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:43:54 -0800 (PST)
Message-ID: <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
Date:   Tue, 6 Dec 2022 10:43:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Content-Language: en-US
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        virtualization@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/5/22 08:20, Alvaro Karsz wrote:
> +/* Get lifetime information struct for each request */
> +struct virtio_blk_lifetime {
> +	/*
> +	 * specifies the percentage of reserved blocks that are consumed.
> +	 * optional values following virtio spec:
> +	 * 0 - undefined
> +	 * 1 - normal, < 80% of reserved blocks are consumed
> +	 * 2 - warning, 80% of reserved blocks are consumed
> +	 * 3 - urgent, 90% of reserved blocks are consumed
> +	 */
> +	__le16 pre_eol_info;
> +	/*
> +	 * this field refers to wear of SLC cells and is provided in increments of 10used,
> +	 * and so on, thru to 11 meaning estimated lifetime exceeded. All values above 11
> +	 * are reserved
> +	 */
> +	__le16 device_lifetime_est_typ_a;
> +	/*
> +	 * this field refers to wear of MLC cells and is provided with the same semantics as
> +	 * device_lifetime_est_typ_a
> +	 */
> +	__le16 device_lifetime_est_typ_b;
> +};

Why does the above data structure only refer to SLC and MLC but not to
TLC or QLC?

How will this data structure be extended without having to introduce a
new ioctl?

Thanks,

Bart.

