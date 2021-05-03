Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DB0C19777
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 17:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDAEE61059
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 17:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhECQ7V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 12:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235317AbhECQ4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 12:56:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C06BD6197C;
        Mon,  3 May 2021 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060211;
        bh=oda4eqHRVFvsClBa5OXXc3KjLxo1xhYRA+i0CkL0TGM=;
        h=From:To:Cc:Subject:Date:From;
        b=jyc+Bhvgp8WRlV5awzPbfUPhAoLA8+g+jfcdee4iJUWomZOd7BxtScHBaaUVlrSMc
         NpVrfTeo4n8xI+yVuAAAtwkvvdE8LQewS6unDCPsrt23tYNDIpVZBhkj6AG3awLMws
         kY7w4TUXdLh6Vcdhpy4Pjy+y1D4O1KUW21J+eqSIKk8NOZFf3xAoFAV9HLDObSKYIa
         LhR0CthMXomJvZAfGPmAqw/NrQfy7Con9MdSuOeymCnpzhsNUjGGayWiXRyGf9N6NV
         1TyrihvxYH2ODRZYdvexy0bVtiOz7jQljvoif6ZaYgzhW5NuiXrkQwfqx2VH3a6x0A
         31S2jibbQsfdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/16] scsi: target: pscsi: Fix warning in pscsi_complete_cmd()
Date:   Mon,  3 May 2021 12:43:14 -0400
Message-Id: <20210503164329.2854739-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit fd48c056a32ed6e7754c7c475490f3bed54ed378 ]

This fixes a compilation warning in pscsi_complete_cmd():

     drivers/target/target_core_pscsi.c: In function ‘pscsi_complete_cmd’:
     drivers/target/target_core_pscsi.c:624:5: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
     ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */

Link: https://lore.kernel.org/r/20210228055645.22253-5-chaitanya.kulkarni@wdc.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index d72a4058fd08..0ce3697ecbd7 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -629,8 +629,9 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
 			unsigned char *buf;
 
 			buf = transport_kmap_data_sg(cmd);
-			if (!buf)
+			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
+			}
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
-- 
2.30.2

