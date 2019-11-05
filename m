Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7649DCA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 01:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 505BA20848
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 01:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfKEBDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:03:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44738 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbfKEBDH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 20:03:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id q26so13830828pfn.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 17:03:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Cw0GA7H4P+NvNZ2CVjOyXYPQ+gLKGTd+sdtcbCWClA=;
        b=gvFALxDOL1sI8OCkk0CdgEB6K0POvrZ+PSbU6dayE4g6v4FFKH7CNWmzznERuP+wfv
         ZIzhkqT/x/GNvACsUTdheKAiibO2SEIkFQxbFoyhjTMcvxrR7TG2VunPCnW15uDDEcAs
         MZSdBdLH+vcvxnk5CN9vuOy87xmFpI1oRA67rB1esbBqTBtpvvtAylTAEuVsKkGPHEnQ
         kUxxN11kj3dgjSiYZeNlrU8oBfpxhWb1MGbQHW0P55Q2zzxAcWMHEVnjuSTdxlsZ3aeE
         02aubH144QM8ysCMlT2MjiW/jYilXtu3UHF6+APpBAlqEPRIABgBfS7K6pRDVWhYGS9R
         nNeQ==
X-Gm-Message-State: APjAAAXoxHWKh1hk1+pcsrpwftmk1wqEcsje5BNDYgMP0/u7ECO9JpdI
        sJhGzQQJITvq79nqaJpZov8=
X-Google-Smtp-Source: APXvYqwreZOoFY0TTqQ+8g4wBcna8GpwQUhre9VXivdAX/qlo3yFFlvkVCnVd3udP5UPmcQ1lEs3+A==
X-Received: by 2002:a17:90a:f84:: with SMTP id 4mr2663010pjz.110.1572915786740;
        Mon, 04 Nov 2019 17:03:06 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id f31sm10146540pjg.31.2019.11.04.17.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 17:03:05 -0800 (PST)
Subject: Re: [PATCH RFC v2 2/5] ufs: Use reserved tags for TMFs
To:     Christoph Hellwig <hch@lst.de>
Cc:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191105004226.232635-1-bvanassche@acm.org>
 <20191105004226.232635-3-bvanassche@acm.org> <20191105005729.GA29695@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f9e5741f-fbfc-8b16-2e0a-43cd4c1a15b5@acm.org>
Date:   Mon, 4 Nov 2019 17:03:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105005729.GA29695@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 4:57 PM, Christoph Hellwig wrote:
> On Mon, Nov 04, 2019 at 04:42:23PM -0800, Bart Van Assche wrote:
>> Reserved tags are numerically lower than non-reserved tags. Compensate the
>> change caused by reserving tags by subtracting the number of reserved tags
>> from the tag number assigned by the block layer.
> 
> Why would you do that?  Do we really care about the exact tag number?
> If so would it make sense to reverse in the block layer how we allocate
> private vs normal tags?
> 
> Also this change should probably merged into the patch that actually
> starts using the private tags by actually allocating requests using
> them.

Hi Christoph,

The UFS driver writes the actual tags into doorbell registers. There are 
two such doorbell registers: one for regular commands and one for task 
management functions. Both doorbell registers are bitmasks that start 
from bit zero. So I don't see how to avoid this kind of tag conversions? 
 From the UFS driver, for regular commands:

ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);

And for TMFs:

ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);

Thanks,

Bart.


