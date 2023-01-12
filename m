Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558E7C61DB3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 22:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjALWhO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237200AbjALWhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 17:37:12 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CCB19291
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 14:37:11 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id g23so6054662plq.12
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 14:37:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZjRpJFolj22gPObrjDPfnWN1VKUQUcKY47jgd1KBRM=;
        b=1mqjBiKqCYJQAKkQBcLuCTdNsYma5Mn049VFbo0mOHW0V0G2numMW2+chaPoCw6O2y
         ZmMgvDgoIWebwjZKFyEkKp9oysLwlVuOPoltffn0mrP/MjobgVrL2MEIY4GRSA2qtIHr
         Ah9Ua9oOMv9VPK6dTqL+THfBBMy2iE9d3v6sXQ1VozguocxYQS5twTnrNqNEcvvmUvsW
         zqf0D5W4nmS0ftZ6gRDEjowbAdOTdCZ2vrqhPJ2TiC12qdkAZaAM1N/FZP5t/pw+rtCR
         OQNmamdxQoZSZrS6UpLAjhs54AJ7bfgSNjt27YBfOLEGpkzp+8KHqapkeDMdpSXk1wpc
         qPIg==
X-Gm-Message-State: AFqh2konYVxZFhX2R4s8HVJ+A73d+WaBRBLCfeanfnqYjTtvGeKt5WlK
        3CfIDxbvopleq1jeIZxn1lw=
X-Google-Smtp-Source: AMrXdXsHYMts0DAUWiX5ZOfbMmbkQ0PZ0O3Ptq7gxiD7YIh24WhuJReqCGr8e+hkP3UVGJyYFB7ghA==
X-Received: by 2002:a05:6a20:4985:b0:ac:a2bb:96e6 with SMTP id fs5-20020a056a20498500b000aca2bb96e6mr77167232pzb.56.1673563031103;
        Thu, 12 Jan 2023 14:37:11 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n128-20020a622786000000b005811f5b9fb3sm12284920pfn.210.2023.01.12.14.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 14:37:09 -0800 (PST)
Message-ID: <af53b716-9cbb-5048-e5a9-9026f44a41b8@acm.org>
Date:   Thu, 12 Jan 2023 14:37:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/3] scsi: ufs: Exynos: Fix the maximum segment size
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, 'Kiwoong Kim' <kwmad.kim@samsung.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        'Krzysztof Kozlowski' <krzysztof.kozlowski@linaro.org>,
        'Chanho Park' <chanho61.park@samsung.com>,
        'Bean Huo' <beanhuo@micron.com>
References: <20230106215800.2249344-1-bvanassche@acm.org>
 <CGME20230106215900epcas5p3b37893c02dfdd363ebb697e5a5c9ffb8@epcas5p3.samsung.com>
 <20230106215800.2249344-3-bvanassche@acm.org>
 <018d01d92584$f5d57c60$e1807520$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <018d01d92584$f5d57c60$e1807520$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/10/23 22:21, Alim Akhtar wrote:
> For some reason, I didn't receive you patch-3/3 in my inbox.

That's unfortunate. That's probably because I use a shell script to 
generate the Cc-list for UFS driver patches:

scripts/get_maintainer.pl --no-git --no-l --no-r --no-roles 
--no-rolestats "${1:-&STDIN}"

Anyway, patch 3/3 is available here: 
https://lore.kernel.org/linux-scsi/20230106215800.2249344-4-bvanassche@acm.org/

Bart.
