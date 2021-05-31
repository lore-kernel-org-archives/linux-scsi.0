Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3659CC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 12:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A61E6124B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 12:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhEaM0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 08:26:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:37242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhEaM0a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 08:26:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622463889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Fv21S2Zk60md3u9UlHZ+Etq+/A/gbvSCbi0VXTqWPMA=;
        b=UNLdCbFKQLMYTGzqRKHFzPungHFHE4lxDKNEKRndYR9fDVL9aZmr/M4QHvovWAfdy+kRd2
        P5wFW6JUPSGEHm1e/BDyyb+MqcLpzU6PejJB0M4FXM4R1wdVe00iYzb16kr7Ui8XKRqnTb
        +wf8vdqR9C6CgZGUbJv9jwTBdt7RCwk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622463889;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Fv21S2Zk60md3u9UlHZ+Etq+/A/gbvSCbi0VXTqWPMA=;
        b=dPMHLgwm2nna5cgaXOgG1PRovmgXAoWsFoY6b1QE989hHkaphIXiaVB6UxVYaNyestm8Ma
        hcOyOIU94LeOLDCA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BEBE5AE72;
        Mon, 31 May 2021 12:24:49 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: Log PCI address in qla_nvme_unregister_remote_port()
Date:   Mon, 31 May 2021 14:24:44 +0200
Message-Id: <20210531122444.116655-1-dwagner@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass in fcport->vha to ql_log() in order to add the PCI address to the
log.

Currently NULL is passed in which gives this confusing log entry:

> qla2xxx [0000:00:00.0]-2112: : qla_nvme_unregister_remote_port: unregister remoteport on 0000000009d6a2e9 50000973981648c7

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 0cacb667a88b..e119f8b24e33 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -671,7 +671,7 @@ void qla_nvme_unregister_remote_port(struct fc_port *fcport)
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return;
 
-	ql_log(ql_log_warn, NULL, 0x2112,
+	ql_log(ql_log_warn, fcport->vha, 0x2112,
 	    "%s: unregister remoteport on %p %8phN\n",
 	    __func__, fcport, fcport->port_name);
 
-- 
2.29.2

