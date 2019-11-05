Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E95FC5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 17:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D04821D6C
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 17:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389278AbfKERF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 12:05:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44764 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388875AbfKERF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 12:05:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id q26so15977573pfn.11
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 09:05:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wDrm93ul+1/efqAjE+TFie2IuABPPJpvlACIA7gCdXU=;
        b=nqdQDhr3FxC4itCywer+0wlQvJ7S2W2FwmkzLDBXnze7HlXh6BBP3pTe8IZaTDI485
         j9mokykr5umrX4wkwekKTlTcRVK1Q3gLqQ62IDByw8lnIjjKEUg97gGN1mn3RgDQV8hA
         jUo9d29fs+beBzDQot9YVBMMixFtR08UfHIbq4WCtfdmvaPlo+CSBHAfmBOMXA8wSo79
         eLZ0wv6rjW0D/fYTWb/s1adnX1a4g45FWJ7MPS3u2QrueJK1vNVwhuhJfHyC1hoiaX9S
         lpTGCksDv5786mcM4lS1pSUaJSMjef3FCU/iRGS/ZhY1U7eJ+C/QgC6y70fx4TLFuJPk
         /8iw==
X-Gm-Message-State: APjAAAXp7dnMbvw/swq0zGrYR9w6SyNCQ1OD806oAdtW4vnQ7sZuIQaj
        6rAXCV3AplGLi3TUdk4A8jM=
X-Google-Smtp-Source: APXvYqyKDOsnkw2GF36BJLMH6x9KXb+i9FU+2TNe5lXRZusSn2vH0wHaRhARS6TRvh7ot5F2MVSCww==
X-Received: by 2002:a17:90a:37e4:: with SMTP id v91mr93945pjb.8.1572973556477;
        Tue, 05 Nov 2019 09:05:56 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z14sm20031167pfq.66.2019.11.05.09.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 09:05:55 -0800 (PST)
Subject: Re: [EXT] [PATCH RFC v2 4/5] ufs: Use blk_{get,put}_request() to
 allocate and free TMFs
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191105004226.232635-1-bvanassche@acm.org>
 <20191105004226.232635-5-bvanassche@acm.org>
 <BN7PR08MB568437EAF8BF59CF9101C507DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <85c20718-fb3f-8a5e-6873-3f313b862b80@acm.org>
Date:   Tue, 5 Nov 2019 09:05:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB568437EAF8BF59CF9101C507DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/19 5:50 AM, Bean Huo (beanhuo) wrote:
>> -	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba,
>> &free_slot));
>> +	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
>> +	req->end_io_data = &wait;
>> +	free_slot = req->tag;
>> +	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
>>   	ufshcd_hold(hba, false);
>>
> Understand now , you delete ufshcd_get_tm_free_slot(). Run a big circle to get a free_slot from reserved tags by calling blk_get_request().
> But UFS data transfer queue depth is 32, not 32 + hba->nutmrs.  How to make sure we see the tag is consistent across block/scsi/ufs?

Hi Bean,

Please have a look at the blk_mq_get_tag() function in the block layer. 
The implementation of that function makes it clear that the tags with 
numbers [0 .. nr_reserved) are considered reserved tags and also that 
the tags with numbers [nr_reserved .. queue_depth) are considered 
regular tags. In other words, adding hba->nutmrs to can_queue does not 
increase the queue depth because the same number of tags are considered 
reserved tags.

Bart.
