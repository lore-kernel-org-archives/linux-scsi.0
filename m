Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D993BC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F02961220
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhDTDSC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:18:02 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:42770 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhDTDR6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 23:17:58 -0400
Received: by mail-pf1-f175.google.com with SMTP id q2so237073pfk.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 20:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t/yGqh/sUzS1o7rmP9UYCrEC+7X4w7yaROxnuHKc8UU=;
        b=DF+sqUSgUm83USZ1RUZWo0bB1Gvmeqc2tAd9RBptnVnCqklgtGF6rNVAsaGxDu0KUh
         mRmw0zRcT5x4LGtlfIymFQz0q/34S2wTtgvrcxpgOhGctgZiWyOr6DDRIMQaWL8Db1iZ
         7crYYKXR4byhGQ3TCaNaPfqEWYJl6Tou23CZZjyzt92BNkodSCQCttjPc+L1a6lvGamz
         Sp+mqo3Ul405kWgX+fTPzQucHL/umlO9KVwIRIAjqxE4+jwkYcEE6aXWlJsZTp8z9G18
         S9lEmo2JJ0fnc+V2n7Y17Igc+mZUDlUUXbWBriav8K1a+uEb+M0l2J2GN7LAC+p8e+1h
         U4lw==
X-Gm-Message-State: AOAM5301dTQpJZW83htoQIrLBwUrdGec61RojoKTxpAjL1EYRUGXzCU3
        CmTE0tU8844PD9sMbiLsq8I=
X-Google-Smtp-Source: ABdhPJxcMESTcW8bby17EFk54GqC5lT5/aF6evwUA+QiS6aesr7/1eSk3QEpcqp/EurmuRYiZ2wgIA==
X-Received: by 2002:a63:f801:: with SMTP id n1mr14745702pgh.231.1618888645205;
        Mon, 19 Apr 2021 20:17:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:3e77:56a4:910b:42a9? ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id l35sm14119363pgm.10.2021.04.19.20.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 20:17:24 -0700 (PDT)
Subject: Re: [PATCH 027/117] advansys: Convert to the scsi_status union
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-28-bvanassche@acm.org>
 <20210420014917.GH2531743@casper.infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <eaa25d23-9d3a-0a0c-b87d-83d62ec5c46a@acm.org>
Date:   Mon, 19 Apr 2021 20:17:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420014917.GH2531743@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 6:49 PM, Matthew Wilcox wrote:
> On Mon, Apr 19, 2021 at 05:07:15PM -0700, Bart Van Assche wrote:
>> An explanation of the purpose of this patch is available in the patch
>> "scsi: Introduce the scsi_status union".
> 
> That is not the correct way to write a changelog.

Thanks for having taken a look. Once there is agreement about the
approach of this patch series I can write a script that replaces the
above text with the description it refers to.

Bart.


