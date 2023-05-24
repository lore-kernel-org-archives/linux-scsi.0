Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0780C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 15:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbjEXPpy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 11:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbjEXPpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 11:45:44 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69473E56
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 08:45:12 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-64d2f99c8c3so810063b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 08:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943044; x=1687535044;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ko9BWC27j0GolZZK6/zENnA62lFsjyw7QbZxuJSAxRs=;
        b=dfTB7JQMQ7Ylq8miANEtGxEPTAZdtPWESg9UJdCtVOvhbpsECk3lZ3jQYpt07DnaOL
         IvBNBdoelP4QvxrTOBX+lX+lUtqlZ88ccfCqA+/+v3voTS5FI3Q69r9N6v89WCo2J+Qa
         PZqmxk0pCC19KQcoPXPM+ZBVcKCv09SL2x0s3CCdTlEjrvP4C85OwYAlm87/5jnEsisz
         Sbbx3AC2FlLmJGtVQUyjKyzPsEuSpJNf80UpWwLPv7+KGmHfq4CgdGRwvAXUfk3bn9Eu
         GjsFftdHQnI+NbU34NyMT67RU27nRcad/vxy3cRTpX7jXVq3TMA4A7PcmQT+Y/l7mpCn
         Rbxg==
X-Gm-Message-State: AC+VfDzPiy1u3FFJTQCLL1sqdzQgTdrypmdwm90zPbAZu08oCXQcA2fK
        CKi+m3/79ZGfiRM7Ru5xq/p7tF3kKAM=
X-Google-Smtp-Source: ACHHUZ6MJXRDugggGC2uk/LeIDtbFrcaygZb5JBqFv8gJ61e4+qJTKruq7nWk6BvqO6Qgehkm8XoOw==
X-Received: by 2002:a05:6a21:7886:b0:10b:b6cf:bbb0 with SMTP id bf6-20020a056a21788600b0010bb6cfbbb0mr12413672pzc.42.1684943044435;
        Wed, 24 May 2023 08:44:04 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f14-20020a63554e000000b0050927cb606asm7732921pgm.13.2023.05.24.08.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:44:03 -0700 (PDT)
Message-ID: <43fb8ad4-fb7f-d31c-91a0-a33c67c6fc04@acm.org>
Date:   Wed, 24 May 2023 08:44:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/4] scsi: ufs: Fix handling of lrbp->cmd
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230517223157.1068210-1-bvanassche@acm.org>
 <20230517223157.1068210-3-bvanassche@acm.org>
 <c0126a93-c34f-10ef-b050-2e34be420b16@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c0126a93-c34f-10ef-b050-2e34be420b16@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/23 05:21, Adrian Hunter wrote:
> Currently the reserved tag is not used for SCSI cmds but
> there is also a WARN_ON(lrbp->cmd) in ufshcd_exec_dev_cmd()

Hi Adrian,

Thanks for the review. I will change that WARN_ON() statement into 
"lrbp->cmd = NULL" to make ufshcd_exec_dev_cmd() consistent with the 
other functions that use the reserved slot.

Bart.


