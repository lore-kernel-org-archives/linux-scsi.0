Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4066C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 20:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18E861153
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 20:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhDOUbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 16:31:46 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33445 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbhDOUbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 16:31:44 -0400
Received: by mail-pl1-f174.google.com with SMTP id n10so1603533plc.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 13:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/2JqW71QIY5Ujoe1Z7JBJkjRN92tE6kKc2uMNgxNqPM=;
        b=IoWHa4WwZIWFeDm58rlFvsZLVLO22JJIy9mEgETEYzU+9jPEM2zgg5lgjA3RqLvz7m
         f9Plx+G37BoOTSa4zRy9P66PPEYvVUMxT9jhuWknxJUCfezsb3J/ym1sweNRlFFglYMb
         7jL2xqng88O4odXI0IYQd+mc1k5fVBgvkZudt2HFWyECe13t5XyNe2nwCwGJFJnW9ZNt
         lsajU/58Tez9z8huwRAMDEhY62gQh8mF8vKhcv6KXlkS/X5feMwf1rhd8bYG1lX2ftcn
         2bOPsESRH5tHgSbAuIB/Q4Uz9L4Lgng24b2ELNj7Q6/U39fknouiAG7ZcNdQE2JQSiwn
         pThg==
X-Gm-Message-State: AOAM533KueP6fKZbQRvxJozTNyKOT1CX/tFqquqrHMBN2ZLndjWeVg0V
        0WLM+5aybUxyqQ1uqG9qWy8TUjfGJxU=
X-Google-Smtp-Source: ABdhPJxz/l/DRPmUSIap2XnWt9uVrD738tCeyabfCr6EhKsJZ9JVCq5iQ3ldAQUvm51VU6RO3IlR9A==
X-Received: by 2002:a17:902:c948:b029:e9:8f01:fa8e with SMTP id i8-20020a170902c948b02900e98f01fa8emr5832388pla.37.1618518679833;
        Thu, 15 Apr 2021 13:31:19 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f031:1d3a:7e95:2876? ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id j3sm2665837pfc.49.2021.04.15.13.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 13:31:19 -0700 (PDT)
Subject: Re: [PATCH v2 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-2-kashyap.desai@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <32dd1ee9-4172-50b9-493c-181ae66da11c@acm.org>
Date:   Thu, 15 Apr 2021 13:31:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-2-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/6/21 7:04 PM, Kashyap Desai wrote:
> +/*****************************************************************************
> + * Define MPI3_POINTER if it has not already been defined. By default        *
> + * MPI3_POINTER is defined to be a near pointer. MPI3_POINTER can be defined *
> + * as a far pointer by defining MPI3_POINTER as "far *" before this header   *
> + * file is included.                                                         *
> + ****************************************************************************/
> +#ifndef MPI3_POINTER
> +#define MPI3_POINTER    *
> +#endif  /* MPI3_POINTER */

As far as I know there are no far pointers in the Linux kernel.

> +typedef u8 U8;
> +typedef __le16 U16;

Introducing U16 as an alias for __le16 is confusing since there is
already an 'u16' type in the Linux kernel. Please use the __le* types
directly.

> +typedef __le32 U32;
> +typedef __le64 U64 __aligned(4);

Do all __le64 variables need four-byte alignment or only some of them?

> +typedef U8 * PU8;
> +typedef U16 * PU16;
> +typedef U32 * PU32;
> +typedef U64 * PU64;

Please use __le* directly instead of introducing the above aliases.
Please also follow the Linux kernel coding style (no space after '*').

Thanks,

Bart.
