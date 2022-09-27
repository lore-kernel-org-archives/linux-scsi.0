Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176EBC07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 01:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiI0Bo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 21:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiI0BoZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 21:44:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C57A6C6C
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w20so7777080ply.12
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=JOcSBJDbPNKdxxi4qNGAXtFEhq+6bWrLRCXy9taKBK0=;
        b=5JrmfRjCkoo8fy6h8FWqSC/AqEwpNNb38xn8OjD/0YU5l3Mta9yDZCbiDZIFOdz6+Q
         Mgu4jOGkIcM5xdha+tICm0Ov2rJ7dnZFBDyIJcvG4XIAjVxuwn5J/s4j5NMcXIZsSKqw
         nJ9f4ioCr7XgSl6Auo4hZPg+hwkpCdAQzZdPrpagC/0vnA28ZBvpsytRqttn0sLaK7Yc
         WCRSDTkiXPcxOmJtTv/aj1zh6+IRAoXIQ2WLcQKCLz358PJrlF2TibJMsytrKzIPKDtl
         YYz/VByzA8yNI3CwxnuKA2VDlWy3qQsnerdJAJpnz2OM5d+W8woPCcgxnpzFCwxMIlsu
         2mBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=JOcSBJDbPNKdxxi4qNGAXtFEhq+6bWrLRCXy9taKBK0=;
        b=ZJLXchPY9hcFBHp7/93rVeXdNIXHXPyiF4bEN6AQvBIByClTtEJZZzycxzqDse8wVQ
         K5N6qmX4XC2OszI+OjcUO0BmeDJ24QCoQIjqHvAxLkoCarjzM17N2Pp032kFLcXY3S3X
         obTfb4NbtI3PHDTu1wo2B6NkG+i177qV2t321ee6+2crMh+BSXzPrP8gyjzuW7CuXLM7
         lVTNQtN/A2Jr6j15B9V6cnTDh3YJRaYCdvztn15CyHRknLWAxWwDuPxgDKqjBKCUeAxM
         KsLZ0iUfsBRDnnFrbIXVYn3/txd0Msr7bBFnVVoeV7XjBqb8Bqz+lto+ZF5B6pP/NPgP
         hiiQ==
X-Gm-Message-State: ACrzQf0XEl9NMUjAlIjyVOzt+wthco+a8R9fJ0k11ZVK0jYw4Vteo0jP
        XHVyT2QG02kcotnMa0qpaQQgLsfh7KhSXQ==
X-Google-Smtp-Source: AMsMyM4KIArFZjPWWsnRlC7IjrVD3iZswBYccQQ/vEud0zbo9JCCXs4kFqw8RguhuttKJ+I9uCTqrw==
X-Received: by 2002:a17:902:d58d:b0:176:da94:e6f7 with SMTP id k13-20020a170902d58d00b00176da94e6f7mr25043917plh.11.1664243062579;
        Mon, 26 Sep 2022 18:44:22 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o2-20020aa79782000000b00537d60286c9sm183062pfp.113.2022.09.26.18.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 18:44:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: [PATCHSET v2 0/5] Enable alloc caching and batched freeing for passthrough
Date:   Mon, 26 Sep 2022 19:44:15 -0600
Message-Id: <20220927014420.71141-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

The passthrough IO path currently doesn't do any request allocation
batching like we do for normal IO. Wire this up through the usual
blk_mq_alloc_request() allocation helper.

Similarly, we don't currently supported batched completions for
passthrough IO. Allow the request->end_io() handler to return back
whether or not it retains ownership of the request. By default all
handlers are converted to returning RQ_END_IO_NONE, which retains
the existing behavior. But with that in place, we can tweak the
nvme uring_cmd end_io handler to pass back ownership, and hence enable
completion batching for passthrough requests as well.

This is good for a 10% improvement for passthrough performance. For
a non-drive limited test case, passthrough IO is now more efficient
than the regular bdev O_DIRECT path.

Changes since v1:
- Remove spurious semicolon
- Cleanup struct nvme_uring_cmd_pdu handling

-- 
Jens Axboe


