Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9BBC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 17:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiKJR0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 12:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiKJR0k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 12:26:40 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B0D1839A
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 09:26:39 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id z26so2792455pff.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 09:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx6B5EajG2p/x0K/8Xmk6JMuVD/5gYYGT8SoTpYWf8c=;
        b=vUalqUyQoJzkFzgl29JqXkCRtrdTy+Fdd35r1mNsZZFpFD2s3C6rjG/n/JhLZCvCQL
         7axihw2qalgBujoNkvECgXIEdpUry9Nx+WQm95APfDGcRfO0244XflZKAK59IJzp62Zg
         iboKHZdZq6cbvmXPHBdbriQmhiy601X6fIN82rSwrKY+rLYLmhvc643plDloFA7BqdOf
         0I5L707GTBf9n5mTXQKZRPh73GKTkAQnEMTOyPThsIS5ov0ETPHw6bi/n3HihP7cGBz8
         K0IttmM5Yjb7++w74nMKR95v2vk7fzABnbFQly6MVxDBIh4KWfu+boAXt3ykNkvvxvVl
         2Niw==
X-Gm-Message-State: ACrzQf2zzTHOrunsAVMNUuqDmloHSr0utiJMwRF9cKiQK6MoClPrPwos
        KRZML/W7K005kkVJxe0eKxM=
X-Google-Smtp-Source: AMsMyM6loaVx8EWCJMbnyMO4Ww/GHGKmybk8gebglLMt6zMZQtJ1c8Wuo4SDdlIy2yEU79GqUB5xDQ==
X-Received: by 2002:a05:6a00:3490:b0:563:8011:e9e4 with SMTP id cp16-20020a056a00349000b005638011e9e4mr3053957pfb.76.1668101198930;
        Thu, 10 Nov 2022 09:26:38 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:2ecf:659:1c55:5? ([2620:15c:211:201:2ecf:659:1c55:5])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f54200b0018725c2fc46sm11535526plf.303.2022.11.10.09.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 09:26:37 -0800 (PST)
Message-ID: <13010fb2-13df-ed0f-031f-d65fdc4738f7@acm.org>
Date:   Thu, 10 Nov 2022 09:26:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
 <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 03:15, John Garry wrote:
> Current method means a store (in scsi_exec_args struct), a load, a 
> comparison, and a mov value to register whose value depends on 
> comparison. That's most relevant on performance being a concern.

Hi John,

Is there any code that calls scsi_execute() from a code path in which 
performance matters?

Thanks,

Bart.

