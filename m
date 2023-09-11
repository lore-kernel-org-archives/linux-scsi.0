Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C180C71153
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjIKEDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjIKEC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D563CDC;
        Sun, 10 Sep 2023 21:02:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8B2C433C7;
        Mon, 11 Sep 2023 04:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404971;
        bh=oCqGCG+suxpdn2gOtDZNLa9sZNbW1Mf0EOZ2yRMQ2vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJIbrMYxuGZMnGmpj4gXa8M/zi9e3u91eGXMmC0vgEp05NM9eVDn6DmvI4Zi7pAFx
         vPhZBRIk+OtNUgT/SYCc2wIyid3JELRE4k3dNuZksepqDGqWSXq70gixh2335RiDCu
         fGsjdPjlB6bS2IUA4PTNEu/Sh7Bm4q2TPcV4+u4c3GeFwic7Dyts9AA9ScVlUfwg0T
         bMd4e/+Jy0STRaqtEyIRORQl+5K5w+txlQ7HDRuY0x700AlGSWR23rxYY/yL4YqUZm
         Cet5TgAKQJwv2tWNXpEvfYMgGgkwRZKhaWVNcWa5CcQf3qYuTqj5PQGnfPUAH+T4r8
         NJFhW7q7PrV2g==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 16/19] ata: libata-sata: Improve ata_sas_slave_configure()
Date:   Mon, 11 Sep 2023 13:02:14 +0900
Message-ID: <20230911040217.253905-17-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change ata_sas_slave_configure() to return the return value of
ata_scsi_dev_config() to ensure that any error from that function is
propagated to libsas.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-sata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 5d31c08be013..0748e9ea4f5f 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1169,8 +1169,8 @@ EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
 int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
 {
 	ata_scsi_sdev_config(sdev);
-	ata_scsi_dev_config(sdev, ap->link.device);
-	return 0;
+
+	return ata_scsi_dev_config(sdev, ap->link.device);
 }
 EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
 
-- 
2.41.0

