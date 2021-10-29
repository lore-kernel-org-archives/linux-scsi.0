Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AA2C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 16:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 066C561183
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 16:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhJ2QMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 12:12:40 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:42778 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhJ2QMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 12:12:40 -0400
Received: by mail-pj1-f41.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso7715627pjb.1;
        Fri, 29 Oct 2021 09:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LXFgbbSzEnPAENQgnYsk5t+E8VlLtZz8rFu/S8Y8Msw=;
        b=xCnpSM/JKY2sZcPSU/KMP5cueWZ8IoDz5LKhFTuJYJlWd4K1+2iAa5O5ELDUfPR6KK
         BhQyAoym5Sh85riTXy3v90YZpadrnnR+6bPtoRcP6/tEjklmEdSZGTRjknSE1+YsiZj7
         MuvOZTd6HV822KGlyeIulpS2EzP1jabX8TwqcQKmfZ5Inh6msGWCInk9F18Zp6Cr34+T
         0OIy4+43yNfw2+L4h742x+T1Nij4XBwzUMZvFqTKeLiTozPCrEcyA3HagszuXKhrCLJ0
         2TI9QqW/5k7Q1vaoTXDKfolaCtbf79jtlSI4nd6tpW8BZCYgimc+8sSeqvvJ9vrJ+gU8
         Z6nA==
X-Gm-Message-State: AOAM532PDC9f+AyzRXu8nHJgg3GxhY4Q8jqmU7zhVBDg8MkXyORxWV+U
        6Cecc2/kfzrYyR4FAWfJd1s=
X-Google-Smtp-Source: ABdhPJyyZjQUsQT53x9DYF/g/qm71X4lEhv4Xwoz5oC82TaIBLk6Z20x3UIz6rQPP6y9gYWHRe6M2A==
X-Received: by 2002:a17:90b:1010:: with SMTP id gm16mr20398839pjb.190.1635523811491;
        Fri, 29 Oct 2021 09:10:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7346:8d3b:12d0:7278])
        by smtp.gmail.com with ESMTPSA id rj6sm11542165pjb.30.2021.10.29.09.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 09:10:10 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20211029155754.3287-1-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <52dbffa7-6549-1f1d-cc2d-9022e65b59a9@acm.org>
Date:   Fri, 29 Oct 2021 09:10:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211029155754.3287-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/21 8:57 AM, Avri Altman wrote:
> HPB allows its read commands to carry the physical addresses along with
> the LBAs, thus allowing less internal L2P-table switches in the device.
> HPB1.0 allowed a single LBA, while HPB2.0 increases this capacity up to
> 255 blocks.
> 
> Carrying more than a single record, the read operation is no longer
> purly of type "read" per-se, but some sort of a "hybrid" command -
   ^^^^^
   purely?
> writing the physical address to the device and reading the required
> payload.
> 
> The HPB JEDEC spec came-up with a dual-command for that operation:
> HPB-WRITE-BUFFER (0x2) to write the physical addresses to device, and
> HPB-READ to read the payload.
> 
> Alas, the current HPB driver design - a single-scsi-LLD-module, has no
> other alternative but to spawn the READ10 command into 2 commands:
> HPB-WRITE-BUFFER and HPB-READ.
> This causes a grat deal of aggrevation to the block layer guys, up to a
> point, in which that they were willing to revert the entire HPB driver,
> regardless of the huge amount of corporate effort already inversted in
> it.
> 
> Therefore, remove the pre-req API for now, as a matter of urgency to get
> it done before the closing of the merge window.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
