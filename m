Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29501C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 18:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiBPSp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 13:45:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiBPSp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 13:45:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6FD923A189
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 10:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645037113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OOx+E3QllfryzTFmIymhQ3ST1693x2OfbOWkWxjfBfw=;
        b=YqPApfl37RisavXJpflcyGe9RbK1q5lmGjYLRfIYqYp5+jWlpD6Ga6LUdh3P5aCZywpNwy
        +c7oYfZHi2kkJwSKIEKmHJZzlhdawCBwgktBy3WxU0fqCHAzct1HmHPkOAsDoKMyjAjtf+
        het1sBJPo/fnfpZriFYejkzbYmo+FnI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-GDx7UajBOhaA0jk-7z_NHg-1; Wed, 16 Feb 2022 13:45:11 -0500
X-MC-Unique: GDx7UajBOhaA0jk-7z_NHg-1
Received: by mail-qk1-f198.google.com with SMTP id u12-20020a05620a0c4c00b00475a9324977so1938334qki.13
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 10:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OOx+E3QllfryzTFmIymhQ3ST1693x2OfbOWkWxjfBfw=;
        b=sRB64Riy9k56s2dNz3F4ftiXribo+qQtbyx2vI9UGYVVe24BtKmIlxtmyYzEVJiDxG
         MYXUVxp+80q1sr5r04fYgqx1pTTdK/K8NuMpGgBVWExpjFLwO0x4bQjP+euIh6Y45Gss
         ggKKuLAnPf/H+4eoBz2YVDvd1Wc7QsA7OqRKG/YYM1+VryKwBDPwcWn/y1qrtn9k7AHR
         jq9XyJ/RygAGQWU8hgDDY1gHMcMT6pJqCb+4/yOn3UFGT1YAjZNL2QSikMm7tGSMIBas
         ZPl5XOMYNXnLFxdn6Ztj0CVNq74MCpG+L+pMLWAOQGcjors6pGY1zLbNldPBr4LCPS43
         55mw==
X-Gm-Message-State: AOAM532vePLkkWcD56E9dkXSxtQaMEqJLpzF779jwZWsEoI1Umagffe9
        1EPApcjDMeIWdN6M9a8BXJczGTLxm/V1rodQtqp+7p9H8I6SGKIsJmwhnc5QwJaZSzZrYFPgfNa
        M+ir7ecCP44lyMc2pTBoj
X-Received: by 2002:a05:6214:21ed:b0:42c:11d1:70cd with SMTP id p13-20020a05621421ed00b0042c11d170cdmr2797944qvj.115.1645037110077;
        Wed, 16 Feb 2022 10:45:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJgOjhzSS8RxxVMNtzc6xG6mkVlUt//oPzsjAQ7SdjdxSfis7RMELX8WfonQ2JnnKXjLlDqw==
X-Received: by 2002:a05:6214:21ed:b0:42c:11d1:70cd with SMTP id p13-20020a05621421ed00b0042c11d170cdmr2797925qvj.115.1645037109867;
        Wed, 16 Feb 2022 10:45:09 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id i4sm20421081qkn.13.2022.02.16.10.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 10:45:09 -0800 (PST)
Date:   Wed, 16 Feb 2022 13:45:08 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        target-devel@vger.kernel.org, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com,
        dm-devel@redhat.com
Subject: Re: [PATCH 6/7] dm: remove write same support
Message-ID: <Yg1GNMD6jIrKOxBE@redhat.com>
References: <20220209082828.2629273-1-hch@lst.de>
 <20220209082828.2629273-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209082828.2629273-7-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 09 2022 at  3:28P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> There are no more end-users of REQ_OP_WRITE_SAME left, so we can start
> deleting it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

