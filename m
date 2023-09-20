Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBF2CE79CE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbjITNzn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbjITNzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3754B1B2;
        Wed, 20 Sep 2023 06:55:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E52C433C8;
        Wed, 20 Sep 2023 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218100;
        bh=vlZ6csb9Q5BK6QmDyw1fLvkxiQLw4ZKZ7aDbedi2UlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5pPn4glTkyMG6wwO+eSzqh/MudkglIPl2lI1q2jtZmIDJu6GVTiUZyl6Kcq+4eug
         QsbOTYpn7s65QewIubSsPEcGOhkoDI0cYsgJZQtfJNcPRQ1m1Ua1N7x/x9UTMJv+lh
         6bLdqzHeq6BMjp2N/TdNDpheyTHWQPZunWAF357WVsI4anudweMDVrqCnZy+2KwbmQ
         SZoWMjcMOPFfeTZDyljtWLScQpb8gZUooQmb9Edc3hXBlaKKWiCPkiPtMBCv6ShMa8
         z5F+VNVJJgHoPpID6JYsBfwYiQ297TjeQOx2kWKLKWj+o/gJX7ZsOBVj2YV6Kf25Rj
         OtBJ5y4Aqugfg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v4 10/23] ata: libata-core: Fix compilation warning in ata_dev_config_ncq()
Date:   Wed, 20 Sep 2023 22:54:26 +0900
Message-ID: <20230920135439.929695-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 24 bytes length allocated to the ncq_desc string in
ata_dev_config_lba() for ata_dev_config_ncq() to use is too short,
causing the following gcc compilation warnings when compiling with W=1:

drivers/ata/libata-core.c: In function ‘ata_dev_configure’:
drivers/ata/libata-core.c:2378:56: warning: ‘%d’ directive output may be truncated writing between 1 and 2 bytes into a region of size between 1 and 11 [-Wformat-truncation=]
 2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
      |                                                        ^~
In function ‘ata_dev_config_ncq’,
    inlined from ‘ata_dev_config_lba’ at drivers/ata/libata-core.c:2649:8,
    inlined from ‘ata_dev_configure’ at drivers/ata/libata-core.c:2952:9:
drivers/ata/libata-core.c:2378:41: note: directive argument in the range [1, 32]
 2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
      |                                         ^~~~~~~~~~~~~~~~~~~~~
drivers/ata/libata-core.c:2378:17: note: ‘snprintf’ output between 16 and 31 bytes into a destination of size 24
 2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2379 |                         ddepth, aa_desc);
      |                         ~~~~~~~~~~~~~~~~

Avoid these warnings and the potential truncation by changing the size
of the ncq_desc string to 32 characters.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 261445c1851b..d8cc1e27a125 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2619,7 +2619,7 @@ static int ata_dev_config_lba(struct ata_device *dev)
 {
 	const u16 *id = dev->id;
 	const char *lba_desc;
-	char ncq_desc[24];
+	char ncq_desc[32];
 	int ret;
 
 	dev->flags |= ATA_DFLAG_LBA;
-- 
2.41.0

