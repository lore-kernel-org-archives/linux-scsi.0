Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FD4C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 02:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843ED61211
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 02:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhIKCl4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 22:41:56 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:40545 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbhIKClz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 22:41:55 -0400
Received: by mail-pj1-f50.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso2779333pjh.5;
        Fri, 10 Sep 2021 19:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RTvYc9+M+PdlY46IoqNCtxrsILmR+QcmKElAcHgC4Mc=;
        b=iKZfp6/oJO2ClXIhjT6ntJWd693wGO3sPnQhO/vjp2grlHvRIBVarin8vZqqgPqB3c
         D/PerRsWPQpBKbGOFffJiAAkAguPGItSEo0CR/YzIxKF8jepv/iNFxAmv4mW1Vf8/Hpm
         PsnI7AjbUr2OWGZVYymWPQ48pJhihDgl12YAMbbx4Hd7fSZEISoGQVKYLMmjZx1FP2yz
         gae1ACD2LDRRou1R+hRnM6G9dopFg3bFNVzo49D6CExUnRPoohKURa+hTykJn1w13TDx
         xS/LwGpeLGmMhxIel9HxmCFH3CVtW98b+8/kHAx44PBut8Jh6Zi2UnHm+dJfmLxaQvU8
         rmWg==
X-Gm-Message-State: AOAM531ZlZ6erNA/k7OpFP5qW0JR6684r54/5unHXeteLHNRecoL0Vr0
        oHtMDAliNKMIe8Xfm09nNxM=
X-Google-Smtp-Source: ABdhPJwepuPWS8nWwZsOQFiFl60q/zyg9/RnPy2lRRlKNzKXKQGzOnwHt3gTf4F4VC8cHu/iM61P1w==
X-Received: by 2002:a17:90b:314c:: with SMTP id ip12mr855880pjb.32.1631328043574;
        Fri, 10 Sep 2021 19:40:43 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:2c24:10db:f5a3:3a53? ([2601:647:4000:d7:2c24:10db:f5a3:3a53])
        by smtp.gmail.com with UTF8SMTPSA id b7sm198471pfl.195.2021.09.10.19.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 19:40:42 -0700 (PDT)
Message-ID: <c58785a4-b6f6-76eb-2104-0b87753a2180@acm.org>
Date:   Fri, 10 Sep 2021 19:40:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH v5 5/7] target: srpt replace enable attr to ops.enable
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210910084133.17956-1-d.bogdanov@yadro.com>
 <20210910084133.17956-6-d.bogdanov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210910084133.17956-6-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/10/21 01:41, Dmitry Bogdanov wrote:
> Remove tpg/enable attribute.
> Add fabric ops enable_tpg implementation instead.

How about changing the prefix from "target: srpt" into "RDMA/srpt:"
since that is the prefix that is used for other ib_srpt patches?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
