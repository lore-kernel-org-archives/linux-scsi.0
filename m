Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D26ECAAD3
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 09:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiIIJFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiIIJE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 05:04:58 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75509481C4;
        Fri,  9 Sep 2022 02:04:36 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DAC0A569A1;
        Fri,  9 Sep 2022 09:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662714272; x=1664528673; bh=zY9RGnCqcMkPkgU1gg/t1KEg8
        tohN+IGeE+GiJntX90=; b=G47iDOkm0sSY4sJZF9WOxvsY25Or8u+GGrFMFguLm
        4UtWrk61MhP/pZyfk143GAIWlozc56D9nBoxPrtzjhaPPlRonY7RYh7wZkLJPBwu
        WPGAEJfahPApp1CGIs1SfpPyW5uL3X9Z6nmV/Grfhun9CjYT/wiuOycqWubBkOEC
        Cc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IgRJlxtfjojk; Fri,  9 Sep 2022 12:04:32 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 81D3A56986;
        Fri,  9 Sep 2022 12:04:32 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 12:04:31 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Fri, 9 Sep 2022 12:04:31 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 1/4] target: core: fix preempt and abort for allreg res
Date:   Fri, 9 Sep 2022 12:04:22 +0300
Message-ID: <20220909090425.14479-2-d.bogdanov@yadro.com>
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

Match a key only if SARK is not zero according to SPC-4 and the comment
above the code:
 If an all registrants persistent reservation is present and the SERVICE
 ACTION RESERVATION KEY field is set to zero, then all registrations
 shall be removed except for that of the I_T nexus that is being used
 for the PERSISTENT RESERVE OUT command;

Without this patch in case of SARK==0 no registrants will be removed.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
  remove superfluous parentheses
---
 drivers/target/target_core_pr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a1d67554709f..1521a97ddac2 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3022,7 +3022,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		if (calling_it_nexus)
 			continue;
 
-		if (pr_reg->pr_res_key != sa_res_key)
+		if (sa_res_key && pr_reg->pr_res_key != sa_res_key)
 			continue;
 
 		pr_reg_nacl = pr_reg->pr_reg_nacl;
-- 
2.25.1

