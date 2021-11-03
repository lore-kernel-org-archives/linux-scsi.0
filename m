Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2575C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 13:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D557F61101
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 13:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhKCNsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 09:48:13 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:37849 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhKCNsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 09:48:13 -0400
Received: by mail-pf1-f174.google.com with SMTP id y20so2390480pfi.4
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 06:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+afLoQU2j8qHWnVnJTwjdjbGoagNdRqZNTWOVV54mnY=;
        b=S9pY0skBB8C/23DONQPp0PEAfJDWYDv3QtqlvHHDgiz0EeavG8h/PzGggLscRV65V6
         mT856RZ2nd4lY0RBzsqvoavOYDF0sQJBD3uLyTpstPbhDCRiCqepVwFT24ww5iQulFxh
         pVnA+5YJR7IoxMTtlJw+k65ELBXkKj8vV0Y/y9VIXTpt4TiveR2fcG5e0Pph7myfyAGX
         w8NoXvizWMdulTltdQG3YMlpWh2joazZafodRCltDwTl9arp7vV3qLbVzGgBj3OT1juI
         SaVdlqRqVnVohwSUGEooXr24LQdh6FSwrDPs9zIMqjPPX3aACz6Omk47QLrO5ciZu14Z
         nRkA==
X-Gm-Message-State: AOAM532/fFVECfS7jvjV/TKZn30FUjQN5WGcgwXUlErXObGnRhpEpcqc
        SrGw230umCzderNDCAejRWo=
X-Google-Smtp-Source: ABdhPJwKyiEAcV46KhiIWKZjZJ9qqBvvPjFPT84xzbWCZmv3wvIpEL4EB9+TkiGRQqB1OglopDLEKA==
X-Received: by 2002:a63:f542:: with SMTP id e2mr15979966pgk.186.1635947136363;
        Wed, 03 Nov 2021 06:45:36 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:7139:8ee0:6bbd:757c? ([2601:647:4000:d7:7139:8ee0:6bbd:757c])
        by smtp.gmail.com with ESMTPSA id f11sm2018237pga.11.2021.11.03.06.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 06:45:35 -0700 (PDT)
Message-ID: <700f0463-23a9-8465-f712-1188cb884dea@acm.org>
Date:   Wed, 3 Nov 2021 06:45:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Content-Language: en-US
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YYI9BLBhrFbgridf@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/21 00:40, Christoph Hellwig wrote:
> On Tue, Nov 02, 2021 at 05:05:29PM -0700, Bart Van Assche wrote:
>> -	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>> +	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
> 
> blk_get_request will be gone in 5.16-rc, so this won't apply.

Thanks for the reminder Christoph. This is something I am aware of. 
Hence the promise in the cover letter to rebase and repost this patch 
series after the merge window has closed.

> But more importantly: SCSI LLDDs have absolutel no business calling
> blk_get_request or blk_mq_alloc_request directly, but as usual UFS is
> completely fucked up here.

As explained by Adrian, the UFS protocol uses a single tag space for 
SCSI commands and UFS device commands. blk_mq_alloc_request() is used in 
this context to allocate a tag only from the shared tag space only. I 
think using blk_mq_alloc_request() for that purpose is fine.

Thanks,

Bart.
