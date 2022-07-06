Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2A8C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiGFXft (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiGFXfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:47 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD372C675;
        Wed,  6 Jul 2022 16:35:46 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2F89CC06E7;
        Wed,  6 Jul 2022 23:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150546; bh=VqZ4QrtIgHeYHuR+ZiRgwQmglyXuamz+Gex6t28X73o=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=H78ITZOWYvbQ4yyEl46xCuF/rnv/orb7iE/hyBx+jdzsZ9v0IzCcaj1VCZ56eRDAR
         4o/mfQQ+7ZtFiOICHR6riUrKdIufY0hUS+lvVEujiVkZvK2BTy77/hQkT05dKdmJyq
         hl+cY6cSaCFdU09esFefH6zFUisCYL0JkuzTgvmFBlpYr3EhZlAraKtJk+Gek22IRU
         IB/3oEL2oVjfKMQTddeskNkNxivO7F2D+nsW04C9zc3HGJQ9TBPWHlXy7J0PpEBkGm
         Zc0it/lz+GBYOREIIOtwt9E/m+nteDh91FGGgiDBxzo/nyuC8x+KL83VMClXRDShUI
         ZKL6SMG141Q3Q==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id EA904A0237;
        Wed,  6 Jul 2022 23:35:44 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:44 -0700
Date:   Wed, 06 Jul 2022 16:35:44 -0700
Message-Id: <17031426bf0084a5342b9ed404368361bef7c50f.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 13/36] target: Don't respond TMR_LUN_DOES_NOT_EXIST for all TMR failure
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

Not every Task Management failure is due to TMR_LUN_DOES_NOT_EXIST,
which is currently being set if target_complete_tmr_failure() is
executed. Only set this response where it should apply.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2fc4ba1814c6..930bf8779d87 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1916,7 +1916,6 @@ static void target_complete_tmr_failure(struct work_struct *work)
 {
 	struct se_cmd *se_cmd = container_of(work, struct se_cmd, work);
 
-	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
 
 	transport_lun_remove_cmd(se_cmd);
@@ -1983,6 +1982,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * to process context with TMR_LUN_DOES_NOT_EXIST status.
 	 */
 failure:
+	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	INIT_WORK(&se_cmd->work, target_complete_tmr_failure);
 	schedule_work(&se_cmd->work);
 	return 0;
-- 
2.28.0

