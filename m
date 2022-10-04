Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E26C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 23:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiJDXqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 19:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJDXps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 19:45:48 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD9125EB6
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 16:45:09 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso247462pjf.5
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 16:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ea5Fftwp7sxTOcDzwK4d+8whzzX4WxrCdde0IZMK4QE=;
        b=H6MgKvh7Tputvl+tn9y/zmiTYbyleWEq3nroLT/uB7z/vkeXE4dhCveY7BFyHJfUes
         aba/eqG4j+3RP07koCrm7g3UAay3nBj2gf+ywwB56Ply5Sz52gkXCnnrejAz+bLYXsl2
         y0Olt8vxMIoH/bYPQCUlCShkfXOnnpFiintYaBqDZHEhEdjgP1WykDjuq2HfV0A6eIwI
         zTSm91IF5qyThvNp+vddrfsqxKV6Cj8aEEbeeMBdNBf4fPNtpG3JbtEOpvz22r9PFLGt
         CG36RRrGK9O0A9d5cYLzje4kABB5hQnvSQ+t+jxtr3x6now7tDQvoC59vZHTVp+ZJayz
         VsIA==
X-Gm-Message-State: ACrzQf3kmb7sAmpPNvajBI4O2J65h04qudJW10/43M/mVfcQ5thBevIY
        VfXV0uz+09tcuXm4dszFcnp1cnJjo94=
X-Google-Smtp-Source: AMsMyM6JyfuPjX6yJF0iqNbdRnlt3ccM6hYF4mg8DHpdXgTtamEogrLKX+XLqlTcqjFw+XdfyNOTHg==
X-Received: by 2002:a17:903:230d:b0:178:29a3:df38 with SMTP id d13-20020a170903230d00b0017829a3df38mr28889695plh.10.1664927094923;
        Tue, 04 Oct 2022 16:44:54 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id h3-20020a633843000000b0043ae1797e2bsm8813413pgn.63.2022.10.04.16.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 16:44:54 -0700 (PDT)
Message-ID: <e7236693-3340-131d-9939-d9a543eae8e3@acm.org>
Date:   Tue, 4 Oct 2022 16:44:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 27/35] scsi: sd: Have scsi-ml retry sd_sync_cache
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-28-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-28-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> +	unsigned char cmd[10] = { SYNCHRONIZE_CACHE };

Can cmd[] be declared static const?

Thanks,

Bart.
