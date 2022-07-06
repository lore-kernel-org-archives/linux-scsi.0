Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4D0CCA480
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 12:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbiGFMeo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 08:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiGFMen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 08:34:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7F515A1A
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 05:34:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id w24so15123740pjg.5
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2022 05:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=hW2431492sCVZamN/p5cUoH7v2KxbwYiYFtMhbuxSSs=;
        b=aO/ZC+U5LATGWzsMenvtODpWhcejLQ4DmRLha/4SFn11Wf8DcIrFk1B5B3fP0AvXUg
         F1PUOqzt04jGHL+kW42wdhfxoatgfieaCaFTjTsg/0aPS0d1NSqzbVAWUr48FwKbi2kk
         bNQBektjLeeE1K2U1dLcbw68C5O909m3ltoYOt5psp5Gsf6ooUgQxbp7vtkJxaFCNVLq
         JB5JDSboVX7gNuCr6BqOEB2T1vnXsuL9FxkeVt6f0+RSoxgWygebchQshMWMnbZdv7Xg
         QtsTjaAJP4QGjnj40SClqvGtAh7oHGQx9EV2mY92w7wDa5vthlOb4om9GVvEhy9g8Ujc
         ZNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=hW2431492sCVZamN/p5cUoH7v2KxbwYiYFtMhbuxSSs=;
        b=ayCzlogt7CIhbOeWDVTgm4KmouQX8YUPkOfg9GwRdySEyRtaxC75rvkUmSAzOPIYfz
         TKBFk0LKTyc8UbvIj55UwDJ5AmzMSCxe41j86Vp4uxEQbsVLH3kUSKhhJAg3eLMF099z
         yVo/9lMGzwGT2ulW6F+AiCSxObjr0o78so9bW9vy0hKRaDzWjvSQSxrh+MJ+VUsncLhl
         kaVc0PePRNhwOD1MPdWJW5QsG6ZiFtqpMid4HFuRpcNb+QRaiXt69Ir2Uyp1KmdzvljZ
         sIwBAgiX65nndehB3xy9Czffn6yW6c2nsbGECsvs973EeWxn5/sY8fd4HbKVF0lb7dOM
         W5Xg==
X-Gm-Message-State: AJIora/+kG5obvvLKhvKgLJG224zFmPgTpYvcjhLJAK79fAl7AAMZRR1
        +8X4jsV7B9WSwDceGNBThZLRng==
X-Google-Smtp-Source: AGRyM1szJSqnPFX6luEMhyzzQ0Aeywhddc3vVY3+ZKqUe4ppobSQfJg1kQYfqyNYWH89tB/Ll0NihQ==
X-Received: by 2002:a17:902:ab42:b0:16c:66d:c44d with SMTP id ij2-20020a170902ab4200b0016c066dc44dmr1314197plb.125.1657110880402;
        Wed, 06 Jul 2022 05:34:40 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 84-20020a621957000000b005289cade5b0sm2634560pfz.124.2022.07.06.05.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 05:34:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     jejb@linux.ibm.com, hare@suse.de, kartilak@cisco.com,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        satishkh@cisco.com, sebaddel@cisco.com,
        damien.lemoal@opensource.wdc.com, john.garry@huawei.com,
        bvanassche@acm.org
Cc:     linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-block@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1657109034-206040-1-git-send-email-john.garry@huawei.com>
References: <1657109034-206040-1-git-send-email-john.garry@huawei.com>
Subject: Re: [PATCH v3 0/6] blk-mq: Add a flag for reserved requests series
Message-Id: <165711087866.291548.18135186803736478100.b4-ty@kernel.dk>
Date:   Wed, 06 Jul 2022 06:34:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Jul 2022 20:03:48 +0800, John Garry wrote:
> Can you please consider this series? Thanks
> 

Applied, thanks!

[1/6] scsi: core: Remove reserved request time-out handling
      commit: deef1be18e3fc62ddf04fb3e5e8ff6a301693dcc
[2/6] blk-mq: Add a flag for reserved requests
      commit: 99e48cd6855e9535488e3c90d65edd46c6e6fc1b
[3/6] blk-mq: Drop blk_mq_ops.timeout 'reserved' arg
      commit: 9bdb4833dd399cbff82cc20893f52bdec66a9eca
[4/6] scsi: fnic: Drop reserved request handling
      commit: 1263c1929fb8c375494666ec6d1bac838ff02c25
[5/6] blk-mq: Drop 'reserved' arg of busy_tag_iter_fn
      commit: 2dd6532e9591f201e7571b30915db807603ab924
[6/6] blk-mq: Drop local variable for reserved tag
      commit: 4cf6e6c0106bf6e6d034fa6043b4428ac2f267fc

Best regards,
-- 
Jens Axboe


