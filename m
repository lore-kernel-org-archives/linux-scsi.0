Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BFEC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 16:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E2A60FDA
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 16:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhFJQrv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 12:47:51 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:46038 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhFJQru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 12:47:50 -0400
Received: by mail-pg1-f178.google.com with SMTP id q15so210651pgg.12;
        Thu, 10 Jun 2021 09:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cP6G4cxMVx0EwF3yOM58gwJwnU2DrynFPBO8vVoT25c=;
        b=c3qrFcPCAWuk1SwAh3onzp9n8U/GlwRQg3g13dEyS3wrQrLEHh+maT35240/HfR3so
         STPYTZI5257WpAh41SQl26oXE6+wuxb9+YGJgiUG3Dovz4xtMm3/9hyQlNynVG5adULR
         J0yX4T+CVwUI5hcJaFn1CwUhAuy51iq9WIPe5IvuGPcsUfvUDciR5GSyjK1dWANlvzFZ
         t/N/PutuHRPSDa3KvVHcDQHbsasG6huDI8WHzlBLaifbnq/SgKYbE+DwRCVxoLeNtm5M
         BcXP91g6xrqBdXzwBMq+7LEu9XDdKzngfgJSRZqiAnCapxkwUeS1Tk9x6YkVAICW32uz
         VlvQ==
X-Gm-Message-State: AOAM530ugiyCbhL0GfrEu/Uxqd918RdVALZmYxjG5Qv1keWe01uAQJv1
        /Oe4D4Dm3yOAn3q3w98j7+E=
X-Google-Smtp-Source: ABdhPJzpQGivVOYAW2RIXlCqghUKslbJyT6lfkoCas5S9KrQfbmjwVSHOUTEQzm5dQb6u0HN49LCYA==
X-Received: by 2002:aa7:8431:0:b029:2e9:dcb1:148f with SMTP id q17-20020aa784310000b02902e9dcb1148fmr3864748pfn.29.1623343553489;
        Thu, 10 Jun 2021 09:45:53 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k9sm3069519pgq.27.2021.06.10.09.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 09:45:52 -0700 (PDT)
Subject: Re: [PATCH v36 1/4] scsi: ufs: Introduce HPB feature
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
References: <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
 <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
 <20210607041755epcms2p271195b24f4a10e777d240ff5d844168f@epcms2p2>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5694e1e0-1c8c-12ef-3215-3d3413a86ea2@acm.org>
Date:   Thu, 10 Jun 2021 09:45:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210607041755epcms2p271195b24f4a10e777d240ff5d844168f@epcms2p2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/6/21 9:17 PM, Daejun Park wrote:
> +What:		/sys/class/scsi_device/*/device/hpb_sysfs/hit_cnt
> +Date:		June 2021
> +Contact:	Daejun Park <daejun7.park@samsung.com>
> +Description:	This entry shows the number of reads that changed to HPB read.
> +
> +		The file is read only.

This patch introduces the hit_cnt attribute in the hpb_sysfs directory
and patch 4 moves that attribute to the hpb_stats directory. That is not
how sysfs attributes should be introduced. Please introduce the hit_cnt
attribute in the hpb_stats directory in this patch such that the sysfs
directory does not have to be modified in patch 4.

Thanks,

Bart.
