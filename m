Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C68BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 04:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356914AbiBDEKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244712AbiBDEKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 23:10:12 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9148C06173B
        for <linux-scsi@vger.kernel.org>; Thu,  3 Feb 2022 20:10:12 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id v3so4056680pgc.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Feb 2022 20:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=031vYfJ67KHsjX/9TmbLjiWAvFMJ8Ihuhto92XSL3GU=;
        b=d5HzS3o4os9vyUj2bHWhZ6dmr3kj79qQd86P9jzBMgHLv/VsnKbJdjsU/+pF5STOqi
         rUSL9ScVsNvBLl3x29/brDY6XPeACcMceEh5XZFSpgAL2JjyHHkqJUfx8UCt7cnkTBVw
         uN+gBrX5d5WvZBSjC+vJ0cjQ/rWY3MPIAp2b9f7WMI9JeExFFK1nkpI+W9+NGWf7TG60
         bjvXXk6qGgDN90t2v61TFRIc74neIxItjwOkRIZTUYiGOyKwgVkinpFRUr1x65EwzFt+
         gPfRI9camcgpf5Z+AGqfqEFwfPE7Zl5vBSlqXai2rMpQgv//FeLTCi74io1xqTp9Bd6l
         LcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=031vYfJ67KHsjX/9TmbLjiWAvFMJ8Ihuhto92XSL3GU=;
        b=DsKLaDKW1r0PXKJo4/yyhZlenDZOYgWAcP+jU8LymABa0O+RHoKThvalTQB+eO1HuS
         FgnTU5+WOoSe6yx9wtMGL03ZOw87uzHPXTHk4iQn8zBIjNGvgK4keg8yuAJwljC/J8SL
         rInVkNekEgrPw+q3tx1C0WpnpJTweetBsxX9Eq7CSj1VHii34MT9TQ3+GU5+4OViuPMN
         m3MC+3PtWBb11ul/MtwPgc6kGiFoUCiLqfe/oajgbIidP4RzuuEG1/3PBn8L3UWXSz0c
         GLn1iB9MHHgI6ytYSilNCcyp1/jePNsRKrZh7hbv8gjCYGzTrFazSq0KZk4QfMP/REUT
         LrDQ==
X-Gm-Message-State: AOAM530d89K3OW3k2FpKOErr1v9UqXAd+aY9F7lbl7vpoWCeHiFUp4Jp
        J9WrguZUQrN/5rRNGDYORUm37Q==
X-Google-Smtp-Source: ABdhPJwWn5Fh7b5BB/tjapIKj9thHK3apRMJZuQw13zWEBWXj2O8MEtVIAsP5QEEDuaC3CWWnDn1lg==
X-Received: by 2002:aa7:8b13:: with SMTP id f19mr1313733pfd.62.1643947812166;
        Thu, 03 Feb 2022 20:10:12 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j3sm436105pgs.0.2022.02.03.20.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 20:10:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     kernel-team@fb.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hare@suse.de
In-Reply-To: <20220203192827.1370270-1-song@kernel.org>
References: <20220203192827.1370270-1-song@kernel.org>
Subject: Re: [PATCH v2 0/3] block: scsi: introduce and use BLK_STS_OFFLINE
Message-Id: <164394781157.434942.7218899475333931010.b4-ty@kernel.dk>
Date:   Thu, 03 Feb 2022 21:10:11 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Feb 2022 11:28:24 -0800, Song Liu wrote:
> Changes v1 => v2:
> 1. Add patch 2/3 to change user visible return value to -ENODEV. (Hannes)
> 2. In the commit log, explain the reason to keep EIO in 1/3.
> 
> We have a use case where HDDs are regularly power on/off to perserve power.
> When a drive is being removed, we often see errors like
> 
> [...]

Applied, thanks!

[1/3] block: introduce BLK_STS_OFFLINE
      commit: 2651bf680bc2ad9a078b7222b0873145ab4ece07
[2/3] block: return -ENODEV for BLK_STS_OFFLINE
      commit: 7d32c027a21ef7aa0a400763397644d44b3576a9
[3/3] scsi: use BLK_STS_OFFLINE for not fully online devices
      commit: 9574d43479e16352e75bc875c9952ed8e129c9b2

Best regards,
-- 
Jens Axboe


