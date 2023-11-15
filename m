Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D98C2BB3F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 19:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjKOTXg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 14:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjKOTXe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 14:23:34 -0500
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A51A19D;
        Wed, 15 Nov 2023 11:23:31 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-53fa455cd94so997a12.2;
        Wed, 15 Nov 2023 11:23:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700076211; x=1700681011;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldrozAYeineeZ/BF/LEq3IJ2o7DgZwcwEmQt6wI/BQE=;
        b=o1tBgLoQaIGaJvHzmZhO7ZwyUm9CcF09wrZB2PiHwMIKaUHpyM2CUeGJXe4QXC/cOo
         rf8B3g9zBRy/4auCfg4B1zn9wTyR3MCrJU+Arpst86bSWJEAD3uXAsozkxAls7iwpwum
         Xu/Z5ncuLa3QO7I8AHo02crHmobmzoWuGu5YVhvj02xQGM9ms7D2KmcxQS5/N8/3SbwS
         BiAOZ4BptBRHRx+FIK5PLQrrM4OCOfBSGoVrDrO93KUcuXMIRVxGtOmg9ZK+2l10IMZN
         cKAcgytceegBL3bBXf8Q6ThoxOlDTfBY23OmEKp5EjFWfVum4tS3peAsXcXnHqU1mGwR
         643g==
X-Gm-Message-State: AOJu0YypTJfhEQOL0U43RzLjvE+4EqbvDU/EzmM5HzYbsHW1O7tx7HNJ
        mtcG5VUCyBsulikDOjDgHuQ=
X-Google-Smtp-Source: AGHT+IGq0v6pa9Jdeag9qRSdRmRPWvaBS8KkivlScZwV+8fLay4ixrQ6HcxZmmpsBH1ODg4GTcks0w==
X-Received: by 2002:a05:6a20:54a4:b0:17b:3438:cf92 with SMTP id i36-20020a056a2054a400b0017b3438cf92mr12829670pzk.5.1700076210814;
        Wed, 15 Nov 2023 11:23:30 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:56f1:2160:3a2a:2645? ([2620:0:1000:8411:56f1:2160:3a2a:2645])
        by smtp.gmail.com with ESMTPSA id k9-20020aa78209000000b00692cac7a065sm3124100pfi.151.2023.11.15.11.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 11:23:30 -0800 (PST)
Message-ID: <03a436a0-b0cf-4173-b846-44509205dacf@acm.org>
Date:   Wed, 15 Nov 2023 11:23:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: clear cmd if abort success in mcq mode
Content-Language: en-US
To:     peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
References: <20231115131024.15829-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231115131024.15829-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/23 05:10, peter.wang@mediatek.com wrote:
> In mcq mode, if cmd is pending in device and abort success, response
> will not return from device. So we need clear this cmd right now,
> else command timeout happen and next time use same tag will have
> warning. WARN_ON(lrbp->cmd).
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
