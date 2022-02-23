Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241B3C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 23:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbiBWXEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiBWXEJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 18:04:09 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A0857B1C;
        Wed, 23 Feb 2022 15:03:40 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id p17so122345plo.9;
        Wed, 23 Feb 2022 15:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Kll/TA3LvLyR2Ia3GwEWYV6t2aZaKAHcKgirgnxuZQY=;
        b=S8KCX3IVtetou2PZ3RXbx7aGKO3tGs0dacP87kWJ4dYLnhyuHV1M25T/NFOSx6XeBT
         VclfAHjsBrFuKMBKyn1KAQ8d9oClOzrN4Idko/GKETxf6UG+HMr6kH1ibb1XUIIxU4QE
         FQ3ebACNiX8kOCESEQCnQ0GI23LJP7E8Mcd12DKgjN4MTmS1eJnY831eBHmqTbpQPcrI
         o1ULnQBFx7HHFW5H+xDuozbnoVddnBG3DU82wIOSv16np51A/osWI6CkmaBAScVDA3wR
         RDlH46IVnOc1SxNPZqiXIxsvS50hwqBW8YR2ZmpacDeMw/Yyu6UGQxYqHKivlsuR6uki
         rdbQ==
X-Gm-Message-State: AOAM5328xePbuY6anyPOFLCBplWzaqv7a3BzB+fZazZmqiZb5aXbkVna
        4R3yV3yMhXqWXVP099yQWaw=
X-Google-Smtp-Source: ABdhPJxknOOFARsVmKn+qqtLX0Id9Ys6l8Muy8e0YdtGAnI/YSeUnaGygWnw/8+mJ0E8Z7pKEeURkg==
X-Received: by 2002:a17:902:d4cb:b0:14f:f7b0:cb28 with SMTP id o11-20020a170902d4cb00b0014ff7b0cb28mr58160plg.60.1645657419554;
        Wed, 23 Feb 2022 15:03:39 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g14sm645833pfj.80.2022.02.23.15.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:03:38 -0800 (PST)
Message-ID: <b9e0460c-61ca-957d-00a4-7f695b299d8a@acm.org>
Date:   Wed, 23 Feb 2022 15:03:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in
 scsi_init_command
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-4-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222140443.589882-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:04, Christoph Hellwig wrote:
> Replace the big fat memset that requires saving and restoring various
> fields with just initializing those fields that need initialization.
> 
> All the clearing to 0 ismoved to scsi_prepare_cmd as scsi_ioctl_reset
                           ^
                    missing space?
> alreadly uses kzalloc to allocate a pre-zeroed command.
> 
> This is still conservative and can probably be optimizated further.
                                                  ^^^^^^^^^^^
                                                  optimized?
Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
