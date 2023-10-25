Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036A5C0032E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 19:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbjJYTBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 15:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbjJYTBm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 15:01:42 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A966123;
        Wed, 25 Oct 2023 12:01:40 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6b26a3163acso48997b3a.2;
        Wed, 25 Oct 2023 12:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698260499; x=1698865299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qkv7a3pDgozHMnmOnvztZwN0UTli4vw9TVWixiS7Nr8=;
        b=wzxJrb/68d82vuefh99iAuITPfDrEbDULmzGYLbaiEWO9nwEjPblJalatjcsOnuoJN
         MfnAg0oMXJOPBFrlJse91wSG+SUkPazEFiOXx/W03qhKi3rGdLs+VxfpYzFhW1qTbKs3
         Rz3NbaAxl9G7N/2qckcXzSIC+TYarli+gpZ14J8Jtm1AMMvnWyheCuvDzvHAcPrKeP1V
         xd5YduB/WMxZ6g4KoYcBtfj8XXsObjvTnn0CP/fWeuqNhOCSOfNDod6BJV7w/BnZxPK2
         KjTX05fobm/xuEC1cQ3KPrqMBRqw02qtBqyR6DF1TlBIsQND1e2Ng476YJbSHI+mnjsM
         rhFg==
X-Gm-Message-State: AOJu0YzGOSlyHHZD2A3TIlfjO0YMoMOPAiCObpFU2seTEuPXEC08Qd5o
        kXB7ajusBZC3MUJ4rFWClAaMrnVvHXA=
X-Google-Smtp-Source: AGHT+IGQrwVha/CsxcgBmuKw0q5WUAmKtg4HAiqyl7vaTYxGEmZOM4WwTawF7/+6O5pow4qTlKeZ6A==
X-Received: by 2002:a05:6a00:234c:b0:6b5:ec98:4289 with SMTP id j12-20020a056a00234c00b006b5ec984289mr14476806pfj.14.1698260499425;
        Wed, 25 Oct 2023 12:01:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:4dcf:e974:e319:6ce8? ([2620:15c:211:201:4dcf:e974:e319:6ce8])
        by smtp.gmail.com with ESMTPSA id v123-20020a626181000000b00693411c6c3csm10151786pfb.39.2023.10.25.12.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 12:01:36 -0700 (PDT)
Message-ID: <faf6f9e4-e1fe-4934-8fdf-84383f51e740@acm.org>
Date:   Wed, 25 Oct 2023 12:01:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora> <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
 <ZThwdPaeAFmhp58L@fedora>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZThwdPaeAFmhp58L@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 10/24/23 18:33, Ming Lei wrote:
> Yeah, performance does drop when queue depth is cut to half if queue
> depth is low enough.
> 
> However, it isn't enough to just test perf over one LUN, what is the
> perf effect when running IOs over the 2 or 5 data LUNs
> concurrently?

I think that the results I shared are sufficient because these show the
worst possible performance impact of fair tag sharing (two active
logical units and much more activity on one logical unit than on the
other).

> SATA should have similar issue too, and I think the improvement may 
> be more generic to bypass fair tag sharing in case of low queue depth
> (such as < 32) if turns out the fair tag sharing doesn't work well in
> case low queue depth.
> 
> Also the 'fairness' could be enhanced dynamically by scsi LUN's
> queue depth, which can be adjusted dynamically.

Most SATA devices are hard disks. Hard disk IOPS are constrained by the
speed with which the head of a hard disk can move. That speed hasn't
changed much during the past 40 years. I'm not sure that hard disks are
impacted as much as SSD devices by fair tag sharing.

Any algorithm that is more complicated than what I posted probably would
have a negative performance impact on storage devices that use NAND
technology, e.g. UFS devices. So I prefer to proceed with this patch
series and solve any issues with ATA devices separately. Once this patch
series has been merged, it could be used as a basis for a solution for
ATA devices. A solution for ATA devices does not have to be implemented
in the block layer core - it could e.g. be implemented in the ATA subsystem.

Thanks,

Bart.
