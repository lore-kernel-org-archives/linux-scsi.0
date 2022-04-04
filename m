Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B92C38A02
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 21:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379543AbiDDVTv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379086AbiDDQdo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 12:33:44 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7F936E0C
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 09:31:48 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id o20so2856718pla.13
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2022 09:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PfcQxKWnDwl/kUQHXfOCv8uKkTcWUMbTjibTyLbBZE4=;
        b=flrOJr+XIsgLNtYcl6B3fdFJ4fJs0noUsbfkpRCSmEH01ryAUWfpB9UxfOeZf7V8qP
         9h6Onj7mUcI3QxOoEy1HCKFeu7Hu6uFqyqL+j+2xB2YLhbV1qQIojCiU3t2AuEg1hsTv
         uON9k1j4b4IaM/+p1AWtA09h2g1zToGHumHfbcpvJnmN+XOnseAIs5jJygABeHfvt2v3
         5MBUSF2TnhzWlvhFHfxtty4saf3mV1N/ABt2StEtbJFMfUNm5OsvN3ArZJTvb4XODFsu
         ebhSmoeadT1KJ4QgsxGPZByLxtRYvJ+neQ6yapO4qF6h/VLXzSgHhHi048fukkjUjCzJ
         e9Eg==
X-Gm-Message-State: AOAM531Tv6YeA92uiKV+9DVX+EnoWWtzUZKk8HaPDSs3e0582np8C5+n
        H6c3HxMZObYAZtm4xcuBuI0=
X-Google-Smtp-Source: ABdhPJzhRykh8H7EGXmcuD5vXuQc9M2JBUqUNDYGYcsJds8JzQrztCgjQbzjOtIKxa7iCEkgkx+70w==
X-Received: by 2002:a17:902:e80c:b0:156:bc53:704e with SMTP id u12-20020a170902e80c00b00156bc53704emr793572plg.31.1649089907395;
        Mon, 04 Apr 2022 09:31:47 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 124-20020a621682000000b004f6a2e59a4dsm12381653pfw.121.2022.04.04.09.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 09:31:46 -0700 (PDT)
Message-ID: <a54906ac-9d1b-9c45-96d1-6b2afb8e0d97@acm.org>
Date:   Mon, 4 Apr 2022 09:31:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/7] mpi3mr: add support for driver commands
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Linux SCSI List <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Prayas Patel <prayas.patel@broadcom.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220329180616.22547-1-sumit.saxena@broadcom.com>
 <20220329180616.22547-3-sumit.saxena@broadcom.com>
 <8a3dfb77-9c42-871a-0d16-1ddf84516c8e@acm.org>
 <CAL2rwxoT311ndWB-imycpC9_hkn8FExO0c0FCw6Q=wkYBnaJbg@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAL2rwxoT311ndWB-imycpC9_hkn8FExO0c0FCw6Q=wkYBnaJbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/22 08:07, Sumit Saxena wrote:
> On Mon, Apr 4, 2022 at 7:55 PM Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 3/29/22 11:06, Sumit Saxena wrote:
>>> +/**
>>> + * struct mpi3mr_nvme_pt_sge -  Structure to store SGEs for NVMe
>>> + * Encapsulated commands.
>>> + *
>>> + * @base_addr: Physical address
>>> + * @length: SGE length
>>> + * @rsvd: Reserved
>>> + * @rsvd1: Reserved
>>> + * @sgl_type: sgl type
>>> + */
>>> +struct mpi3mr_nvme_pt_sge {
>>> +     u64 base_addr;
>>> +     u32 length;
>>> +     u16 rsvd;
>>> +     u8 rsvd1;
>>> +     u8 sgl_type;
>>> +};
>>
>> Does the above data structure force user space software to pass a
>> physical address to the kernel? A kernel driver should not do this
>> unless there is a very good reason to do so. Passing a physical address
>> from user space to the kernel requires freezing the virtual-to-physical
>> mapping. Some user space developers erroneously use mlock() for this
>> purpose. Is there any other way than the VFIO_IOMMU_MAP_DMA ioctl to
>> prevent that the kernel modifies the virtual-to-physical mapping?
 >
> This structure is not for user space consumption. Mistakenly, it's moved
> to this header. Will fix it in the next revision.

I can't find any code in the kernel that stores the value 
MPI3_FUNCTION_NVME_ENCAPSULATED. Does that mean that that value is set 
by user space and hence that the definition of that constant should 
occur in a uapi header? Same question for struct 
mpi3_nvme_encapsulated_request.

Thanks,

Bart.
