Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96055C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 22:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343726AbiEYWSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 18:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiEYWSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 18:18:06 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047AB674F2
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 15:18:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so20006150pgc.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 15:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=uOobr8g0kT4vEBTgEu41bzRQi+qLtEZA9dzxHh988+w=;
        b=xpDGw8HD+rq0ijZElDdUGvJGAZlpyvFvuENAf0s86Ef94wJeHiSRryth3N/ygc6E7L
         5EbTlAWA2vba+4KQRF0YHYTiOMYpfCE8L2MgOsIZ+w+i7JO5KPkF9xH/YAcXmLPaP1qy
         eQEVgSNsp37uRxguZlUK9MNiE7LoerAZtQ37XcBYz13entkCPWgEagwijO6PNNqKOvJh
         5bm9YGNvIy7wXQ/y81JLv6eS0t7JYb+HoHct/wdceSe1KE2/lnipDp4lcsvCGvwe64zJ
         iGyy7lWhoVTUfy7udPnkAQXCA0uBzZF/jRknEzFU9mqEnFQnJMD/T9ZZ9i97TYy2Tgur
         DZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=uOobr8g0kT4vEBTgEu41bzRQi+qLtEZA9dzxHh988+w=;
        b=GbNenwiiJs5XOjRdL/3/s/ulyUp+5yh6XVzCgUlH4dD1yXhzcNc8ebTJSERpEWr7pR
         hmWydIVw/kts2AkJkzBMy5Lmur+D7z/U6+XLxTXTE5i08zpPCOGwi5NGg49QV+eRzPs3
         ZR+vK1ivdkwnq05Ih42pXWNOqVkPBlPvpw8BnWodd2NAa4QK9eN4FCfDbjpWcs10nOhl
         Xuai3x8G/0queJIYQDBHGgfer+2/EmkwlgeMVduKCltkQgFSXIszgaOJ1TtZ+mCAwMpT
         ZVzdZxCkNpdZ+KUicmrggeIpLdc/lIC6cxGmbg1Mh371XQSMVxlfhBtYQu9VfSZGqF89
         N12A==
X-Gm-Message-State: AOAM530NVbj+HO7GHn3m7YTOGulAWPLQHAwsxCMxTMuNM681ZKnLuU5n
        hwF9L0hGCAEk/gAXW6tGv0vhZw==
X-Google-Smtp-Source: ABdhPJxpuTeIO1Oa9xMYMhqTlBj9aldPGGnhN2rnoNHGuNNCWXN2iKcf2lIwWGTCgnzjOycuK/okqg==
X-Received: by 2002:a63:5565:0:b0:3fa:78b7:55a0 with SMTP id f37-20020a635565000000b003fa78b755a0mr12773469pgm.384.1653517085208;
        Wed, 25 May 2022 15:18:05 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:400::4:38c1])
        by smtp.gmail.com with ESMTPSA id y21-20020a056a001c9500b00518895f0dabsm9109191pfw.59.2022.05.25.15.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 15:18:04 -0700 (PDT)
Date:   Wed, 25 May 2022 15:18:02 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [ANNOUNCE] blktests under new maintainership
Message-ID: <Yo6rGhGdccNJXCe8@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, everyone,

I'm happy to announce that Shin'ichiro Kawasaki is taking over as
maintainer of blktests. I haven't been working in the storage space for
awhile, and I also haven't been very prompt to review or merge patches
lately, so this should hopefully make things easier for everyone.

The GitHub repo will be staying in the same place
(https://github.com/osandov/blktests) for now. The main difference is
that you should now Cc Shin'ichiro instead of me when submitting
patches, and he'll be the one applying them.

Thanks!
Omar Sandoval
