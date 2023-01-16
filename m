Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF11C54EBE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 18:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbjAPSkE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 13:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbjAPSjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 13:39:18 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E224F13523;
        Mon, 16 Jan 2023 10:31:51 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id h192so20236735pgc.7;
        Mon, 16 Jan 2023 10:31:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgM7OcSUvOW2wOS7R0Olxa0MGQ+rbvnGDz26lNgbwHo=;
        b=v+aWnCC2v/P2GUKXmOHVIui2PrHfkDU4Xt91b/4K/L3jNF3lOwzl4WHYygDeXILKSe
         JCC64PFDSl1pso4BM8wVvtzxJN/2r8DHE8XUX8PQYsA8l+dYluX5BpLj9U4M+7HsuuDv
         MIffja3ADAl8bfMa5WX2z265HdK6+cK+vm56gCC5n5zLntUHn2YiHf2dqLGzffsIl2iJ
         m/CzK44N76A6XanE9tq4MA2cX6ktwD8mASn/vLo1Qc6rruvvMWDLpxW6nwjVqIEDVea+
         FgTHg34W45HxbR/ATywgX10TWNGOs0sL94Z55qQNsHet92bSJBkhNz5cwYRmO1ibcuGi
         3fcA==
X-Gm-Message-State: AFqh2krRejTpn4ixfOmuhsoI8Xy3xfd1Y2GiI0XvVpoV9BHXPXmeJ13k
        QH2Dv27dNngIqfY6LRCCZSI=
X-Google-Smtp-Source: AMrXdXuFRxLtI3U7qSXHZ3RJyMbZHS75cm6BtkLq8pZ3A4HgceusIDRBpQwHAGiwGN4hEdtPiKQikg==
X-Received: by 2002:a05:6a00:c6:b0:580:9e9e:c442 with SMTP id e6-20020a056a0000c600b005809e9ec442mr21705163pfj.24.1673893911337;
        Mon, 16 Jan 2023 10:31:51 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id x15-20020aa78f0f000000b00587fda4a260sm2213058pfr.9.2023.01.16.10.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 10:31:50 -0800 (PST)
Message-ID: <446139ab-6f9a-a6d9-c2fa-f8f773eca88f@acm.org>
Date:   Mon, 16 Jan 2023 10:31:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
To:     Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
 <228d2351-e0ff-e743-6005-3ac0f0daf637@acm.org>
 <61abebf1-4c92-a6eb-5d27-5ad223d85f46@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <61abebf1-4c92-a6eb-5d27-5ad223d85f46@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/23 10:12, Steffen Maier wrote:
> How would removing this check solve the other and seemingly more fatal 
> (even without panic_on_warn) WARNING?:
> 
> [ 4760.878107] do not call blocking ops when !TASK_RUNNING; state=2 set 
> at [<000000017ed2c0fa>] __wait_for_common+0xa2/0x240

Isn't the warning address the same for both reports, namely 
alua_rtpg_queue+0x3c?

> FWIW, it seems we only seem to get such reports for debug kernel builds 
> (not sure which kconfig options are relevant) but not for production / 
> performance builds.

Sleep-in-atomic warnings are only reported with kernel debugging 
enabled. With kernel debugging disabled, sleeping in atomic context 
results in different behavior (kernel hangs).

Thanks,

Bart.


