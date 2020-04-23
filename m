Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A86FC2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08CC82075A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSLaXtxL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgDWDas (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 23:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgDWDas (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 23:30:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F193C03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:30:48 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z1so549598pfn.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4/zvg6y52iJB7+gaq0nZ8SCSPjRxo5U7dMOp5VS20vw=;
        b=bSLaXtxLiNwo/JNIMpRBHy+Dc03zWwezVSSSgHh4jf7oywo32HXq/05M6WNXmaNZde
         gy1ie5Al0TD5ewi8ikpgByjGrD2KimgLAig7L3OEpBcCRoanhYCdUzdFV4276qOTetzt
         NJ5EXzOGHldF+Xxb2+iSSIwaXwGKDL+55NtNFA16eZ7P3au8Ceg6gRnDsq0H13zX8ujT
         6zJvMoa3cxIw/bCWU2uP3ZphMu+pQsSzQG250FxFbMRG0IY5cPll9GLxXTeeyBitgSfE
         CgC8RZwXysYX5XDRUB+9n3cw7exRMNmXs0e4S810BD3akRHPQ4XEPXMD6ZKiFwfDGsGn
         uiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4/zvg6y52iJB7+gaq0nZ8SCSPjRxo5U7dMOp5VS20vw=;
        b=E3BB9kRIGP/ozwMq0y/VuEoDHOYJ5H81rzUzuS9QOJgVoGTRFjr2zvij8Cl0y3LQxf
         bIdJErdmj53JzfDx0fiWw3CT7l0m2gEnClK+O3skizCr1EL34ulmtxgwJMJpEyJk5SBF
         sujLDZ44Qq/zcj12MT29vaaAk2c8J3WobDTT8guZYvCplkR5WoPVPWfDy/gMJZePd2pF
         99PAJLT2BjRWqsmgflYHjDu9Qq4strwivwVSnVRWrAUhpBD2/zNBqpKYLAbQHlAqoBZB
         QvGsRPDQUn5P2EcwbdC5TIuogRP3ykkWN9YjB5DebZ4EjLwUqxcJucp/qfxwiGICb3ha
         JiMA==
X-Gm-Message-State: AGi0PuaXTrkSwm2YttHnHuNxXg+y0Od+HFJ67vxkHxzpI3nNis6Hp8+b
        UHxF4+arIIX6hmhs7MkRwsM=
X-Google-Smtp-Source: APiQypLYFXqMH1Ef5W8gTmnaPoLxuKXUQXqKnipJHOHVoAZ4GWmwUEjLB8lk9fbEdQYePNh9E+7P0Q==
X-Received: by 2002:aa7:920d:: with SMTP id 13mr1860646pfo.112.1587612647480;
        Wed, 22 Apr 2020 20:30:47 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c4sm729124pgg.17.2020.04.22.20.30.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:30:46 -0700 (PDT)
Subject: Re: [PATCH v3 22/31] elx: efct: Extended link Service IO handling
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-23-jsmart2021@gmail.com>
 <e574f136-656a-78c9-f062-554ae15f0899@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <1d2ebba9-2609-47ad-a9d7-a569a93f449c@gmail.com>
Date:   Wed, 22 Apr 2020 20:30:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e574f136-656a-78c9-f062-554ae15f0899@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/2020 12:58 AM, Hannes Reinecke wrote:
...
> That is a bit strange.
> Sending a response can fail, but (apparently) sending a request cannot; 
> at the very least you don't have (or check) the return value from the 
> send request.
> 
> Some intricate scheme I've missed?
> 

The send_request fully handles the failure case, which ends up calling 
the request completion callback with an error status, before 
send_request returns to the callee.   Not handled that way with the 
response. The response routine handles the error.

Agree with your other comments and will address them.
Same thing for comments on patches 19 and 20.

-- james
