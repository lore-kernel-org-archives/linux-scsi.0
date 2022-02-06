Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12BDC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Feb 2022 20:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240989AbiBFUce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Feb 2022 15:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbiBFUcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2022 15:32:32 -0500
X-Greylist: delayed 546 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 12:32:31 PST
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D53C06173B
        for <linux-scsi@vger.kernel.org>; Sun,  6 Feb 2022 12:32:31 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9E21C210E4;
        Sun,  6 Feb 2022 20:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644179004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Pj2I0rsfuTgQ4bLw61zz9Pz4kkPloZvvSo9ZV3lV6og=;
        b=QqZxUC3KoVjRNVX+LeMPeQAtLG6AIla4b4OlTH+e8D3ASbpnAM8ZAYV7I7dn//dG6FfVwK
        sZQpzr0jLvP8oUrm5DlwN2hhGtPBfG4qRpSnaxNDagwj3eDki1OgjILiiN60jT9WXT93dl
        CzWp+xsjeT6u17b8f9BfF6HdXQ/0YXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644179004;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Pj2I0rsfuTgQ4bLw61zz9Pz4kkPloZvvSo9ZV3lV6og=;
        b=A1bZeEG0cDALoMlWtSKIP3mjGvTxnORdD0ksGAm8IUUuP0g+YMqWlTw3K4PD7F8hU7b7Kc
        c7hOzmEulIFbyVAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E7A4139EF;
        Sun,  6 Feb 2022 20:23:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5dYHHjwuAGL+MgAAMHmgww
        (envelope-from <dmueller@suse.de>); Sun, 06 Feb 2022 20:23:24 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        James Bottomley <James.Bottomley@SteelEye.com>,
        =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
Subject: [PATCH v2] qla2xxx: fix error status checking in qla24xx_modify_vp_config()
Date:   Sun,  6 Feb 2022 21:23:11 +0100
Message-Id: <20220206202311.19392-1-dmueller@suse.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function was checking vpmod->comp_status and reported it as error
status, which is however already checked a few lines below.

Guessing from other occurrences it was supposed to check entry_status
instead.

Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Signed-off-by: Dirk Müller <dmueller@suse.de>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 10d2655ef676..28fdd80e1e4d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4253,10 +4253,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
 		    "Failed to issue VP config IOCB (%x).\n", rval);
-	} else if (vpmod->comp_status != 0) {
+	} else if (vpmod->entry_status != 0) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10be,
 		    "Failed to complete IOCB -- error status (%x).\n",
-		    vpmod->comp_status);
+		    vpmod->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vpmod->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bf,
-- 
2.35.1

