Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43F7C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 18:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCISnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 13:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCISnD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 13:43:03 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44075AB
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 10:42:53 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id d10so1625775pgt.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 10:42:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678387373;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8izKDlBJQYhVuiQIu4V49HfvoxGgSCwG5WbvLGvtKo=;
        b=uFu0OgEoUpqIalq6DeR8Zvz676G58SZJjjzCCTFjIvB8aDrb5At/7Nxhpd5usdnzAq
         7lh6CEEWRQi1hUR1HVpLKzJqke9zacH0VuC5yqaNhNQi7Yl29lP9+aouQ19WccPhMUBw
         UHv98wJjnHbw7Eq6agvu+kAzHsU4WUkrOE1T1bDLS3+2bB7eKrq2MwrLZ0yIT4j1+geN
         w7l0/RsNPBzuVLVuyM1sm6UqjmXfE8UpfB1REgHxoiiKKW04FAL+aKo5qMJTHB3BwiS2
         be477yzFir0RqtAqo1AtCTGP11/tlS7nSqts9IAA2MEsc3n0VYO7r0wNWXRnN4Nwld+G
         hqpQ==
X-Gm-Message-State: AO0yUKUfcwH7CSjF7fDdp3EmuaH6IzDxw5NK22y1U8HyNWdgeo9jsLRY
        1h1cG2BdRN0vGMeWV0/am6cWM9q4YBM=
X-Google-Smtp-Source: AK7set9hQYSNqisA9lY5xq60OUqSORusFEP1a0wkJPO3gUrwmwuZaDQIpuUTrfkw2ESRJNQ88K31wQ==
X-Received: by 2002:a62:4e43:0:b0:5d6:4ef8:8c6f with SMTP id c64-20020a624e43000000b005d64ef88c6fmr17967647pfb.34.1678387372683;
        Thu, 09 Mar 2023 10:42:52 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id s2-20020aa78282000000b005905d2fe760sm11579782pfm.155.2023.03.09.10.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 10:42:52 -0800 (PST)
Message-ID: <db248a4c-14bb-3e8f-7d25-c7e56ac7efcf@acm.org>
Date:   Thu, 9 Mar 2023 10:42:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 01/81] scsi: qla2xxx: Refer directly to the
 qla2xxx_driver_template
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-2-bvanassche@acm.org>
 <fb29154c-fdac-8b45-1e8a-4b4e732e4dd7@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fb29154c-fdac-8b45-1e8a-4b4e732e4dd7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/23 05:10, John Garry wrote:
> Apart from that, I will say that I haven't studied the driver in detail, 
> but my impression is that we should just set this flag per-shost in 
> base_vha->host.active_mode, and not the host template supported_mode 
> member. Indeed, we don't even seem to be making this driver 
> scsi_host_template as const in this series, which I thought was the aim 
> (and I assume because of this).

This patch is necessary because this patch prevents to declare the 
'hostt' member of struct Scsi_Host const.

Thanks,

Bart.
