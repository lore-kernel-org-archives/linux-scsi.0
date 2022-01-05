Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9989C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 19:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243650AbiAETl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 14:41:28 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:35604 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiAETlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 14:41:24 -0500
Received: by mail-pj1-f52.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso5482550pje.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jan 2022 11:41:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aJ+G9k7d0StPk0o8VI97gj8oK+gzU5dCSPRihqKG1L0=;
        b=kx3DIqACcKO3TTVRm97DVYGYVWJ7peTxlxb9Wqid8D0oC/HfMxSAtk9ZXW86r8Bvqd
         6xN2xth/phlI7KJoCyPrJeijdLuhMAHnwSQtS9p/3m1g4XR8s9k0K+B+VvvTO83Y9E/X
         b4/bZwAfrqigxgu5esa20T/qgdbPwc7z+Ku8JRrAubUAyp1aEysF+oPsIEtXH7sUyayF
         20fw/QkWQW6o2ei49V5XjaYTAV61QPUhO5fVcv+WZfy57/70n65xq/Hz656LmQYvBF9H
         NPlHZcEGAl5cibNZIhTxMX6r9ZPPuGcNIgdSKTfFZ/r5QV4iPrprf2TDaC2rvtSR2o3v
         oyvA==
X-Gm-Message-State: AOAM532eNzvjOagV4dx1uzTGTmXWufFjmrAczGI5bviiBo/Xt6/rnHOZ
        MhWJzAdLAwMFhKgfX3hGrSERa7ep0FA=
X-Google-Smtp-Source: ABdhPJzSi8ATT0KcxYLZPSaGhUxChmCRXW/sSheZ+HSfwIeuVVNrhc2QLPEZgjt6DaAbBzBSLPk9Tw==
X-Received: by 2002:a17:902:da89:b0:149:304b:fd70 with SMTP id j9-20020a170902da8900b00149304bfd70mr54499291plx.53.1641411683571;
        Wed, 05 Jan 2022 11:41:23 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:fe3a:aa6c:7088:7ef7? ([2620:15c:211:201:fe3a:aa6c:7088:7ef7])
        by smtp.gmail.com with ESMTPSA id u15sm48653089pfk.186.2022.01.05.11.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 11:41:22 -0800 (PST)
Message-ID: <30eee7ac-7749-4f9e-9e6d-2856ec55d469@acm.org>
Date:   Wed, 5 Jan 2022 11:41:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 1/9] scsi_debug: address races following module load
Content-Language: en-US
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        Luis Chamberlain <mcgrof@kernel.org>
References: <20211231020829.29147-1-dgilbert@interlog.com>
 <20211231020829.29147-2-dgilbert@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211231020829.29147-2-dgilbert@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/30/21 18:08, Douglas Gilbert wrote:
> +	if (READ_ONCE(sdebug_deflect_incoming)) {
> +		pr_info("Exit early due to deflect_incoming\n");
> +		return 1;
> +	}

The new mechanism will work fine on x86 but not on ARM systems. Please
change all READ_ONCE(sdebug_deflect_incoming) calls into
smp_load_acquire(&sdebug_deflect_incoming) and all
WRITE_ONCE(sdebug_deflect_incoming) calls into
smp_store_release(&sdebug_deflect_incoming).

Thanks,

Bart.
