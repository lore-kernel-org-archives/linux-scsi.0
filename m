Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EF8C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 15:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2DE60F59
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 15:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhGZOhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:37:06 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44238 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234941AbhGZOhE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 10:37:04 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 452BC48EBC;
        Mon, 26 Jul 2021 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1627312651; x=1629127052; bh=PXbKZB+ReRYrdxv/kfaQPbo6yUy4XvDW665
        ytPV6Ndk=; b=K8mQcHwqd7BmkbqwY+swmZlseathCbq8fvSe+acpoS3fsCfKzhE
        vjhgBVAUkakbkmuD2EfRVDhJqWIHjeCjH3dfj5vBYprVapf9xFSyF5xZTaLP9wFe
        ifujsGp81UZK+0qmj3NWLXvfrs6A31YbdpiOIb6hL8XSEbU1JJu4tx40=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8wUCBJ6FAn81; Mon, 26 Jul 2021 18:17:31 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 057ED412C6;
        Mon, 26 Jul 2021 18:17:31 +0300 (MSK)
Received: from yadro.com (10.199.0.6) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 26
 Jul 2021 18:17:30 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <ddiss@suse.de>, <bvanassche@acm.org>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Sergey Samoylenko <s.samoylenko@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [v2 2/2] target: core: Fix sense key for invalid XCOPY request
Date:   Mon, 26 Jul 2021 18:16:46 +0300
Message-ID: <20210726151646.32631-3-s.samoylenko@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726151646.32631-1-s.samoylenko@yadro.com>
References: <20210726151646.32631-1-s.samoylenko@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.6]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TCM fails to pass the following tests in libiscsi:

  SCSI.ExtendedCopy.DescrType
  SCSI.ExtendedCopy.DescrLimits
  SCSI.ExtendedCopy.ParamHdr
  SCSI.ExtendedCopy.ValidSegDescr
  SCSI.ExtendedCopy.ValidTgtDescr

XCOPY always returns the same NOT READY sense key for all
detected errors. It changes a sense key for invalid requests
to ILLEGAL REQUEST sense key, for aborted transferring data
(IO error and etc.) to COPY ABORTED.

Fixes: d877d7275be34ad ("target: Fix a deadlock between the XCOPY code and iSCSI session shutdown")
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
---
 drivers/target/target_core_xcopy.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 0f1319336f3e..64baf3e8c079 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -674,12 +674,16 @@ static void target_xcopy_do_work(struct work_struct *work)
 	unsigned int max_sectors;
 	int rc = 0;
 	unsigned short nolb, max_nolb, copied_nolb = 0;
+	sense_reason_t sense_rc;
 
-	if (target_parse_xcopy_cmd(xop) != TCM_NO_SENSE)
+	sense_rc = target_parse_xcopy_cmd(xop);
+	if (sense_rc != TCM_NO_SENSE)
 		goto err_free;
 
-	if (WARN_ON_ONCE(!xop->src_dev) || WARN_ON_ONCE(!xop->dst_dev))
+	if (WARN_ON_ONCE(!xop->src_dev) || WARN_ON_ONCE(!xop->dst_dev)) {
+		sense_rc = TCM_INVALID_PARAMETER_LIST;
 		goto err_free;
+	}
 
 	src_dev = xop->src_dev;
 	dst_dev = xop->dst_dev;
@@ -762,20 +766,20 @@ static void target_xcopy_do_work(struct work_struct *work)
 	return;
 
 out:
+	/*
+	 * The XCOPY command was aborted after some data was transferred.
+	 * Terminate command with CHECK CONDITION status, with the sense key
+	 * set to COPY ABORTED.
+	 */
+	sense_rc = TCM_COPY_TARGET_DEVICE_NOT_REACHABLE;
 	xcopy_pt_undepend_remotedev(xop);
 	target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
 
 err_free:
 	kfree(xop);
-	/*
-	 * Don't override an error scsi status if it has already been set
-	 */
-	if (ec_cmd->scsi_status == SAM_STAT_GOOD) {
-		pr_warn_ratelimited("target_xcopy_do_work: rc: %d, Setting X-COPY"
-			" CHECK_CONDITION -> sending response\n", rc);
-		ec_cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
-	}
-	target_complete_cmd(ec_cmd, ec_cmd->scsi_status);
+	pr_warn_ratelimited("target_xcopy_do_work: rc: %d, sense: %u,"
+		" XCOPY operation failed\n", rc, sense_rc);
+	target_complete_cmd_with_sense(ec_cmd, sense_rc);
 }
 
 /*
-- 
2.25.1

