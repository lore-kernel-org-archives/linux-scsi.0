Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426BAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 17:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244832AbhK3Rhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:37:43 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:42606 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238828AbhK3Rhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 12:37:42 -0500
Received: by mail-pg1-f178.google.com with SMTP id s37so10898750pga.9
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 09:34:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JBzELG2AHfpIX7y0ShXrMOcLkztJaYewHFP3D+A7eEI=;
        b=fxO3y5BzGeT3MY0yyVIUnEtsEinsmu/e3ntCOyo8MahRI9p7dYIMyiJ9Puz74Ob5Kw
         upicI3O4YZVleJYXaD5xLc2CnSH+x7B+k52AD7AfwuUaaxEjQpJo3m8v5MTGuwkCxfvT
         bMW4qzsLPDc/vbl9SDB8VFf4iG2BOvHpDLWI9eOAnx7g5uGAhP2z5b2TsXORxPTYcoYy
         99uA1sFrhswVJUakGYaBsne66a4CWzVL0e7QIl5EPP2Fk1yYAnz4acj+2CHuMx/6k4Wp
         6UMqkFRnI047usZBaDhTxfzOQi2ksBL2EOPfLmnSaT/Uv7xtyVbQ50OCyHt06q6T1Qzl
         tE9g==
X-Gm-Message-State: AOAM530iAVaW4bYHdtc7Bmzb/b1fF5EJGX8JAg98Ixd4WNVpqKFYdc93
        jKs/mhZtZCfeLfZs0GzI5yI=
X-Google-Smtp-Source: ABdhPJyTiVf1QxTPuyqIZ6Hs4WGKT/1EmrmRWRDotUWSz+RvCCBDUdilVHwMogB8oEtXn/nJXQEtmA==
X-Received: by 2002:a63:e64e:: with SMTP id p14mr438344pgj.155.1638293662855;
        Tue, 30 Nov 2021 09:34:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id u22sm23484276pfk.148.2021.11.30.09.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:34:22 -0800 (PST)
Subject: Re: [PATCH v2 19/20] scsi: ufs: Implement polling support
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-20-bvanassche@acm.org>
 <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
 <deeb660e-d1ef-7a54-6221-45cfebd87881@acm.org>
 <952443760df360b48a153c01b1dad957cd82fdea.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <eea50392-b9b4-2d0b-3fbe-61e73a3b838f@acm.org>
Date:   Tue, 30 Nov 2021 09:34:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <952443760df360b48a153c01b1dad957cd82fdea.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 7:40 AM, Bean Huo wrote:
> It is the test case in your commit message. If iodepth=1, there is no
> performance improvement. Increase the io-depth to multiple, for
> example, let iodepth= CPU core counter. I see that the interrupt
> overhead is significantly increased when the request is completed, so
> IO_polling will win compared to the interrupt mode.

Hi Bean,

It is not guaranteed that polling will result in a significant performance
improvement. I assume that on my test setup the improvement is so
significant because the interrupt coalescing delay. Maybe the interrupt
coalescing delay is much smaller on your test setup.

Bart.
