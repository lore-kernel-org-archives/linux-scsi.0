Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EC8C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 15:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjBVPZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 10:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVPZm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 10:25:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC4736FDA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 07:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677079503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tvleqFLJq4MrlHDq8WNjaZEAYcrFfPJIDD31BvpSrmY=;
        b=MPA82h6tEqRqcpYVh3Vji/zKErsQTcWUthCIp3Oh/L0M+zgVKmN4UCjfopMyfpABcEWaE8
        WLR2NZSr0UdXgQqmKEo60LBmSeqhKehWiWUn9BzLpLMSLfsrQb6jpCyjBQTlqQFOb5zIwa
        73QNkCwmQsGCJPhU97KgHQ7FJYfZsvA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-3AJY0AhYNfulCs7oe5TOHA-1; Wed, 22 Feb 2023 10:25:02 -0500
X-MC-Unique: 3AJY0AhYNfulCs7oe5TOHA-1
Received: by mail-ed1-f69.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso11121406edu.17
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 07:25:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvleqFLJq4MrlHDq8WNjaZEAYcrFfPJIDD31BvpSrmY=;
        b=fM96+UL6QwlKewiU6DT3P6gVE1ThaDezabVcfk31FzdTkrKas2bjgTV0NAFTQVs5Zz
         7ogQbVrsMMxrRaeNfHklzDWy0QOzOLpsSnyvBbi9jHeIuZTxH6bUSz7sJa3oAnyZpjXC
         ZA/MFR+mjiIDjY56umcH3LPgH7A/1fwFAKDj14sLMFg59Slj+rmCXrfs5/4u6FRARY25
         nGT+hNHqF6hSGvgJCjJmityojhFgqXWr4NxEjEcP6VfTk16714j+OQ6KT1MuePVZ3afh
         Uw2aIXtn/PrN2UzGyB0xLsYWs/YhHmvdopqrm3v4+4tXNY3bNMJih+MBaT0IFiB0WLwR
         2PtQ==
X-Gm-Message-State: AO0yUKUOGmsdoYmCwmkI3Dw2t+OU6HBot5a3ScuuiVaeAbHzt5Y5adL8
        4wm3g2FRgpdmsUZev1mNs3SPrm1JX9naN1ja5lz1ztgRNpViWrp0GBS9YM2Ik9e0AF/mF3wAmJL
        d03/4yXx4goUGIsnm8krjyYzRu7s=
X-Received: by 2002:a05:6402:1b05:b0:4ab:4ad1:a381 with SMTP id by5-20020a0564021b0500b004ab4ad1a381mr9178270edb.10.1677079498923;
        Wed, 22 Feb 2023 07:24:58 -0800 (PST)
X-Google-Smtp-Source: AK7set9Ku7xcpMDhRuWGHB2QoCTkvxAuh1sOc3+1HBqVtxi3CEiIe9NAhLUvzrDi+xlW7qJJD8AAzQ==
X-Received: by 2002:a05:6402:1b05:b0:4ab:4ad1:a381 with SMTP id by5-20020a0564021b0500b004ab4ad1a381mr9178256edb.10.1677079498653;
        Wed, 22 Feb 2023 07:24:58 -0800 (PST)
Received: from [192.168.0.101] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id c9-20020a50d649000000b004af64086a0esm651095edj.35.2023.02.22.07.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 07:24:57 -0800 (PST)
Message-ID: <8920826f-256c-680e-aed4-bf75c29429de@redhat.com>
Date:   Wed, 22 Feb 2023 16:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 0/4] ses: prevent from out of bounds accesses
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, mikoxyzzz@gmail.com
References: <20230202162451.15346-1-thenzl@redhat.com>
 <yq1mt56skb6.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <yq1mt56skb6.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/21/23 23:59, Martin K. Petersen wrote:
> 
> Tomas,
> 
>> First patch fixes a KASAN reported problem Second patch fixes other
>> possible places in ses_enclosure_data_process where the max_desc_len
>> might access memory out of bounds.  3/4 does the same for desc_ptr in
>> ses_enclosure_data_process.  The last patch fixes another KASAN report
>> in ses_intf_remove.
> 
> Thanks for working on this! With your series applied, in combination
> with a straggling patch from James, I can finally boot my SAS test setup
> without any KASAN warnings.
I'm glad it worked for you and it could have been added since I've
noticed some previous approaches rejected.
> 
> Applied to 6.3/scsi-staging, thanks!
> 

