Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07421C71153
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjIKEDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjIKEC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45F11BE;
        Sun, 10 Sep 2023 21:02:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05554C433C8;
        Mon, 11 Sep 2023 04:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404969;
        bh=vqzkUUP3N9azAe/Qwg9XhX6L+Y6At/1NJvewATcW2EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYWLXbhPn2QrsFWKNB51Lzkis8wQ4SMoIpi7lvEGH5TKlfxokHXpzvKSlZcKLNrpg
         YmI14K5eNxd1OyHU4gQTLAwsLhLt9x00Uh1v8yGEMYdUbyKBRfQ6iuojFfmmrzhQnp
         ely+LSvhlY+dME2tp6/zjxv7dbqG4yPRKdHTd9kkVN8YMujaZRrJGk/9PcwJKWZHbj
         o0EiiXuhf7Fwq4zsLEqrVLEvajLVX06iImiTMx1269O3ZMcwXkpyxSgRnDFXfiuvIZ
         G3eqnXhSWOHGTdAnrTtLDgMBgLITLR2ojgM4nKjsLgtEW6EexSRAPni7OJCIuMtCEm
         85ITMAAupkNCg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 15/19] ata: libata-core: Do not resume ports that have been runtime suspended
Date:   Mon, 11 Sep 2023 13:02:13 +0900
Message-ID: <20230911040217.253905-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi disk driver does not resume disks that have been runtime
suspended by the user. To be consistent with this behavior, do the same
for ata ports and skip the PM request in ata_port_pm_resume() if the
port was already runtime suspended. With this change, it is no longer
necessary to for the PM state of the port to ACTIVE as the PM core code
will take care of that when handling runtime resume.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c4a32abc2e29..26e94edf5103 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5234,10 +5234,8 @@ static void ata_port_resume(struct ata_port *ap, pm_message_t mesg,
 
 static int ata_port_pm_resume(struct device *dev)
 {
-	ata_port_resume(to_ata_port(dev), PMSG_RESUME, true);
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	if (!pm_runtime_suspended(dev))
+		ata_port_resume(to_ata_port(dev), PMSG_RESUME, true);
 	return 0;
 }
 
-- 
2.41.0

