Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4777C55ABD
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 20:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACFF82242E
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 20:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgKNU50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Nov 2020 15:57:26 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43723 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgKNU50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Nov 2020 15:57:26 -0500
Received: by mail-pl1-f194.google.com with SMTP id u2so6193499pls.10;
        Sat, 14 Nov 2020 12:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=16xSpaXhAEOF0N0U9OOB7ZCXwUuMywa2m2HceEa9Iw4=;
        b=tU9OtLBUbtIpY0BAlF9ddBuoAKPE72vMrtV7BHSzoV1E82gfqbtiF8zeX2yVvy9ZVU
         YvS37Im0ley4KITvrhyvGqlmWtTBjLax2xwoB0/vuxuyrVB8SwEHdvPXL2WOcWFYyx/e
         bDl6OoZ6oseH+gvkyRTEDuVATC09CLNAO1Mf29Ew5I/jMKWQQ8lN8jr/IkolRKR8jk1U
         LKBNCdo5yvTYhEQYVP/B9yx3xz+Tk/ACHD26Z8MGqYrCH8Zv/UmY9kUkYtcz4hW54Dar
         moNIYYXnlzoq5x4PV6wnAYwkH3BPYcsUYJberJz0C3PyDUvX9kDFWpip7cubj9hN1JHb
         QfqA==
X-Gm-Message-State: AOAM531AXOidRLFqdTPIhvFOlO2+PNGiPbVN0DWNrAi3nHzIrYrc5uJl
        7ftFIM5q01ljzrka+4XX1m0=
X-Google-Smtp-Source: ABdhPJxN95asfd2nvQMo510YjA+Wku+VpWqlMQg1JxXwovicCEenAsosTW2ocPXCqEjyuH7KN1z7vA==
X-Received: by 2002:a17:90a:7409:: with SMTP id a9mr9219187pjg.48.1605387445013;
        Sat, 14 Nov 2020 12:57:25 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g1sm14268854pjt.40.2020.11.14.12.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 12:57:23 -0800 (PST)
Subject: Re: [PATCH RFC v1 1/1] scsi: pm: Leave runtime resume along if block
 layer PM is enabled
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1605249009-13752-1-git-send-email-cang@codeaurora.org>
 <1605249009-13752-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <97dea590-5f2e-b4e3-ac64-7c346761c523@acm.org>
Date:   Sat, 14 Nov 2020 12:57:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1605249009-13752-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/12/20 10:30 PM, Can Guo wrote:
> If block layer runtime PM is enabled for one SCSI device, then there is
> no need to forcibly change the SCSI device and its request queue's runtime
> PM status to active in scsi_dev_type_resume(), since block layer PM shall
> resume the SCSI device on the demand of bios.

Please change "along" into "alone" in the subject of this patch (if that
is what you meant).

> +	if (scsi_is_sdev_device(dev)) {
> +		struct scsi_device *sdev;
>  
> +		sdev = to_scsi_device(dev);

A minor comment: I think that "struct scsi_device *sdev =
to_scsi_device(dev);" fits on a single line.

> +		 * If block layer runtime PM is enabled for the SCSI device,
> +		 * let block layer PM handle its runtime PM routines.

Please change "its runtime PM routines" into "runtime resume" or
similar. I think that will make the comment more clear.

> +		if (sdev->request_queue->dev)
> +			return err;
> +	}

The 'dev' member only exists in struct request_queue if CONFIG_PM=y so
the above won't compile if CONFIG_PM=n. How about adding a function in
include/linux/blk-pm.h to check whether or not runtime PM has been enabled?

Otherwise this patch looks good to me.

Thanks,

Bart.
