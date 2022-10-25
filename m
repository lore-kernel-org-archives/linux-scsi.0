Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53AEECDFA1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 14:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiJYO0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 10:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiJYO0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 10:26:24 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74E0D73CA
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 07:26:20 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f23so11096804plr.6
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 07:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6inl2xUwbU0DfEDCPMZHsKdvYllmDmyCgz5ky/29DX4=;
        b=KZDeeCxM9aUMHVmWF57+BUh0bmaeVwFv2pQip2mnYstZe6AtBtqcs9W8Vf0KF3gDq1
         WUAXi4XcwIVMdLLV46pQLGicLPWjghk7f2Nm41L6/DfWw+XQlk4AKVE4MutFVWLRm+/n
         zKJKGLilV3NiRTUbBR7eY0dF3sNeR4bgAYa3G/KiqkUQMVlYKd9MaIqsm3sYZHGIrHGn
         lyTRV+Cb0ndmv+D46DzAE7pE1PZ4Ifj1NnaJuXQ8KPqOmrC1G1OVh0Op6f1fpyZYxLZf
         qf+E3g/a//mAb/9dSUJ8BvYL0fuNiif7TRmoGvTs1G7tJp0v6ccWqPD7hJvjXR0Y+4W1
         JhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6inl2xUwbU0DfEDCPMZHsKdvYllmDmyCgz5ky/29DX4=;
        b=rZYrg/H3spDUilLtgBpCMXoieAF6ZvYOr1hQNdRo9bC+6tc82NOBqiK4rvQ+7CZLrD
         hpifgCr0FtZzCF9h1LfC6gFPt3Fa8CjL38MPrizqBlHttbSOf1FRaObiU/NhA+rWVtRh
         N038d1aXrG0rOKFDu2ZcarcfbbVCWIvXc6TfpOUhbAflVT6XGVHO/AnnDMbRi5tcLt/f
         DTxhrGQN0/vU6gbN9cnllAUN96CaaSxyg4CQ11nsaaVc6iqZoM5atgE5GvT7hOiVB6Wk
         qyx+S6vzbD7o3TXTsPVtwVIFHvU5UGWL5APdTNqsegovTi7A4fj4nn9uH302FfnZVy4e
         bZtg==
X-Gm-Message-State: ACrzQf2A5OQzvFL061z/lrJgMS8Io67dtI2diB6+jZYpbTiOd9NkFmtp
        ZlHctlQPS9IN0uptlu53z0iNZw==
X-Google-Smtp-Source: AMsMyM7ay7dDcU7gdgoJax3wbgJfZUZQsW/hxStAj2YCAbwHUi7QDnm7OQ+cno8H/fN6/Ix6ouJpjQ==
X-Received: by 2002:a17:902:c40b:b0:17f:9636:9014 with SMTP id k11-20020a170902c40b00b0017f96369014mr38258126plk.150.1666707979874;
        Tue, 25 Oct 2022 07:26:19 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q15-20020a170902dacf00b0018685257c0dsm1308397plx.58.2022.10.25.07.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 07:26:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
        Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org
In-Reply-To: <20221018135720.670094-1-hch@lst.de>
References: <20221018135720.670094-1-hch@lst.de>
Subject: Re: don't drop the queue reference in blk_mq_destroy_queue
Message-Id: <166670797886.12575.5830280614420890136.b4-ty@kernel.dk>
Date:   Tue, 25 Oct 2022 08:26:18 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 Oct 2022 15:57:16 +0200, Christoph Hellwig wrote:
> currently blk_mq_destroy_queue not only shuts down the queue, but also
> drops a queue references, which leads to the NVMe PCIe/Apple drivers and
> scsi grabbing an extra references. Fix this to help with unifying more
> code between the various NVMe drivers (and to make the code a little saner
> even on it's own).
> 
> Diffstat:
>  block/blk-mq.c            |    4 +---
>  block/bsg-lib.c           |    2 ++
>  drivers/nvme/host/apple.c |    8 --------
>  drivers/nvme/host/core.c  |   10 ++++++++--
>  drivers/nvme/host/pci.c   |    5 -----
>  drivers/scsi/scsi_scan.c  |    1 -
>  drivers/ufs/core/ufshcd.c |    2 ++
>  7 files changed, 13 insertions(+), 19 deletions(-)
> 
> [...]

Applied, thanks!

[1/4] blk-mq: move the call to blk_put_queue out of blk_mq_destroy_queue
      commit: 2b3f056f72e56fa07df69b4705e0b46a6c08e77c
[2/4] scsi: remove an extra queue reference
      commit: dc917c361422388f0d39d3f0dc2bc5a188c01156
[3/4] nvme-pci: remove an extra queue reference
      commit: 7dcebef90d35de13a326f765dd787538880566f9
[4/4] nvme-apple: remove an extra queue reference
      commit: 941f7298c70c7668416e7845fa76eb72c07d966b

Best regards,
-- 
Jens Axboe


