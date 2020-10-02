Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80293C4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 07:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB9220874
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 07:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSnIaXvV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgJBHds (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgJBHds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 03:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601624027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wBXzihMG2sj/H713MdZMBi9VEglJ/cPQiGjlk1VaOfY=;
        b=dSnIaXvV9SYKnTDg/dS9zwJ1xg5Ft1Y+HAZheZ6hlHw+g8/xZY2K5uSqxFCgLQf7BUDMKv
        2WvoGaVETgg5LNu7elkqE3q/5wDQ2ZoEYMZPTXLr6lRuKszxg+Td4P1XLcIZ91fXi97H8M
        7aYVMcnqDL8G99fwR0zw6i/0CE/P2ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-sjX1v1weNQKoUMeghcmigw-1; Fri, 02 Oct 2020 03:33:45 -0400
X-MC-Unique: sjX1v1weNQKoUMeghcmigw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B49C1006701;
        Fri,  2 Oct 2020 07:33:44 +0000 (UTC)
Received: from nangaparbat.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF3EA19C78;
        Fri,  2 Oct 2020 07:33:42 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
Subject: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list corruption early"
Date:   Fri,  2 Oct 2020 09:33:41 +0200
Message-Id: <20201002073341.12470-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit b0055acaedf56a2717a6e2a4b700f1959a1b60df.

This warning is duplicated because the very same condition
is already checked in __iscsit_free_cmd().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 45ba07c6ec27..ff7830ddbd7b 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -764,8 +764,6 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
 	int rc;
 
-	WARN_ON(!list_empty(&cmd->i_conn_node));
-
 	__iscsit_free_cmd(cmd, shutdown);
 	if (se_cmd) {
 		rc = transport_generic_free_cmd(se_cmd, shutdown);
-- 
2.26.2

