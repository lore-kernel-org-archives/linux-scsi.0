Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA74C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 08:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48404611AD
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 08:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhDOIkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhDOIkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 04:40:19 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D60AC061574;
        Thu, 15 Apr 2021 01:39:57 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o123so15599051pfb.4;
        Thu, 15 Apr 2021 01:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3tRTg0shzbghpK8s5KkDpORVJgOU6nXvQDc4YptWxp4=;
        b=dzupOljK/n2OhOKq3IFzO/jpubmmgifqonI7cIVcK57nYONTDn0gN+SMqd+LVuhEue
         vSOJmf26iaOeofbY33+7llZWIbG92xNXaeesFkp0AroekPl+iUY+XDIvyc5flXvsoEht
         MVOKE1W2f9eGWDOGOYFjhcZC1B0OTfJfA7W2qzrPcXDekA8tmSlR2QPNB5MryIIYQZbz
         ssdKILAwuvYxQTVduNjgdr6acCBmQgkipEXGjIFt51ycr+XxjnOqTeHVyfVVJxloaLud
         HhtVRgp39rFZsswxe1bP3XX88qm2K7hfI04uSV4FuUyBP6bcWcG9umfpyC/scl3ngPhd
         V10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3tRTg0shzbghpK8s5KkDpORVJgOU6nXvQDc4YptWxp4=;
        b=UKSh1c0QQ/oWbomzt3ldMzxbCOijZcTMgd1BxIpqpS/S3+cUw9NAfEj7afOoLxLkrc
         BUP9OGKwWy8COrTFTyrDK73Lrx15/qlWTlA/LTJcgmRF6tkKpAjbCY4p6Gj+d8A/vrKk
         aBstPPbttzHcrDikvQKVBk0Q1GHycu7qpTKnrQYNPJNHBbzBQ41AebqJUkTynHR0wwD2
         8oTtvI7NTCeDGJyAoSaejDIRlqCoCjFkEDNBw0wgV1JgGqXfv4ycNOwx08FSAH0ruxRH
         sbWQj8+P6CyF8jHqSrHCEBtAbRu/xUgZYEH7WTgmzNcY/eZmhznUv2NoHFOkB19T/DQB
         4TFg==
X-Gm-Message-State: AOAM530wbnT7qjY2PLgWiIRhJfpBJADgrNIhlGrG8SPBTSRbU7ujUc5S
        HiP3REvdVE7VxkOfTQmgqVA=
X-Google-Smtp-Source: ABdhPJz/E8YagRoaQfmGydf9eGCq3z8Im0ouKOCNMw/9TlVzNQ5NsPj3ODCpxu/cZ1XaZZeQpmJi/Q==
X-Received: by 2002:a62:e119:0:b029:245:8e0:820 with SMTP id q25-20020a62e1190000b029024508e00820mr2092886pfh.4.1618475996564;
        Thu, 15 Apr 2021 01:39:56 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id t67sm1573474pfb.210.2021.04.15.01.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 01:39:56 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V2 11/12] HV/Netvsc: Add Isolation VM support
 for netvsc driver
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-12-ltykernel@gmail.com>
 <20210414155016.GE32045@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <de145e13-2444-aa01-906e-e3abe5a64dc4@gmail.com>
Date:   Thu, 15 Apr 2021 16:39:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414155016.GE32045@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/14/2021 11:50 PM, Christoph Hellwig wrote:
>> +struct dma_range {
>> +	dma_addr_t dma;
>> +	u32 mapping_size;
>> +};
> 
> That's a rather generic name that is bound to create a conflict sooner
> or later.

Good point. Will update.

> 
>>   #include "hyperv_net.h"
>>   #include "netvsc_trace.h"
>> +#include "../../hv/hyperv_vmbus.h"
> 
> Please move public interfaces out of the private header rather than doing
> this.

OK. Will update.

> 
>> +	if (hv_isolation_type_snp()) {
>> +		area = get_vm_area(buf_size, VM_IOREMAP);
> 
> Err, no.  get_vm_area is private a for a reason.
> 
>> +		if (!area)
>> +			goto cleanup;
>> +
>> +		vaddr = (unsigned long)area->addr;
>> +		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++) {
>> +			extra_phys = (virt_to_hvpfn(net_device->recv_buf + i * HV_HYP_PAGE_SIZE)
>> +				<< HV_HYP_PAGE_SHIFT) + ms_hyperv.shared_gpa_boundary;
>> +			ret |= ioremap_page_range(vaddr + i * HV_HYP_PAGE_SIZE,
>> +					   vaddr + (i + 1) * HV_HYP_PAGE_SIZE,
>> +					   extra_phys, PAGE_KERNEL_IO);
>> +		}
>> +
>> +		if (ret)
>> +			goto cleanup;
> 
> And this is not something a driver should ever do.  I think you are badly
> reimplementing functionality that should be in the dma coherent allocator
> here.
>
OK. I will try hiding these in the Hyper-V dma ops callback. Thanks.
