Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13084C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 01:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E64636103B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 01:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhG3BVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 21:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233855AbhG3BVa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jul 2021 21:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E582660E09;
        Fri, 30 Jul 2021 01:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627608086;
        bh=KTh+1SvWGrqaP3ZzUAM76b2+rrCHeZnuYTqbOR/wQI0=;
        h=From:To:Cc:Subject:Date:From;
        b=mPkRXG4bstZLhu+l0/gTAZuS7sV0j9IQMW/fWBVg3OSMwJmOZ9FOLPaUAmEUmAcrA
         yw4UIS2GrdPScRxDxYqm9lJz/fXnl3wNn9VGGo4HHzxg129/qL0poB9Cx+eqZGjwXR
         ia/v+oqk6hE30NlIdKqjPbnmLtfAwKohIf//cLuxidSQVdHP1WJCo9TdhjxkJupOyr
         p7TUdBQH9orIC6FlC8HQZCEgHuWHPGgNW6kNY8ic3CpGmqiLMyZ5261ls3T12n3SWq
         7PMHjGm7kELpkQyS3q4o8jZhGY7mN/D+jS57Sof5k+I/q7KWrNUIbla/ObLsN9q777
         wGgP4za1IkVKQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] bsg: Fix build error with CONFIG_BLK_DEV_BSG_COMMON=m
Date:   Thu, 29 Jul 2021 18:21:08 -0700
Message-Id: <20210730012108.3385990-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.264.g75ae10bc75
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When CONFIG_BLK_DEV_BSG_COMMON is enabled as a module, which can happen
when CONFIG_SCSI=m and CONFIG_BLK_DEV_BSGLIB=n, the following error
occurs:

In file included from arch/x86/kernel/asm-offsets.c:13:
In file included from include/linux/suspend.h:5:
In file included from include/linux/swap.h:9:
In file included from include/linux/memcontrol.h:22:
In file included from include/linux/writeback.h:14:
In file included from include/linux/blk-cgroup.h:23:
include/linux/blkdev.h:539:26: error: field has incomplete type 'struct
bsg_class_device'
        struct bsg_class_device bsg_dev;
                                ^
include/linux/blkdev.h:539:9: note: forward declaration of 'struct
bsg_class_device'
        struct bsg_class_device bsg_dev;
               ^
1 error generated.

The definition of struct bsg_class_device is kept under an #ifdef
directive, which does not work when CONFIG_BLK_DEV_BSG_COMMON is a
module, as the define is CONFIG_BLK_DEV_BSG_COMMON_MODULE.

Use IS_ENABLED instead, which evaluates to 1 when
CONFIG_BLK_DEV_BSG_COMMON is y or m.

Fixes: 78011042684d ("scsi: bsg: Move bsg_scsi_ops to drivers/scsi/")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/bsg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index b887da20bd41..9602ae3ab01b 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -7,7 +7,7 @@
 struct request;
 struct request_queue;
 
-#ifdef CONFIG_BLK_DEV_BSG_COMMON
+#if IS_ENABLED(CONFIG_BLK_DEV_BSG_COMMON)
 struct bsg_ops {
 	int	(*check_proto)(struct sg_io_v4 *hdr);
 	int	(*fill_hdr)(struct request *rq, struct sg_io_v4 *hdr,

base-commit: 08dc2f9b53afbbc897bc895aa41906194f5af1cf
-- 
2.32.0.264.g75ae10bc75

