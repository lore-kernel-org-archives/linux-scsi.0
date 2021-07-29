Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457ABC43214
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 16:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3328360C41
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 16:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhG2QLa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 12:11:30 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:55880 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbhG2QK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 12:10:28 -0400
Received: by mail-pj1-f48.google.com with SMTP id ca5so10947622pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 09:10:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+zAf+ahTl9NfgkjP5qr5QoGHKT0Xd44xr6+iGivpK+M=;
        b=M41wQwlJFGshrbhjnGlPgxyD499q6ruw49ALBcJ51LxaCRrr3YbGA7ipNCtUspdd32
         PQXq7P5F96d7Oy5/m7r1H5pUnyp4LNxbHafGNMzS2f9nPqKVH6TA/9kUsqqs02H8eO0M
         nulo3wv96wMqRhIye7mrl+EmY5zESATt+bTaKJF+k1YwbgDBiHYVfd1bacvaTFj7p8uP
         k6V6RhEQUBRP7gez1z9e0FPsh+zuxeTyrYx6OgTgkQjL2dIGlTUrFKmI2609HfE+b/Yj
         RZMr8cwjLE1ybixt1o2fWXxX4zf7eYlJsu/JWQShpo6corHnacbsQwn8mmu+p/jC9tcQ
         y+9g==
X-Gm-Message-State: AOAM532IpWDdBd/nTo7zGSrouJ/RcoHvl4uF5FshXa9P3q+ubkL73Ccd
        9mt982oV3SKevDBbMWm1sUY=
X-Google-Smtp-Source: ABdhPJyPXkzbckDPNh/6JRxTkQuo7FtEYeC80vfHO2VxfRcIBgGLeSRo+xlWvAgV3DvJY99MSMvktg==
X-Received: by 2002:a05:6a00:80a:b029:341:185e:8674 with SMTP id m10-20020a056a00080ab0290341185e8674mr5834069pfk.42.1627575024358;
        Thu, 29 Jul 2021 09:10:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:3328:5f8d:f6e2:85ea])
        by smtp.gmail.com with ESMTPSA id d22sm4320460pfq.177.2021.07.29.09.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 09:10:23 -0700 (PDT)
Subject: Re: [PATCH v3 11/18] scsi: ufs: Revert "Utilize Transfer Request List
 Completion Notification Register"
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
        Keoseong Park <keosung.park@samsung.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-12-bvanassche@acm.org>
 <d15377870057a6ff956a18910b2d0695b145d889.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cd22192c-fd45-5c7e-d70d-0d787ba02ddf@acm.org>
Date:   Thu, 29 Jul 2021 09:10:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d15377870057a6ff956a18910b2d0695b145d889.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/29/21 1:03 AM, Bean Huo wrote:
> On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
>> Using the UTRLCNR register involves two MMIO accesses in the hot path
>> while
>>
>> using the doorbell register only involves a single MMIO access. Since
>> MMIO
>>
>> accesses take time, do not use the UTRLCNR register. The spinlock
>> contention
>>
>> on the SCSI host lock that is reintroduced by this patch will be
>> addressed
>>
>> by a later patch.
>>
>>
>>
>> This reverts commit 6f7151729647e58ac7c522081255fd0c07b38105.
> 
> Bart,
> This commit is the key change in "Optimize host lock on TR send/compl
> paths and utilize UTRLCNR"
> https://patchwork.kernel.org/project/linux-scsi/cover/1621845419-14194-1-git-send-email-cang@codeaurora.org/.
> 
> How did you compare the performance gain/loss after reverting this
> commit?

Hi Bean,

I measured the performance impact of patches 11 and 12 combined. In a 4 
KB read IOPS test I see that these two patches combined improve 
performance by 1%. This illustrates that the two MMIO accesses of the 
UTRLCNR register are slower than the single MMIO access of the doorbell 
register.

Thanks,

Bart.
