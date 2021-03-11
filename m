Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5F1C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E17864FEB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhCKITx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhCKITs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 03:19:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF27C061574;
        Thu, 11 Mar 2021 00:19:48 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id e7so1402809edu.10;
        Thu, 11 Mar 2021 00:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=JBkeGpB+eWcXhx4gy2dRtgu8ZT120IY/LnQIA5/kUxU=;
        b=Iw1OSl6Zd9Y5xk2PiGCEzlaRQP0Rr45+4k4xnShOmdVQUmLNQP+723QsO7c4Wtcjq7
         lRWcG0/hhJWpJWKLQGEaOZ+mEQVTotQ3zfXtTdHTQTnFfESCU2FjE+s3YNBxQ767hSFy
         ubvBbGVB2zQb8BNkHo7RGn10ftyOxX9wHCtsCWEHXOrCGz9VmXI1iSjZ9FQ5sXPLmY80
         kbiqdLEARHlyHI/1dxvXMI1Yiy5vbMutLFbcXadbzRIAEYyZS++kRt/tIlyAiyMUGhtg
         533oIhHYDVjflcRlbkGdJlq7WLDX4gkYGqonSuXZR1ZhGlpPYZO4JZo0BebEDiIS94DE
         BSCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JBkeGpB+eWcXhx4gy2dRtgu8ZT120IY/LnQIA5/kUxU=;
        b=TdKbU8qBL7ti2dnboYitir/28g/++61ZHiKkSMDt5DvRUB2kdkqrl0/Uwehu/m0g2B
         kgadsQJ7ped5lTmOnyo9hfglMGmDd1R6l6OMXIWhRASa7syep2FQr7UA88F9FgEDyNLE
         eDof57u6L0v8xqToz6HKOONqW4YCpf+ybYBhKedUdnSkAGJxq92c0srlpq9eHvvQDcsw
         KftFb9pnQBjQOCXJ4VZExFvFK/8QAkcw1RaFarfSAFmfJTyTQtClgLHJUy1R7LPdkKGS
         XB6UZbjhqszuEEtZ1ZhwmNy6AaKCQ1PlACufBKP/vTJ2zYEfkVg2y5JkrCudoh+OecOY
         F02g==
X-Gm-Message-State: AOAM5326d2CHu2eYPOEiNmdg1uRKtyDwR4pFpz7ZgredFnRjwMB7eUz+
        VnlR63U8gfiGEg0hBdCYdKw=
X-Google-Smtp-Source: ABdhPJxRzXMdhHiC/RZkQxL6XEJN1B9PML6IDoY4fU0PNAfFkn2+xN+i2I9q7lWGwQlGLPTML4qsSQ==
X-Received: by 2002:a05:6402:1c98:: with SMTP id cy24mr7321315edb.296.1615450787250;
        Thu, 11 Mar 2021 00:19:47 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id oy8sm874331ejb.58.2021.03.11.00.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:19:46 -0800 (PST)
Message-ID: <3a5c555cb69ee24f56e986097ebf2a212dd017f8.camel@gmail.com>
Subject: Re: v3: scsi: ufshcd: use a macro for UFS versions
From:   Bean Huo <huobean@gmail.com>
To:     Caleb Connolly <caleb@connolly.tech>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, ejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, beanhuo@micron.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 11 Mar 2021 09:19:45 +0100
In-Reply-To: <20210310153215.371227-1-caleb@connolly.tech>
References: <20210310153215.371227-1-caleb@connolly.tech>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-03-10 at 15:33 +0000, Caleb Connolly wrote:
> When using a device with UFS > 2.1 the error "invalid UFS version" is
> misleadingly printed. There was a patch for this almost a year
> ago to which this solution was suggested.
> 
> This series replaces the use of the growing UFSHCI_VERSION_xy macros
> with
> an inline function to encode a major and minor version into the
> scheme
> used on devices, that being:
> 
>         (major << 8) + (minor << 4)
> 
> I dealt with the different encoding used for UFS 1.x by converting it
> to match the newer versions in ufshcd_get_ufs_version(). That means
> it's
> possible to use comparisons for version checks, e.g.
> 
>         if (hba->ufs_version < ufshci_version(3, 0))
>                 ...
> 
> I've also dropped the "invalid UFS version" check entirely as it
> seems to
> be more misleading than useful, and hasn't been accurate for a long
> time.
> 
> This has been tested on a device with UFS 3.0 and a device with UFS
> 2.1,
> however I don't own any older devices to test with.
> 
>         Caleb
> ---
> Changes since v1:
>  * Switch from macro to static inline function
>  * Address Christoph's formatting comments
>  * Add Nitin's signoff on patch 3 ("scsi: ufshcd: remove version
> check")
> Resend:
>  * Fix patches 1/3 referencing the macro from v1
>    instead of the new inline function
> Changes since v2:
>  * Remove excessive parentheses from ufshci_version()
>  * Pick up Christoph's Reviewed-by
> 
> Caleb Connolly (3):
>       scsi: ufshcd: use a function to calculate versions
>       scsi: ufs: qcom: use ufshci_version function
>       scsi: ufshcd: remove version check
> 
>  drivers/scsi/ufs/ufs-qcom.c |  4 +--
>  drivers/scsi/ufs/ufshcd.c   | 66 ++++++++++++++++++-----------------
> ----------
>  drivers/scsi/ufs/ufshci.h   | 17 +++++++-----
>  3 files changed, 38 insertions(+), 49 deletions(-)
> 
> 
Thanks for your patch, good look to me.

Reviewed-by: Bean Huo <beanhuo@micron.com>

