Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1EBC6FA8A
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 09:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiIIJFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiIIJEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 05:04:53 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594B74A102;
        Fri,  9 Sep 2022 02:04:37 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4C1D656988;
        Fri,  9 Sep 2022 09:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662714273; x=1664528674; bh=M+tZNAFbHdcX6kD2GEHrOH/oz
        cH0w42GSHGfYjScItQ=; b=OHXAPflaIfGJPw3dGalMzlu11frcyR+T+0NMtwOrN
        6sLMOTrwVpf44MBS0OPka3tz+kE6RSn2WttbXx+/afSEbACLu0zBn/K1bH93eucn
        DMx3pYyxlA6ja0vZXHE/sglhpuLwQoKSxfkNOMpanyqWdNVIQFIWmQnTeNXlX9pW
        dc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zW5A6EEb-Gyq; Fri,  9 Sep 2022 12:04:33 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8AA71569A0;
        Fri,  9 Sep 2022 12:04:32 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 12:04:32 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Fri, 9 Sep 2022 12:04:31 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 3/4] target: core: abort all preempted regs if requested
Date:   Fri, 9 Sep 2022 12:04:24 +0300
Message-ID: <20220909090425.14479-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909090425.14479-1-d.bogdanov@yadro.com>
References: <20220909090425.14479-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to SPC the preempted commands shall be always aborted.

SPC-4: 5.12.11.2.6 Preempting and aborting
c) all commands from the I_T nexus(es) associated with the persistent
reservations or registrations being preempted (i.e., preempted commands)
except the PERSISTENT RESERVE OUT command itself shall be aborted as
defined in SAM-5;

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index e3869576f254..6a5f9504a481 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2960,9 +2960,23 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 
 		spin_unlock(&dev->dev_reservation_lock);
 
-		if (preempt_type == PREEMPT_AND_ABORT)
+		/*
+		 * SPC-4 5.12.11.2.6 Preempting and aborting
+		 * The actions described in this subclause shall be performed
+		 * for all I_T nexuses that are registered with the non-zero
+		 * SERVICE ACTION RESERVATION KEY value, without regard for
+		 * whether the preempted I_T nexuses hold the persistent
+		 * reservation. If the SERVICE ACTION RESERVATION KEY field is
+		 * set to zero and an all registrants persistent reservation is
+		 * present, the device server shall abort all commands for all
+		 * registered I_T nexuses.
+		 */
+		if (preempt_type == PREEMPT_AND_ABORT) {
+			core_tmr_lun_reset(dev, NULL, &preempt_and_abort_list,
+					   cmd);
 			core_scsi3_release_preempt_and_abort(
 				&preempt_and_abort_list, pr_reg_n);
+		}
 
 		if (pr_tmpl->pr_aptpl_active)
 			core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
-- 
2.25.1

