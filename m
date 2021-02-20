Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2138C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 02:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 888AD64E77
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 02:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhBTCQr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 21:16:47 -0500
Received: from smtp.infotech.no ([82.134.31.41]:43761 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBTCQq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Feb 2021 21:16:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B340920418F;
        Sat, 20 Feb 2021 03:16:04 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yFyEggTNyNqs; Sat, 20 Feb 2021 03:16:03 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 3FEAC20418D;
        Sat, 20 Feb 2021 03:16:01 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH] sg: syncing at patch 26 versus staging
Date:   Fri, 19 Feb 2021 21:16:00 -0500
Message-Id: <20210220021600.77891-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 5.12/scsi-staging branch current has patches 1 through 26 out
of 45 presented, applied around version 13 (currently at version
15 about to be 16). Due to bug fixes in the author's patchset,
there is a divergence in the drivers/scsi/sg.c source file. This
patch brings them back into sync.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---

This patch is designed to be applied to the 5.12/scsi-staging
branch or the branch containing patches 1 through 26 taken
from patchset v13.

 drivers/scsi/sg.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c5a34bb91335..1a89f617869c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -312,7 +312,7 @@ static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 			pr_info("sg: sdp or sfp NULL, " fmt, ##a);	\
 	} while (0)
 #else
-#define SG_LOG(depth, sfp, fmt, a...) { }
+#define SG_LOG(depth, sfp, fmt, a...) do { } while (0)
 #endif	/* end of CONFIG_SCSI_LOGGING && SG_DEBUG conditional */
 
 
@@ -522,11 +522,9 @@ sg_release(struct inode *inode, struct file *filp)
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 
 	/*
-	 * Possibly many open()s waiting on exlude clearing, start many;
+	 * Possibly many open()s waiting on exclude clearing, start many;
 	 * only open(O_EXCL)'s wait when open_cnt<2 and only start one.
 	 */
-	/* possibly many open()s waiting on exlude clearing, start many;
-	 * only open(O_EXCL)s wait on 0==open_cnt so only start one */
 	if (test_and_clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm))
 		wake_up_interruptible_all(&sdp->open_wait);
 	else if (o_count < 2)
@@ -1584,7 +1582,7 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 			      SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 #endif
 	kfree(rinfop);
-	return result;
+	return result > 0 ? -EFAULT : result;	/* treat short copy as error */
 }
 
 static int
@@ -2711,9 +2709,9 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 static int
 sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 {
-	int j, k, rem_sz, align_sz;
+	int j, k, rem_sz, align_sz, order, o_order;
 	int mx_sgat_elems = sfp->parentdp->max_sgat_elems;
-	unsigned int elem_sz, order, o_order;
+	unsigned int elem_sz;
 	const size_t ptr_sz = sizeof(struct page *);
 	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
-- 
2.25.1

