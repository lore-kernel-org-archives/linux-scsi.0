Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DF5C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 18:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB323610C7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 18:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWSPn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 14:15:43 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:37511 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFWSPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 14:15:41 -0400
Received: by mail-pl1-f179.google.com with SMTP id y21so1598764plb.4;
        Wed, 23 Jun 2021 11:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YPCKLnIdvm7c8vo4HC4dw3kc7x5gu+eIEAEO9XY3hos=;
        b=EIB8G16uae3DQkN7a5rQOi8jtYFy9W/X1SxxuizdI/+bumSwZSV6NbG3o1n/BwAr02
         T6mx37vVmtEtN63s+40MQptuj5DEAxwl3cyBGZcMiE/kImtrflad7OEd23nnuyMxAE11
         qW2UtG6M5BYZfi82xZTGbeN3HYgrCdpZkFsoes/diWZVlCz8RFUGTbRmOG7GfGUx2oAT
         HsPwLO1IHVLLVG08HKQ+RF8LWhl+loUnRRjJER63Z+NICCbYsndRo5TUTIcJe9lfXIZx
         592ICyGU9lHWF3Qcv5CPkJ8C/XgF8dEwQfnpi8Ofw1AHfI2DG83oORyqfEKHyzrUVqzU
         krrA==
X-Gm-Message-State: AOAM530dAOACSWJd9ajvEHH5GQLJ3mUXuhtMbYzfLAoX0T0ldMbJsdeJ
        McrjA7ixm287d0WC5o0zsm8=
X-Google-Smtp-Source: ABdhPJyMi5StJCE81hWrugfS2bXvA/tPdhBTRMxwzaplnFcTQdUEKfKyevvLYlwPhZO27dstCRx4Uw==
X-Received: by 2002:a17:90a:384d:: with SMTP id l13mr1585156pjf.201.1624472002858;
        Wed, 23 Jun 2021 11:13:22 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c24sm549766pgj.11.2021.06.23.11.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 11:13:22 -0700 (PDT)
Subject: Re: [PATCH v38 1/4] scsi: ufs: Introduce HPB feature
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
References: <20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f@epcms2p7>
 <CGME20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f@epcms2p4>
 <20210616070812epcms2p4650ce5cd78056dce9162482e59bb74dd@epcms2p4>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5a71d4c3-2f1f-3c85-eb90-381775e7030e@acm.org>
Date:   Wed, 23 Jun 2021 11:13:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210616070812epcms2p4650ce5cd78056dce9162482e59bb74dd@epcms2p4>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/21 12:08 AM, Daejun Park wrote:
> +What:		/sys/class/scsi_device/*/device/unit_descriptor/hpb_pinned_region_start_offset
> +Date:		June 2021
> +Contact:	Daejun Park <daejun7.park@samsung.com>
> +Description:	This entry shows the start offset of HPB pinned region.
> +
> +		The file is read only.
> +
> +What:		/June/class/scsi_device/*/device/unit_descriptor/hpb_number_pinned_regions
> +Date:		March 2021

Please change /June into /sys and "March 2021" into "June 2021".

> @@ -7094,6 +7119,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>  {
>  	int err;
>  
> +	ufshpb_reset_host(hba);
>  	/*
>  	 * Stop the host controller and complete the requests
>  	 * cleared by h/w

Shouldn't the ufshpb_reset_host() call occur under the comment instead
of above?

Thanks,

Bart.
