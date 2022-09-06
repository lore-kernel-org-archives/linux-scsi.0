Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93556ECAAA1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 10:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbiIFKrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239867AbiIFKqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 06:46:43 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9712B72B59;
        Tue,  6 Sep 2022 03:45:42 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E72535657C;
        Tue,  6 Sep 2022 10:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662461115; x=1664275516; bh=Fpimq6VMnQbeROvd1zyJqnwMp
        JjLfHSfpqs8/l7gDSQ=; b=UEbxkTqTHGecj8s7RT9lne4V9KIhs6EXzC0Iky57D
        6Trr91o0lW+qwsZXC+E0Dd/m5doW+7jB27EhivMFOVGC8v6SrXa5xfKL0OaqnhdP
        jGDZeCTzwWl3KleAhgFpdQ2H4JHu+46U32DZnF7Ktxqb2nAiT8yCLhwXiSsx1k4+
        9I=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id D5Qu9S4NW8Dw; Tue,  6 Sep 2022 13:45:15 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CB3CF56594;
        Tue,  6 Sep 2022 13:34:44 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 13:34:44 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 13:34:41 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 5/6] scsi: target: check emulate_3pc for RECEIVE COPY
Date:   Tue, 6 Sep 2022 13:34:20 +0300
Message-ID: <20220906103421.22348-6-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906103421.22348-1-d.bogdanov@yadro.com>
References: <20220906103421.22348-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RECEIVE COPY RESULTS is an opcode from 3rd party copy command set and
shall be rejected if emulate_3pc attribute is off like EXTENDED COPY.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_xcopy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 8713cda0c2fb..edf522208285 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -1009,8 +1009,14 @@ sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
 {
 	unsigned char *cdb = &se_cmd->t_task_cdb[0];
 	int sa = (cdb[1] & 0x1f), list_id = cdb[2];
+	struct se_device *dev = se_cmd->se_dev;
 	sense_reason_t rc = TCM_NO_SENSE;
 
+	if (!dev->dev_attrib.emulate_3pc) {
+		pr_debug("Third-party copy operations explicitly disabled\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	pr_debug("Entering target_do_receive_copy_results: SA: 0x%02x, List ID:"
 		" 0x%02x, AL: %u\n", sa, list_id, se_cmd->data_length);
 
-- 
2.25.1

