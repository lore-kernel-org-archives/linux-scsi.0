Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC6DC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 16:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C430560EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 16:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhG2QMu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 12:12:50 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:40773 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbhG2QMQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 12:12:16 -0400
Received: by mail-pj1-f47.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so16341535pja.5
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 09:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ArBftOP8yvZAoaLiG5a3Qx0ZEpiDv7NQryuUqMaPziI=;
        b=WBYg1FWFJwb1QIQNZbW/AYW1/xceXhr7DYivvwIxuVd1yx+35+zVXfWurOX560O53H
         j6NsZgkurwKi+h/WzgwYOtzk0pV+o+sINFpibKPoz0+kBCVIpAcmczmXRwyJjM6niON/
         m9rddiqOIVa6qKAandKJ37ZJmqimXb5n/0liSFxTIUwJVPpVFCiSZOOND5I07/RmjQJZ
         wvIoTgww/0Ix1EPzQ0cLRR+7M+hpFR6W8edKcxxYqHvr1wMw88jubYtt+2x+stYycM/i
         TG4ckRXaGAIZOMCHN5JNwls50vKmfPGQyzJE2cAOTL0Gw9Pd4NSl4zNqRgj86SIZvx5d
         Y0FQ==
X-Gm-Message-State: AOAM531dd5/4A0cqYG8kU9iySwGR/BgyMR/E5LA2ZLIEoT7W3shJW4jS
        yczOwULjPbMptQ0mlX5DLE4=
X-Google-Smtp-Source: ABdhPJzrXJdyyOSw1vIbs9KBjVNWGghHPcklUMWe4u5g0grDqB1xb+4QtxBgc19kdN72eEbjvW9s7Q==
X-Received: by 2002:a65:6a01:: with SMTP id m1mr4462451pgu.201.1627575118057;
        Thu, 29 Jul 2021 09:11:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:3328:5f8d:f6e2:85ea])
        by smtp.gmail.com with ESMTPSA id s19sm1023683pfe.206.2021.07.29.09.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 09:11:57 -0700 (PDT)
Subject: Re: [PATCH v3 13/18] scsi: ufs: Optimize SCSI command processing
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-14-bvanassche@acm.org>
 <75b72176a497e4156ad4e80e1078b78c1956d879.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <88d9eb5c-55a2-4965-8b34-03112310aed4@acm.org>
Date:   Thu, 29 Jul 2021 09:11:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <75b72176a497e4156ad4e80e1078b78c1956d879.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/29/21 2:12 AM, Bean Huo wrote:
> Removing hba->host->host_lock, use hba->outstanding_lock, the issue
> fixed by your patch [12/18] still be fixed?

Yes. My understanding is that setup_xfer_req() calls must be serialized 
against each other but not against any other code that is protected by 
the host lock.

Thanks,

Bart.
