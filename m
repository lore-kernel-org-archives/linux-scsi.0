Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44850C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 17:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbiDMRxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 13:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiDMRxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 13:53:11 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128DD38BF3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 10:50:48 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bu29so4982774lfb.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 10:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=r74y0EwDVmDlpC/kUkPtE7VG7DVXEKM1QwmOEqbKwS0=;
        b=MclBlZJVnfe0f0mcJEdBX+WMA04jn7pmAvarbJ3uHULyR87IvtLf7s1sGDHo7Sfb/S
         T8TheUiHcvkPdluJi7tbPOVTKmCnVlbrARbMXWeUjf6Lmrc5fjjASySd5a1ZAvb4qBvH
         g+Jhpcs6WQ/vAaDxkWNH7jhlZy+h1v4KNWSkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r74y0EwDVmDlpC/kUkPtE7VG7DVXEKM1QwmOEqbKwS0=;
        b=4AwEv45kH1n3gXvpRAwAIluZjhtKUxSe30mFkN2tilcqGRoadh/ErB1YqPCq+WUtbS
         6M8rZqH38VqHTtJ5ATJhyBrKXenvE/u8v/84XUS/nPuC1R6JeA6mELDnHF63y/F1NAJ+
         JZ+nNaV1uJIMBaEgIJYdTJAWLs1Yx5cDrP29laj5tPWhDcLVWf81k93eyEm8EEKFuayB
         ofzf+AdgRaoUJtPqvBH+G5vfwie2dDB5X2Rr2d7k+zdbxsvijKdnUf4CMUB3uAvhyzwy
         p8x6sNQ0K9kvU200s4jq3n2bQ/zt/pTQakfpwcsPnzh8nqIaiZbv3t3EelsAdC0SS6m4
         Fn4A==
X-Gm-Message-State: AOAM530gg7ChRe0uftgEgyQvn7U1ylF4NKzJCfirM7N/7XAiaxQ2t3F9
        CS908YN+UWMv64c0PHG6i4M/IK0CdiTxSwax0m0u4ghfj+/jEIgA
X-Google-Smtp-Source: ABdhPJw06dZBVNUIDQBWGii1MtEgofJKqcwF1+Fxho2xulrNNrU9nvVhU36k0pdsY3uyxyPyjh40brLkZfbI4HV2Bp8=
X-Received: by 2002:a05:6512:1694:b0:448:3fd4:c7a9 with SMTP id
 bu20-20020a056512169400b004483fd4c7a9mr30013864lfb.29.1649872245861; Wed, 13
 Apr 2022 10:50:45 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Bunker <brian@purestorage.com>
Date:   Wed, 13 Apr 2022 10:50:32 -0700
Message-ID: <CAHZQxyKbksT=FrLvtPFyBUzGChsTHaRZ-+R0Uc1oDcedVHLTUg@mail.gmail.com>
Subject: [PATCH 1/1] dm-mpath: do not fail paths on ALUA state transitioning state
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I would like to revisit this patch since it continues to cause fallout
for us. Our best practice has always been to use the setting
no_path_retry of 0 in multipath-tools.This means that our customers
who have a previously working configuration file upgrade into this
problem.

My understanding around why this patch was not accepted the first time
was because some array vendors stay in the ALUA transitioning state
for a very long time. It doesn't seem to me that not failing the paths
leads to a problem since the path checker and priority will protect
against continually using the transioning paths, but I am not aware of
the array vendor that led to this patch in the first place. If this
patch is still not acceptable, can it be made acceptable with a flag
allowing this behavior?

Without this patch we have to reach out to all of our customers who
are at risk and let them know that a change of no_path_retry to some
non zero value is required before they upgrade. There is no good way
to reach them all before this issue is hit and they take an unexpected
outage.

The solution of no_path_retry is not a perfect fit for us either.
There are situations where getting to all paths down and the error
bubbling up as soon as possible is expected. A distinction between the
transitioning state getting there and some other state like
unavailable or standby is not there. The fail path logic is the same.

If the answer is that multipath-tools should handle this, a
distinction in failing the path should be made to allow the
multipath-tools to queue on transitioning but fail on other states to
be able to retain the previous behavior without either regression
mentioned above.

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
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
