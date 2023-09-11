Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223F5EEB581
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbjIKECo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjIKECi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE2619C;
        Sun, 10 Sep 2023 21:02:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A0FC433C7;
        Mon, 11 Sep 2023 04:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404952;
        bh=zt8SHfm0S1ydGUW/ZIcmoSrvhaFT5I6eBfc0hnmzxZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2Vguqvh0RHFPVowRaVWejivzVRExgs/tiLCszscZ0ewLQpJDPYPAro2LGtcVK0zg
         ZxA6U/FmJ2tP+yQ1FGgSCFlWL0WNAc9Ow/BE64FYf8Ma8eExjL+YCkTOLrB2p13UTD
         +y9OzCvW2vjHQWu1jSaYTEQfxHHyJu4N25verZaKeYTGN+6DQ6he6QX+fwz4rm70K2
         CvIEPZzJyRkycBGrxgLvs3FdHjRH90usLy3sulAzenfz0U710Llu9IGQ5ESHpspPxq
         rR87DbHgKrZeGxSITiuLOU1wbMg3XrElFvfrlFpB9LRXVQQ1D13aNqU86a7Y0YnuqD
         XwlEGKZxvOnJQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 06/19] ata: libata-core: Do not register PM operations for SAS ports
Date:   Mon, 11 Sep 2023 13:02:04 +0900
Message-ID: <20230911040217.253905-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
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

