Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEEFC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 01:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E027723A3C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 01:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgLRB67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 20:58:59 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:35827 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLRB66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 20:58:58 -0500
Received: by mail-pf1-f169.google.com with SMTP id c79so587730pfc.2;
        Thu, 17 Dec 2020 17:58:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ylk3mmy8RKaw/CShyBpWu3tKW4aFR91rhWA8RSAroKA=;
        b=cJhLETY9dKputf7qF8FhZhad8+XpDO7LQM6RXthD+trjW6urvNYZRDOWSw2kaUwpni
         sz3e1a3f4hjqLKRdA1C6qqN2EhsnB1IT8qzWqyflEewPGbLtn1iSEugOsOBegXPZkj5I
         SeTrVih2RpRIpdKrR7dS8CzzxLdUrq/q3siiFKhSVUgwAjfzNoJBkE9RZ3PrPu9n2W4M
         xTk1grdsjuFkBofaelzFcZD0R19Pu4+Azt0AzsUTa6nwh6M5S/zSEm8sKljTdh5gq4Xb
         KrMAOhnBPWtDlWNkUGY/+jlF37IEnQsWJP/x+jdJlx/msw8zX5aKiCF4jgYtHgvB6aJY
         nv8A==
X-Gm-Message-State: AOAM530FFFcDsZ2Si0/5nbZZBnWgLj26DN8bMAfxtyu9Bt0psbsEZGce
        tIVJDgcQ40CjJ5PP92dhd4NoTL+t8h0N7w==
X-Google-Smtp-Source: ABdhPJw8hdM2+32d93UTdQYxaa4WmtOSaGcYE0QV3Hp+cC3iKXEnkkpVcSOKAa2u/1etfTJ4btFI8A==
X-Received: by 2002:a63:c155:: with SMTP id p21mr1961874pgi.377.1608256697719;
        Thu, 17 Dec 2020 17:58:17 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b5sm6973724pfi.1.2020.12.17.17.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 17:58:16 -0800 (PST)
Subject: Re: [PATCH v14 0/3] scsi: ufs: Add Host Performance Booster Support
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
References: <X9ncUJH/vHO7Luqi@kroah.com>
 <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
 <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p1>
 <20201218010520epcms2p1f7994bde414008ea1f44c733350308db@epcms2p1>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e8b08117-0670-7222-05bb-a88910a93be1@acm.org>
Date:   Thu, 17 Dec 2020 17:58:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201218010520epcms2p1f7994bde414008ea1f44c733350308db@epcms2p1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/17/20 5:05 PM, Daejun Park wrote:
> Here is my iozone script:
> iozone -r 4k -+n -i2 -ecI -t 16 -l 16 -u 16 
> -s $IO_RANGE/16 -F mnt/tmp_1 mnt/tmp_2 mnt/tmp_3 mnt/tmp_4 
> mnt/tmp_5 mnt/tmp_6 mnt/tmp_7 mnt/tmp_8 mnt/tmp_9 mnt/tmp_10 mnt/tmp_11 
> mnt/tmp_12 mnt/tmp_13 mnt/tmp_14 mnt/tmp_15 mnt/tmp_16
> 
> Result:
> +----------+--------+---------+
> | IO range | HPB on | HPB off |
> +----------+--------+---------+
> |   1 GB   | 294.8  | 300.87  |
> |   4 GB   | 293.51 | 179.35  |
> |   8 GB   | 294.85 | 162.52  |
> |  16 GB   | 293.45 | 156.26  |
> |  32 GB   | 277.4  | 153.25  |
> +----------+--------+---------+

Hi Daejun,

What are the units of the numbers in columns 2 and 3?

Thanks,

Bart.
