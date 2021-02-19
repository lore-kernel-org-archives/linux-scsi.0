Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AB6C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1670364EC0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBSTqB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhBSTp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:45:57 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5689FC061574;
        Fri, 19 Feb 2021 11:45:17 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id e13so12466766ejl.8;
        Fri, 19 Feb 2021 11:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dUGdp3YLs2BZmXGrzi6F4KewLbPwl+iYjXY9YqwK4EA=;
        b=ieQKu6GJLnktpb9Vr9FZA7GT7LBi1QGxATM0BI5Dv1IOW62oY/lizln9L3RT0L7kbG
         6y+YxqjEwb+kT00HLBc9vqKsJKEjf8hWk33VRiACWi7JX59qoAUNjCcSKwK0Ci5GBdaM
         vfV0nezZ9InK+J8d45uSMuJzBLZ/gYVPAf3kXJrdwzIr7qxoyHZXAl2jSoTMx2RaTpAr
         ZB64549+/QKvPzUOIqVDbUZgLEt5KhLMjDmuUgMR24EOdbqssUWzyeeG1MsaLreZWs9Z
         YohTb6tDUnt3WTRHJUQjFrlEVvXfAHMDQ3W180zsfi5rIRAaqLWQPTgGVOahn9Qw8UBj
         0xVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dUGdp3YLs2BZmXGrzi6F4KewLbPwl+iYjXY9YqwK4EA=;
        b=t2gPjAZJ83CSMQiQSqeRJNTNa8SF98vVtFfKB8GfQBGNdBm7Ya/RcL8mYsplcseMPS
         nh1fGymHbJqzOdUxva2At4YejhlHcZfTQk298lh9zvtftHXEexvdQX/yn/YKtoSbQOX0
         CtMsqHnSDWqJWVuo+vryb/+Fu5QK7dIuDDec3nh5Pxnd9VHgnA8LnsXzaaHHWmEDv+XV
         hjAMpzjDkdKHXg8JCM0h1D7FLbgq+C58DXUkWKUgwGOXnDGAjUVWr5TEXnlDFHCmgQlG
         Xq8DVLMj6V4A4xlxRlzxxO0g/cVdD3r2jc0hujHqXokvOX/GQtZnrdq3wyCBzHKSAZyq
         n/lQ==
X-Gm-Message-State: AOAM531Rua7X3xxl6CSXh/bcHYIPf2CqD06U5xCavAgnD18jxoMGe0Xj
        Tij6oi6M4oJUfqfKctwA0+IcPVIGvQY=
X-Google-Smtp-Source: ABdhPJxMiOQ+zcQgp/GNd7TWp7MKr5unkvzuNQR4WDiriUdaQlWISrS1Hh/McO8zxho6tI+25ecS/w==
X-Received: by 2002:a17:907:78d5:: with SMTP id kv21mr10209054ejc.461.1613763916068;
        Fri, 19 Feb 2021 11:45:16 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id u18sm5119866ejc.76.2021.02.19.11.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 11:45:15 -0800 (PST)
Subject: Re: [PATCH 23/25] target_core_user: add backend plug/unplug callouts
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-24-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <3cb1059f-fbdd-499d-e59d-9fc3a6a0c1bf@gmail.com>
Date:   Fri, 19 Feb 2021 20:45:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210217202811.5575-24-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.02.21 21:28, Mike Christie wrote:
> This patch adds plug/unplug callouts for tcmu, so we can avoid the
> number of times we switch to userspace. Using this driver with tcm
> loop is a common config, and dependng on the nr_hw_queues
> (nr_hw_queues=1 performs much better) and fio jobs (lower num jobs
> around 4) this patch can increase IOPs by only around 5-10% because
> we hit other issues like the big per tcmu device mutex.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_user.c | 27 +++++++++++++++++++++++++--
>   1 file changed, 25 insertions(+), 2 deletions(-)
> 


Looks good.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
