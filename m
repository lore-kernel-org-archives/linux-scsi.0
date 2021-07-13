Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C70C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 23:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0A9361370
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 23:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhGMX3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 19:29:49 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:36619 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236769AbhGMX3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 19:29:49 -0400
Received: by mail-pf1-f170.google.com with SMTP id 21so200247pfp.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 16:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hc48E0u02J5LjcV2x7sM5iVBcN/RUvehXQLj8IHyecU=;
        b=TeSCiS5NTJwUh7vazJkXTe8s+TZuHd/FA0wfM+NTFb+Urgx7qTWvLRR1nsd9EQZq++
         OwMTzsRwBSzqottN3vpT3s34SioTMBG3PNfb2Etxor5S9MdQkA8eMKsoUpZByTUvzUSV
         KQ48P8xeNw7qQ5kM0WiN6W2EWUUIgviSlGh3d3+3s9NWBHULrvFclz2Aq8HJ9uaugRF3
         lORSpuUzjPIv7KnLHEk68WUFL6Fx/EnwpkkP+QHtyc1Y+KiAAmR7wEfHXpG80JGMhyTR
         3isrEHLoSKSj/ckTBdl0XgSO1FTRQS2wLldd76nrGsDpXS/WMk7d0flDweUWJna/I8jQ
         TkQw==
X-Gm-Message-State: AOAM533mRceA8/0LTT3ylTpfmzU3zHzulPtDnE4GK4DYk0eO3k+bZVnJ
        hZA02dejECCgslj6v5pgE1Q=
X-Google-Smtp-Source: ABdhPJzm7kFTfhdwKAPHiEYFE5DoGryp2qIV7PUfIA9F8XZ1tzRUzBi+1p0CW/LQb0VkZ/MFipaxKw==
X-Received: by 2002:a65:4286:: with SMTP id j6mr6586956pgp.10.1626218817923;
        Tue, 13 Jul 2021 16:26:57 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:d6d0:1357:913a:795c? ([2620:0:1000:2004:d6d0:1357:913a:795c])
        by smtp.gmail.com with ESMTPSA id 127sm251845pfy.107.2021.07.13.16.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 16:26:57 -0700 (PDT)
Subject: Re: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
From:   Bart Van Assche <bvanassche@acm.org>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
 <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
Message-ID: <1b35777f-bea2-9443-0bac-c42b37acf8b3@acm.org>
Date:   Tue, 13 Jul 2021 16:26:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 9:49 AM, Bart Van Assche wrote:
> On 7/11/21 5:29 AM, Avri Altman wrote:
>>> This patch is a performance improvement because it reduces the number of
>>> atomic operations in the hot path (test_and_clear_bit()).
>> Both Can & Stanley reported a performance improvement of RR with 
>> "Optimize host lock..".
>> Can those short numerical studies can be repeated with this patch?
> 
> I will measure the performance impact of this patch for rq_affinity=2 as 
> soon as I have the time. As you may know we are close to an internal 
> deadline.

(replying to my own email)

Hi Avri,

The performance I measure with the current upstream UFS driver is 61.0 K 
IOPS. With a variant of this patch (outstanding_reqs protected with a 
new spinlock instead of the host lock), I see 62.0 K IOPS. In other 
words, this patch realizes a small performance improvement. This is what 
I had expected since this patch reduces the number of atomic operations 
involved in updating outstanding_reqs.

Thanks,

Bart.
