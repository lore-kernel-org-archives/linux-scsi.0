Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496EEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281C022CA1
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:46:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GJo6qLO2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgHEJp5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbgHEJpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 05:45:23 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E37C06179F
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 02:45:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d19so566666pgl.10
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 02:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=frtssFZl2k+0RW8Ck7DYyWzCIdpJFd7XWZU4HUn8FDM=;
        b=GJo6qLO2DueEWHf/94R5+/cCa4AVCNBDq3GR5hJT13yWVC9MBQLlIqfjLwdIX1IJMg
         vPGqfSBI6DrK9+a/rCxMrwgCEb+gL9DVOA/zArSFaDK9TVI6o3agt24tkYZeLA3eE9M2
         xgv1sy4S2L5TpkbOO87OaVIeLidoXEA3B+r3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=frtssFZl2k+0RW8Ck7DYyWzCIdpJFd7XWZU4HUn8FDM=;
        b=TgnOg8xYezR6qyO8Ory19wtQ+dXnc28q/sjyqWR/xQLiSnPmFPkVAS+goBkHxeNUEN
         kPjyn9BXttLYroDKIjnJhr/3F4uqsBbQFof0zeIP0n02yRez8wdoGN2Y1Pkf7ZXcPvkv
         VbycE73JSIjLaByuz3k3c7SekUAPWLztE/7OkKhyhu0jlOpD9hdIMHS8vjagDYcBIfJg
         jIZKwF3jTgIrLgBn28N3Ivyeda7Td2qXCLX3wifEpyxXFvpxizF7nNEdeUbSf6U1rfIR
         TrqsyJhGz73PyDge2d98c8ckyFhzBWwjRMtI3zQ/c+4n7KtSYuQSPOpUXk3tUBh9R436
         3bTg==
X-Gm-Message-State: AOAM532UgU82kEx11M4FNrrpVt3po1fhcNP2RjY9QiNn2+fdwy0O9SNu
        Kw3JV1TG1UfSc0R3HhtJ5GxurKfWh29ya3SUqbpdsV7xH8uHGU2h2TUa4/nHbHNd4vp5mv+k0Um
        fXg+8wXb7Dny8zPBJiVCtTQ1rn6QM1Iu+3Il2LzutqRcEYlTurdABHgy2glr75Q9QgGfHXqPmhx
        QMAr4/Jg==
X-Google-Smtp-Source: ABdhPJzuziSQVUqzqGRsjKsr59dJcNgZ+r23cQ3ozntBCTV3D3tCEHSMtWjyqh2aNgnUVyDlRywEjw==
X-Received: by 2002:aa7:96e5:: with SMTP id i5mr2512780pfq.108.1596620721137;
        Wed, 05 Aug 2020 02:45:21 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e9sm2632346pfh.151.2020.08.05.02.45.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:45:20 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH 3/5] scsi: No retries on abort success
Date:   Wed,  5 Aug 2020 08:21:00 +0530
Message-Id: <1596595862-11075-4-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Made an additional check in scsi_noretry_cmd to verify whether user has
decided not to do retries on abort(issued on scsi timeouts) success  by
checking the SCMD_NORETRIES_ABORT bit

If SCMD_NORETRIES_ABORT bit is set we are making sure there won't be any
retries done on the same path and also setting the host byte as
DID_TRANSPORT_FAILFAST so that the error can be propogated as recoverable
transport error to the blk layers.

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/scsi_error.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 927b1e6..3222496 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1749,6 +1749,16 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 
 check_type:
 	/*
+	 * Check whether caller has decided not to do retries on
+	 * abort success by setting the SCMD_NORETRIES_ABORT bit
+	 */
+	if ((test_bit(SCMD_NORETRIES_ABORT, &scmd->state)) &&
+		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
+		set_host_byte(scmd, DID_TRANSPORT_FAILFAST);
+		return 1;
+	}
+
+	/*
 	 * assume caller has checked sense and determined
 	 * the check condition was retryable.
 	 */
-- 
1.8.3.1

