Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6532C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 22:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2C9D61369
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 22:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbhDLWpD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 18:45:03 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:59400 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238085AbhDLWpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:02 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B421C4131F;
        Mon, 12 Apr 2021 22:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1618267481; x=1620081882; bh=O5BTYwJ2JKWPj/2J9QOM17wsJDWxcagYBhR
        xvCDKGyI=; b=cTxX8oIaFIF4kinknPC11b3egWBm6ZSJjOQrTsBvL35J74HxSkg
        x780j+341SiAajuaVyIdSuQgEyzKbInJp2D0R4fGMWvT8NqL1/+wXtJ8BAk5dv9E
        4OQrI+q1T3gXrz5MIUsELoDYMw3VKi55h0NWFWFYqiIpkMCMzIkWhNVE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fPI0Jz4EO5jy; Tue, 13 Apr 2021 01:44:41 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BF95F4131D;
        Tue, 13 Apr 2021 01:44:41 +0300 (MSK)
Received: from yadro.com (10.199.0.123) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 13
 Apr 2021 01:44:41 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/2] scsi: target: Bump INQUIRY VERSION to SPC-4
Date:   Tue, 13 Apr 2021 01:44:26 +0300
Message-ID: <20210412224427.101167-2-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412224427.101167-1-k.shelekhin@yadro.com>
References: <20210412224427.101167-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.123]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bump the SCSI primary command set standard to SPC-4. The upcoming
version descriptors will report newer SCSI standards (like SBC-3) that
are not defined in SPC-3.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 70a661801cb9..c42a954ce641 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -58,7 +58,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
 		buf[1] = 0x80;
 
-	buf[2] = 0x05; /* SPC-3 */
+	buf[2] = 0x06; /* SPC-4 */
 
 	/*
 	 * NORMACA and HISUP = 0, RESPONSE DATA FORMAT = 2
-- 
2.31.1

