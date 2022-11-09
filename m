Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F5DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiKISuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiKISuJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:50:09 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F4A1743B
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:50:08 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id gw22so17555808pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KtkHVsOJmickhey8mzfqsdDSZQNM87yvYhjWndfM9/k=;
        b=l9Gkd0NQxDsFH/Kn6OyV6zDm3pYOT4xhjEj4VMpBZ08yqwUZEkkIEYW2M0w0Kp/2cJ
         C1kRvI5N9GhsoUmP9uVcyF+I3ECRmx7gWJqAsTEwrb9aQySsOxifIafmPzVZOSG1aA1m
         yAG6K8dmJgPKjiQ+j30BNAyajPtHwyLg+s9IvRcZPmMSfHiTWGXhmYnFerN46QS32ilq
         0iU9poz/NwqwQ3QK41faoRnc8k+KWppMhDe5ylHJKNnwLhh9MMXEHr3VGMu0QzuEaLC/
         4Y4+h7wKfdztdF/97sw+NAGpMHQN11XqRve+BoRR1GqWl9i8nC/h4X8h4VCwptK0gMeA
         /PgA==
X-Gm-Message-State: ACrzQf3Lj7aK4BaTGo6BVdyEZCQbsbdPaeYOhv8MjiHVbNfdgcbmxEzC
        AIOFLX+W5lNMOrKMGCGJ0vo=
X-Google-Smtp-Source: AMsMyM4vY5CCiEzBoyadJjk8WLFoUofgtbYAho+06pShhpvPJxKSRyyBiZWW4fBLdULq6pXsux6gBg==
X-Received: by 2002:a17:90a:840c:b0:20d:11e3:3b26 with SMTP id j12-20020a17090a840c00b0020d11e33b26mr1240163pjn.133.1668019807988;
        Wed, 09 Nov 2022 10:50:07 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00172f6726d8esm9415317pln.277.2022.11.09.10.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:50:07 -0800 (PST)
Message-ID: <7fa5c97a-fc65-4940-1f59-f77bb44828f8@acm.org>
Date:   Wed, 9 Nov 2022 10:50:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 27/35] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-28-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-28-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> This has ch_do_scsi have scsi-ml retry errors instead of driving them
> itself.

How about splitting this patch into two patches - one patch that removes 
the 'unit_attention' member variable and a second patch that reworks 
scsi_exec_req() error handling? With or without that change:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

