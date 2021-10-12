Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E86EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 16:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 340BA60E53
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 16:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhJLRBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:01:35 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:35630 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhJLRBe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 13:01:34 -0400
Received: by mail-pf1-f177.google.com with SMTP id c29so110809pfp.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 09:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JZoXwqt/8j22e8oqDYyflr9qwzwN1laMVBBTprNwrEY=;
        b=LELBGJ7LbFa+PzCENgA7sl2DdqFv4z0W6ZCjhH5wJTjYHOwznAJtGZp4aOJNTqgfRu
         CYBhz9busUAQCn+OGpMkzdPQSSKfGXfU43GuQiWbqiRF8cXRgqDF2EvBJ9PRzZVlT64B
         f7Rg8lEwk0bNO6sb1bM7rK820es/htDc2iGyIzjYZQzpM5XHu9hOp+VEe79lCkDwjSkD
         XquJGr1KTmPNUla4E6hZZDHGrRqewSNfvIRPllUq3VtOL67aS25krhEojqGaoqThnkf+
         X1U3j+CQh0f6OUx8EHBUwP2Mm3QPmGkdEMRl8OB9JgyOiISJSu+iHqxxpWOl1ubMD+X+
         ZORA==
X-Gm-Message-State: AOAM533/eos1xVRIV+kNA17BBs9jR0D+4Zu6gtPexYfKd98iVLhiovr4
        Ml4Vd/LajPhuVTYCeGIoNohsqXM2UIQ=
X-Google-Smtp-Source: ABdhPJwQA60WqAEy6B67QL5nHhVEW+f4a4qxumJcb5IIobWqeNCgywCUnVhULAb4yu5tRzpJHFtNkw==
X-Received: by 2002:a63:da14:: with SMTP id c20mr23859802pgh.155.1634057972252;
        Tue, 12 Oct 2021 09:59:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id m7sm11791300pgn.32.2021.10.12.09.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 09:59:31 -0700 (PDT)
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
 <20211012144906.790579d0@songyl>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
Date:   Tue, 12 Oct 2021 09:59:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012144906.790579d0@songyl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 7:49 AM, Yanling Song wrote:
> On Mon, 11 Oct 2021 12:54:20 -0700
> Bart Van Assche <bvanassche@acm.org> wrote:
> 
>> On 9/29/21 20:47, Yanling Song wrote:
>>> +#define SPRAID_IOCTL_RESET_CMD _IOWR('N', 0x80, struct
>>> spraid_passthru_common_cmd) +#define SPRAID_IOCTL_ADMIN_CMD
>>> _IOWR('N', 0x41, struct spraid_passthru_common_cmd)
>>
>> Do these new ioctls provide any functionality that is not yet
>> provided by SG_IO + SG_SCSI_RESET_BUS?
> 
> These new ioctls are developed to manage our raid controller by our
> private tools, which has no sg device. so SG_IO cannot work for our
> case.

Why won't an SG device be associated with spraid device nodes? My 
understanding is that an SG device is associated with every SCSI device 
if CONFIG_CHR_DEV_SG is enabled and also that a bsg device is associated 
with every SCSI device if CONFIG_BLK_DEV_BSG is enabled.

Why is it that SG_IO is not sufficient? This is something that should 
have been explained in the patch description.

>> Additionally, mixing driver-internal and user space definitions in a
>> single header file is not OK. Definitions of data structures and
>> ioctls that are needed by user space software should occur in a
>> header file in the directory include/uapi/scsi/.
> 
> Sounds reasonable. But after checking the directory include/uapi/scsi/,
> there are only several files in it. It is expected that there should be
> many files if developers follow the rule. Do you know why?

If this rule is not followed, that will be a red flag for the SCSI 
maintainer and something that will probably delay upstream acceptance of 
this patch.

Bart.
