Return-Path: <SRS0=Jnta=D7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E004C2D0A3
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 04:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB1522201
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 04:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754979AbgJXEHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Oct 2020 00:07:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36251 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgJXEHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Oct 2020 00:07:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id b23so2803114pgb.3;
        Fri, 23 Oct 2020 21:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pdcicX9lxPMihXjurGsPe6g0UYtq7T7Wx9LqUueYjOU=;
        b=CJR7Z9soDRY0FqymgZVo6L10CWrDA1HXdBr4sLiCCCbuyn2EbPXVlj6w0PC5n8AcOl
         IJCXt03saWEDoDZMJBv7vN4Hw9Ienax7yeim6uW3X4dVdtte5eVAcD+0VP7vKJsGPyn1
         7VUAM/G72+z5XAYFTvFhKHtP9bByb7Zmla+dnWgI1pAB6EI78g6xO0eoqjN1+aiMw9om
         c1rPne54VMksFVwt6kJnqlVa5RMoKaYkpvJrFuKB/5Iyg117OjS//LeLUdGdBeUqx3FC
         7fJW88+iq1U9CZ8WWNaZXNj94J0Tabzk9rf0JrlZLPDJ2OnImDxB3UnxLP0G8SOvUOCq
         1imw==
X-Gm-Message-State: AOAM533T3qKGJu5WnvCxtujnuXY3S255eIj0VqaRFFvKOqI0BbQX83+o
        aL0Due6g39wRCKUVjyxZeH8AUcndSeDQFw==
X-Google-Smtp-Source: ABdhPJx/9jKiP9y4fxQry5XNjzovkycwy6eIBjkRcDzUmdS8jyj39rrOdNtntJKKNWk46S5qiswWww==
X-Received: by 2002:aa7:82ce:0:b029:142:2501:35cb with SMTP id f14-20020aa782ce0000b0290142250135cbmr2307492pfn.43.1603512461135;
        Fri, 23 Oct 2020 21:07:41 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s131sm3626359pgc.18.2020.10.23.21.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 21:07:39 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
Date:   Fri, 23 Oct 2020 21:07:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201022172011.42367-4-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/20 10:20 AM, Anastasia Kovaleva wrote:
> According to FCP-4 (9.4.2):
> 
>   If the command requested that data beyond the length specified by the
>   FCP_DL field be transferred, then the device server shall set the
>   FCP_RESID_OVER bit (see 9.5.8) to one in the FCP_RSP IU and:
> 
>   a) process the command normally except that data beyond the FCP_DL
>   count shall not be requested or transferred;
> 
>   b) transfer no data and return CHECK CONDITION status with the sense
>   key set to ILLEGAL REQUEST and the additional sense code set to INVALID
>   FIELD IN COMMAND INFORMATION UNIT; or
> 
>   c) may transfer data and return CHECK CONDITION status with the sense
>   key set to ABORTED COMMAND and the additional sense code set to
>   INVALID FIELD IN COMMAND INFORMATION UNIT.
> 
> TCM follows b) and transfers no data for residual writes but returns
> INVALID FIELD IN CDB instead of INVALID FIELD IN COMMAND INFORMATION
> UNIT.
> 
> Change the ASCQ to INVALID FIELD IN COMMAND INFORMATION UNIT to meet the
> standart.

Is FCP the only standard that requires to report INVALID FIELD IN COMMAND
INFORMATION UNIT for residual overflow? I haven't found any similar
requirement in the iSCSI RFC nor in the SRP standard.

Additionally, what benefits does it provide to report a CHECK CONDITION
upon residual overflow? The SCST QLogic FC target driver doesn't do this
as far as I know, is more than ten years old, is widely used and so far
nobody complained about this.

Bart.
