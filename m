Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819EAC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 04:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4751364E57
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 04:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhBLEMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 23:12:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhBLEMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 23:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613103077;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGSTJ+HM+7VqDqFE+Eky32FecMVzs7Bcg9hDuw+mgkU=;
        b=HYxGcbkfz5a1JXkyJqxkPc994HrJeozN9vnotzeMwx/9+Z3cjZaeBjDD7pmLzYZWNw76Xh
        c+SqyWBUITwG7i4o3QdMctL/28rBYMbfTltMTM/o9g8LzIay97PXAcF2fwCZfjVegd5n7j
        UzskMId0nLOuFw9PVtLLUu6J7twcc3o=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-BHXZ-BwcNg6eqIEm_rPgfw-1; Thu, 11 Feb 2021 23:11:16 -0500
X-MC-Unique: BHXZ-BwcNg6eqIEm_rPgfw-1
Received: by mail-pg1-f199.google.com with SMTP id n2so6643003pgj.12
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 20:11:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uGSTJ+HM+7VqDqFE+Eky32FecMVzs7Bcg9hDuw+mgkU=;
        b=saSztWY95tF0ttWmAeH2dimc1iT4hKHIFqsMS46N6vhqH0wNP+baFB9m8aPebhqsjT
         y+l8y0vWwHy7F2sJREn0UzXpxF0bI1HyniBePUdeZDMS2R/mzHlKarZFgM0ZjNeBcqDj
         JVKDCU9B4Jf4FfNcg7nZBX9JIiId8xHJwvq3n5OPgqiKO+YH/jiu9ukiLV+ykbHiIeyr
         Ar/wX0Fb4omlFAefCPFjTqEOOjt21gn/TOfI+iFVA0tYmvax6fAEA5meS7RNuhJ0H/vs
         u5TRy5+fApZN+vEujQoUSx/4hIYv9LhQqW+01cYc04gdIN3zVDe4ylEgV8WEqfu97yUn
         JYLQ==
X-Gm-Message-State: AOAM533tcaxswtOBquA0nqRNeBhSF0O5spuYY8/OQHQxqCaQXEqVrTF7
        oNloj4j46EoejnDS7sWhTQ3MtSnNYGBgkcn2d9Cnoo8lvm+O7nC3Dn8sVDQO3+6xXdXnbneqe31
        htHtFzez8csOp/P+OxzYBZg==
X-Received: by 2002:a63:6203:: with SMTP id w3mr1417633pgb.224.1613103056858;
        Thu, 11 Feb 2021 20:10:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyduJ+VUkuvUWyn8zdfdOMBfeRnXsDPGGc6LXBWFnQ5eLwYhOE3VLPCITfJhujNVxCd1nLFog==
X-Received: by 2002:a63:6203:: with SMTP id w3mr1415657pgb.224.1613103016659;
        Thu, 11 Feb 2021 20:10:16 -0800 (PST)
Received: from [172.24.0.1] ([122.169.13.134])
        by smtp.gmail.com with ESMTPSA id nl12sm8449191pjb.2.2021.02.11.20.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 20:10:10 -0800 (PST)
Reply-To: mgandhi@redhat.com
Subject: Re: [PATCH v2] scsi: qla2xxx: Removed extra space in variable
 declaration.
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kernel-janitors@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20210211131628.GA10754@machine1>
 <ccf393f7-cbfc-fb8c-6f73-bb502eaa54f3@acm.org>
 <b44bd29e-389c-634f-333d-edc88b3d7be9@oracle.com>
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
Organization: Red Hat
Message-ID: <9da0412a-6bf0-1f09-85af-2aec025ee3ec@redhat.com>
Date:   Fri, 12 Feb 2021 09:40:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b44bd29e-389c-634f-333d-edc88b3d7be9@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart, Himanshu,

On 2/11/21 10:18 PM, Himanshu Madhani wrote:
> Hi Milan,
> 
> On 2/11/21 9:57 AM, Bart Van Assche wrote:
>> On 2/11/21 5:16 AM, Milan P. Gandhi wrote:
>>> Removed extra space in variable declaration in qla2x00_sysfs_write_nvram
>>>
>>> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
>>> ---
>>> changes v2:
>>>   - Added a small note about change.
>>> ---
>>> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
>>> index ab45ac1e5a72..7f2db8badb6d 100644
>>> --- a/drivers/scsi/qla2xxx/qla_attr.c
>>> +++ b/drivers/scsi/qla2xxx/qla_attr.c
>>> @@ -226,7 +226,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
>>>       struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
>>>           struct device, kobj)));
>>>       struct qla_hw_data *ha = vha->hw;
>>> -    uint16_t    cnt;
>>> +    uint16_t cnt;
>>>         if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size ||
>>>           !ha->isp_ops->write_nvram)
>>
>> I'm not sure if such a patch is considered substantial enough to be
>> included upstream.
>>
>> For future patches, please follow the guidelines for submitting patches
>> and use the imperative mood for the subject (Removed -> Remove) and do
>> not end the patch subject with a dot. See also
>> Documentation/process/submitting-patches.rst
>>
>> Bart.
>>
>>
> Agree with Bart here.
> 
> What was motivation behind this patch?
> 
> if you scroll through code, i am pretty sure you will find more than one place where spaces are not consistent (especially 15+ yr old code).
> 
I thought it was a typo and extra space was left, so just fixed it.
But it looks that there are many other places in qla2xxx source with similar declarations.
I apologize for the noise.

Thanks,
Milan.

