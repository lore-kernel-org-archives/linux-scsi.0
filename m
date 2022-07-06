Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0019DC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiGFXfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiGFXfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:52 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562E62C675;
        Wed,  6 Jul 2022 16:35:52 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 339E640787;
        Wed,  6 Jul 2022 23:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150552; bh=LZdfP1dedOAVuUz3XRTRsLB/VZpumsqI+DHamdN21kM=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=JD0mvMO5r5a/X/MAWKtRRK4ACD4+ih+RZhFC0YONHr9/eKjs2WfEJjqt2g2cW73Ba
         7ZZ6oBA9etEigMZp5+BaLDeQbm2x9gvgX9bQuNb1ixK8QJ28frUH39dkuhmPCxqzTS
         OI8tdX9PHDHRpqtttj/YX3mppA89JfS2i3vjpT15jBDv3LhYH/nmN1iIxvPu/Bwld6
         hubhx+kU2xx14mMwhnRfBG9QN+ed4sdgWKvlzuUFn6CVkTA88RloD+N9+Nj0EBnVjK
         R/j9Zp6l9A/RyxY5EiqAvacso0EamSnebSrXfZjcSKqA+FU3iXA42nbxpb5ixVyMn8
         bFYkhC+a6KX+g==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 112F4A0063;
        Wed,  6 Jul 2022 23:35:51 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:51 -0700
Date:   Wed, 06 Jul 2022 16:35:51 -0700
Message-Id: <b772cb40e2f2d769139138f42fc59046c4f0e639.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 14/36] target: Introduce target_submit_tmr_fail_response
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similar to transport_send_check_condition_and_sense(), some error
condition and status can only be checked by the user of the target core
(such as TMR_OVERLAPPED_TAG_ATTEMPTED). Introduce
target_submit_tmr_fail_response() to allow the user to directly provide
the fail reason of the TMR command.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_transport.c | 33 ++++++++++++++++++++++++++
 include/target/target_core_fabric.h    |  3 +++
 2 files changed, 36 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 930bf8779d87..c899da241b38 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1989,6 +1989,39 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_tmr);
 
+void target_submit_tmr_fail_response(struct se_cmd *se_cmd,
+		enum tcm_tmrsp_table rsp,
+		struct se_session *se_sess, u64 unpacked_lun,
+		gfp_t gfp, u64 tag, int flags)
+{
+	struct se_portal_group *se_tpg;
+	int ret;
+
+	se_tpg = se_sess->se_tpg;
+	BUG_ON(!se_tpg);
+
+	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			  0, DMA_NONE, TCM_SIMPLE_TAG, NULL, unpacked_lun);
+
+	ret = core_tmr_alloc_req(se_cmd, NULL, TMR_UNKNOWN, gfp);
+	if (ret < 0)
+		return;
+
+	se_cmd->se_tmr_req->ref_task_tag = tag;
+	se_cmd->se_tmr_req->response = rsp;
+
+	/* See target_submit_cmd for commentary */
+	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
+	if (ret) {
+		core_tmr_release_req(se_cmd->se_tmr_req);
+		return;
+	}
+
+	INIT_WORK(&se_cmd->work, target_complete_tmr_failure);
+	schedule_work(&se_cmd->work);
+}
+EXPORT_SYMBOL(target_submit_tmr_fail_response);
+
 /*
  * Handle SAM-esque emulation for generic transport request failures.
  */
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 38f0662476d1..73bf6b372926 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -172,6 +172,9 @@ int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
 		gfp_t, u64, int);
+void	target_submit_tmr_fail_response(struct se_cmd *se_cmd,
+		enum tcm_tmrsp_table rsp,
+		struct se_session *se_sess, u64 unpacked_lun, gfp_t, u64, int);
 int	transport_handle_cdb_direct(struct se_cmd *);
 sense_reason_t	transport_generic_new_cmd(struct se_cmd *);
 
-- 
2.28.0

