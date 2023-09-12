Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC24DCA0EC8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjILCHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbjILCCC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:02:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838841A4BCB;
        Mon, 11 Sep 2023 18:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6CFC32791;
        Tue, 12 Sep 2023 00:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480227;
        bh=44l0Mp8cg8u5dMXZhVw61tV4c5nbQZJ+oJw++vvJt+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omJcYTSHdDWHGBcu7bJ1/f+ab5Eb908etpse/yre3YdYBQs7fN2eWJ9tMB0jr3XiN
         fwjlfiCEK/5KYWGlNIcPsJleedkh33vT7x+VAxQp40ozdKOnU+R5UUPGiX/TLuRgId
         pRZu5cfzjIfhaPJlkkejHZvtEteZZbfTgTjphpuCHjht1fu73oan8WPCQs/zUpgX4K
         V3hHUABfCC5WrBD9YFe/1UmghLKt9/5LbPcpxrGtjyhp5/e5fnLzU25l7/A9Fb9GNY
         dsyO3BOs+TEeVxFG59ONtr805M/7AMQhfczlrb3DBLxDibF3TtvixEk6F5F64tHj6J
         Yl/LglI4I+AMQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 06/21] ata: libata-core: Do not register PM operations for SAS ports
Date:   Tue, 12 Sep 2023 09:56:40 +0900
Message-ID: <20230912005655.368075-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libsas does its own domain based power management of ports. For such
ports, libata should not use a device type defining power management
operations as executing these operations for suspend/resume in addition
to libsas calls to ata_sas_port_suspend() and ata_sas_port_resume() is
not necessary (and likely dangerous to do, even though problems are not
seen currently).

Introduce the new ata_port_sas_type device_type for ports managed by
libsas. This new device type is used in ata_tport_add() and is defined
without power management operations.

Fixes: 2fcbdcb4c802 ("[SCSI] libata: export ata_port suspend/resume infrastructure for sas")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c      | 2 +-
 drivers/ata/libata-transport.c | 9 ++++++++-
 drivers/ata/libata.h           | 2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0479493e54bd..18b2a0da9e54 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5339,7 +5339,7 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
 #endif
 
 const struct device_type ata_port_type = {
-	.name = "ata_port",
+	.name = ATA_PORT_TYPE_NAME,
 #ifdef CONFIG_PM
 	.pm = &ata_port_pm_ops,
 #endif
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index e4fb9d1b9b39..3e49a877500e 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -266,6 +266,10 @@ void ata_tport_delete(struct ata_port *ap)
 	put_device(dev);
 }
 
+static const struct device_type ata_port_sas_type = {
+	.name = ATA_PORT_TYPE_NAME,
+};
+
 /** ata_tport_add - initialize a transport ATA port structure
  *
  * @parent:	parent device
@@ -283,7 +287,10 @@ int ata_tport_add(struct device *parent,
 	struct device *dev = &ap->tdev;
 
 	device_initialize(dev);
-	dev->type = &ata_port_type;
+	if (ap->flags & ATA_FLAG_SAS_HOST)
+		dev->type = &ata_port_sas_type;
+	else
+		dev->type = &ata_port_type;
 
 	dev->parent = parent;
 	ata_host_get(ap->host);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index a5ee06f0234a..c57e094c3af9 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -30,6 +30,8 @@ enum {
 	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
+#define ATA_PORT_TYPE_NAME	"ata_port"
+
 extern atomic_t ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;
-- 
2.41.0

