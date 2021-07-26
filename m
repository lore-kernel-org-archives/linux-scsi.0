Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA11C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 060B560F9B
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhGZTjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 15:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbhGZTjF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 15:39:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBD1C061765
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p71-20020a25424a0000b029056092741626so15385723yba.19
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VfDxoCReDm+XfUOmdfI9bwSV32koHBs4WIv0MpubLz8=;
        b=KJHhZGIp4jKvBjwR8O5xZinTKKgnfulQvUjEgb+F8mv9/+TkC4BS8c3I7LTiIUplYI
         jKJ84XNavPSxt+ubLiJ7rIDR0uyoFhe5VK7uUfSYKUv8+lEzz3ztai0iCfzEjsyrc4Gu
         CiQHkVOix5C1w6WigMb2jk2qYNeNWcujzxhnMQ7B5RzMXuyPjMtDG+N1i+AkJdDhZ9Bv
         WNO2pHOHRuoROieddUvjkx79vK0QNp+ilZwkCe/PdT8+4S3jigZ9lkt8YNDhvf5pHrS0
         KaysMxSZlBn2h2XX92Y0cgyMh+zpH7OBGX2ANVuzEZRvbNTqKagru6PKoeZpxXyfjWc8
         /wGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VfDxoCReDm+XfUOmdfI9bwSV32koHBs4WIv0MpubLz8=;
        b=PaCtUdvlMykE/yXUe3Ejy0PzDIedi236s7Idy1BtoP+Egxk+RC/oEE6Z9UO51F1aVM
         FctMUZHCr+YYFWvXxNMu7yIBDVu4uf2b4mmOyvv8oXw+xDUzD71Y/bPQWqFQ2WSu0ki1
         biBn9GpSk+6v3E/T9J9Drbiyyg2FjYe+XzlUGhUpL02m+qOU2k3gNYn8TGm1S0o1+i7G
         sPAhEObHCrYjyROGLD3i+lqjTinbM7T1BpoYyRaaIifT4m1uDWdKeANTNEeJtN4FPhG/
         vrOv4R72nGEENm4LkJ1ed/EFYwxYJmDfaxI2xeQSCRfCUSafDxRs6bKj71HmKBNYwuVp
         3Pnw==
X-Gm-Message-State: AOAM532EAa9uX6pu3BUgTwKE3pmpwbjIo0PxiIpMu1u8cZgIlbrncyxO
        QCeuLQGxx7C3lvUB03jQIwgELMsW
X-Google-Smtp-Source: ABdhPJx9RgyvReiw/itct0/6JahGn7Hxif/512W9GnqlhzG71X1cOjsqKVl/nn9ymlpKHxYahaaVw+vQyA==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:ccf7:db54:b9d7:814f])
 (user=morbo job=sendgmr) by 2002:a25:2593:: with SMTP id l141mr14862499ybl.489.1627330772904;
 Mon, 26 Jul 2021 13:19:32 -0700 (PDT)
Date:   Mon, 26 Jul 2021 13:19:23 -0700
In-Reply-To: <20210726201924.3202278-1-morbo@google.com>
Message-Id: <20210726201924.3202278-3-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com> <20210726201924.3202278-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 2/3] bnx2x: remove unused variable 'cur_data_offset'
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the clang build warning:

  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1862:13: error: variable 'cur_data_offset' set but not used [-Werror,-Wunused-but-set-variable]
        dma_addr_t cur_data_offset;

Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 27943b0446c2..f255fd0b16db 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1858,7 +1858,6 @@ void bnx2x_iov_adjust_stats_req(struct bnx2x *bp)
 {
 	int i;
 	int first_queue_query_index, num_queues_req;
-	dma_addr_t cur_data_offset;
 	struct stats_query_entry *cur_query_entry;
 	u8 stats_count = 0;
 	bool is_fcoe = false;
@@ -1879,10 +1878,6 @@ void bnx2x_iov_adjust_stats_req(struct bnx2x *bp)
 	       BNX2X_NUM_ETH_QUEUES(bp), is_fcoe, first_queue_query_index,
 	       first_queue_query_index + num_queues_req);
 
-	cur_data_offset = bp->fw_stats_data_mapping +
-		offsetof(struct bnx2x_fw_stats_data, queue_stats) +
-		num_queues_req * sizeof(struct per_queue_stats);
-
 	cur_query_entry = &bp->fw_stats_req->
 		query[first_queue_query_index + num_queues_req];
 
@@ -1933,7 +1928,6 @@ void bnx2x_iov_adjust_stats_req(struct bnx2x *bp)
 			       cur_query_entry->funcID,
 			       j, cur_query_entry->index);
 			cur_query_entry++;
-			cur_data_offset += sizeof(struct per_queue_stats);
 			stats_count++;
 
 			/* all stats are coalesced to the leading queue */
-- 
2.32.0.432.gabb21c7263-goog

