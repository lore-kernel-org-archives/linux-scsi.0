Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CBEC4320A
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 13:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E28660F94
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 13:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhHDNt7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 09:49:59 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:52574
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238388AbhHDNty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 09:49:54 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0DE9A3F07D;
        Wed,  4 Aug 2021 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628084981;
        bh=LHgwEwJwBhA3Jk9szjE12QvXSxeY8OwPwHuc0stiIR4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=L30q+nS1jlA+p2VWODnXXL5HN3Ci4YCBOFyx12RDgNM4tA//GKihhdGuQbxL57gFi
         p64WS0kG/ym8EQ0MzKucqez2arjZgXKy05E/m59qjW0vxvNZKLpZYihkOtNtnjlFOF
         6y11kk6s5BuITBuFTe2r4FoUEA5GKceVcKIwZ7pp7jIHl23Q4jVk49P9UQ9ppfjVkD
         eIpwrZXMQ1eBXpGyQ1bMLDeYXdulfZwFSg5u4o+voQq6ei2w+Z1aeZREaR/+Jux14x
         qpBZU0JmprjAqt/BkcKOpZoCW/AUw3KZm087QXD7gLi+bmioo4wIsoF0PREM5VKcIq
         kqKfwRM3e/G7Q==
From:   Colin King <colin.king@canonical.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Fix incorrectly assigned error return and check
Date:   Wed,  4 Aug 2021 14:49:40 +0100
Message-Id: <20210804134940.114011-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the call to _base_static_config_pages is assigning the error
return to variable rc but checking the error return in error r. Fix this
by assigning the error return to variable r instread of rc.

Addresses-Coverity: ("Unused value")
Fixes: 19a622c39a9d ("scsi: mpt3sas: Handle firmware faults during first half of IOC init")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 19b1c0cf5f2a..cf4a3a2c22ad 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7851,7 +7851,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 			return r;
 	}
 
-	rc = _base_static_config_pages(ioc);
+	r = _base_static_config_pages(ioc);
 	if (r)
 		return r;
 
-- 
2.31.1

