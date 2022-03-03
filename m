Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071C9C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 01:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiCCBa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 20:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiCCBa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 20:30:27 -0500
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85781A06F4
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 17:29:43 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id 139so3192237pge.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 17:29:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4FIFa6MYeCES5cvf13iUPNrAPJGP8UqkKeqJYhHv4hI=;
        b=mNeXh440WapWrXsyLrJiDacd9ufiOxRA/laeJcpGhyyLNTZYaNeO2msgJNSMSHCvmz
         /Yx69xxrdhDm7OuMLZd+WRO0fwUBjI11nJW6Gjm5MRBuagFBX54HOSyfmwkBQtY+cbGN
         WfY6yXTuqRY5eaYXeBuytGzjcE6sMgA2suXuXDLlDiIiygM965GnsB9c9dYcGPQG7QrU
         h4EYSMRSlgv5JuYDzs2HUHT+lRzdnE+3v6lOAPn77OOIfTW3CXcQStixnfL8DikF8x63
         1xbPvuM36qK8M2kcw8jOmBE84TFO2WGxiMevNkPKZocgmHGlovwk8hkC8hOQP5Yc8m7X
         iPHQ==
X-Gm-Message-State: AOAM530z+bSsX7+jMOmhSRscaEWtjL7l0S1QC0gowCG1mwEbSVre2ajQ
        +fErgj+8O2wDu4nkW8PW6iF2wpybDSA=
X-Google-Smtp-Source: ABdhPJylssUgiJukCTmc8eWTLv46VlCv/+B8U/JPqv+eR3ZBi5uAcCWgF8mf0JUQ3qSom/7TTsBzdQ==
X-Received: by 2002:a05:6a00:15c6:b0:4f0:ecec:8214 with SMTP id o6-20020a056a0015c600b004f0ecec8214mr36523874pfu.33.1646270983251;
        Wed, 02 Mar 2022 17:29:43 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j16-20020a63e750000000b00373598b8cbfsm335743pgk.74.2022.03.02.17.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:29:42 -0800 (PST)
Message-ID: <c45c438e-9344-9b62-5e1c-17ecf56f4183@acm.org>
Date:   Wed, 2 Mar 2022 17:29:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 11/14] scsi: sd: Implement support for NDOB flag in WRITE
 SAME(16)
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-12-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-12-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> +		if (get_unaligned_be16(&buffer[2]) >= 2)
> +			sdkp->ndob = buffer[5] & 1;
> +	}

Code like the above is incomprehensible without having access to the 
corresponding specification. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
