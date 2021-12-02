Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62069C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 23:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242554AbhLBX7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 18:59:42 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:38542 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbhLBX7m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 18:59:42 -0500
Received: by mail-pg1-f180.google.com with SMTP id s137so1314965pgs.5
        for <linux-scsi@vger.kernel.org>; Thu, 02 Dec 2021 15:56:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XYr5qnrTJq7UFpm7ZkFEeXoXgXb87ZAhxCaIWjzsKpY=;
        b=73ima+iYWkqyujIkhCWdlCiyUfqNGqrcPkEp7nllZyPDHGSSplieM3pKLlThkWcAYw
         14eOeS/n2CmcMCQ/x3mwbaDPgh0OpzVWc6O9vttraGi+4RdYUsD3+6L8zoOqnWQJW5Yr
         wpEjDWcHuOBSfrV3/g8UbxF0t6McnPIAYEMLNk6DRuqtj8PVohT5H+pWfu+BEsG3VstL
         z8+a7mCJvvbjmlpdyXCfN4/4r+K2SAgJMeUGqdBHy3LpEB2WQA8ZCwKTZO6bfv3oU9oq
         4RdDXl3cgn0OA6QvQQEEo/EMyJ2y33x4ukXmNF8hat0pGx3tcp8vhuY56C4Jm2Ph4mw2
         9IUg==
X-Gm-Message-State: AOAM532uqkrGq0QbvZDUUcfzbbHp/qHmuNcRHBUyoRAT3+ZmUW23UYkV
        CJHQLkrsb1c8ZJImGDS4WKY=
X-Google-Smtp-Source: ABdhPJwLt6LBxSI88Piu3iGgAD6+PI2El8+pyCwoZNMaV1Lto/qaJlV2kuFlfeXk6jWgItyxqYLg5g==
X-Received: by 2002:a62:80d2:0:b0:4a4:b4e3:a723 with SMTP id j201-20020a6280d2000000b004a4b4e3a723mr15685166pfd.8.1638489378964;
        Thu, 02 Dec 2021 15:56:18 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:fac5:b2eb:ef0d:f30b])
        by smtp.gmail.com with ESMTPSA id t66sm840463pfd.150.2021.12.02.15.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 15:56:18 -0800 (PST)
Subject: Re: [PATCH v3 16/17] scsi: ufs: Optimize the command queueing code
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-17-bvanassche@acm.org>
 <1be2859c-c698-7bfd-2ed1-ea17bbeedad7@codeaurora.org>
 <1be02f4a-2ab6-63fd-f6f2-3825c28ef4e5@acm.org>
Message-ID: <2a7e32ce-b3b8-d833-61f1-cd9864c551bc@acm.org>
Date:   Thu, 2 Dec 2021 15:56:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1be02f4a-2ab6-63fd-f6f2-3825c28ef4e5@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/21 10:13 AM, Bart Van Assche wrote:
> +static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
> +{
> +    struct scsi_device *sdev;
> +    u32 pending;
        ^^^^^^^^^^^

(replying to my own email)

The above should be changed into "u32 pending = 0;"

Thanks,

Bart.
