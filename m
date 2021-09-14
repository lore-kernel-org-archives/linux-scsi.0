Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290C5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0475D610CE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbhINDcK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:32:10 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:33706 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbhINDcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 23:32:09 -0400
Received: by mail-pg1-f177.google.com with SMTP id u18so11456980pgf.0;
        Mon, 13 Sep 2021 20:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0bjrAWTQ5Nbpiiwg86S9P5tLkoKX1Hbn83j5How7zUE=;
        b=PGODaQbCcwLkV69xzKS8BN/hythSLXlqlhkEdxIfUd8pYDWiXJ//2XkmyZn6doueLP
         RdN8ZH4HL+y19YIL76Zxzv01e6Cmb9oZiVkoOa6CrPc+jq3spSjirNMnM9vZr9TlnjjU
         29CubUWC0mWm08m7e6TD0wXsMZOOgftjwgeV6mFC1Y5+QuTv66k2tLpkNboGBLkm6pjT
         Uz8mPqQ0/oX8bb1qp4YBbruB7J4bH7RxeupUahcEYkf/ParLA62Q6z1/8nDd9gR4aSoc
         EweZiL41SJf4lxwrxYlIgIF+kJYsJ2LfiJ/8atbFPZRuk15WMSiNKBnSGrotuoKaO7Tw
         vy6w==
X-Gm-Message-State: AOAM533/t9Zt0KZHIJ4RFxuAiMl7QoPsfhkVg3VeqPnBDS/PFYczQTEP
        znkNYtXoQ8CZqQXlKx+yIR0=
X-Google-Smtp-Source: ABdhPJyXyVKxbj9IOO9q0ra6s7lB+wFjTb5ZqqyYr0YRmQ0B/dBFM3C+sSx0TQqop4ZDoSVjk5WepQ==
X-Received: by 2002:a65:40c4:: with SMTP id u4mr13911546pgp.186.1631590252522;
        Mon, 13 Sep 2021 20:30:52 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:e47e:ab85:4d9e:deba? ([2601:647:4000:d7:e47e:ab85:4d9e:deba])
        by smtp.gmail.com with ESMTPSA id m9sm4139068pfh.94.2021.09.13.20.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 20:30:51 -0700 (PDT)
Message-ID: <c6b2007b-155b-18b2-e45d-06f600c98797@acm.org>
Date:   Mon, 13 Sep 2021 20:30:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v2 1/3] scsi: ufs: introduce vendor isr
Content-Language: en-US
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <cover.1631519695.git.kwmad.kim@samsung.com>
 <CGME20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059@epcas2p1.samsung.com>
 <6801341a6c4d533597050eb1aaa5bf18214fc47f.1631519695.git.kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6801341a6c4d533597050eb1aaa5bf18214fc47f.1631519695.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 00:55, Kiwoong Kim wrote:
> +static inline irqreturn_t
> +ufshcd_vendor_isr_def(struct ufs_hba *hba)
> +{
> +	return IRQ_NONE;
> +}

Since "static inline irqreturn_t ufshcd_vendor_isr_def(struct ufs_hba 
*hba)" occupies less than 80 columns please use a single line for the 
declaration of this function. Additionally, please leave out the 
"inline" keyword since modern compilers are good at deciding when to 
inline a function and when not.

Thanks,

Bart.
