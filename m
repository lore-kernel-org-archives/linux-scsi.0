Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56CDC6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 13:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjDSNrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 09:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDSNrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 09:47:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BE110254
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 06:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681911987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GOxgOCwtGvxpA2owUd+xDFs01Dv74+zF+p3guW5fkDk=;
        b=RmZkAnMR7nLF/QhaDetOxeYZJFZpmc5v3e6ZYNwiiWQShejbbiTiskToPZNDK9jT6yCrwx
        xbLb7ByFXp5m3aR5QdtkbZ03PXJ7wt+2Ktt26Z6A1I13dNYkeiRD1qAdM/xmSt4dTJQEqT
        Mw5Zz86aaUcSVQh/X1Vaxr6HHDmm9aQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-pCmsVqRqO2aFeMHyONpm_w-1; Wed, 19 Apr 2023 09:46:26 -0400
X-MC-Unique: pCmsVqRqO2aFeMHyONpm_w-1
Received: by mail-ej1-f72.google.com with SMTP id e23-20020a170906375700b0094ed5ffb83fso6251211ejc.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 06:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681911985; x=1684503985;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GOxgOCwtGvxpA2owUd+xDFs01Dv74+zF+p3guW5fkDk=;
        b=SqG1wvGELXU6Sd6dBZLaiEX0/7Tfe/bvcAl34eYJ86w1o7TdRyvh8W2OeTereiIypf
         zduANFwXYCRHFk2NqopnNrr9KU6nWwt5/I42zaLKbJKIbyrU05iY/do8IiauZALYTuFU
         oMUY4TysHIEkOAC3PJ0ktSOHozAME/BZib12OE09pJpMRIy2kM6SuOuoyKC3TzbPw2wh
         7F4olde9O2oYAQc8d+V9tZRcAWdZOEA86lyYX9Krq621i88iM/IkOEAhED4KHGDBtPbG
         Zg+MlZnL3tQ2UnzWIW2knIRjJkaLdOiwybJWvpQWxVEJXd+UsvJvsuEGlPf5EYiaPt7A
         sc8A==
X-Gm-Message-State: AAQBX9dKqOn4zLid0pURL0hjEBDQ3z3y8+GFVtvQkOsQfg4zXqfWhGv+
        DiiTRbi7UQIVStZhYUag3dpMP6143W+rrUxidF3sXkY01ppYyVzxc3AhZbu3vTOSReL23l50kix
        GlmIlBhhs9bVjivWLsw5jnA==
X-Received: by 2002:a17:906:c0c7:b0:94e:c4b:4d95 with SMTP id bn7-20020a170906c0c700b0094e0c4b4d95mr13983332ejb.69.1681911985438;
        Wed, 19 Apr 2023 06:46:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350b52xb3vmW7Gz1NVoeY9DVC/PrHfRDpL9DKtgGqHW/cjIFw45mRYuFQKHoyCW1YQ5ES2fwetQ==
X-Received: by 2002:a17:906:c0c7:b0:94e:c4b:4d95 with SMTP id bn7-20020a170906c0c700b0094e0c4b4d95mr13983308ejb.69.1681911985149;
        Wed, 19 Apr 2023 06:46:25 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id p20-20020a170906615400b0094aa087578csm9483506ejl.171.2023.04.19.06.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 06:46:24 -0700 (PDT)
Message-ID: <69eb3a65-712f-f66e-dd42-52498dfb7138@redhat.com>
Date:   Wed, 19 Apr 2023 15:46:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: question about mpt3sas commit b424eaa1b51c
Content-Language: en-US
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
 <3b2829ee-93f1-feb1-d113-cbc084d23149@redhat.com>
 <4b16b673ba4d38417353970628e494714fcc1937.camel@redhat.com>
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <4b16b673ba4d38417353970628e494714fcc1937.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/23 17:43, Jerry Snitselaar wrote:
> On Tue, 2023-04-11 at 15:09 +0200, Tomas Henzl wrote:
>> On 4/8/23 21:18, Jerry Snitselaar wrote:
>>> We've had some people trying to track a problem for months
>>> revolving
>>> around a system hanging at shutdown, and last thing they see being
>>> a
>>> message from mpt3sas about a reset. They quickly bisected down to
>>> the
>>> commit below, and reverted it made the problem go away for the
>>> customer.
>>>
>>> b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during
>>> shutdown")
>>>
>>> I got asked to look at something since I recently at another issue
>>> that involved mpt3sas at shutdown, so I was looking through the
>>> history, saw this commit being mentined. Looking at it, I'm not
>>> sure
>>> why it is doing what is doing.
>>>
>>> It says it is to perform a soft reset, but that was already
>>> happening before this commit via:
>>>
>>> scsih_shutdown -> mpt3sas_base_detach ->
>>> mpt3sas_base_free_resources -> _base_make_ioc_ready(ioc,
>>> SOFT_RESET);
>>>
>>> The original submission [1] had the following commit message:
>>>
>>> "During shutdown just move the IOC state to Ready state
>>> by issuing MUR. No need to free any IOC memory pools."
>>>
>>> But is now skipping more than not freeing the memory pools. It no
>>> longer frees memory that was kalloc'd, it doesn't unmap something
>>> that
>>> was iomapped, it no longer cleans up the fault reset workqueue, and
>>> no
>>> longer calls the pci cleanup code. It also no longer does the
>>> things
>>> it moved to scsih_shutdown under the pci access mutex, nor uses the
>>> if
>>> condition that was in mpt3sas_base_free_resources.
>>>
>>> [1]
>>> https://lore.kernel.org/r/20210705145951.32258-1-sreekanth.reddy@broadcom.com
>>>
>>>
>>> Am I missing something, and what the commit does here is really
>>> okay?
>>
>> When a driver's shutdown method is called it may be still processing
>> in
>> parallel I/Os (that may also happen any time later) so not releasing
>> the
>> resources the driver has allocated is correct. A next step is then a
>> power off or a boot of a new kernel anyway.
>> A driver should stop DMA transfers and IRQ's, silence itself and when
>> needed inform the attached hw to flush memory or whatever else.
>>
> 
> Should it clean up dma mappings then? All of that memory pool stuff is
> still mapped.
Can this do any harm? If no then it is pointless.
> 
> Thanks for the info.
> 
> Regards,
> Jerry
> 
>> (The fix I've posted for the DMA issue in shutdown has this subject
>> 'mpt3sas: fix an issue when driver's being removed')
>>
>> Regards,
>> Tomas
>>
>>>
>>> Regards,
>>> Jerry
>>>
>>
> 

