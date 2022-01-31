Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8F6C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 17:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380831AbiAaRTE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:19:04 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:35571 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241643AbiAaRTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 12:19:03 -0500
Received: by mail-pg1-f179.google.com with SMTP id p125so12833351pga.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2022 09:19:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nR8EiklqG8hxB0MOAFi6fqYt0ybtkfe+I6kykwU6yrs=;
        b=66YVDzBojp+m90Lw0DPLguLnIHOMDz656M/u/rL9sNyMZa3buRzyV7wJku/tmbh7OK
         qE8/2+9HpwwUAMPlYDLMNwOAcVioVQ5bx60KGrGEBs6A1yN5TDHWgY6YN+noHDMExQh3
         7h+ue1RihrgIz8QV3VXbzK3Dpb3faarCCyTBDBT1fW+QxY7rIeMIeUb9MZRT7/BVDHq7
         RMeOzbeEw+hGCY7DoGIe91wnJW1U49uOF5ZuzpNjfL08D+FfRpcdmSC+r8e/DHQLdq9c
         nAxEOMyP8oVRU1IACWTvJRUEQY+gni3yZjj8EvN0M/GrT2rzgR/mqAvfNkgr1CpNOZ+d
         MPyA==
X-Gm-Message-State: AOAM532v0HrcJWsX8fTHuvN5LfNG7sJbiSoHTGwDIOhYETjWkFQYHV1v
        /fQePAARbvFyqtgiJ/uPpd4=
X-Google-Smtp-Source: ABdhPJzndbEGzLreSuun/TVyXCVODYzU2q+O1p21jgj67ZWy91G2PuN8kyURKCfzVZRDWz7N3VdNiQ==
X-Received: by 2002:a63:90c7:: with SMTP id a190mr17751652pge.185.1643649542856;
        Mon, 31 Jan 2022 09:19:02 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y42sm17158804pfw.157.2022.01.31.09.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:19:02 -0800 (PST)
Message-ID: <ff9c4010-3dbd-83a8-50b4-d4070f0d11ea@acm.org>
Date:   Mon, 31 Jan 2022 09:19:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 13/44] bfa: Stop using the SCSI pointer
Content-Language: en-US
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "sudarsana.kalluru@qlogic.com" <sudarsana.kalluru@qlogic.com>,
        "anil.gurumurthy@qlogic.com" <anil.gurumurthy@qlogic.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-14-bvanassche@acm.org>
 <737e4d80bd7843284825e4e7664f17fed8f488a0.camel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <737e4d80bd7843284825e4e7664f17fed8f488a0.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/31/22 02:39, Johannes Thumshirn wrote:
> On Fri, 2022-01-28 at 14:18 -0800, Bart Van Assche wrote:
> 
>> +       wq = bfad_priv(cmnd)->wq;
>> +       bfad_priv(cmnd)->wq = NULL;
> 
> Can't this be shortened to
>   
> 	wq = xhcg(bfad_priv(cmnd)->wq, NULL);

In this patch series my goal was to introduce as few functional changes 
as possible in legacy drivers. The xchg() alternative looks valid to me 
but would involve a functional change, namely changing non-atomic 
instructions into an atomic instruction. Do you want me to make that change?

Thanks,

Bart.
