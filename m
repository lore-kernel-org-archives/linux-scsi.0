Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8ABC1B08C
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 16:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B096261407
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 16:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhGORAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jul 2021 13:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhGORAO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jul 2021 13:00:14 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7874BC06175F
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jul 2021 09:57:20 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id f30so4500102lfv.10
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jul 2021 09:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MB8W6m9B5P2EnwCxyCHWzrTZ39gMLLaGpWhx2Uve/6w=;
        b=AGrKlx9oPgyQjrmJgzTs3H4nyPif5OZHHeroeQ8YuhkTdVu9HPQr7vclVxBOc4J0T2
         kucCaHmm2K1yrKFbjtz8cUitlGa0CXH80wj6PyWrc1jb3DW3uPqm4cFwZE8/HGJBypfc
         dz/pL8j1BeXoR8o1DiWX13G5NU6mg/sl6iF7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MB8W6m9B5P2EnwCxyCHWzrTZ39gMLLaGpWhx2Uve/6w=;
        b=PFtekApH6fLd+GpbYf2r3ncmtmLrBnKHjJ+OYP04qAb5wH1XRe9Zo0m2YoP/LmOhgH
         tH6DqhozdqoupKYkbxNTRt5XV3X4vooJisx7Q2ZOSlHXO142jqreB53anmE2FSRKNds6
         h/q9yDEw53RF1aCYIFHCPBeZKaNpJ6pyxch51S57QmOvsJ2u2PIFS+WxugjR/JwNhhma
         fEFae7h92gjDG9LWAx5JwvHr5rr/IrJBavg+aXzOnAhB490vFUywVBAlxAvIuLvbTngL
         bEwB8g71XVPEBHV7vIXvAK/ycdoIcZzUjDL1w+G4X3xydOkDEAtYUHDA7EhC4I6JMs6R
         keHA==
X-Gm-Message-State: AOAM531w9CC0DHI9iwnULHkQbBpfJB0Wfx7/WIXvwVDofXRxYl9ERuno
        M4xLuqBiRuu4ctXxykLOxFmGMJiqOHTWT4kxZYYBj8nXoauush8V
X-Google-Smtp-Source: ABdhPJzjUgQkdOLKgS8h5rmznw8WyLtqTrpz3izzXtZrx9zqX+46AutlDahT/LyHi7bfJoCdulamesr3eYKgBQ8Zq28=
X-Received: by 2002:ac2:538c:: with SMTP id g12mr684280lfh.245.1626368238594;
 Thu, 15 Jul 2021 09:57:18 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Bunker <brian@purestorage.com>
Date:   Thu, 15 Jul 2021 09:57:07 -0700
Message-ID: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
Subject: [PATCH] scsi: dm-mpath: do not fail paths when the target returns
 ALUA state transition
To:     linux-scsi@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When paths return an ALUA state transition, do not fail those paths.
The expectation is that the transition is short lived until the new
ALUA state is entered. There might not be other paths in an online
state to serve the request which can lead to an unexpected I/O error
on the multipath device.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>
--
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..28948cc481f9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1652,12 +1652,12 @@ static int multipath_end_io(struct dm_target
*ti, struct request *clone,
        if (error && blk_path_error(error)) {
                struct multipath *m = ti->private;

-               if (error == BLK_STS_RESOURCE)
+               if (error == BLK_STS_RESOURCE || error == BLK_STS_AGAIN)
                        r = DM_ENDIO_DELAY_REQUEUE;
                else
                        r = DM_ENDIO_REQUEUE;

-               if (pgpath)
+               if (pgpath && (error != BLK_STS_AGAIN))
                        fail_path(pgpath);

                if (!atomic_read(&m->nr_valid_paths) &&
--

Thanks,
Brian

Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
