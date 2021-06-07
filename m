Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1257EC47094
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 16:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA2C460C40
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 16:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFGQsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 12:48:53 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:39452 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhFGQsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 12:48:52 -0400
Received: by mail-pl1-f176.google.com with SMTP id v11so546011ply.6;
        Mon, 07 Jun 2021 09:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RqM/V5eLWFeMro1faYW6Y0l876M4QVLq21ePu11ZzHo=;
        b=niFZyRnjSZJUNGMlrmksvrbJSipG+ozte98gtTST863mnM4S0pJ/hW/0pn1dS4LBb+
         NthETeqqL6TxjPNijfj/pKrOl0X4Ki7Uwzgbm0VXnql1IUvsWtMtuBqM81cmVJ+klaL0
         Z7QlJHOJleJlYG/nvil5WBkb2rXAsA7ME9A3quqKa6YzgMFuQdyfG54AZ/3HXRpyNV/K
         sjUsVZzeNMvfbnLgmTaez+OaHe/oDjNGc2yldeJfOWT96IYyykYnZlXLYCcYFCOXY9jD
         tNeXbONBQ+7TRTqlVtb4mnicUEoqACg9IEwRxPRPbTDJPTNzqUcUqD92spcwM71E7MfM
         uTeg==
X-Gm-Message-State: AOAM53219joUKd4texRR/6tx74XRqpxBBsqzzWsxnmTNxkbwVU3b+B/R
        MbQzDqwZRvpZkMNWNTFy8LY=
X-Google-Smtp-Source: ABdhPJygdkxD8CUNwO3gYZnjRveMacyt4NUWgX026stBqMkMsRkcnezkILEftsvJah1e8t9mswV/2Q==
X-Received: by 2002:a17:902:145:b029:10d:c0d5:d6ac with SMTP id 63-20020a1709020145b029010dc0d5d6acmr18880586plb.9.1623084420905;
        Mon, 07 Jun 2021 09:47:00 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k13sm8408819pfh.68.2021.06.07.09.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 09:47:00 -0700 (PDT)
Subject: Re: [PATCH v12 1/3] bio: control bio max size
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Changheun Lee <nanich.lee@samsung.com>, damien.lemoal@wdc.com,
        Avri.Altman@wdc.com, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, alim.akhtar@samsung.com,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        cang@codeaurora.org, gregkh@linuxfoundation.org,
        jaegeuk@kernel.org, jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        mj0123.lee@samsung.com, osandov@fb.com, patchwork-bot@kernel.org,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        tj@kernel.org, tom.leiming@gmail.com, woosung2.lee@samsung.com,
        yi.zhang@redhat.com, yt0928.kim@samsung.com
References: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CGME20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74@epcas1p1.samsung.com>
 <20210604073459.29235-1-nanich.lee@samsung.com>
 <63afd2d3-9fa3-9f90-a2b3-37235739f5e2@acm.org>
 <YL2+HeyKVMHsLNe2@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <221377e3-05d1-f250-1ad8-6e5c9485d756@acm.org>
Date:   Mon, 7 Jun 2021 09:46:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YL2+HeyKVMHsLNe2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/6/21 11:35 PM, Christoph Hellwig wrote:
> On Fri, Jun 04, 2021 at 07:52:35AM -0700, Bart Van Assche wrote:
>>  Damien is right. bd_disk can be NULL. From
> 
> bd_disk is initialized in bdev_alloc, so it should never be NULL.
> bi_bdev OTOH is only set afer bio_add_page in various places or not at
> all in case of passthrough bios.  Which is a bit of a mess and I have
> plans to fix it.

Hi Christoph,

Thank you for having shared your plans for how to improve how bi_bdev is
set.

In case you would not yet have had the time to do this, please take a
look at the call trace available on
https://lore.kernel.org/linux-block/20210425043020.30065-1-bvanassche@acm.org/.
That call trace shows how bio_add_pc_page() is called by the SCSI core
before alloc_disk() is called. I think that sending a SCSI command
before alloc_disk() is called is fundamental in the SCSI core because
the SCSI INQUIRY command has to be sent before it is known whether or
not a SCSI LUN represents a disk.

Thanks,

Bart.
