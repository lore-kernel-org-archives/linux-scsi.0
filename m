Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827A7C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DDA76024A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhDTPCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 11:02:01 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:34355 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbhDTPB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 11:01:56 -0400
Received: by mail-pj1-f43.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so1437982pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 08:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EIzuzQ5jdi/C9LIu4Qthum4sgm9kcJXpktH/7AKqzGg=;
        b=N8nBdKwcyyPSKKhNFHPRxmZsm19sq1SKPfHcA4zFDDZRKeLTukOWsJOKgw7Bw9p+YR
         4TaNtxajTl56t2GawV/7KPS28G90E/0C/3e2vYbQX4H+KBISuzZIv1gFXiAX59Dk4n/z
         nI9JGxPD7Mtr4fkR0amau5vhj+zM2FkTcLmiSjcsgdWJ+AVqPIntQZL2iHkc1Wx98ewe
         rqikPP+UpISAZGJQptcPUxFdYUslH6lpD/IUqCSZ+mJQQdXlYowWpFzQ7dGZdqs+Xbxg
         mZL7l10fAEgZsG/rn81Tk6sFO2YGuaATKB6imaepPBufbId2Tp8RT2w+xKrBmUpvZwvA
         nu2g==
X-Gm-Message-State: AOAM531AQTH3sVYfGp2tWMleIpOjuBTaBB7IUW4SA0nNY7vvAdENujkW
        cc60qhHN65P1x/ZPNjhlsBU=
X-Google-Smtp-Source: ABdhPJwWtpO+o9gynNF053LgCEAO3/W+BSXRsT3IAuWypSiin5YotpQAOmIVgk/OaKSjfq5Bu1ZXQg==
X-Received: by 2002:a17:90a:f293:: with SMTP id fs19mr5629970pjb.207.1618930881144;
        Tue, 20 Apr 2021 08:01:21 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b389:6c06:5046:89e? ([2601:647:4000:d7:b389:6c06:5046:89e])
        by smtp.gmail.com with ESMTPSA id k11sm2856854pjq.47.2021.04.20.08.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 08:01:20 -0700 (PDT)
Subject: Re: [PATCH 027/117] advansys: Convert to the scsi_status union
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-28-bvanassche@acm.org>
 <20210420014917.GH2531743@casper.infradead.org>
 <eaa25d23-9d3a-0a0c-b87d-83d62ec5c46a@acm.org>
 <20210420032323.GJ2531743@casper.infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <20666bc6-b039-4a32-2d23-376cbe3987ff@acm.org>
Date:   Tue, 20 Apr 2021 08:01:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420032323.GJ2531743@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 8:23 PM, Matthew Wilcox wrote:
> ... I haven't taken a look.  I have no idea what this patch does,
> and I can't provide feedback on the approach.  Because I haven't seen
> the approach.  All I've seen is this patch, and the one to sym53c8xx.
> Take a look at those patches in isolation -- would you be able to provide
> any kind of sensible feedback?

Hi Matthew,

Please take a look at the description that is available at
https://lore.kernel.org/linux-scsi/20210420000845.25873-12-bvanassche@acm.org/T/#u

Thanks,

Bart.


