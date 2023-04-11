Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E56C76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 13:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjDKNKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 09:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjDKNKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 09:10:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14A944A3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 06:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681218582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A3A3R77QZ++3XaMR8dl2QnKnilDtweVc9Y+y5AYwQ1g=;
        b=Y7E/zWTTCa18xNCjjKhJ4qN0KEqw8GPoBE52bUWBBGlQ7BCc7AilEM+AIFEkpbJ/UUB1Eo
        Zl16N+Ke0YjT7q8o4JiryZMwOxPBmoShtKMPp2KkaC2ecrCCljZyZaZIi+FkI8Fc9LUwhg
        5vjYhQc/wyD3+un33w7zs+WWYPd96/M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-aKboxxDDOQqof0comk-6Ng-1; Tue, 11 Apr 2023 09:09:41 -0400
X-MC-Unique: aKboxxDDOQqof0comk-6Ng-1
Received: by mail-wm1-f70.google.com with SMTP id h22-20020a05600c351600b003ef739416c3so17138650wmq.4
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 06:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218580; x=1683810580;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3A3R77QZ++3XaMR8dl2QnKnilDtweVc9Y+y5AYwQ1g=;
        b=ZDiysXw1x/5v9werdF3bGfhjJElXBs+1pgrW6BQwpJ7UryDkz2w+NGHS8pGUtMT27n
         fizq+rc/KdVZDlIOi1ATLyVwe2dr6td2KoVRy+0bcCu/FD66m2Xk5MjzwnOJ9ixTKcWB
         d4Lupbb50z1+nx7I71DrADgoamFeZjhUIQ35NQZ9H91i5Io0MCzTNTIu2K+I6Q0Zy3FE
         MbB9HXL3Fd9o4PvdQ4wq5A5nkcBEb/wMXwCGlPg4jqmcFB02iUUTMX2rYFun+HidzLkw
         lnEDWLe3VvvtGx/lfMAaPBKyoU3noyJtgshthGeMi8xW5BFRbF7/5kisfiBps4ULeopa
         ClHA==
X-Gm-Message-State: AAQBX9cBn3g8corJuMJT+v1/JMm9PcWHpbgqiElvBsB7Ee9srfFm1kPe
        s/tcO6aIVdlInyqv8cvW1zp7O5QWo5aCTEThLkzc9APADrf/u317gKS+YL9Do1kpcz2Bel9frYk
        BiajC5VVoYH1fjgjmB51j8w==
X-Received: by 2002:a05:600c:2294:b0:3ef:f26b:a173 with SMTP id 20-20020a05600c229400b003eff26ba173mr1922468wmf.14.1681218579956;
        Tue, 11 Apr 2023 06:09:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y+G8fHm5KIqpnQIvGEeucSsttPSYQTuadQhFguxu8j0VBW9g0AE4iNUT//MmnnCF6H1v1TsA==
X-Received: by 2002:a05:600c:2294:b0:3ef:f26b:a173 with SMTP id 20-20020a05600c229400b003eff26ba173mr1922452wmf.14.1681218579655;
        Tue, 11 Apr 2023 06:09:39 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id q5-20020a7bce85000000b003ede3e54ed7sm16967535wmj.6.2023.04.11.06.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 06:09:39 -0700 (PDT)
Message-ID: <3b2829ee-93f1-feb1-d113-cbc084d23149@redhat.com>
Date:   Tue, 11 Apr 2023 15:09:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: question about mpt3sas commit b424eaa1b51c
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/8/23 21:18, Jerry Snitselaar wrote:
> We've had some people trying to track a problem for months revolving
> around a system hanging at shutdown, and last thing they see being a
> message from mpt3sas about a reset. They quickly bisected down to the
> commit below, and reverted it made the problem go away for the
> customer.
> 
> b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
> 
> I got asked to look at something since I recently at another issue
> that involved mpt3sas at shutdown, so I was looking through the
> history, saw this commit being mentined. Looking at it, I'm not sure
> why it is doing what is doing.
> 
> It says it is to perform a soft reset, but that was already happening before this commit via:
> 
> scsih_shutdown -> mpt3sas_base_detach -> mpt3sas_base_free_resources -> _base_make_ioc_ready(ioc, SOFT_RESET);
> 
> The original submission [1] had the following commit message:
> 
> "During shutdown just move the IOC state to Ready state
> by issuing MUR. No need to free any IOC memory pools."
> 
> But is now skipping more than not freeing the memory pools. It no
> longer frees memory that was kalloc'd, it doesn't unmap something that
> was iomapped, it no longer cleans up the fault reset workqueue, and no
> longer calls the pci cleanup code. It also no longer does the things
> it moved to scsih_shutdown under the pci access mutex, nor uses the if
> condition that was in mpt3sas_base_free_resources.
> 
> [1] https://lore.kernel.org/r/20210705145951.32258-1-sreekanth.reddy@broadcom.com
> 
> 
> Am I missing something, and what the commit does here is really okay?

When a driver's shutdown method is called it may be still processing in
parallel I/Os (that may also happen any time later) so not releasing the
resources the driver has allocated is correct. A next step is then a
power off or a boot of a new kernel anyway.
A driver should stop DMA transfers and IRQ's, silence itself and when
needed inform the attached hw to flush memory or whatever else.

(The fix I've posted for the DMA issue in shutdown has this subject
'mpt3sas: fix an issue when driver's being removed')

Regards,
Tomas

> 
> 
> Regards,
> Jerry
> 

