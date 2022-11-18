Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7501DC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 15:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiKRPH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 10:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242129AbiKRPHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 10:07:32 -0500
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC84E7A
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 07:07:31 -0800 (PST)
Received: by mail-pg1-f170.google.com with SMTP id n17so5216526pgh.9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 07:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rw+hwNP/YVhyhMTqrkZ9W55x3sMQCM7YOj2DJVbO+IU=;
        b=c/ZEwiEeSPCFUnBs/cCqvsWVhioaQGzwVLfgXiXEqYUT0tCk4FpnbvqqUMHNs+xBFQ
         /e6/+20ifgk2eq3ZAZnIsPyvTE8ogmAJ+dQxVGC7y632KAiswXOYT7rDfV2KuJxFe2x5
         6tjw/LkXm7tOD+ZpvHsscm5f0KD7wkU+kgVu0EvmEpJoL1MnAjIYUaCDvFihgJSQZtuC
         Ty0n4Chv1Zan27ydV12SUYx2agtrL2i13eKr5HxfaO1kdj6fqF8JWx8S5r0KfUOwdK9A
         0BuFuIznQwXxSo5ZaHb89AmVwT1Wh540g+ABdDAHuZvhmMTeMd5PUQ8uaefF2JjBzOUv
         UPbQ==
X-Gm-Message-State: ANoB5pmmtPe/LEslBRL28iECiIOwF553TTPeZ4T2MsCFbycHJxjQ32j3
        TcjAGYFUvAOxTjPctmpS86g=
X-Google-Smtp-Source: AA0mqf6TecCqUQBztVuM40UCHpPU1F/kFcMwZ0KKNZfts7p9NoX9In6cH59BIOIdDz4DKSRFa3BLGA==
X-Received: by 2002:a63:b513:0:b0:477:3052:248c with SMTP id y19-20020a63b513000000b004773052248cmr2503827pge.179.1668784051225;
        Fri, 18 Nov 2022 07:07:31 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902780200b00186a2444a43sm3819153pll.27.2022.11.18.07.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 07:07:30 -0800 (PST)
Message-ID: <2cb6d6aa-965c-e716-6110-5b90b634f59a@acm.org>
Date:   Fri, 18 Nov 2022 07:07:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/2] scsi: alua: Revert "Move a scsi_device_put() call out
 of alua_check_vpd()"
Content-Language: en-US
To:     Sachin Sant <sachinp@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>
References: <20221117183626.2656196-1-bvanassche@acm.org>
 <20221117183626.2656196-2-bvanassche@acm.org>
 <621BAA12-689E-4420-9D63-CC53E77370D5@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <621BAA12-689E-4420-9D63-CC53E77370D5@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/22 22:11, Sachin Sant wrote:
> Tested it on top of next-20221117. The reported warning is not seen.
> 
> Tested-by: Sachin Sant <sachinp@linux.ibm.com <mailto:sachinp@linux.ibm.com>>

Hi Sachin,

Thank you for the help with testing.

Can you also test patch 2/2 from this series 
(https://lore.kernel.org/all/20221117183626.2656196-3-bvanassche@acm.org/)?

Thanks,

Bart.

