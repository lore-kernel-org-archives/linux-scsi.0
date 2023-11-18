Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACD1C5ACB3
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Nov 2023 16:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjKRQbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Nov 2023 11:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjKRQbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Nov 2023 11:31:03 -0500
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFBEC5;
        Sat, 18 Nov 2023 08:30:59 -0800 (PST)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6d67d32adc2so1775138a34.2;
        Sat, 18 Nov 2023 08:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700325059; x=1700929859;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3WKmew4n4drM5xE4ws+Oy36GEAlyWdGud1pb+cjqvMM=;
        b=DHLvStcWwtFEc0gzM44nQoja06rN8zcZ6uHoV2mn+Ug60dZ6D2Uqsd0qgJIHnNMIdH
         F+zb0yPzbSIz8QLQyc/vD660PfZ8Oxql0S6jqnuL4mjfTI7tKSVs6aj+/Dm8MnJDoipd
         6sJxJQGYxl+ZGMqWqyWQzedGqBSlHooWAfsD6nQkybrdimgY4Z26FR5RXeniAySDv1P7
         E/OW9Uy9+aAXo8xou5BEK4pVUgmC2IxUCFA/0uOwpPNsXSqPCgi8/vVksxI61ke4LZMs
         FTQz7pV/I5Xca4qZC7E2eIsR80BNtL+OznTPOMFjOe9X16ePztuZ9ZReczSLpqpBxD/e
         X3gw==
X-Gm-Message-State: AOJu0YwnErcsmwDcm1qjMZnL4orS4UpLIudB8UhQN077DBvTd2Bua+GC
        4OMmWUnubEgfgacri2VdqXs=
X-Google-Smtp-Source: AGHT+IH5VUZsYo3rViv237HGZ/bVSXqAI8aLO5LUHz7Qi+fbje5OGNg6aphDq2VuZfrT9dqiWunCtQ==
X-Received: by 2002:a05:6830:2099:b0:6b9:a6ef:2709 with SMTP id y25-20020a056830209900b006b9a6ef2709mr2866226otq.8.1700325059037;
        Sat, 18 Nov 2023 08:30:59 -0800 (PST)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id j24-20020a63e758000000b005742092c211sm3121805pgk.64.2023.11.18.08.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Nov 2023 08:30:58 -0800 (PST)
Message-ID: <edfb3eb5-e738-47ed-92c9-2b08511d68d5@acm.org>
Date:   Sat, 18 Nov 2023 08:30:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/34] scsi: use atomic find_bit() API where appropriate
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Matthew Wilcox <willy@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
        Alexey Klimov <klimov.linux@gmail.com>
References: <20231118155105.25678-1-yury.norov@gmail.com>
 <20231118155105.25678-16-yury.norov@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231118155105.25678-16-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/23 07:50, Yury Norov wrote:
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 21 ++++++---------------
>   drivers/scsi/qedi/qedi_main.c   |  9 +--------
>   drivers/scsi/scsi_lib.c         |  5 ++---
>   3 files changed, 9 insertions(+), 26 deletions(-)

One patch for each of the above source files please. mpi3mr and qedi are
both SCSI drivers. scsi_lib.c is a source file from the SCSI core.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index cf3864f72093..4460a37f4864 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2499,9 +2499,8 @@ void scsi_evt_thread(struct work_struct *work)
>   
>   	sdev = container_of(work, struct scsi_device, event_work);
>   
> -	for (evt_type = SDEV_EVT_FIRST; evt_type <= SDEV_EVT_LAST; evt_type++)
> -		if (test_and_clear_bit(evt_type, sdev->pending_events))
> -			sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);
> +	for_each_test_and_clear_bit(evt_type, sdev->pending_events, SDEV_EVT_LAST)
> +		sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);

Hmm ... the original code iterates over the range 1 .. SDEV_EVT_LAST
while the new code iterates over the range 0 .. SDEV_EVT_LAST - 1. 
Please fix this.

Thanks,

Bart.

