Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A93C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 07:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7780207ED
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 07:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="IdnhLORW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgFJHg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 03:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgFJHg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 03:36:28 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086F1C03E96B
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2020 00:36:27 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l12so1397135ejn.10
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2020 00:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jojkXZlPGe32eOB8MJ8XE0pvLkHExoHHXpIUndojxgw=;
        b=IdnhLORWXj9oFU+Y3j3LmgfkG1100EGPE3TWZ905xuCyWxHX6yjbAtGOUcPV34JpXv
         QnTnNySdckcTz74hVr0WskrgifQvbqxXG5V+Jib1kncl27JBUS44+lIbe4d05sza0oeK
         QnwCQbCl5dnD35coizB5Y7KCcvPDwbyi27Uzw3DLFSaDwo3Le1W9m49OfjV7qsOIKgRj
         xWWrzSIULwSnd/XeI+m6rKi3EzYjhVspTlyswytscpyzH6WS9lgL4AR5MAmBLLksh+LZ
         HstFux7xKUO4QpS2UVwOFrcvLppVqhowjhfbhYoN6Z4bFaZ7LfJ827JmTSilr9eF5CN/
         DuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jojkXZlPGe32eOB8MJ8XE0pvLkHExoHHXpIUndojxgw=;
        b=Bi32AD07U8ucP0aMqLD/1Uk22pZbPN/M9s6krFEo/NOypYhRwUebdDJf/+NCnaDEb4
         XRsTRmJ02zcwTnnkG7p9HsMgl5RxN0HR2UKP45mJrILnjTot+BucP6ry+V0M6ssRP443
         nVDjSBUFT5bXHvnPNU9JO6ye4+HKQScCB9BXmJM7N9c2OtJzAjFD2rwVK7HAexFSpzgK
         uEIqmYNzzJ8aV1M9SEakQC8Ne/UmcZKfhKN3HOm2RYZZxxWriIR5XwCg5gxQNcKaCre4
         y/t1jLamwHUVPNPgARbgWGTM5JV5XEpNbxRFvHxXBWTNYySNkj45/VkWmfmS61EtvdPV
         Is+w==
X-Gm-Message-State: AOAM530Eal1qo24hBGaybkb1aiRBQUsnl7GSmq91Ejr5NDonwSeChGVd
        hSSBcV3kHtzWauQvpCZSlN1lncIeCFRn+zkVYUONjQ==
X-Google-Smtp-Source: ABdhPJy3J87ecWPgKV8F4KtPSgenUMiZsgvD6/ULieyOIFpzQX3AQ1UxquuVMSsYlwoPS1Y+nogP1xIiSOBxIr11THA=
X-Received: by 2002:a17:906:5c0a:: with SMTP id e10mr2159963ejq.389.1591774586538;
 Wed, 10 Jun 2020 00:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200610064540.269738-1-hch@lst.de>
In-Reply-To: <20200610064540.269738-1-hch@lst.de>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 10 Jun 2020 09:36:15 +0200
Message-ID: <CAMGffEmi+42C69oEj2frN1Xn81F-xeRrBxQaLmSeTFGdP-B1+g@mail.gmail.com>
Subject: Re: [PATCH] scsi: wire up ata_scsi_dma_need_drain for SAS HBA drivers
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>, brking@us.ibm.com,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 10, 2020 at 8:45 AM Christoph Hellwig <hch@lst.de> wrote:
>
> We need ata_scsi_dma_need_drain for all drivers wired up to drive ATAPI
> devices through libata.  That also includes the SAS HBA drivers in
> addition to native libata HBA drivers.
>
> Fixes: cc97923a5bcc ("block: move dma drain handling to scsi")
> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Michael Ellerman <mpe@ellerman.id.au>
For pm8001, looks good to me!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
