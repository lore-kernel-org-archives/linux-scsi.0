Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E187C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 20:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF044611ED
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 20:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhITUhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 16:37:06 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:43817 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhITUfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 16:35:04 -0400
Received: by mail-pg1-f176.google.com with SMTP id r2so18572449pgl.10
        for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2021 13:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ukw+O8Toy4owNHkH//DSdQM1mo2n7RKdzS/JuedmTd4=;
        b=1WeuIMaHqXCVAgSQlx9RvNP0Pd60jY1CcjpmKn/ojJb+KF47r8aoT5ZDTXN8wEPWQN
         LSgShbnDIgxae1UH9RZ+FRt53NfyFFFFxNT2l0xIK/9NbpngomZpZNDecL+xtML2P+tk
         ukvSBjKHA86LSHkDcgHJnkH0faN9+H8uXndgtVXaHIokkcCe2TSNNjuIaDi3LjmrBOd/
         D0U11+g3348nJvJ7HZMPp/Fj9HctFxxjz6ShwZzp3VFwSfyhWQA/Ws2dm+a2IBow2l8K
         o4HXl77WuvxmX3imRDW3VoFgi1Kh6xW8+5dQ/GAMUAdd4SKsgMn8RbxQQ27+Ci9cgMJy
         NjUg==
X-Gm-Message-State: AOAM530A9kr592x24nLTWLcC1AXFJXc5i8HELpxyvrdvQj8fOjm/pOZj
        nGPA2G/CtHmZ6aqbiX/hFDDCh66fOg4=
X-Google-Smtp-Source: ABdhPJx/bko7KhWJT5RronCwMWHEfFGKQ0xZZOJULlbENZq8J/u9qt8KQdfM0XcjSdzx6h0ZWCMrwg==
X-Received: by 2002:a63:e516:: with SMTP id r22mr25202204pgh.197.1632170016364;
        Mon, 20 Sep 2021 13:33:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6e2a:d64:7d9d:bd4a])
        by smtp.gmail.com with ESMTPSA id lj7sm286974pjb.18.2021.09.20.13.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 13:33:35 -0700 (PDT)
Subject: Re: [PATCH V4 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210916170211.8564-1-adrian.hunter@intel.com>
 <20210916170211.8564-2-adrian.hunter@intel.com>
 <8a3ab601-81c4-8386-b7c8-5bea2ed99002@acm.org>
 <3a8b5325-0bef-b18e-8961-3bfc465096a0@intel.com>
 <fb303d7d-d069-f503-a351-6791d5e21f38@acm.org>
 <85faef6e-d136-c0ec-cdc2-4a9e6c6223ee@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <75ad3b8f-5bc9-c9e0-71fe-1c7c0c3c58a4@acm.org>
Date:   Mon, 20 Sep 2021 13:33:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <85faef6e-d136-c0ec-cdc2-4a9e6c6223ee@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/21 10:30 AM, Adrian Hunter wrote:
> On 17/09/21 8:58 pm, Bart Van Assche wrote:
>> The same comment applies to the commands sent by ufshcd_probe_hba() I think.
>> If you would like to address this issue, how about passing the flag
>> BLK_MQ_REQ_RESERVED to the blk_get_request() call in ufshcd_exec_dev_cmd()?
>> The following additional changes are required to make this work:
>> * Add a 'reserved_tags' member to struct scsi_host_template, e.g. close to
>>    tag_alloc_policy.
>> * Modify scsi_mq_setup_tags() such that it copies the reserved_tags value
>>    from the host template into tag_set->reserved_tags.
>> * Set 'reserved_tags' in the UFS driver SCSI host template.
> 
> I think these things only happen on the reset path, so all the slots should
> be free, even if all the tags are allocated.  With some care, it might be
> possible simply to grab a free slot.

Hmm ... my understanding is that ufshcd_try_to_abort_task() may fail and hence
that it is not guaranteed that there will be free slot. Anyway, I'm fine with
the patch in its current shape and implementing the mechanism explained in my
previous email at a later time.

Bart.


