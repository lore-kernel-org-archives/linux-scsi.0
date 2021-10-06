Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C1EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 13:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B1F61075
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 13:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhJFN1d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 09:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239017AbhJFN1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 09:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633526724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=REf5XfxKy2/DOMCe3ZbKnMPcGwKfHql13e1o3U4ongw=;
        b=BGS/JmZPyZ9+oB+7WQs7e/klejAQ8bfM4bDsbsE2rIqGW41BSybP74RFocK/FWYxm+RrWY
        xDwpPSTBZrC/X56J83rrO1+U1vAqil0ZLpP+krgJLqff9bOfI3bckYLNSz4OEeGvuatSE0
        An1vSEjziYAZcncrTEw9DUlIIoRhjSQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-o7XY2M16NiGqA9I9HMayvw-1; Wed, 06 Oct 2021 09:25:23 -0400
X-MC-Unique: o7XY2M16NiGqA9I9HMayvw-1
Received: by mail-qt1-f197.google.com with SMTP id n1-20020a05622a11c100b002a749aace38so2286323qtk.4
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=REf5XfxKy2/DOMCe3ZbKnMPcGwKfHql13e1o3U4ongw=;
        b=s9FMdbBQNreafxobAQ9Hhmn+iuoZvRwKn8mzUEq+JDts+tma0TwbjXM+3DkgiVdqzt
         8jnuS49YPe7bDrEr81JJl2Zk2YCobgeZFwrNAZ/WR8Z+yYgWyqru8PuWt5eeF+ghGuHH
         CVmQORaf10eCH0zCxgkI3IDowQ1EmAXQb6hqkqsCYzel25LbA8BoBrd9n2uwfLU0zLWg
         oi9/9YYiTlsZ8cvnGHVOKhUr5vDh8RQL5kJGMZ538tnL5uuTrYKXjVWmYv/B2N0CKS49
         t01O2dD6OqcXdjkYxXSUi83vpRUUIFiG3BCjHyhKzsK5dfH0HZJ5r9M5VEJMXmlqzENJ
         m+fQ==
X-Gm-Message-State: AOAM530iyF0Njwyw3UrPD8Xu61kzlCC4nt7xvrYO/D1aI455sNutnnZm
        pV4pETvQzVHUycW0uB1z1EOsB+sTuBFsEJnY9Sh2YuEzfar8QtDFKnSDzaNjteHTmLVFhl68oB/
        u/su7/LmsP2mQivsQouMZ
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr26967159qtd.382.1633526723439;
        Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+PKn5GM9cvmQAEvw5ba5TX7RO88qJGng/rIUSvV54/GxbODRhQ88kDsUXdjhkd0AFADfwww==
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr26967139qtd.382.1633526723289;
        Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id m11sm11234942qkm.88.2021.10.06.06.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
Date:   Wed, 6 Oct 2021 09:25:22 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 2/4] blk-crypto: rename keyslot-manager files to
 blk-crypto-profile
Message-ID: <YV2jwuFGgSfxS56K@redhat.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
 <20210929163600.52141-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929163600.52141-3-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29 2021 at 12:35P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> In preparation for renaming struct blk_keyslot_manager to struct
> blk_crypto_profile, rename the keyslot-manager.h and keyslot-manager.c
> source files.  Renaming these files separately before making a lot of
> changes to their contents makes it easier for git to understand that
> they were renamed.
> 
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

