Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C57C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B9FF6103B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhIQR7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 13:59:39 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:44787 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhIQR7j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 13:59:39 -0400
Received: by mail-pf1-f181.google.com with SMTP id b7so9866725pfo.11
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 10:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6GfC7OWWKIimRyXiyXQW8QSWu9xy2+az5m5bQnRYYLA=;
        b=OMTvca0DuNS/Rugh2orNeZUch+iWwxf/EBnGfr7LcqKO+COTTjEi7n2fU0lsern7DG
         H7dWKyfWlWsgrswJI3PPWG36hxk1fRazaRaCqLwS7QTV8Ow19mIHeo/Wq69p/ch5GQuy
         iqWY6UDjKt8JDx2j4T01P8siD8QDbbaPanJpOpOztEolJczTvWNzCJAl+izij8Cg7yv6
         RQ2Qg+/nWa4cCBvSgaMpH3iCdBJiii5ISkYTjyrkvRDNf7xpZ40BTIqJwxwAQg01WI1l
         Y/wkfFNdd3sO+6EM0XdLv+PBVEAFUya6tj1dksDRG5BYk2SQAaKz2o1qk0SlHLsHOUMA
         9aVQ==
X-Gm-Message-State: AOAM5303zhYITDRz2Dat0E74rFtLS/t/nN7A7fXR2gRXK1OZOj1WrVq6
        KJtzwcm5Pe4YQ4qgZJzXS/joR86q8fU=
X-Google-Smtp-Source: ABdhPJz810yBxQv90hsjd6yylrxXvyWDZKJk/NrPk89iMQT9iNofW5Cj5UxrHQgxwYRviUsPXCe1jQ==
X-Received: by 2002:a62:ea06:0:b0:3e1:62a6:95b8 with SMTP id t6-20020a62ea06000000b003e162a695b8mr11920301pfh.70.1631901495911;
        Fri, 17 Sep 2021 10:58:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa45:4fa2:923f:21d1])
        by smtp.gmail.com with ESMTPSA id u6sm6697931pgr.3.2021.09.17.10.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 10:58:14 -0700 (PDT)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fb303d7d-d069-f503-a351-6791d5e21f38@acm.org>
Date:   Fri, 17 Sep 2021 10:58:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3a8b5325-0bef-b18e-8961-3bfc465096a0@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/17/21 10:39 AM, Adrian Hunter wrote:
> On 17/09/21 7:09 pm, Bart Van Assche wrote:
>> On 9/16/21 10:02 AM, Adrian Hunter wrote:
>>> -static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
>>> +static int ufshcd_request_sense_direct(struct ufs_hba *hba, u8 wlun)
>>>    {
>> [ ... ]
>>> +    /* The command queue cannot be frozen */
>>> +    req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>>
>> hba->cmd_queue shares a tag set with the request queues associated with SCSI
>> LUNs. Since this blk_get_request() call happens from the context of the error
>> handler before SCSI requests are unblocked, it will hang if all tags are
>> in use for SCSI requests before the error handler starts.
> 
> All the commands sent by ufshcd_probe_hba() take the same approach, so no
> difference there.

The same comment applies to the commands sent by ufshcd_probe_hba() I think.
If you would like to address this issue, how about passing the flag
BLK_MQ_REQ_RESERVED to the blk_get_request() call in ufshcd_exec_dev_cmd()?
The following additional changes are required to make this work:
* Add a 'reserved_tags' member to struct scsi_host_template, e.g. close to
   tag_alloc_policy.
* Modify scsi_mq_setup_tags() such that it copies the reserved_tags value
   from the host template into tag_set->reserved_tags.
* Set 'reserved_tags' in the UFS driver SCSI host template.

Thanks,

Bart.


