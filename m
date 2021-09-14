Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD53EC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4034610FB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhINK5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 06:57:11 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42346 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231732AbhINK5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 06:57:07 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C85A941E83;
        Tue, 14 Sep 2021 10:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1631616947; x=1633431348; bh=3uof/WYmN8pkogEl14wt0VHVbH++rlYsqbL
        vT+pPh+U=; b=EshRlj22/tXAXW+WiQz3zdpYbykbbips2HgoRt+UzF9m2bAfTn2
        YtAqGFIyWOZYu5e87Q0iP7O/vQmUzIHm6mI5XSgoIwCouZ2U0HZhoRNAeg0Oq4P/
        TfjwaIYdHgKwMyy+l9ngvEuV2G0xTnUgP8R+PYgBYG7gHN8qw9DDT/uI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qytEVc-o97Xg; Tue, 14 Sep 2021 13:55:47 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DD93141E95;
        Tue, 14 Sep 2021 13:55:47 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.9) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 14
 Sep 2021 13:55:46 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        James Smart <james.smart@broadcom.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 1/3] scsi: efct: add state in nport sm trace printout
Date:   Tue, 14 Sep 2021 13:55:37 +0300
Message-ID: <20210914105539.6942-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914105539.6942-1-d.bogdanov@yadro.com>
References: <20210914105539.6942-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.9]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similar to other state machine traces and to make debug easier add the
state name to nport sm trace printout.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/elx/libefc/efc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc.h b/drivers/scsi/elx/libefc/efc.h
index 927016283f41..468ff3cc9c00 100644
--- a/drivers/scsi/elx/libefc/efc.h
+++ b/drivers/scsi/elx/libefc/efc.h
@@ -47,6 +47,6 @@ enum efc_scsi_del_target_reason {
 
 #define nport_sm_trace(nport) \
 	efc_log_debug(nport->efc, \
-		"[%s] %-20s\n", nport->display_name, efc_sm_event_name(evt)) \
+		"[%s]  %-20s %-20s\n", nport->display_name, __func__, efc_sm_event_name(evt)) \
 
 #endif /* __EFC_H__ */
-- 
2.25.1

