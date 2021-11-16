Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241BFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 04:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0670261C14
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 04:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241472AbhKPEZb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:25:31 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:42815 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344362AbhKPEZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 23:25:15 -0500
Received: by mail-pj1-f51.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1700314pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 20:22:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PoTC22jzxxbQMSMeezM3Y8iHKu0+Ol7oAzg4XOCwz2E=;
        b=jHZ23fK0BTyXq2W99dOZzPmC2Q0h0WgRGnUau1icklRwCLp2Sp1XDzKnqg//9QAAFY
         h020s0uX5XlXaFq8+xOaDNNjTLVIKZZAWpWLEeT6uPhzICjzyAr6OvvORwlxlWw9+Z+x
         qgkho5reHyYx9Ef8HptjYSKNVVfwpjALLiB7TxAPhDNb92/OCX3/kZHMmiNgJB/NjckE
         iZs1QWrgKrmr9+J3ez0MlXsGluTV9l2KTXMMITteQ+QbYT7ZugLuehzsa52QDCaMhEoN
         hKT0R9h2pQGesssRk0I0ngTGCqpx8u1ZKDr4JM1jiaqlJeucNxLDQL2wUsVEJkTo4bhL
         Y9Ow==
X-Gm-Message-State: AOAM533ssysHHXoLiRLTXFj0pqUYJTUoEDDvyD2aOM11d6EpGFuTDtvt
        utd4kkZNr4+lx27Wl3cFeCk=
X-Google-Smtp-Source: ABdhPJxNSf58TGIw1VmmjcuB3dr4q0FVRzj9/ztszPl60NjU5htbENZhF5Y03iB0qvTDpCDnAePlBg==
X-Received: by 2002:a17:90a:c398:: with SMTP id h24mr5058548pjt.73.1637036537543;
        Mon, 15 Nov 2021 20:22:17 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id i2sm17659343pfg.90.2021.11.15.20.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 20:22:16 -0800 (PST)
Message-ID: <6a548678-cd7b-f132-76cc-c3e5241f6c52@acm.org>
Date:   Mon, 15 Nov 2021 20:22:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] scsi: simplify registration of scsi host sysfs attributes
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
 <52cea40c-1de2-9742-168a-c8ff0a29f0bf@acm.org>
 <00694cf2-b6d6-fd40-2d80-a36d306302b9@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <00694cf2-b6d6-fd40-2d80-a36d306302b9@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/21 19:29, Damien Le Moal wrote:
> On 2021/11/16 11:18, Bart Van Assche wrote:
>> On 11/15/21 1:29 AM, Damien Le Moal wrote:
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index 8049b00b6766..c3b6812aac5b 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -359,6 +359,7 @@ static void scsi_host_dev_release(struct device *dev)
>>>    static struct device_type scsi_host_type = {
>>>    	.name =		"scsi_host",
>>>    	.release =	scsi_host_dev_release,
>>> +	.groups =	scsi_sysfs_shost_attr_groups,
>>>    };
>>
>> Many SCSI LLDs use class_to_shost() to convert a device pointer into a SCSI host
>> pointer. This patch makes the use of that macro very confusing since the SCSI
>> host class is no longer involved in attribute registration.
> 
> OK. But at least I think we should fix this:
> 
> WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups));
> 
> to change it into:
> 
> if (WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups)))
> 	shost->shost_dev_attr_groups[j] = NULL;
> 
> to guarantee that the attribute groups array is NULL terminated, as it should
> be. This will ensure that we do not end up with a kernel crash when a buggy
> driver is loaded. No ?

Hi Damien,

Please take a look at 
https://lore.kernel.org/linux-scsi/ab1a9bfd-c1d2-e101-a9f3-f969ed3d1cad@acm.org/. 
That patch removes the WARN_ON_ONCE() statement entirely.

Thanks,

Bart.
