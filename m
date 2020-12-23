Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FF6C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 03:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B797520705
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 03:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgLWDFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 22:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbgLWCTK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EBFF22202;
        Wed, 23 Dec 2020 02:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689907;
        bh=MuCTss8gWjCF+n3zxjeYSjAVyq7+gciHkrm6lonSMY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPz91yGMYjS5FhZS43mRK5hEB+gL072HqDIKkT1pj6GKUHUGD3nGsmBa1sQCCbu9e
         ZozmzaZFRyESHQOlPENPplzGdzkNxuuX8+S5vwot0DrvxNECqlSlWrsaiIQpDMSsv9
         YqEa5VCzIxKCyrkGjQDmv2zyo2SirukACfO6uvl79mVejhHPiEneZFQYus/UvORqcw
         L7K5RZ+9wSpBkxO5i2r8GdMfReUBM0dijJQ+YcDAjzLEPyFPAlced4b6qs2IhkyL/v
         z55hAqeMTKmurRjtnNwJ6YbHbt8EtSWQLn5oOwp6ocziM64SI3o8edY1FSw80cTu2w
         6CkYqco57H/pQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 010/130] scsi: target: Fix cmd_count ref leak
Date:   Tue, 22 Dec 2020 21:16:13 -0500
Message-Id: <20201223021813.2791612-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 02dd4914b0bcb8fd8f8cad9817f5715a17466261 ]

percpu_ref_init sets the refcount to 1 and percpu_ref_kill drops it.
Drivers like iSCSI and loop do not call target_sess_cmd_list_set_waiting
during session shutdown, though, so they have been calling percpu_ref_exit
with a refcount still taken and leaking the cmd_counts memory.

Link: https://lore.kernel.org/r/1604257174-4524-3-git-send-email-michael.christie@oracle.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b1f4be055f838..c43e907eeba8e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -238,6 +238,14 @@ EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
+	/*
+	 * Drivers like iscsi and loop do not call
+	 * target_sess_cmd_list_set_waiting during session shutdown so we
+	 * have to drop the ref taken at init time here.
+	 */
+	if (!se_sess->sess_tearing_down)
+		percpu_ref_put(&se_sess->cmd_count);
+
 	percpu_ref_exit(&se_sess->cmd_count);
 }
 
-- 
2.27.0

