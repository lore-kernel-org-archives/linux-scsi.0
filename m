Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6D3C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 318E923B81
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgLIGdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 01:33:20 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9559 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgLIGdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 01:33:15 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrRzD55MFzM2YQ;
        Wed,  9 Dec 2020 14:31:52 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.9) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 14:32:22 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: ufs-mediatek: use correct path to fix compiling error
Date:   Wed, 9 Dec 2020 14:31:44 +0800
Message-ID: <20201209063144.1840-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20201209063144.1840-1-thunder.leizhen@huawei.com>
References: <20201209063144.1840-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.9]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the kernel is compiled with allmodconfig, the following error is
reported:
In file included from drivers/scsi/ufs/ufs-mediatek-trace.h:36:0,
                 from drivers/scsi/ufs/ufs-mediatek.c:28:
./include/trace/define_trace.h:95:42: fatal error: ./ufs-mediatek-trace.h: No such file or directory
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)

The comment in include/trace/define_trace.h specifies that:
TRACE_INCLUDE_PATH: Note, the path is relative to define_trace.h, not the
file including it. Full path names for out of tree modules must be used.

So without "CFLAGS_ufs-mediatek.o := -I$(src)", the current directory "."
is "include/trace/", the relative path of ufs-mediatek-trace.h is
"../../drivers/scsi/ufs/".

Fixes: ca1bb061d644 ("scsi: ufs-mediatek: Introduce event_notify implementation")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/ufs/ufs-mediatek-trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek-trace.h b/drivers/scsi/ufs/ufs-mediatek-trace.h
index fd6f84c1b4e2256..895e82ea6ece551 100644
--- a/drivers/scsi/ufs/ufs-mediatek-trace.h
+++ b/drivers/scsi/ufs/ufs-mediatek-trace.h
@@ -31,6 +31,6 @@ TRACE_EVENT(ufs_mtk_event,
 
 #undef TRACE_INCLUDE_PATH
 #undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_PATH ../../drivers/scsi/ufs/
 #define TRACE_INCLUDE_FILE ufs-mediatek-trace
 #include <trace/define_trace.h>
-- 
2.26.0.106.g9fadedd


