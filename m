Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6605AC001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 18:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjGSSd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjGSSd4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 14:33:56 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8127910CB
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:33:55 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1b8bbcfd89aso43429495ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689791635; x=1692383635;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oXioRTyJ4xwJBXnRRnwkRMoM7jBSHJ82oBIcR/YDHRY=;
        b=HzBgd0h0u3VSzi1fObVcOqfS8rjYPhBbiGLnfpa/KL9JIVNc4g3r8XX/Y8oNrWhIsb
         Ia/hrD6hmdrQUumV/703Fng7rPJDYzX7qthRhbaXG4WGTNr/Toc8KYnaa3LW5ELErYxz
         JSPgBmYS8qz4OE0jb1Nn0HGPvPnDdUsmFPfaKeIvZ7zYbG9mhDdgGT8l6thkglU/96yK
         Vq2DI0t1eoREe1K7104cMCFMXSPzlrvTm0Wb8E0qLEwnL52IUcko7xR4U9Q7hPPflzbN
         PQVej918zeJPO6C+fD0QptE/eAZiCRZGUX0gqj7TGdOjk89uq1QDYW09ZRqEjROyyQVp
         FSdw==
X-Gm-Message-State: ABy/qLY6ugVMqmoIUvpDNeYEbZWIDPmv/zTzMqo2tJJjKD4Nda6GvjKZ
        NHDmizpvrVUCvdH83d4rNR4=
X-Google-Smtp-Source: APBJJlEzxHCWj+pwQYV1zGg4uIxc8NYkljDSA6e8GRPoBX5bUMwVwvb4dauIsGttC9sfSFVxO4aMug==
X-Received: by 2002:a17:902:da92:b0:1b8:525a:f685 with SMTP id j18-20020a170902da9200b001b8525af685mr18061919plx.37.1689791634650;
        Wed, 19 Jul 2023 11:33:54 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a2ab:183f:c76c:d30d? ([2620:15c:211:201:a2ab:183f:c76c:d30d])
        by smtp.gmail.com with ESMTPSA id e21-20020a170902d39500b001b9dfa8d884sm4299434pld.226.2023.07.19.11.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 11:33:54 -0700 (PDT)
Message-ID: <b67e7390-6829-e403-2a58-64fbbc0f821e@acm.org>
Date:   Wed, 19 Jul 2023 11:33:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 04/33] scsi: Have scsi-ml retry scsi_probe_lun errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 14:33, Mike Christie wrote:
> This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
> itself.
> 
> There is one behavior change with this patch. We used to get a total of
> 3 retries for both UAs we were checking for. We now get 3 retries for
> each.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

