Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBB1C27C76
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 17:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjA1Rxs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Jan 2023 12:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjA1Rxr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2023 12:53:47 -0500
Received: from msg-2.mailo.com (msg-2.mailo.com [213.182.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416281353F;
        Sat, 28 Jan 2023 09:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1674928414; bh=a4sH8oqur0SvTEb2rb1hiaMf6ovlS7xyJkK7IKnSui4=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:MIME-Version:
         Content-Type;
        b=LOC04ENxRTqxGOTebgbLrslbyjcmlOFPWCgpTM/4Gt7K8hsDoh2rhV0Fm4qQauWKn
         Q5+fQ1J2ZEBmaTmIhUyYhpFDfm5AbSsgfnWCbHq0LYPPW+HLiZ7e+cpICavQKgq3e0
         HMHMf9+zwgIsl3DY7lnrChSJGXtn+DPG5U5L6WCs=
Received: by b-3.in.mailobj.net [192.168.90.13] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Sat, 28 Jan 2023 18:53:33 +0100 (CET)
X-EA-Auth: ZTk1KFyUHY3eCvo5WJKUPZdb9riHCSlXYyhMcgx97VsP3lL1BI3O/wylcM0T8Kl3mi5AbfLU0WRGSlbNMEV44ejJVvNRKL59
Date:   Sat, 28 Jan 2023 23:23:29 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Deepak R Varma <drv@mailo.com>
Subject: [PATCH v2] scsi: bfa: Use min helpers for comparison and assignment
Message-ID: <Y9VhGXYLHWCwEnel@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify code by using min helper macros for logical evaluation
and value assignment. Use the _t variant when the variable types
are not same. The change also facilitates code realignment for improved
readability.
Proposed change is identified using minmax.cocci Coccinelle script.

Signed-off-by: Deepak R Varma <drv@mailo.com>
---
Changes in v2:
   - include an opportunity from bfa_svc.c

 drivers/scsi/bfa/bfa_fcbuild.c   | 3 +--
 drivers/scsi/bfa/bfa_fcs_rport.c | 5 +----
 drivers/scsi/bfa/bfa_svc.c       | 5 +----
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index df18d9d2af53..a58a73e596c0 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -1092,8 +1092,7 @@ fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
 
 	rftid->dap = s_id;
-	memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
-		(bitmap_size < 32 ? bitmap_size : 32));
+	memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap, min_t(u32, bitmap_size, 32));
 
 	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index c21aa37b8adb..d501314be8d8 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2539,10 +2539,7 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 	 * - MAX receive frame size
 	 */
 	rport->cisc = plogi->csp.cisc;
-	if (be16_to_cpu(plogi->class3.rxsz) < be16_to_cpu(plogi->csp.rxsz))
-		rport->maxfrsize = be16_to_cpu(plogi->class3.rxsz);
-	else
-		rport->maxfrsize = be16_to_cpu(plogi->csp.rxsz);
+	rport->maxfrsize = min(be16_to_cpu(plogi->class3.rxsz), be16_to_cpu(plogi->csp.rxsz));
 
 	bfa_trc(port->fcs, be16_to_cpu(plogi->csp.bbcred));
 	bfa_trc(port->fcs, port->fabric->bb_credit);
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 4e3cef02f10f..e9629a29aece 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5271,10 +5271,7 @@ bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
 	 */
 	do {
 		wqe = bfa_q_first(&mod->sgpg_wait_q);
-		if (mod->free_sgpgs < wqe->nsgpg)
-			nsgpg = mod->free_sgpgs;
-		else
-			nsgpg = wqe->nsgpg;
+		nsgpg = min(mod->free_sgpgs, wqe->nsgpg);
 		bfa_sgpg_malloc(bfa, &wqe->sgpg_q, nsgpg);
 		wqe->nsgpg -= nsgpg;
 		if (wqe->nsgpg == 0) {
-- 
2.34.1



