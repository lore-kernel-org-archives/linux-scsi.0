Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7D8C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 16:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC9561108
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 16:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhHBQAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 12:00:38 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:35791 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbhHBQAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 12:00:37 -0400
Received: by mail-pj1-f54.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so6585368pjs.0;
        Mon, 02 Aug 2021 09:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KJPWKLrfaK2e0yJl6JQWP9RmJpRiCp6nhz3lhMlLXo0=;
        b=hZl0hP4nYqr33WgA1ORnnbXqPIY2Lm4Mc60Wm3b+VIyf3e43wsd8EKp7uneOHHm2ap
         nGTHcmjsL6dKDKcg+EESGFSXGBjNTyql2vQgbcy/vXUfy/HArO4R5S2eq/gB4iowHwU6
         4AbfZfvBLRFp0pr4jqiV6/mSXaQJnJKP8QeusVtFp3Giy1M73bqKSbX88QAoG6QrX3ZC
         zdSc571te/5DhNtZhxxhFfDjTC7yuoDA4g6sBTUIR2McL+qloUA9D1BfLi86xfqtzJa/
         5eYBtp34zfG6hEjIu2kisFMYP2iEGGpW8k9dSjabGxuuobR7Iptab7b4fvGhuY50aOhG
         QbKw==
X-Gm-Message-State: AOAM530iZJ7AyuaFXLQX2AH5Tx3u/pWydrRWeDQBDDMeCimw5+IWDjvj
        gCmfcTMqqc7EMzmAZ4vsWKI=
X-Google-Smtp-Source: ABdhPJx3oQlq4ikSI5le0GEW5NYWZHvRD7EGyFirnsSLqzg83Q6VHnEf0pFZ+3TiEYOa7hBir2tyhg==
X-Received: by 2002:a17:90a:b009:: with SMTP id x9mr14596160pjq.55.1627920027053;
        Mon, 02 Aug 2021 09:00:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:1687:85fe:8bf4:9fb9])
        by smtp.gmail.com with ESMTPSA id z11sm11050881pjq.13.2021.08.02.09.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 09:00:26 -0700 (PDT)
Subject: Re: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs
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
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
 <20210802090232.1166195-8-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <82a38e44-f0d5-6089-3297-7a6d1293559c@acm.org>
Date:   Mon, 2 Aug 2021 09:00:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802090232.1166195-8-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/21 2:02 AM, Damien Le Moal wrote:
> +/**
> + * sas_ncq_prio_supported_show - Indicate if device supports NCQ priority
> + * @dev: pointer to embedded device
> + * @attr: sas_ncq_prio_supported attribute desciptor
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read/write' sdev attribute, only works with SATA
> + */
> +static ssize_t
> +sas_ncq_prio_supported_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			scsih_ncq_prio_supp(sdev));
> +}
> +static DEVICE_ATTR_RO(sas_ncq_prio_supported);

Since this is new code, how about using sysfs_emit() instead of snprintf()?

Thanks,

Bart.
