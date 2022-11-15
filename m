Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D6EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 23:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiKOXXd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiKOXXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 18:23:32 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399421001
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 15:23:31 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id 62so6664526pgb.13
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 15:23:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XgWubNwaGcP4NPH7z3r7zWCsVhKC0OX0EXbAVcDnIh4=;
        b=ja52RuPDHLZ7ryFMHXcSIqcqQdgi8V8nMde1LL3ePwgkHma1Z+TDQslWoOhNNknAET
         Skgm7EExDPdefqcpiAlDB9BoMuXJE+LPUOCMy2p82KDTFOkFg0ibx5X7pqivFH89uDTb
         150JWnnRndac2dLfIvWv2GrPElETGmMyFbX7/qdM1hSIEZ37uqaz1lpOotnVAKPAy8A3
         LT2LJhINNlhMH4nOeZPgWVpmCnTgDMZYwyD6E23QAWyMiPevZYbegSWEQrCmBZHxUTwi
         pLKlfM/6jUGPaHiFcoGSVLmQp07oC0m/+D3kQYaySE5UUKRb7zPs58sXKTdPCmU2Le8o
         CmJA==
X-Gm-Message-State: ANoB5pm+4o3LjCDZOY9G9ixIvVd+9KSKXaxwaFVP5z9aOraDNnr1/9zb
        hJRv8+J77wxXJ09R+Y+uAPB2/yHC758=
X-Google-Smtp-Source: AA0mqf4BsQzXnu7eiK/+5VvpqhOImOsN7H/wO1FHsJ+OB1dffoTPJxn06HCPXC40WZuMg2OACh/f0w==
X-Received: by 2002:a62:18c7:0:b0:572:725f:338d with SMTP id 190-20020a6218c7000000b00572725f338dmr5001954pfy.1.1668554610610;
        Tue, 15 Nov 2022 15:23:30 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f13a:cdae:57:ff73? ([2620:15c:211:201:f13a:cdae:57:ff73])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b00186b6a04636sm10558009plg.255.2022.11.15.15.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 15:23:29 -0800 (PST)
Message-ID: <38dff1cf-f52c-8101-2088-d4bc59723c42@acm.org>
Date:   Tue, 15 Nov 2022 15:23:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] scsi: ufs: Fix the polling implementation
Content-Language: en-US
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20221114233042.3199381-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221114233042.3199381-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/22 15:30, Bart Van Assche wrote:
> Certain code in the block layer assumes that requests submitted on a
> polling queue (HCTX_TYPE_POLL) are completed in thread context. Hence
> this patch that modifies ufshcd_poll() such that only requests are
> completed for the hardware queue that is being examined instead of all
> hardware queues. The block layer code that makes this assumption is the
> bio caching code. From block/bio.c:
> 
>      If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done
>      from process context, not hard/soft IRQ.
> 
> The REQ_ALLOC_CACHE flag is set for polled I/O (REQ_POLLED) since
> kernel v5.15. See also commit be4d234d7aeb ("bio: add allocation cache
> abstraction").

Please drop this patch - I plan to send an improved version later.

Bart.

