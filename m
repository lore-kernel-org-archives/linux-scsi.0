Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05774C48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 18:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF9AD610F7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 18:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWST1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 14:19:27 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:41611 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhFWST0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 14:19:26 -0400
Received: by mail-pg1-f177.google.com with SMTP id u190so2457720pgd.8;
        Wed, 23 Jun 2021 11:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z+AOrquLkDeOpFoqZtvHK/EtjzG0F5WeDTVQkdzlRoY=;
        b=jTvcUMVRjUxCPRvtOFMEyws3Kf0Er2Ubz+XirRjw9CSLyRvIrpv+bvmGYyDXjPLqMN
         FcNaGgp86hlMuAIXP1BdMuL0nl7TF3WBOlFJyNbk144Vt/AnoPBMyIVXR4JKpPEEKr8/
         tAXrxEfHoRt4TwY1gdyA5zr+9R0hhY2QSBp98IAgkmZgevpTSzJ/HJO6YPtLSSFxJxXj
         7iFzzac8qd3jDAB1+GQ5q0BYTMWniiK0hicJMex7IZUEx1CK/WnxFnBHu+wL49cuQhE7
         1zwWfVV5BYwCCLo0qgjqsIqqH4wpOZ1YFin1zgPS/85L+bkyDPXoKtaJRpMf+cUUoGod
         s4hg==
X-Gm-Message-State: AOAM531CzNc9mt3xm/rCD88Dq+NczHoZRJk9H1S7M0v1dCkrpKkxl37w
        2Jcz7HEWMS3fj+1wwR0iFAA=
X-Google-Smtp-Source: ABdhPJylzVWnGjRlhLOd4VXY5K4YFuoa3mFP3EQWej9Onc+NgbYwMb96iL7Ge5dZHElWdEGLNagoAw==
X-Received: by 2002:a63:1b52:: with SMTP id b18mr697598pgm.179.1624472228421;
        Wed, 23 Jun 2021 11:17:08 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h9sm501149pgn.57.2021.06.23.11.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 11:17:07 -0700 (PDT)
Subject: Re: [PATCH v38 3/4] scsi: ufs: Prepare HPB read for cached sub-region
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
 <CGME20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f@epcms2p8>
 <20210616070913epcms2p83805028905f46225a65cc71678cddde7@epcms2p8>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <468d63c0-f902-efc2-17d7-5f4321806ca6@acm.org>
Date:   Wed, 23 Jun 2021 11:17:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210616070913epcms2p83805028905f46225a65cc71678cddde7@epcms2p8>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/21 12:09 AM, Daejun Park wrote:
> +	if (blk_rq_is_scsi(cmd->request) ||
> +	    (!ufshpb_is_write_or_discard(cmd) &&
> +	    !ufshpb_is_read_cmd(cmd)))
> +		return;

If this patch series is reposted, please fix the indentation of
"!ufshpb_is_read_cmd(cmd)".

Thanks,

Bart.
