Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAE7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 15:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385671AbiEBPNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 11:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352318AbiEBPNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 11:13:00 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2B311A20
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 08:09:30 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id n14so25723580lfu.13
        for <linux-scsi@vger.kernel.org>; Mon, 02 May 2022 08:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=juDxd6VR+YQ02Zm0hzgGxUOZEz69Kzcnmgzu9eTf6nU=;
        b=GySAGDK3VOU9c9wakLFOS62nTy4laYrIyyZSvF+mcWpnDmt2isoHOR2ECi1NUocfLd
         ASW66/WLzU8JEb239iR2+S6yALZ50xA10H1xbHB8499Ip2IEhGSKw7oMZvLH21rBTGyC
         pdZ2NtcVFG5CgFNiDp6MQUg0b8h4MPDf6POk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=juDxd6VR+YQ02Zm0hzgGxUOZEz69Kzcnmgzu9eTf6nU=;
        b=dtSNdnbNdg2knVFwXLkxCF0n1rAuRHvD+jSp3Tq3IJuwg/SEXTDiztogT8fgHutULB
         0/5U5546b2Z+1v6kUyapiXObfiAo9m2SwfcvFpSqlPRp/Imdqw96Z8ARCkqmUq7kIoyu
         TRqHT/cBZfj3bdjn8XkuzqvGj4/ryzJ+UuXZiZeEbQhVEJ8NeRmhpohCopSzPN3C8Hl6
         PJYV+neskT4BXnWMVa3/cbzWpBurvsPOm03v2XFNaslqt8wwWHv/0DuwH5jj4PC9Qt2z
         NQUC0JyXOQiYhlxDzgPcnxxIXOLJC4tflqdYwTCfGeXI4r9jexzY/Y3Loo5fY9ppwBh3
         740Q==
X-Gm-Message-State: AOAM5308SPRY2Kg5svZ6T7a/x78ciLKMzvJfR87Z+KmGn4qc4Rysri37
        CFHe+TqrhYVJ/P73lvDsFhifB3OX8Y4m4qAbD0hmQpjLtMfBeQ==
X-Google-Smtp-Source: ABdhPJwCTTQ9RwSqu/J9v2aOg26k1GMN/B7nftUYaWiI8hT41YTMB2jKOih2foph83RxDBvrVHPjz6ZKIZ9/dkqtVq0=
X-Received: by 2002:ac2:4252:0:b0:472:5e3b:cc44 with SMTP id
 m18-20020ac24252000000b004725e3bcc44mr6401044lfl.414.1651504168649; Mon, 02
 May 2022 08:09:28 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Bunker <brian@purestorage.com>
Date:   Mon, 2 May 2022 08:09:17 -0700
Message-ID: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
Subject: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA transitioning state
To:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The handling of the ALUA transitioning state is currently broken. When
a target goes into this state, it is expected that the target is
allowed to stay in this state for the implicit transition timeout
without a path failure. The handler has this logic, but it gets
skipped currently.

When the target transitions, there is in-flight I/O from the
initiator. The first of these responses from the target will be a unit
attention letting the initiator know that the ALUA state has changed.
The remaining in-flight I/Os, before the initiator finds out that the
portal state has changed, will return not ready, ALUA state is
transitioning. The portal state will change to
SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new I/O
immediately failing the path unexpectedly. The path failure happens in
less than a second instead of the expected successes until the
transition timer is exceeded.

This change allows I/Os to continue while the path is in the ALUA
transitioning state. The handler already takes care of a target that
stays in the transitioning state for too long by changing the state to
ALUA state standby once the transition timeout is exceeded at which
point the path will fail.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>
___
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
b/drivers/scsi/device_handler/scsi_dh_alua.c
index 37d06f993b76..1d9be771f3ee 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1172,9 +1172,8 @@ static blk_status_t alua_prep_fn(struct
scsi_device *sdev, struct request *req)
        case SCSI_ACCESS_STATE_OPTIMAL:
        case SCSI_ACCESS_STATE_ACTIVE:
        case SCSI_ACCESS_STATE_LBA:
-               return BLK_STS_OK;
        case SCSI_ACCESS_STATE_TRANSITIONING:
-               return BLK_STS_AGAIN;
+               return BLK_STS_OK;
        default:
                req->rq_flags |= RQF_QUIET;
                return BLK_STS_IOERR;
-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
