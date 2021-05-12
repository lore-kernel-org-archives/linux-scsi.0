Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A17C43616
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 302D6613B5
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346327AbhELVYB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:24:01 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:45734 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386795AbhELUrz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:47:55 -0400
Received: by mail-oi1-f176.google.com with SMTP id n184so23449445oia.12
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=RFwCPIT5MeXceKS+f/zzg6oE08U2+Fc5BHjRyxIw39JTrACdP1GEFnno0Fak1/Mm3a
         wHBMYyT/f394DqW9YwspmNecaxms3q4SuhK0gbxA5DUapbpKNFZTlYafRg7KQ9Y/3yI+
         psqZ4diD+T8DJAwml7Unsgwox1T1LBBoHt0FVVAOnueRr0PrbhzRCVa2PFCTYUwOgl+y
         UE3SQ0iH9CTRqGtMzlAyhok8tilfS3UIBYZ58L9afEXUQilicI1/+VDj6RRdo/4YYkFT
         TxH0RL7Y7NRRv427py4C7GXeM97gi5QhKWKmcQ2aIMnUD89+eZLwHiWpz4+KKhYIiQsH
         4vMQ==
X-Gm-Message-State: AOAM530dYHzRogANDLJ7z4G3BbIfTi0COt91W7GDcKHgIClq5oShgUOb
        7nFUoL3TF2kmdjQdJONciyCogaxORj0=
X-Google-Smtp-Source: ABdhPJxzUYxTtk2DGAtqyMxivfBSCUxjmFkgq9bzDIvxfOY7lVj4qCTTg6TVJmy6TWQppdlLOj2wGw==
X-Received: by 2002:aca:4ec7:: with SMTP id c190mr302852oib.32.1620852406731;
        Wed, 12 May 2021 13:46:46 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:c65a:d038:3389:f848? ([2600:1700:65a0:78e0:c65a:d038:3389:f848])
        by smtp.gmail.com with ESMTPSA id n5sm201745otq.69.2021.05.12.13.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 13:46:45 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] iser: Use scsi_get_pos() instead of scsi_get_lba()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org
References: <20210512200849.9002-1-bvanassche@acm.org>
 <20210512200849.9002-3-bvanassche@acm.org>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <3d0e8170-a285-a3cb-b812-5d33a22adc2e@grimberg.me>
Date:   Wed, 12 May 2021 13:46:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512200849.9002-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
