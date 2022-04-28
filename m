Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C98C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 20:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242797AbiD1USa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiD1US3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 16:18:29 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A1231DC4
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 13:15:13 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id bo5so5178341pfb.4
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 13:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UXsv0TgK6Bxb1iSkz873wlp4mhWaTaPxLip7UoyI+zk=;
        b=1YfySB3wFe/94qykMBUGsaGNeRF/APDFF5daBHn77+Lm3P1CrftJ/bcbA6FHkpzanj
         QNKTLzx1AWFleL9P8C/x2+1QVnmlFL3fDvTDqEV3l4QxBb/JC8lfJOXlzRyVOKECVIS3
         7K3n9bFsf23E1XY0lRcdGR1RLrciy5UR7N7KGN0YvEJSF/kund1roAzxzvTmMB3IQIFz
         BCWLzFxfdB/pSU3uV695YmzXbExrAHilQsOq+Qanz/CMc5rYhwnA+E6Zwt254BQ1mDqj
         j1AhVRdpebT1yiYxAb8Rx1utdEiHhQedzwRPIZ+ZYANHqOlUI1nlZZnY0efct+5lGXaR
         HYwQ==
X-Gm-Message-State: AOAM531efJl0+5PaQy+z0ABIb8gEiNs3FFGOo34yl0TcHqGXZQ6EjoBa
        gD+L6bn/d867SIoc9dOoteM=
X-Google-Smtp-Source: ABdhPJyNFYtqakwZ9x56d381al14TuTx0G54CrxWnRUP9SJDNzURPGW+C2YYy7+/ztsBbgjqq/n33Q==
X-Received: by 2002:a62:3101:0:b0:50a:db12:bbda with SMTP id x1-20020a623101000000b0050adb12bbdamr36403184pfx.28.1651176913363;
        Thu, 28 Apr 2022 13:15:13 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6f14:f527:3ca8:ecbf? ([2620:15c:211:201:6f14:f527:3ca8:ecbf])
        by smtp.gmail.com with ESMTPSA id r14-20020a63e50e000000b003c14af5060esm3655498pgh.38.2022.04.28.13.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 13:15:12 -0700 (PDT)
Message-ID: <e43664a0-d069-6f86-290f-67c032c8a0e6@acm.org>
Date:   Thu, 28 Apr 2022 13:15:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/4] scsi: ufs: Move a clock scaling check
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220427233855.2685505-1-bvanassche@acm.org>
 <20220427233855.2685505-3-bvanassche@acm.org>
 <DM6PR04MB6575D637A530236D970386F6FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575D637A530236D970386F6FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/22 00:38, Avri Altman wrote:
>> Move a check related to clock scaling into ufshcd_devfreq_scale(). This
>> patch prepares for adding a second ufshcd_clock_scaling_prepare()
>> caller.
>
> A caller for ufshcd_clock_scaling_prepare() in which clk_scaling is not allowed ?

Hi Avri,

This patch prepares for adding a caller from outside the clock scaling 
code path. I will integrate this text in the patch description.

Thanks,

Bart.
