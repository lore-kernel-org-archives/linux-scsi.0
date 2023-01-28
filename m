Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D791FC27C76
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 03:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjA1D4h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 22:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjA1D4g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 22:56:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96F259E7
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 19:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674878149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uBQfiaGfehrbZhD+dmNA0LfHN/DYYGRL/4Xes3KYST0=;
        b=EBXH8Oepo7cwqG69PHgsqey+cueTjsXpMHdBh4O6HMK8qo1SvJWZcG+JhaONG3rkCkmIpg
        O2yuOmDZ67/tqf77JJ0Olf6Nj1PbDew98qp59+RAlZY0fk/nANMuf/9jPDnRD/GNr7aCf7
        lTK++81qW+FqG7wddyfzzD/8uk9uC4E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-VXaTXZFeM_W_iwyZDUsZ3Q-1; Fri, 27 Jan 2023 22:55:45 -0500
X-MC-Unique: VXaTXZFeM_W_iwyZDUsZ3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2AB929ABA16;
        Sat, 28 Jan 2023 03:55:44 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CE8114171BE;
        Sat, 28 Jan 2023 03:55:36 +0000 (UTC)
Date:   Sat, 28 Jan 2023 11:55:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>, ming.lei@redhat.com
Subject: Re: [PATCH v3 9/9] scsi: ufs: exynos: Select
 CONFIG_BLK_SUB_PAGE_SEGMENTS for lage page sizes
Message-ID: <Y9Scs+S9vOwe0q53@T590>
References: <20230118225447.2809787-1-bvanassche@acm.org>
 <20230118225447.2809787-10-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118225447.2809787-10-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Wed, Jan 18, 2023 at 02:54:47PM -0800, Bart Van Assche wrote:
> Since the maximum segment size supported by the Exynos controller is 4
> KiB, this controller needs CONFIG_BLK_SUB_PAGE_SEGMENTS if the page size
> exceeds 4 KiB.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Kiwoong Kim <kwmad.kim@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/host/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index 4cc2dbd79ed0..376a4039912d 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -117,6 +117,7 @@ config SCSI_UFS_TI_J721E
>  config SCSI_UFS_EXYNOS
>  	tristate "Exynos specific hooks to UFS controller platform driver"
>  	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
> +	select BLK_SUB_PAGE_SEGMENTS if PAGE_SIZE > 4096

I remember that PAGE_SIZE is still 4K on Android kernel, so
UFS_EXYNOS should work just fine, or Android kernel is going
to change PAGE_SIZE?


Thanks,
Ming

