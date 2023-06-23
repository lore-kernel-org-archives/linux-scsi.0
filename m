Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A74EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 14:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjFWO24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 10:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjFWO2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 10:28:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856162129
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 07:28:54 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-54f85f968a0so113271a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 07:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687530533; x=1690122533;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxvtIP4itcIMy2xBoREx2ZnCs/7fWvEY+3NnP7o1OdA=;
        b=0XkOlQg5GVdfxff7f0/O9y8KglQpCczs3RIHqW0nWmOhMHFKn7xefsYxhI1FLNYkF4
         6w+3uWB3LulDMGQbEAC8cMvn1Uc5VMnorOOoPoHqoacZFbEIeWEcPQeKZ0CivfyV313K
         8kepEOJo4KxsYf7P79KmuimhS2M+M+HGBJ60vYGROlGUaqhWRHQ5Mrcvoc9mOTmwOShx
         JLkfzK7y34wIMBPpQeQqeXz49JXFe58IkXXEQKsqSV6QqBgUNWkJwzm/oVm7p4ViSGTz
         voDlFCQqvPuUSyxpol/bVdtLn1QPeW+KAd8JZoDXfvBmd2TWoyb7riJyMWHojGvqCBoh
         Gpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687530533; x=1690122533;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NxvtIP4itcIMy2xBoREx2ZnCs/7fWvEY+3NnP7o1OdA=;
        b=CZS20kPqcySxh0ikHu93Yt2D+zBDh4QyYRG1kZUyvgy+5haLnOmS7cnOmlVnFX6t8A
         J1u0P6/jq7nvkFuVwpPRfbH+ZGOYPpei7dNgnhYcM81K+DV9/PbImrtfp0O4/2S3sDcE
         1KHamio3vRLVinI5azToWV5D2lg2pEEhdMTRkH6+lDsG6lM1G6H26Dp3x77DeD38ejg+
         01+BbmvueCF0eMKsom3P+PdgzLwULk1+Y+tUWQpVxGXQgTL1cXNIPzyylHcoalI2aG0R
         cXk0PDKYLYjBU7mRtrTmWQ7WDGUBeiEdWgGh1Ed1ufxHtWmFtZZYELcyZC082LzOF7Nw
         5wMw==
X-Gm-Message-State: AC+VfDx+giIyDKMqEHVemPXmt96S0TWj2wgZ/NkFp1IuzddCurIMOsNr
        yo3IsWZXahpA91yaTg67sJPYg2HtRisDLNzpu7w=
X-Google-Smtp-Source: ACHHUZ7ZnlIjEUqcgwFInu1ckuPjUX80QWOQg1dZXZyo2Turs2tAFc3/xeigeQZmV7hBMzDVYkwvfA==
X-Received: by 2002:a17:90b:1bc2:b0:25c:1ad3:a4a1 with SMTP id oa2-20020a17090b1bc200b0025c1ad3a4a1mr25609493pjb.1.1687530533347;
        Fri, 23 Jun 2023 07:28:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090ad58800b00256a4d59bfasm1566198pju.23.2023.06.23.07.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 07:28:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     hch@lst.de, chaitanyak@nvidia.com, shinichiro.kawasaki@wdc.com,
        dgilbert@interlog.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, yukuai3@huawei.com,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com
In-Reply-To: <20230621160111.1433521-1-yukuai1@huaweicloud.com>
References: <20230621160111.1433521-1-yukuai1@huaweicloud.com>
Subject: Re: [PATCH] scsi/sg: don't grab scsi host module reference
Message-Id: <168753053177.470264.9198493732249259434.b4-ty@kernel.dk>
Date:   Fri, 23 Jun 2023 08:28:51 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-d8b83
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Thu, 22 Jun 2023 00:01:11 +0800, Yu Kuai wrote:
> In order to prevent request_queue to be freed before cleaning up
> blktrace debugfs entries, commit db59133e9279 ("scsi: sg: fix blktrace
> debugfs entries leakage") use scsi_device_get(), however,
> scsi_device_get() will also grab scsi module reference and scsi module
> can't be removed.
> 
> It's reported that blktests can't unload scsi_debug after block/001:
> 
> [...]

Applied, thanks!

[1/1] scsi/sg: don't grab scsi host module reference
      commit: fcaa174a9c995cf0af3967e55644a1543ea07e36

Best regards,
-- 
Jens Axboe



