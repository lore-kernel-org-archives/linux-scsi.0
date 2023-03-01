Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0B7C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCAXuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCAXuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:50:11 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F9A37F0B;
        Wed,  1 Mar 2023 15:50:10 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id u5so12382843plq.7;
        Wed, 01 Mar 2023 15:50:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0OIgFmEFtc+C2R0Qcf7EO5fQFJ5xFbdomNNE+DU4Mr8=;
        b=6FknR2XE/k3UR7p5TlwmDY5KYt3YG4SG8oMOg9pbnwumfUVrBtcdmcvzgIrovPCQXW
         M5ejCS7TKZ/su2ohz7EqPUdOF9bQ1z9tBA5k35GOc8T7XeAHhjURlset2fmmLLj7sy7D
         L1AnpvsZFODVAMy9Z/N6l9OvvBojmenFH1+VxAfdySkIPGEJfwfeGbgKINcFUq5rVS6n
         GOXoH4fRAnW+vGBE7C76EWE7iN4VTCCtgjXn3A/G+wp9vdbh8IqufBKp3xvAu53k4sUG
         EhxCS/WM69Py1RRgd5yc36ZoYOv2AqovyWQQQxpJLFuNhcgGp0+R4l7WyMIpQWmPsFaX
         ePxw==
X-Gm-Message-State: AO0yUKUpzSqnbkfWXWS67P07tNgyFhg1wl6mrFk3tV3Y0uj+2a9xQFUA
        M9cdOoHydzU1z50hsIWWBEqn8MaGW3A=
X-Google-Smtp-Source: AK7set8kjFnsUYrTv6rfMERrD4Qq0qpoGvPq3OzvBNEfNKYIl2RA/EDN8yaFy5PTQfETxBIIjcEuGQ==
X-Received: by 2002:a17:90b:1652:b0:237:ad8e:e3b1 with SMTP id il18-20020a17090b165200b00237ad8ee3b1mr9555782pjb.8.1677714609548;
        Wed, 01 Mar 2023 15:50:09 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:ee04:e3cd:c905:c9ed? ([2620:15c:211:201:ee04:e3cd:c905:c9ed])
        by smtp.gmail.com with ESMTPSA id t21-20020a17090a951500b002347475e71fsm318387pjo.14.2023.03.01.15.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:50:08 -0800 (PST)
Message-ID: <ad8b054a-26a5-ea60-9c66-4a6b63ca27ef@acm.org>
Date:   Wed, 1 Mar 2023 15:50:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF TOPIC] Hybrid SMR HDDs / Zone Domains & Realms
Content-Language: en-US
To:     Khazhy Kumykov <khazhy@chromium.org>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/23 15:34, Khazhy Kumykov wrote:
>   - There’s already support in the kernel for marking zones
> online/offline and cmr/smr, but this is fixed, not dynamic. Would
> there be hiccups with allowing zones to come online/offline while
> running?

It may be easier to convince HDD vendors to modify their firmware such 
that the conventional and SMR zones are reported to the Linux kernel as 
different logical units rather than adding domains & realms support in 
the Linux kernel. If anyone else has another opinion, feel free to share 
that opinion.

Whether or not others agree with my opinion, I think this is a good 
topic for LSF/MM.

Thanks,

Bart.

