Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01135C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 16:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbiECQ2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 12:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiECQ2N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 12:28:13 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E599E3D48A
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 09:24:36 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id 7so10527729pga.12
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2022 09:24:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bvsXeAAd0KvgCQ6RxPGwEQm7RAa1AavzHl3itJaj2d4=;
        b=Ld7QSCbR+HN9V9U8TBA5gaW5jYlQ2OFAG0yCTUCmsv43WV/Fv+Igglb5uDT4B0cgZx
         1M3Z/1NAepP+PQJWqg/Wb82sXA7tR6UntgG7A35zfFO+k7Sz4n+395fvUBMKGvV796vw
         YCT9Hvwtj9sTZsGLCBsgiMW6tEVuiu/Pu5qswHNP1vOHoBShhxrHUO+zpNBGeFS4q2XI
         7SJkz+gao4i92EvQnt2StyyYgUwBYX74D3C3iNcNJRHYEAWSKyiUCOKnhoF2TppHZNLv
         8bmzYPO7f/Y8HS+xDT/Oyup+UCjkM+uo466dd+R2ERzAYY7DsudHuriVUxr+Fdm9BvMg
         C+jg==
X-Gm-Message-State: AOAM530vX1viFA4zBJ0rYB9Un+XPkiJ84QJ2B2kUJgt8xPcoU06f5/Wr
        5amkkq07BptZnMcQ+c+t6vc=
X-Google-Smtp-Source: ABdhPJzrXLPRm4nB4JeIY4OytCxZllypcGN2n+C4Y+QfaFxIGuAC8OPsqRddOyNTau2eLDxbstwYag==
X-Received: by 2002:a05:6a00:2444:b0:4fd:db81:cbdd with SMTP id d4-20020a056a00244400b004fddb81cbddmr16939095pfj.32.1651595076206;
        Tue, 03 May 2022 09:24:36 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id gb20-20020a17090b061400b001d9927ef1desm1535994pjb.34.2022.05.03.09.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:24:35 -0700 (PDT)
Message-ID: <f2411826-c529-74c1-ce11-0d8f98eea9da@acm.org>
Date:   Tue, 3 May 2022 09:24:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 05/11] pmcraid: select first available device for target
 reset
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215416.5351-1-hare@suse.de>
 <20220502215416.5351-6-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220502215416.5351-6-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 14:54, Hannes Reinecke wrote:
> As we're moving away from using a scsi command as argument for
> eh_XX callbacks we should be selecting the first available device
                   ^^^^^^^^^
> for sending a target reset to.
  Please explain in the commit message why selecting the first available 
device is the right approach.

Thanks,

Bart.
