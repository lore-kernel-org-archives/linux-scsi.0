Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DAAC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6604613FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbhD0WAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:36 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38966 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239469AbhD0V74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2667320416A;
        Tue, 27 Apr 2021 23:59:12 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mLiLKwkfmXc0; Tue, 27 Apr 2021 23:59:10 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 7A692204190;
        Tue, 27 Apr 2021 23:59:09 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 62/83] sg: work on sg_mrq_sanity()
Date:   Tue, 27 Apr 2021 17:57:12 -0400
Message-Id: <20210427215733.417746-64-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Work for following share variable blocking patch.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5e6c67bac5cd..e43bb1673adc 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1059,9 +1059,11 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 static int
 sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 	      struct sg_io_v4 *a_hds, u8 *cdb_ap, struct sg_fd *sfp,
-	      bool immed, u32 tot_reqs)
+	      bool immed, u32 tot_reqs, bool *share_on_othp)
 {
 	bool have_mrq_sense = (cop->response && cop->max_response_len);
+	bool share_on_oth = false;
+	bool share;
 	int k;
 	u32 cdb_alen = cop->request_len;
 	u32 cdb_mxlen = cdb_alen / tot_reqs;
@@ -1084,12 +1086,13 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			       __func__, rip, k);
 			return -ERANGE;
 		}
+		share = !!(flags & SGV4_FLAG_SHARE);
 		if (immed) {	/* only accept async submits on current fd */
 			if (unlikely(flags & SGV4_FLAG_DO_ON_OTHER)) {
 				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
 				       rip, k, "no IMMED with ON_OTHER");
 				return -ERANGE;
-			} else if (unlikely(flags & SGV4_FLAG_SHARE)) {
+			} else if (unlikely(share)) {
 				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
 				       rip, k, "no IMMED with FLAG_SHARE");
 				return -ERANGE;
@@ -1100,8 +1103,11 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			}
 			/* N.B. SGV4_FLAG_SIG_ON_OTHER is allowed */
 		}
-		if (!sg_fd_is_shared(sfp)) {
-			if (unlikely(flags & SGV4_FLAG_SHARE)) {
+		if (sg_fd_is_shared(sfp)) {
+			if (!share_on_oth && share)
+				share_on_oth = true;
+		} else {
+			if (unlikely(share)) {
 				SG_LOG(1, sfp, "%s: %s %u, no share\n",
 				       __func__, rip, k);
 				return -ERANGE;
@@ -1124,6 +1130,8 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			hp->max_response_len = cop->max_response_len;
 		}
 	}
+	if (share_on_othp)
+		*share_on_othp = share_on_othp;
 	return 0;
 }
 
@@ -1241,7 +1249,8 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		}
 	}
 	/* do sanity checks on all requests before starting */
-	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, immed, tot_reqs);
+	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, immed, tot_reqs,
+			    NULL);
 	if (unlikely(res))
 		goto fini;
 	set_this = false;
-- 
2.25.1

