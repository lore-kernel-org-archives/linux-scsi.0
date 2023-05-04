Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEA4C7EE22
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 20:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjEDUpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 16:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjEDUpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 16:45:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C73156A1
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 13:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683232905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9W1Zsoz6z+YP+cxJPViag88+eoCge/nILvYxACPZGtQ=;
        b=Dqh6I4kh3Q8cN/F8706uipH1J94iYlhnRLyPWq4pKP33uApcLRgKshCEtR06t8+kUoP86y
        vZmIwUi36l85Wpc7wFklTHIfl3D7qwmnIYE0eUbJHzk8kmrZ6yty/MCXD3fzmoh7E1nV5e
        Q302BoVrU35mHDGUjoc4k3EYi/uD2hg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-2x0AigkQMr-UQHSy4Sjf9w-1; Thu, 04 May 2023 16:41:44 -0400
X-MC-Unique: 2x0AigkQMr-UQHSy4Sjf9w-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3ef6decfabeso5758321cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2023 13:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683232903; x=1685824903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9W1Zsoz6z+YP+cxJPViag88+eoCge/nILvYxACPZGtQ=;
        b=gUH5MQJsKuUAyvWKCXjJefFdxjN+y/UXm2zr+aV34+HaDPzqwwMkcQpF0v527XCoch
         d9oLwpPhXWVmbxmY4ZRbJVxsgdkePENSk3PKSnOw5Acb/DiJcM810PXpSEbEEYLdwneR
         rCZ+E0CAO6PAv5wbQZ3emOMJrZG1pkTz/4SjGkAmxH1CWGxdCQmirM5UX3Q9TP52Dn5v
         xl0PrPkgxjvUnSfTpGuOTFCXOF21XyH8o/PeEUYj4m7QvXvBF+Uc9W5f0J4iTZpi/+0l
         cot4yBJi8fBxiwW35XI6nsQGYuULcSWTI1BvLxV12JPDF2miJRMFv08KbpAiHT8EAguE
         rDZg==
X-Gm-Message-State: AC+VfDwwpjbHJp1LhVHepj5uoda7kKmS23bEtChg2Oi7cTvK2E062gkq
        RP9v/irsk7ibshdiuDogW3ly9LEbNwQiUv5XwRx1h8HsIDryNrzoqqkPt2WevxLxOUzz5XiT2gH
        tVAHpb7a7l8yTxUG4FhYQFw==
X-Received: by 2002:a05:622a:1482:b0:3ef:3fd8:9209 with SMTP id t2-20020a05622a148200b003ef3fd89209mr7860892qtx.48.1683232903716;
        Thu, 04 May 2023 13:41:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5sqBUtFrSM46EgamHSslz3Cly3hy0Rw75yEGIIJQVlsyTywTwm9SVP9oXHM1gIGTBv65ZIbA==
X-Received: by 2002:a05:622a:1482:b0:3ef:3fd8:9209 with SMTP id t2-20020a05622a148200b003ef3fd89209mr7860870qtx.48.1683232903430;
        Thu, 04 May 2023 13:41:43 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id fd9-20020a05622a4d0900b003d65e257f10sm9150872qtb.79.2023.05.04.13.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 13:41:42 -0700 (PDT)
Date:   Thu, 4 May 2023 16:41:40 -0400
From:   Adrien Thierry <athierry@redhat.com>
To:     Stanley Chu <chu.stanley@gmail.com>, peter.wang@mediatek.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: ufs: core: Initialize devfreq
 synchronously"
Message-ID: <ZFQYhHwlc+UnbKWc@fedora>
References: <20230329205426.46393-1-athierry@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329205426.46393-1-athierry@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Wed, Mar 29, 2023 at 04:54:25PM -0400, Adrien Thierry wrote:
> This reverts commit 7dafc3e007918384c8693ff8d70381b5c1e9c247.
> 
> This patch introduced a regression [1] where hba->pwr_info is used
> before being initialized, which could create issues in
> ufshcd_scale_gear(). Revert it until a better solution is found.
> 
> [1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com
> 
> Signed-off-by: Adrien Thierry <athierry@redhat.com>
> ---
>  drivers/ufs/core/ufshcd.c | 47 +++++++++++++--------------------------
>  include/ufs/ufshcd.h      |  1 -
>  2 files changed, 16 insertions(+), 32 deletions(-)
>

I've been working on a fixed version, and realized the original issue [1]
has been fixed by [2]. Thanks to the softdep, whenever the ufs core and
the simple ondemand governor are built as modules, the governor module
will be loaded before the ufs core module. Thus, the ufs core doesn't end
up calling request_module because the governor is already loaded.

So, it looks like there's now no need to submit a fixed version.

[1] https://lore.kernel.org/all/20230217194423.42553-1-athierry@redhat.com/
[2] https://lore.kernel.org/all/20230220140740.14379-1-athierry@redhat.com/

Best,

Adrien

