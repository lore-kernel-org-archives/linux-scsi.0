Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F92C38142
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 17:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjA1RDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Jan 2023 12:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjA1RDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2023 12:03:00 -0500
Received: from msg-2.mailo.com (msg-2.mailo.com [213.182.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E659620059;
        Sat, 28 Jan 2023 09:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1674925368; bh=+8TKLKDrMXk1aX3sjR/kJoEvZAQFsAvwmSjZFAccLgg=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:MIME-Version:
         Content-Type;
        b=Ui0AegwQcfT2+K0Cac1J2ZgbYyt5qkOTti+bkZ27XAokWCFdtDKV2rR0qAYxJSFIC
         +FZU+uhv6OtyOKpVLcXokGF/xFp9dVsHA5+cNGX/d1/QUOrvmNXroP8Gv0NAduZxqE
         u+5nlocKw7Y6csYdUSzNmk+JZ/X/ky0uwDHtiFIM=
Received: by b-2.in.mailobj.net [192.168.90.12] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Sat, 28 Jan 2023 18:02:48 +0100 (CET)
X-EA-Auth: h5MYg+Yeo7m+WjFzLuSX2OLGCOmYFsxT1QAjTicMi8hGeJhhYIs9w1BsP5iTpo4oQkyrL8I3lMmx3VJBPCwN73XoBV07RqTv
Date:   Sat, 28 Jan 2023 22:32:42 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Deepak R Varma <drv@mailo.com>
Subject: [PATCH] scsi: bfa: Use min helpers for comparison and assignment
Message-ID: <Y9VVMh8epgxQYyji@ubun2204.myguest.virtualbox.org>
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
 drivers/scsi/bfa/bfa_fcbuild.c   | 3 +--
 drivers/scsi/bfa/bfa_fcs_rport.c | 5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

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
-- 
2.34.1



