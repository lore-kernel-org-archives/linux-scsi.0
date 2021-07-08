Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5522CC07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 20:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D16616E9
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 20:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhGHUpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 16:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhGHUpv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 16:45:51 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7D8C061574
        for <linux-scsi@vger.kernel.org>; Thu,  8 Jul 2021 13:43:08 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u18so9052492lfl.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jul 2021 13:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=fvUEZxos9r3uyMbGQTe8Jua7nmJkSUlsS9MdSywTPhw=;
        b=f0+0DAGORb5YXt00m5CbaxCOk8RNIax6cTjzIXE382v9uFH+acpqDetgn7jjij/uyY
         LJe8dbGDnCJ4ddGUdpcJPTbnLuujjfkDjnQq07aQ96/S/dvt1OSvEJzbJgBwAkKI0Sr9
         e+VWzRfp8bGqSWHW34h/MRoh4gEcNONT/VXI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fvUEZxos9r3uyMbGQTe8Jua7nmJkSUlsS9MdSywTPhw=;
        b=Zttdq8u2HLRwvTdRu43vJGAJ14w/EQ+KvM30f6yC++RrVghAA+SOUHDNgjJPtJtq/0
         xCM7GV1KTJTlRr/WK2B/NJG1TaGYERn1k9WGiCcKuGfASyZHGrJYEbwZt2IoI49CrmvH
         vvW8Ah77hJVC7gWBhqo47tFaGKesX3+Fcb3f9cEB2tY4GwBsVbBCwtdbIvKheTCwEzQx
         P7fKR6uYbepRjQQqb6lp3cgC9BDbvrXU/khrwkNuLlCsf7qSvW4Or5P54S7uALXOf2fZ
         bnKBl4ZUH+OnWb96/+JwzzX0/B90fEqJXOhJ7GXYsty6Za+jsNPQinB7FBzyeMOvimuC
         ew0A==
X-Gm-Message-State: AOAM530Yyjd7hpT5oDYQQdQAIZS2XrYu3asLaDLXvH0waJODY0Y37mWk
        iGz5nPw8D6LOqQ2yEOoq6NILWV6Sd1W6IAciOv3XzXSWH9wnFKjk
X-Google-Smtp-Source: ABdhPJwC+G8QhBFARx1E+pL77uVrExBGiigF5LmnYh58H5PyPYmsGWH1Blv+wsHzY8syQmyPm/1Fgl0f3yKPF6xbZWA=
X-Received: by 2002:ac2:5b1e:: with SMTP id v30mr20703550lfn.226.1625776986435;
 Thu, 08 Jul 2021 13:43:06 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Bunker <brian@purestorage.com>
Date:   Thu, 8 Jul 2021 13:42:55 -0700
Message-ID: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
Subject: [PATCH 1/1]: scsi dm-mpath do not fail paths which are in ALUA state transitioning
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In a controller failover do not fail paths that are transitioning or
an unexpected I/O error will return when accessing a multipath device.

Consider this case, a two controller array with paths coming from a
primary and a secondary controller. During any upgrade there will be a
transition from a secondary to a primary state.

1. In the beginning all paths active / optimized:
3624a9370602220bd9986439b00012c1e dm-12 PURE,FlashArray
size=3.0T features='0' hwhandler='1 alua' wp=rw
`-+- policy='service-time 0' prio=50 status=active
  |- 13:0:0:11 sdch 69:80  active ready running
  |- 14:0:0:11 sdce 69:32  active ready running
  |- 15:0:0:11 sdcf 69:48  active ready running
  |- 1:0:0:11  sdci 69:96  active ready running
  |- 9:0:0:11  sdck 69:128 active ready running
  |- 10:0:0:11 sdcg 69:64  active ready running
  |- 11:0:0:11 sdcd 69:16  active ready running
  `- 12:0:0:11 sdcj 69:112 active ready running

CT0 paths - sdce, sdcf, sdcg, sdcd
CT1 paths - sdch, sdci, sdck, sdcj

