Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC40C11F6A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C1C61C6D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhGGSTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:19:46 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:51124 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhGGSTb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:19:31 -0400
Received: by mail-pj1-f41.google.com with SMTP id ie21so2061068pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XQUIWVvNpv1olJcESftJWFjgJgeNmLc5ZZ30mInFVeY=;
        b=Qf9/S86i2d4Z17HWFyqIOt9kMtEGVrXw3Khc7535KLlv3WCn/otET7+kXRM0Z55fkb
         sDNObZYaOYu9CmRCTHAiX8FyHyTbmW3z9lb3bDmragBlNdXt6NKG+qA7ADCO1jE5t9K4
         bRC8JkiOmWiBUtxKw9a+8UMWz22vmjP4tsSzkA0hLHZZvkflLRglIXUmiar6iHXM2iXG
         n2kXdpJr8tRPuxeV+py4HFK58gGRc+5FwGt5X9JvHWgSWyHklkEXecMWSYITYyHUaLen
         L8fraQD+k2jxf9NLmRnWsb6xZ9MLvDH25c+PtlxIhrQC7Ysp91mfjrEgeSgyD3u2qjHw
         uxfQ==
X-Gm-Message-State: AOAM533YbECVUYbApbU1WU2Gi6QfjwC1Epq4EIhXJZHGJ9i7a4mDQoIS
        NeaNkAmct9ucSmd9cQom7y0=
X-Google-Smtp-Source: ABdhPJwDeoHCO/nRerDHjJxkbZHrVZg3T+qGdqA5ddb+Mh1YkxGQAC5nWk8qoRRkXWZu6Z0M8aqN+A==
X-Received: by 2002:a17:90a:eb11:: with SMTP id j17mr28549266pjz.177.1625681808422;
        Wed, 07 Jul 2021 11:16:48 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6679:27d9:f7a8:3b7e? ([2601:647:4000:d7:6679:27d9:f7a8:3b7e])
        by smtp.gmail.com with ESMTPSA id c64sm20953403pfb.166.2021.07.07.11.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 11:16:47 -0700 (PDT)
Subject: Re: [PATCH 00/21] UFS patches for kernel v5.15
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <DM6PR04MB65755CE992094A6CDA56EDFDFC1B9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <57717c9d-1b1c-18f4-8443-0abdcb116705@acm.org>
Date:   Wed, 7 Jul 2021 11:16:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65755CE992094A6CDA56EDFDFC1B9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/6/21 4:28 AM, Avri Altman wrote:
> May I suggest to re-group the ufs part of this series so it can be reviewed more effectively:
>  - Cleanups (relatively simple & intuitive, so can it be picked up ?)
>   ufs: Reduce power management code duplication
>   ufs: Only include power management code if necessary
>   ufs: Rename the second ufshcd_probe_hba() argument
>   ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
>   ufs: Remove ufshcd_valid_tag()
>   ufs: Verify UIC locking requirements at runtime
>   ufs: Improve static type checking for the host controller state
>   ufs: Remove several wmb() calls
>   ufs: Inline ufshcd_outstanding_req_clear()
>   ufs: Rename __ufshcd_transfer_req_compl()
> 
> - Fixes of "Optimize host lock" (can those 2 be squashed ?)
>   ufs: Fix a race in the completion path
>   ufs: Use the doorbell register instead of the UTRLCNR register
>   
>  - Revamping ufs error handling
>   ufs: Fix the SCSI abort handler
>   ufs: Request sense data asynchronously
>   ufs: Synchronize SCSI and UFS error handling
>   ufs: Retry aborted SCSI commands instead of completing these successfully

So this comes down to moving the "ufs: Fix the SCSI abort handler" later
in this series? I will make this change.

Thanks,

Bart.
