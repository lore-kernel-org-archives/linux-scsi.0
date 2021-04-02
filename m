Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF23C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 01:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A91060FF3
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 01:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhDBBd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 21:33:58 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:38438 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhDBBd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 21:33:58 -0400
Received: by mail-pj1-f47.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso3949279pji.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Apr 2021 18:33:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x4Q8mSTlBLOrviPRDCLgpA/TpdpG6u1cyp/hh2Mldjs=;
        b=lro8OqqyRVBRBNPiPVpz9q60ayhKAXTvMGBElrO8vLUzErastxLiPMlkRPab+gzrcG
         5sru2YH8F+4scCM3ntzUF5G62wLJM4jbClhAAWojkZhiZfkYklk83Jup2bGED2cW3lBn
         huzn3ISBJMrjbLfEo0GJLbzocevzcXnUSZedoIE8K5V1Z6bC4q3XHYQaWJIKaPbIk/9s
         F92ALhG17XZmb3GyxkqvZFMWF0R4dmrafGGyWcnA6vi0PYyxviU9yU4j9BoooLGoBgfN
         TK0p3oloDH8eZ77BgfzyKORD0JFyM3Fi39CKkQWbyIaDZ7CKqdTVcFVQJPCCUrpmh8m0
         TcEg==
X-Gm-Message-State: AOAM531XgNJyS8sH8OS8BjKljWsZJ81hvquekbQuoMtWa3HDKKBQGaGP
        H82RXVnwzzLMb78KwiX/vWk=
X-Google-Smtp-Source: ABdhPJwzv0oT8qJVDf4PN38RPS+i7MI5GAdI4ovrYyz3JSIZmavWQbvy7bqFrZEmnCgbXH2r6oBfiQ==
X-Received: by 2002:a17:90b:4910:: with SMTP id kr16mr11343555pjb.26.1617327237804;
        Thu, 01 Apr 2021 18:33:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:2046:e611:bcdf:eb50? ([2601:647:4000:d7:2046:e611:bcdf:eb50])
        by smtp.gmail.com with ESMTPSA id s15sm6880375pgs.28.2021.04.01.18.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 18:33:57 -0700 (PDT)
Subject: Re: [PATCH] scsi_mod: Add a new parameter to scsi_mod to control
 storage logging
To:     Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org,
        hare@suse.de, emilne@redhat.com, martin.petersen@oracle.com,
        jpittman@redhat.com, djeffery@redhat.com,
        dgilbert <dgilbert@interlog.com>, axboe@fb.com, hch@lst.de
References: <1617325783-20740-1-git-send-email-loberman@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3ab37563-c620-395c-bd12-74376962728d@acm.org>
Date:   Thu, 1 Apr 2021 18:33:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1617325783-20740-1-git-send-email-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/21 6:09 PM, Laurence Oberman wrote:
>  #define sd_printk(prefix, sdsk, fmt, a...)				\
> -        (sdsk)->disk ?							\
> -	      sdev_prefix_printk(prefix, (sdsk)->device,		\
> +	do {								\
> +		if (!storage_quiet_discovery)				\
> +		 (sdsk)->disk ?						\
> +			sdev_prefix_printk(prefix, (sdsk)->device,	\
>  				 (sdsk)->disk->disk_name, fmt, ##a) :	\
> -	      sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> +			sdev_printk(prefix, (sdsk)->device, fmt, ##a);	\
> +	} while (0)

The indentation inside the above macro looks odd to me. I guess that you
want to avoid deep indentation? Consider using if (...) break; instead
to reduce the indentation level. Additionally, please change the ternary
operator into an if-condition since the result of the ternary operator
is not used. How about rewriting the above macro as follows?

do {
	if (storage_quiet_discovery)
		break;
	if ((sdk)->disk)
		[ ... ]
	else
		[ ... ]
} while (0)

Thanks,

Bart.
