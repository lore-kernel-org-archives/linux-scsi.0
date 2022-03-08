Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E27C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 04:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiCHFAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiCHFAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:00:53 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADB424BC3
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 20:59:57 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso1333237pjq.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Mar 2022 20:59:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6KVf7vCgbs2qCLpTyIna6quzpgLz2/dNWVQtIuaDAtU=;
        b=4GS/7DUDNAYXqvkVxyjMW6i/IWxS4dJeL/KVr08VkGKPwjD7yIx8uMSJ8bLs2FH05e
         eui25l8PCCBCMtKxQGPbn44KFt9FxNkP/rt5stQpXuPsXbtc0gVkw5xHvDk5SV+FWIBx
         ZM6IskKA0PrRA/IIRKyaStK3EPEUfCL9udpQwiY0B/qynlav+t2PgFF48tS8NTJXhYNT
         biqkpY83pLGiKbWyP4BhLE55NPScJItYvp1Td73yVr+9YFhsv/ZK83vMBAVU75WnJ2w+
         UeAYWs04C0ZXiaMKcl8QCEQv6Exb6QjXXGcoN1OTZAD2nfMImLFxdBBYEsNkwKlFSOKy
         CMPg==
X-Gm-Message-State: AOAM532Pbe+SyNSop1E4vbx43f9wvHTUnbwZZ0RWIElW4wvbk6dHQq69
        TuMNUgYz8MNhjRJiYNQwL6A=
X-Google-Smtp-Source: ABdhPJz4dM8J8e2ouOkYue3hG8/mUnLooNnihpuDJ0gPZaQV/P10B/O3B4HO0KU/afdJs5V+ZqVV0w==
X-Received: by 2002:a17:902:854a:b0:14e:e053:c8b3 with SMTP id d10-20020a170902854a00b0014ee053c8b3mr16074869plo.8.1646715596441;
        Mon, 07 Mar 2022 20:59:56 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm17082738pfj.128.2022.03.07.20.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 20:59:56 -0800 (PST)
Message-ID: <21b6ff27-84ec-5a54-ef1d-80c6614e22bb@acm.org>
Date:   Mon, 7 Mar 2022 20:59:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 2/4] scsi: iscsi: Tell drivers when we must not block
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <20220308003957.123312-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220308003957.123312-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:39, Mike Christie wrote:
> -static int iscsi_iser_task_xmit(struct iscsi_task *task)
> +static int iscsi_iser_task_xmit(struct iscsi_task *task, bool dontwait)

Arguments with "not" in their name easily lead to double negations. Has 
it been considered to change "bool dontwait" into "bool may_sleep" and 
to inverse the argument passed to this and similar functions?

Thanks,

Bart.
