Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C600C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 18:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2366D6113D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 18:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349790AbhIHS37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:29:59 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:45824 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350369AbhIHS3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 14:29:30 -0400
Received: by mail-pj1-f50.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2153970pjq.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 Sep 2021 11:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VD7CgH6LmzPGFepmYwj/XJvv5e8RaOhEdaE4SiHDyRU=;
        b=bP/YX4jEHUDfkTnVk/UXHbvCDO1F0IXg/7H2BCdxSxJkHzpagSgss4jKResB5ZtGtR
         G8jPPmtnJfSwiRNy+eSXhYe1fdkyStV0XLRtzpWa/WI0I8ziipxHAsb3grALJwJkB+Zs
         UQ+jq8Gvod1jI+yoXEYuTR1YR3dS1HrBTMM9Eex891IK+H3FZQJVGuthwK+vIIl1al+T
         YmoGZ2O9ub9z3GesE/trQ1NxbdlkyPAzxhbiEv2rASKP6e/r1fZwY/qhWhwz3PiYoRiw
         Ds/qjUqEt+bi/es5gnNPvREW9EYyqkTgpqMf+3DuWdRGwpg6jNwRWsO2w5agyowCAdfX
         qHsg==
X-Gm-Message-State: AOAM531L8pLwRJ0Zp+Mcv/VwqrdN5zl/3NrWOxjnncJWcBFAyiWjwPCa
        bfxG7rjIlvidNYQWKGOdrgA=
X-Google-Smtp-Source: ABdhPJylWRgbJYJc848q6vjWv3mMkAkdpB/B6gtLvmD/rpt/qfJmocLB+FGe8v3MUqSZYC8ANbZpqw==
X-Received: by 2002:a17:90a:1a4c:: with SMTP id 12mr5655857pjl.195.1631125699297;
        Wed, 08 Sep 2021 11:28:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c0ea:8a04:6095:f44a])
        by smtp.gmail.com with ESMTPSA id x10sm3273257pfj.174.2021.09.08.11.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 11:28:18 -0700 (PDT)
Subject: Re: [PATCH v2 01/10] qla2xxx: Add support for mailbox passthru
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        djeffery@redhat.com, loberman@redhat.com
References: <20210908164622.19240-1-njavali@marvell.com>
 <20210908164622.19240-2-njavali@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <96a11a9b-fc55-0826-1970-b37b738c3c97@acm.org>
Date:   Wed, 8 Sep 2021 11:28:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210908164622.19240-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/21 9:46 AM, Nilesh Javali wrote:
> +struct qla_mbx_passthru {
> +	uint16_t reserved1[2];
> +	uint16_t mbx_in[32];
> +	uint16_t mbx_out[32];
> +	uint32_t reserved2[16];
> +} __packed;

Why does this data structure start with 4 reserved bytes?

Thanks,

Bart.
