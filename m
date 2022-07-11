Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC3EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 08:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiGKIkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 04:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiGKIjg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 04:39:36 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53E9B60C0;
        Mon, 11 Jul 2022 01:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Iszld
        rkcWJLeZEhSrUJwi5/TDWFFSntIsp/SlG4KVbs=; b=PeLy+5SG+BYwEAqSyHKVS
        /FqIt+o09oZobfoGIFb0QsFFeOeylPvOqpuGPAkMnJmb/oV1oewAXQ9e3tNYPvqi
        xmQ+GtRwwDSXKn0uiFqJAw2m/luxUIrvyLE3VLWQeUBLSSKjdMyfOcPzBc99Sj9Q
        /knh2PsYwwEScBlqLXLmno=
Received: from localhost.localdomain (unknown [111.48.58.12])
        by smtp9 (Coremail) with SMTP id DcCowABXqRV74ctizvpuOg--.12243S2;
        Mon, 11 Jul 2022 16:38:20 +0800 (CST)
From:   Jiangshan Yi <13667453960@163.com>
To:     Kai.Makisara@kolumbus.fi, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH] scsi: st: replace ternary operator with min() or max()
Date:   Mon, 11 Jul 2022 16:37:53 +0800
Message-Id: <20220711083753.4041723-1-13667453960@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowABXqRV74ctizvpuOg--.12243S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr4xurW8Xr45Cr1kXw4kXrb_yoW8KFW3pF
        Z5K3y0k3y8JF1kWFnFgan8C34ftasYqFWjk3y5X3y5ZFn5GF909w1fGFyUKayrtrs7Jasr
        tr1qgr95G3WUtr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j9iSdUUUUU=
X-Originating-IP: [111.48.58.12]
X-CM-SenderInfo: bprtllyxuvjmiwq6il2tof0z/1tbiVwo7+1etnohaeQABsT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jiangshan Yi <yijiangshan@kylinos.cn>

Fix the following coccicheck warning:

drivers/scsi/st.c:1575: WARNING opportunity for max().
drivers/scsi/st.c:2187: WARNING opportunity for min().
drivers/scsi/st.c:3997: WARNING opportunity for min().
drivers/scsi/st.c:4029: WARNING opportunity for min().

min() and max() macro is defined in include/linux/minmax.h. It avoids
multiple evaluations of the arguments when non-constant and performs
strict type-checking.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 drivers/scsi/st.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 850172a2b8f1..9555988fa78e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1572,8 +1572,7 @@ static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
 
 	if (!STbp->do_dio) {
 		if (STp->block_size)
-			bufsize = STp->block_size > st_fixed_buffer_size ?
-				STp->block_size : st_fixed_buffer_size;
+			bufsize = max(STp->block_size, st_fixed_buffer_size);
 		else {
 			bufsize = count;
 			/* Make sure that data from previous user is not leaked even if
@@ -2184,8 +2183,7 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 					  STps->eof, STbp->buffer_bytes,
 					  (int)(count - total));
 			) /* end DEB */
-			transfer = STbp->buffer_bytes < count - total ?
-			    STbp->buffer_bytes : count - total;
+			transfer = min((size_t)STbp->buffer_bytes, count - total);
 			if (!do_dio) {
 				i = from_buffer(STbp, buf, transfer);
 				if (i) {
@@ -3994,7 +3992,7 @@ static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, in
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
 		struct page *page = st_bp->reserved_pages[i];
-		cnt = length - offset < do_count ? length - offset : do_count;
+		cnt = min(length - offset, do_count);
 		res = copy_from_user(page_address(page) + offset, ubp, cnt);
 		if (res)
 			return (-EFAULT);
@@ -4026,7 +4024,7 @@ static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
 		struct page *page = st_bp->reserved_pages[i];
-		cnt = length - offset < do_count ? length - offset : do_count;
+		cnt = min(length - offset, do_count);
 		res = copy_to_user(ubp, page_address(page) + offset, cnt);
 		if (res)
 			return (-EFAULT);
-- 
2.25.1

