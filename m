Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFF2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 15:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9580610E5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 15:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhJ1QBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 12:01:55 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:44585 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1QBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 12:01:54 -0400
Received: by mail-pf1-f182.google.com with SMTP id a26so6367975pfr.11;
        Thu, 28 Oct 2021 08:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mutmdOYDUUCIr7fsjnojaxA7hpGsA4ENUDLCt5JOY4I=;
        b=y63pQaiv38WpHndacsR/qIH43xuAeJaJ35FUg7aDF71YnUOOAIlatPuRxeeja/t10j
         Fj2CMUFa8NE5Dfls9n8pcFv85hmWTl7nPbBX457SCnMt1c+c8HO5enya2m/51fS+h6NZ
         3Nuxv0xrWznSvu1W+rnXlmdvZnvmjg+/LIBN4sMhxJf0GlliTxDUPbie3NlogRfNLO2f
         FCZPaPY9vZuxCohQkxAnPnX1hS824bDuBn1TmgMqaG/o/ZwJsgAHWOO6Bz9Xy8esSuip
         dZUsPTg4fZ+yvFtCKoqSt7ww4U0PZWD8a95wcpc5evvJCJZa8yBXuJ2B6m0QN1etCT2y
         rPyw==
X-Gm-Message-State: AOAM533s2Wg2+SpLmjh8oTi92dcIHTnHmH2fSz+oEMBmrBZqHQ6cXOf0
        pHjWRq2ERakhYWzo3vmAi4s=
X-Google-Smtp-Source: ABdhPJw43XHWUaPDTIONgfMBhNXAohT/s8KNJwA0G0AWfx76mUEi3hjfoqSlZJyR+rzMAbYwSu8yVA==
X-Received: by 2002:a05:6a00:5e:b0:47e:603f:26bb with SMTP id i30-20020a056a00005e00b0047e603f26bbmr803311pfk.18.1635436767495;
        Thu, 28 Oct 2021 08:59:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e816:bd0d:426c:f959])
        by smtp.gmail.com with ESMTPSA id u4sm8123016pjg.54.2021.10.28.08.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 08:59:26 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
To:     jejb@linux.ibm.com, daejun7.park@samsung.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0d66b6d0-26c6-573f-e2a0-022e22c47b52@acm.org>
Date:   Thu, 28 Oct 2021 08:59:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/21 7:28 AM, James Bottomley wrote:
> If the block people are happy with this, then I'm OK with it, but it
> doesn't look like you've solved the fanout deadlock problem because
> this new mechanism is still going to allocate a new tag.

(+Jens, Christoph and linux-block)

Hi James,

My understanding is that the UFS HPB code makes ufshcd_queuecommand()
return SCSI_MLQUEUE_HOST_BUSY if the pool with pre-allocated requests is
exhausted. This will make the SCSI core reissue a SCSI command until
completion of another command has freed up one of the pre-allocated
requests. This is not the most efficient approach but should not trigger
a deadlock.

Thanks,

Bart.
