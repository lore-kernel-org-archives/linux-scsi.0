Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBE5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 16:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466CA604DA
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 16:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhKEQQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 12:16:38 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:46059 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbhKEQQh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 12:16:37 -0400
Received: by mail-pj1-f51.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so3714084pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 05 Nov 2021 09:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pk/sTsn4PRcqA/p5HMy/dJTgSIF7zF7cTDPdrPyvfQw=;
        b=HC39vMbnyCldnDiELQ4j8DO0x7L2WgrPO1elsvFqnHz8NZMktSAeqWA4i4xMPL6Cqo
         ZM0xGAoH9Cyi5zsnFdHtAEkRp5HI1YBpr2Y3QDVqEt28ojJmCk78Sv16Pxg1ZxXx3/C+
         /MuwJJnuN34kKvutSOpMiLQE3aXJyoiCAyxaUhTi8Qu3Xmj7Zqw1Xnta2+J/cVqVLlUZ
         xK2QPq2iULpLcw/A+7XfitWnnE0Epjgt3Agkab5V4DVmQgVUxp0OwzxD/l37+L2CrKee
         QIPmkr05Yd61cd1sF7pZOJi8Uq6WAABdZGECICBM/rK5SefiFiU4BQ9DX0UgKIhfrkVR
         Kf3w==
X-Gm-Message-State: AOAM5316IAdcOrx+O5m7QmubNMNoC24Lv/7oKWc8Go41hlk+BD9C1Qa7
        69zJmymMDRq/ckX7nJQk46ux2M7mq+82RQ==
X-Google-Smtp-Source: ABdhPJzWiyC/dt99xDZMwWk/HcJW+q+odJH89ZZ27UIWGDaY3eyb7E3L2mFwPZEw3O7QVJkl79pWUQ==
X-Received: by 2002:a17:902:7616:b0:13f:354a:114f with SMTP id k22-20020a170902761600b0013f354a114fmr53561679pll.8.1636128836610;
        Fri, 05 Nov 2021 09:13:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ba5f:cd4e:95d7:bb41])
        by smtp.gmail.com with ESMTPSA id z10sm6748427pfe.92.2021.11.05.09.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 09:13:56 -0700 (PDT)
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
 <20211012144906.790579d0@songyl>
 <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
 <20211013065012.02b76336@songyl>
 <9d9d2f95-7782-85a7-b79a-ce481292c451@acm.org>
 <20211020003323.61323f67@songyl>
 <1abeda89-d7cf-9164-d8a1-3c764fd870a4@acm.org>
 <20211105130203.196c6293@songyl>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bec25e84-7c10-a97c-5adb-cdbc75888d63@acm.org>
Date:   Fri, 5 Nov 2021 09:13:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211105130203.196c6293@songyl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/21 6:02 AM, Yanling Song wrote:
> We've studied BSG and in general it can work.
> 
> The following is our draft design, please give your comments:
> 1. Applications from user space send commands to driver thru struct
> sg_io_v4, the private data(used by driver) is saved in sg_io_v4->request
> and the data length is saved in sg_io_v4->request_len.
> 
> 2. SG_IO is used in bsg_ioctl(), the following has to be set because
> bsg_transport_check_proto() will check the fields:
>      sg_io_v4->protocol = BSG_PROTOCOL_SCSI;
>      sg_io_v4->subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;
> 
> Does the above match the BSG design?

I think so. Sample user space code that submits to a BSG interface is
available e.g. here:
https://github.com/westerndigitalcorporation/ufs-utils/blob/dev/scsi_bsg_util.c

> And one question:
> The number of queue and queue depth are hardcoded in bsg_setup_queue().
>         set->nr_hw_queues = 1;
>         set->queue_depth = 128;
> 
> Any reason to do it? how about it does not match the chip's capability?
> for example, the chip supports 8 hardware queues and each queue depth
> is 4096?

Will BSG commands be processed internally by the spraid driver or will these
be sent to the hardware queues?

If there is a need in the spraid driver for concurrent processing of BSG
commands, feel free to make nr_hw_queues and/or queue_depth configurable.
I recommend to do this by introducing a new structure (bsg_creation_params?)
and by passing a pointer to that data structure to bsg_setup_queue().

Thanks,

Bart.
