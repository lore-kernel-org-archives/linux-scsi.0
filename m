Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBFDC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 00:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D2F860FE6
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 00:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhHYA5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 20:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhHYA5d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 20:57:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A60C061757
        for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2021 17:56:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so3014175pjw.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2021 17:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hDmA88AGRY/vwa+gGKxIK+/H24lAkykEt+wHqqXlCXE=;
        b=P4GuDJeRVVhudmZI0u/uwgue6Kjrok+r6cIijY3U9m3HnBE9NpbWgsfh6G/s0y1bel
         w5+4yfF06qam48qOwPOPuHVgB6hVfowJEdilUzYcWCCURTL4c+gjpl7LjVM6iktCExmH
         ATetYYtz1VgnAipAKAt3kEcaTm2Gf+4TZDyA2FD98rmswB3KYcu5qz/X0ry9U9eRNGqf
         e3g0dPqKML9WiKGRiPYHS0uxWos7MXJ1eebirZMT2TPiB+SDRM6UWiY2gEy6ac0MmyT0
         +fmFhdtMEg/anpcvZtaCgvWFlozXf/mGGbQ0Qz3oUDIv5EwkfWSNvXbZq8aj8yBq7dKi
         YiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hDmA88AGRY/vwa+gGKxIK+/H24lAkykEt+wHqqXlCXE=;
        b=Nf6XVImUXD/DlqTTs4iyiNh87rDtWl0T+mNacMBxuqj/h1QkCitrU73+5BFYQo94wh
         czK4LOvHYpyzIqHgPA2ivRTM/vf5pH/U1anELIl9HiSmslfxswHyFWRHmjgX2s1LKSh6
         nHuumDjpZgU9uXfKjvk3lV0XRqUQp43WOPg3qo0wFCJnoCW3sRkbKhRFMpqO7K/EpMvR
         p5HlqGphEcpoAuO8NzrUufQcLwv8a3RPOLv3AUM4bOgELY4E18v2+dIETvVbJb/yLEqc
         fKRoWPsohEN7FxNMuK8cjzN3hbyMx3o7vJ+izP9Cl+rQtxoKDE0o7nIpsQSqOfoixS/A
         Nsdg==
X-Gm-Message-State: AOAM532JR9qZsqMx07zyTi4j5NdnhS8yCIg2clYozvm1Ur4ATykkEHJ8
        UnUZtCDOpACq+LLfnajl39wLjA==
X-Google-Smtp-Source: ABdhPJzEbsbxIKFkhGP3ddFUby75YgoJoOMwYM1WFQsZCXKHIZkwkFbGXjDml41unr/U4CBZo1Nv2g==
X-Received: by 2002:a17:90b:1897:: with SMTP id mn23mr7361948pjb.61.1629853008633;
        Tue, 24 Aug 2021 17:56:48 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:400::5:f616])
        by smtp.gmail.com with ESMTPSA id v63sm23428489pgv.59.2021.08.24.17.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:56:48 -0700 (PDT)
Date:   Tue, 24 Aug 2021 17:56:46 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] block/001: wait until device is added
Message-ID: <YSWVTjSYegn/wGX2@relinquished.localdomain>
References: <20210824031753.1397579-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824031753.1397579-1-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 11:17:53AM +0800, Ming Lei wrote:
> Writing to the scan attribute of scsi host is usually one sync scan, but
> devices in this sync scan may be delay added if there is concurrent
> asnyc scan.
> 
> So wait until the device is added in block/001 for avoiding to fail
> the test.
> 
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  tests/block/001 | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/block/001 b/tests/block/001
> index 51ec9d8..01356d0 100755
> --- a/tests/block/001
> +++ b/tests/block/001
> @@ -21,15 +21,20 @@ stress_scsi_debug() {
>  		return
>  	fi
>  
> -	local host target
> +	local host target target_path
>  	for target in "${SCSI_DEBUG_TARGETS[@]}"; do
>  		(
>  		host="${target%%:*}"
>  		scan="${target#*:}"
>  		scan="${scan//:/ }"
> +		target_path="/sys/class/scsi_device/${target}"
>  		while [[ ! -e "$TMPDIR/stop" ]]; do
>  			echo "${scan}" > "/sys/class/scsi_host/host${host}/scan"
> -			echo 1 > "/sys/class/scsi_device/${target}/device/delete"
> +			while [ ! -d ${target_path} ]; do
> +				sleep 0.01;
> +				[[ -e "$TMPDIR/stop" ]] && break
> +			done
> +			[ -d ${target_path} ] && echo 1 > ${target_path}/device/delete

Applied, with the shellcheck errors fixed and simplified logic. Thanks.
