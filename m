Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E410C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 21:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD43619CC
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 21:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhCWVZB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 17:25:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:48570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233454AbhCWVYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 17:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616534687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2rbPaXRKb7h4KyZ87XmNO0rXGf+RsMQ+Dah0PlV+ljQ=;
        b=GZdWyDhAZrk5dNxzmvWAjFgX2R7jynyHBAYA+/texyWHmHCl7Oixy8/iMvK/1jRTrkkdJC
        Hn3WMoUeMnsL4ZDo4AE76EKe0hnBBO+ZqYFXMjxgS3P5AX7l9CaAmVbvRBhzJLcovXDyCm
        zRwqcaPC0gcxdK4821NQ3EARtJJU84I=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 899F6AD4A;
        Tue, 23 Mar 2021 21:24:47 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        David Disseldorp <ddiss@suse.com>,
        =?UTF-8?q?J=C3=BCrgen=20Gro=C3=9F?= <jgross@suse.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/2] target: pscsi: avoid OOM in pscsi_map_sg()
Date:   Tue, 23 Mar 2021 22:24:30 +0100
Message-Id: <20210323212431.15306-1-mwilck@suse.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

pscsi_map_sg() uses the variable nr_pages as a hint for bio_kmalloc()
how many vector elements to allocate. If nr_pages is < BIO_MAX_PAGES,
it will be reset to 0 after successful allocation of the bio.

If bio_add_pc_page() fails later for whatever reason, pscsi_map_sg()
tries to allocate another bio, passing nr_vecs=0. This causes
bio_add_pc_page() to fail immediately in the next call. pci_map_sg()
continues to allocate zero-length bios until memory is exhausted and
the kernel crashes with OOM. This can be easily observed by exporting
a SATA DVD drive via pscsi. The target crashes as soon as the client
tries to access the DVD LUN. In the case I analyzed, bio_add_pc_page()
would fail because the DVD device's max_sectors_kb (128) was
exceeded.

Avoid this by simply not resetting nr_pages to 0 after allocating the
bio. This way, the client receives an IO error when it tries to send
requests exceeding the devices max_sectors_kb, and eventually gets
it right. The client must still limit max_sectors_kb e.g. by an udev
rule if (like in my case) the driver doesn't report valid block
limits, otherwise it encounters I/O errors.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/target/target_core_pscsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 7b1035e..977362d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -881,7 +881,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			if (!bio) {
 new_bio:
 				nr_vecs = bio_max_segs(nr_pages);
-				nr_pages -= nr_vecs;
 				/*
 				 * Calls bio_kmalloc() and sets bio->bi_end_io()
 				 */
-- 
2.26.2