2. Run I/O to the multipath device:
[root@init115-15 ~]# /opt/Purity/bin/bb/pureload -m initthreads=32 /dev/dm-12
Thu Jul  8 13:33:47 2021: /opt/Purity/bin/bb/pureload num_cpus = 64
Thu Jul  8 13:33:47 2021: /opt/Purity/bin/bb/pureload num numa nodes 2
Thu Jul  8 13:33:47 2021: /opt/Purity/bin/bb/pureload Starting test
with 32 threads

3. In an upgrade the primary controller is failed and the secondary
controller transitions to primary. From an ALUA paths perspective, the
paths to the previous primary go to ALUA state unavailable while the
paths transitioning to the promoting primary move to ALUA state
transitioning.

It is expected that 4 paths will fail:
Jul  8 13:33:58 init115-15 kernel: sd 14:0:0:11: [sdce] tag#1178 Add.
Sense: Logical unit not accessible, target port in unavailable state
Jul  8 13:33:58 init115-15 kernel: sd 15:0:0:11: [sdcf] tag#1374 Add.
Sense: Logical unit not accessible, target port in unavailable state
Jul  8 13:33:58 init115-15 kernel: sd 10:0:0:11: [sdcg] tag#600 Add.
Sense: Logical unit not accessible, target port in unavailable state
Jul  8 13:33:58 init115-15 kernel: sd 11:0:0:11: [sdcd] tag#1460 Add.
Sense: Logical unit not accessible, target port in unavailable state

Jul  8 13:33:58 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:64.
Jul  8 13:33:58 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:48.
Jul  8 13:33:58 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:16.
Jul  8 13:33:58 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:32.

Jul  8 13:33:58 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 7
Jul  8 13:33:58 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 6
Jul  8 13:33:59 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 5
Jul  8 13:33:59 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 4

4. It is not expected that the remaining 4 paths will also fail. This
was not the case until the change which introduced BLK_STS_AGAIN into
the SCSI ALUA device handler. With that change new I/O which reaches
that handler on paths that are in ALUA state transitioning will result
in those paths failing. Previous Linux versions, before that change,
will not return an I/O error back to the client application.
Similarly, this problem does not happen in other operating systems,
e.g. ESXi, Windows, AIX, etc.

5. It is not expected that the paths to the promoting primary fail yet they do:
Jul  8 13:33:59 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:96.
Jul  8 13:33:59 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:112.
Jul  8 13:33:59 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:80.
Jul  8 13:33:59 init115-15 kernel: device-mapper: multipath: 253:12:
Failing path 69:128.
Jul  8 13:33:59 init115-15 multipath[53813]: dm-12: no usable paths found
Jul  8 13:33:59 init115-15 multipath[53833]: dm-12: no usable paths found
Jul  8 13:33:59 init115-15 multipath[53853]: dm-12: no usable paths found

Jul  8 13:33:59 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 3
Jul  8 13:33:59 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 2
Jul  8 13:33:59 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 1
Jul  8 13:33:59 init115-15 multipathd[46030]:
3624a9370602220bd9986439b00012c1e: remaining active paths: 0

6. The error gets back to the user of the muitipath device unexpectedly:
Thu Jul  8 13:33:59 2021: /opt/Purity/bin/bb/pureload I/O Error: io
43047 fd 36  op read  offset 00000028ef7a7000  size 4096  errno 11
rsize -1

The earlier patch I made for this was not desirable, so I am proposing
this much smaller patch which will similarly not allow the
transitioning paths to result in immediate failure.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>

____
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..d5d6be96068d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1657,7 +1657,7 @@ static int multipath_end_io(struct dm_target
*ti, struct request *clone,
                else
                        r = DM_ENDIO_REQUEUE;

-               if (pgpath)
+               if (pgpath && (error != BLK_STS_AGAIN))
                        fail_path(pgpath);

                if (!atomic_read(&m->nr_valid_paths) &&


Brian Bunker
SW Eng
brian@purestorage.com
