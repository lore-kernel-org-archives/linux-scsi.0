Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54933C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jun 2022 03:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbiFUD4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 23:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiFUD4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 23:56:50 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148F22127F;
        Mon, 20 Jun 2022 20:56:50 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so8460634pjr.0;
        Mon, 20 Jun 2022 20:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0dn1nrEhMmNTab7d8HWQiHYpxCy3xYlyPAzQg2QoWuQ=;
        b=6STyHIfsVEngcpAXTqj6ajpAn3xWZ8mZUOwy9gShBFF3QMwJuRBmYNY16mBubSqNUk
         6mQQmppXGivDfFZy9/kAe9GsQA78b/UbOFOZesp09Kxm8ngQ/A8LJoBP6/4NwH84t1ro
         4R3DVWjwKwYPnMot5/u+5m6+YiKF0qKHQhT3f6IIUm5ZeoLAuxsMkDTIi6T0nOEJ4ze6
         ZKLm9DKLkmTZuCXtVIV+ZIlgfE7DddNrMRPmEU1t8CWwTA/oDChcy8hqRJXiK7e9E80j
         VtYP1FOhXVOOiJS1Qp7gEhlAKsqBnMTZ1YG5VCbqlzQL0flabslnNX2U+67q8CHeaf/3
         27Yg==
X-Gm-Message-State: AJIora8QpxqIHAx7KuLLQ1g2y0p2Gn1tIBctyGt4xeERU3xuooHKZt1F
        sGIjf3RNJ1yhDp/WmfAIZ44=
X-Google-Smtp-Source: AGRyM1uFV8Ime7c/P/pn6ocMTrvvGTYTVYiFhpcniEJqxG3Gfafbfm2MLBaGJtH1W//X43U71EMZAQ==
X-Received: by 2002:a17:902:e411:b0:16a:187d:99ac with SMTP id m17-20020a170902e41100b0016a187d99acmr12595347ple.25.1655783809383;
        Mon, 20 Jun 2022 20:56:49 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090264c200b0016a12fab6c2sm5175804pli.307.2022.06.20.20.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 20:56:47 -0700 (PDT)
Message-ID: <f21b7a51-ccb0-b8dc-a48e-94a7a0f7e125@acm.org>
Date:   Mon, 20 Jun 2022 20:56:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] trace: events: scsi: Print driver_tag and scheduler_tag
 in SCSI trace
Content-Language: en-US
To:     Changyuan Lyu <changyuanl@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Rajat Jain <rajatja@google.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>
References: <20220620202602.2805912-1-changyuanl@google.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220620202602.2805912-1-changyuanl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/20/22 13:26, Changyuan Lyu wrote:
> Traces like scsi_dispatch_cmd_start and scsi_dispatch_cmd_done are
   ^^^^^^

Aren't these called "trace events" instead of "traces"?

> useful for tracking a command thoughout its lifetime. But for some ATA
                                 ^^^^^^^^^
throughout?

> passthrough commands, the information printed in current logs are not
                                                                 ^^^
is?

> enough to identify and match them. For example, if two threads send
> SMART cmd to the same disk at the same time, their trace logs may
> look the same, which makes it hard to match scsi_dispatch_cmd_done and
> scsi_dispatch_cmd_start. Printing tags can help us solve the problem.
> Further, if a command failed for some reason and then retried, its
                                                         ^^^^^^^
is retried?

> driver_tag will change. So scheduler_tag is also included such that we
> can track the retries of a command.

Despite the above comments, thanks for the detailed and very informative 
patch description.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
