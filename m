Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2655EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 19:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E405761A3C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 19:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347693AbhI3T5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 15:57:07 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:36515 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344849AbhI3T47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 15:56:59 -0400
Received: by mail-pl1-f172.google.com with SMTP id y5so4816708pll.3;
        Thu, 30 Sep 2021 12:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hxo8zWTeavlZiwQhHPk9TyhCAEA2B2YQU/hL0A/lgco=;
        b=pHtemc5kOrJn7ub9c8CJkRAlpo0mZzSfRl/iAy6oZ+jgc2zU1eYfMDYlcWJjXFLsQ5
         hOOUsY5122ymoeTJN9pp8Ty7xpsY9Zmt9laNgMu20rW1XnrLsPEcE8V06twizJ5yn6b5
         AlveD+iQwgKMMwthxMQn26Do/fOFwiCS3JHI1UwdNTmUCTVUscI3kfDHIXd0A9dT081x
         Ma3CDge+D4Pnzx7+bvF1afNX2/ttZcTbEIAlAAqbNp4jE2khk/7HyIKU1vdtlnglOyqU
         8bDOHbhclwqyLBG7JB2xkvyVfPYeGuw59nxNViQ66WfKcJUT+JqSi1RfwY/GMSbhUm0K
         hVNg==
X-Gm-Message-State: AOAM531SdXOsrp/1WE9dNrVe29V0rjtjDJ6tMGADbZb0XRnKD0hXudIw
        N/ELe/ZDUEV1GaaQzT7zwfuMUzmRCbw=
X-Google-Smtp-Source: ABdhPJwD3OwqoNpAOxrvw/024gJHJnaBTyD3nnpMlAlbfcqSWdrOuwtD/c1eihJcHLG64+l/O9EFpw==
X-Received: by 2002:a17:90a:4091:: with SMTP id l17mr8579978pjg.138.1633031716575;
        Thu, 30 Sep 2021 12:55:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id t1sm3418482pgf.78.2021.09.30.12.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 12:55:16 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: ufs: retry START_STOP on UNIT_ATTENTION
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20210930195237.1521436-1-jaegeuk@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <aacbec00-34e8-f082-51a5-15391bf99710@acm.org>
Date:   Thu, 30 Sep 2021 12:55:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930195237.1521436-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 12:52 PM, Jaegeuk Kim wrote:
> Commit 57d104c153d3 ("ufs: add UFS power management support") made the UFS
> driver submit a REQUEST SENSE command before submitting a power management
> command to a WLUN to clear the POWER ON unit attention. Instead of
> submitting a REQUEST SENSE command before submitting a power management
> command, retry the power management command until it succeeds.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
