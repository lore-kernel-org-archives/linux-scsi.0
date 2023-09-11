Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E099EEB580
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjIKEDA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbjIKECx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04280CD1;
        Sun, 10 Sep 2023 21:02:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF43C433C9;
        Mon, 11 Sep 2023 04:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404967;
        bh=VOmvAS9Fp5vZ53X0cdqel0TmIY5kauWrYDHV0Bi7mUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1o2e3i38nMJRM8LJsLnMjnkbbzBWLpW5gSLO0yhi+4uF78whLKk7sLvUT613Rq0W
         2p5hd4uKrJi9aX7cQEC5+sLO0dK1/X55CD//UHo2Grf6A7f1QWsM4w7hWcDkcHpcRf
         XW3D2TBzo2Gg6VpIjN38LrnfLAbDqmTR4FE1TP4xeaFQsAz1+Js32IPE1MM2hZNq48
         UAIFQZwnbZzK7lGuCAkm3P8XtquYzZdpd9sOvUXFZ7MjE256COFjNiLRNH+L9CQr7n
         7yKftgR7lUvGFP4JnoV7BKr6CtMRdpM900hSc/ADAUlYYySb86L462cL7W//EcH1Dy
         5nH/OKio3rlkw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 14/19] ata: libata-core: skip poweroff for devices that are runtime suspended
Date:   Mon, 11 Sep 2023 13:02:12 +0900
Message-ID: <20230911040217.253905-15-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When powering off, there is no need to suspend a port that has already
been runtime suspended. Skip the EH PM request in ata_port_pm_poweroff()
in this case.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8fa5fbae14f3..c4a32abc2e29 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5219,7 +5219,8 @@ static int ata_port_pm_freeze(struct device *dev)
 
 static int ata_port_pm_poweroff(struct device *dev)
 {
-	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
+	if (!pm_runtime_suspended(dev))
+		ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
 	return 0;
 }
 
-- 
2.41.0

