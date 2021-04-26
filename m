Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B42C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 04:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9571D611CC
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 04:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhDZELU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 00:11:20 -0400
Received: from mail-vs1-f50.google.com ([209.85.217.50]:43750 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZELU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 00:11:20 -0400
Received: by mail-vs1-f50.google.com with SMTP id h19so9001503vsa.10
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 21:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RxXdLKOcKmxfvLTSiENTHF5jpkdyLpnf8PZWQqc5rJs=;
        b=c+HLFGwUy/YFwK3ZMXTWGwpjdcT97A2n0WfeI6ssKGDhiAhmnCkge+9GvZOTr3YbXC
         OCfoIm98lCOkq6HG6I5zOD3VclUnY941E+KCGptbqiXACd8af+RkyCsWR1CT0DRrhle+
         E+O05T4vK9w4IWk5ut8QERNUi/zHKiB3hYz/2O7Zw4JSiIL7K1hU+Qf8qjy2veRe1m/V
         SfLbv9Y6lUr4d0pXGw5j9uDJ0cgD1PMLeQxdgzI/jeGRQsR8KuvufN6DW0cDoi8Id4B+
         +5j6c6o66GWlC8KBAuNuVyWOaMs5rSQX1robAXQsXJGLO8OBp/Bkij+ctZ7qOH9cH5wE
         AM+w==
X-Gm-Message-State: AOAM530EvjyHOxS1quswlxGm2eBuf+eZAUJGcdhtRvrJdkKr/UarJ5YY
        WDI/fbzaZcfbwjfJzGYAnubErmkNCQ4gcQ==
X-Google-Smtp-Source: ABdhPJzCWeSGpwenPjZYqSB6vk5wZWIqm/DfvoMz5KmAfg9xFyWDiEXzhUg33+TsWedBH7+2iomneg==
X-Received: by 2002:a62:1401:0:b029:25a:d41c:fb2e with SMTP id 1-20020a6214010000b029025ad41cfb2emr15956548pfu.51.1619408692101;
        Sun, 25 Apr 2021 20:44:52 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q8sm1743618pfk.137.2021.04.25.20.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:44:51 -0700 (PDT)
Subject: Re: [PATCH 12/39] xen-scsifront: compability status handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-13-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f6f18bcd-8873-d37e-ce76-161196fff33c@acm.org>
Date:   Sun, 25 Apr 2021 20:44:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-13-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> The Xen guest might run against arbitrary backends, so the driver
> might receive a status with driver_byte set. Map these errors
> to DID_ERROR to be consistent with recent changes.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/xen-scsifront.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> index 259fc248d06c..0d813a2d9ad2 100644
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -251,6 +251,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
>  	struct scsi_cmnd *sc;
>  	uint32_t id;
>  	uint8_t sense_len;
> +	int result;
>  
>  	id = ring_rsp->rqid;
>  	shadow = info->shadow[id];
> @@ -261,7 +262,12 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
>  	scsifront_gnttab_done(info, shadow);
>  	scsifront_put_rqid(info, id);
>  
> -	sc->result = ring_rsp->rslt;
> +	result = ring_rsp->rslt;
> +	if ((result >> 24) & 0xff)
> +		set_host_byte(sc, DID_ERROR);
> +	else
> +		set_host_byte(sc, host_byte(result));
> +	set_status_byte(sc, result & 0xff);

The "& 0xff" isn't necessary in "(result >> 24) & 0xff" since 'result'
is a 32-bit variable.

Thanks,

Bart.
