Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F58EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5502B6103B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhKCQmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:42:11 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:52083 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhKCQmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:42:10 -0400
Received: by mail-pj1-f50.google.com with SMTP id gt5so1666957pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 09:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FVU6T1D8NFlpG41qhBpMiacbMjs5V9LNHBqpZo2FmJU=;
        b=iELQ8tvsMTQUxTmhwAXsqCbNi2pwDpbchJOSxZopGAspBM51hctCWI01qG5b2dqq3o
         KJUCFB62NA+FrD7RvkrXkiuhNdjicPnqWdUDE4sOu5z4XvSsVXcP5JfDkdXAQajkzS9O
         xvlI+tRH9L9wVCUlxMa3jGBH0jDhymnS5UMzb3DQY82qmIw5zME8X7TAnNHfzXVMUq62
         ji8miyqsawrnrFjGLuTXMF3voLO1Y8e6KhnUh+gy3cvkEb7V/wxrt95wSg8Ft7y3M32x
         ETb+wJHdeRu5BkGiyHS3BGD691y1avr1R5BTNsqFmMSe0L8+qj3PWJMUFYdQh/xJDVne
         lpbA==
X-Gm-Message-State: AOAM533ubFH7QUQgFNzeOE9LMQsWekWefdv819dac33/4fkVzsElBTSy
        pUlbyCvQwqqK2GzTgoFDcOE=
X-Google-Smtp-Source: ABdhPJxAEG/hySVzSVHJju9nSYEGAyBolqpyc+btuhYg48xWomdQDcYVWXPfwMb5bDgOl7PVni/aaw==
X-Received: by 2002:a17:90a:8b8a:: with SMTP id z10mr16192606pjn.20.1635957573897;
        Wed, 03 Nov 2021 09:39:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id z10sm2908539pfh.106.2021.11.03.09.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 09:39:33 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <YYI9BLBhrFbgridf@infradead.org>
 <700f0463-23a9-8465-f712-1188cb884dea@acm.org>
 <YYK4i6ak6Dqe1JeG@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5711eeec-e607-48fd-7c51-4d6f33fbb1ec@acm.org>
Date:   Wed, 3 Nov 2021 09:39:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YYK4i6ak6Dqe1JeG@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/21 9:27 AM, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 06:45:34AM -0700, Bart Van Assche wrote:
>>> But more importantly: SCSI LLDDs have absolutel no business calling
>>> blk_get_request or blk_mq_alloc_request directly, but as usual UFS is
>>> completely fucked up here.
>>
>> As explained by Adrian, the UFS protocol uses a single tag space for SCSI
>> commands and UFS device commands. blk_mq_alloc_request() is used in this
>> context to allocate a tag only from the shared tag space only. I think using
>> blk_mq_alloc_request() for that purpose is fine.
> 
> The problem is not the shared tag space, the problem is that it is
> poking through layers.  IFF we have good use cases for just allocating
> a tag (and we don't want to reserve it, which does make sense for many
> things like task management) we need a SCSI layer API that returns just
> the tag (and preferably also poisons the request in some way).

How about changing the blk_mq_alloc_request() / blk_put_request() calls in
ufshcd_exec_dev_cmd() and __ufshcd_issue_tm_cmd() into
scsi_{get,put}_internal_command() calls once Hannes' patch series that
introduces these functions is upstream? See also "[PATCH 03/18] scsi: add
scsi_{get,put}_internal_cmd() helper"
(https://lore.kernel.org/linux-scsi/20210503150333.130310-4-hare@suse.de/).
See also patch "[PATCH 10/18] scsi: implement reserved command handling"
(https://lore.kernel.org/linux-scsi/20210503150333.130310-11-hare@suse.de/).

Thanks,

Bart.


