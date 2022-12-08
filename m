Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFF0C63705
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiLHLDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLHLBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:01:49 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E5E20;
        Thu,  8 Dec 2022 03:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497247; x=1702033247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+2rcDb8R1vimSMhPpbJUZYO/DgWj/NmRG1DqkpYlr00=;
  b=TIal/gE+fTlBcW5PmyonxBcwt8aFPXL8oizijh3bLKsu198kGwSMqNpN
   /38WY1ZG56Y6I+IfYMb69h6dVmigrJU6woBBp6uAB9u/bEkVPzajmX/mb
   NeDzezpmmSt7jBeraACghDFTL1WmC0yDavM3aY4nnF2vsRpZ01Q90UQr3
   z3PtYhggDvqShXaEOJoAYhsb4gtnNrqbVp+Ph7TjXnFP8/7XUtIIxxeAN
   smfCWu056TNFp0uWBOYIJqCpGLzyryKvkWixyPDf7AAxI5xAvyX5xcIHC
   lJLjqFpHfFGh49lcOMDtJYG3VJBZFwAgu/3e1giKiFLB8iazcDmrq9j09
   g==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333352"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:00:47 +0800
IronPort-SDR: T773sZgtEEhsp4Yb53XJ9LUFMp0eYTVhXugqinH9jw9LxFLzl59pszY3Z6lIhzg81o4BOPIZQm
 PxmfAc8Zy7kd2yBw8/RK0kvK36Y+aP4h6bR71Coy2TTQ/QyLej8Dv009tLO5OU/Q59B46sPBD7
 GwFTyNa31g9EFvRKJuCXS57riLIRzkHw7AQXxUj46ICSABll0wNu2n9vh4yAZ2Sf5BbopGceBX
 jbywvIb0J99HxDeNwiRbYWp8njqiMj4+6DC55tYINreyH8Mw+aq2nCuPq1a4fUFLdg0M2N8Nhr
 2Is=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:32 -0800
IronPort-SDR: rwn0kGQ91q2YomI1osM1ApYS7FakkOpg4HS2A6YjuYcvEl7cU49TidaBe5n0CzoGbx/RHARXUy
 l+s9fRDrm9s4INy2A8WTOECC00elkgpqMQCNx/AgIadN0FzI/wPq7iQ4luNZpjZjk7l6DncNJE
 XZV7Z/9vC//MUTZbHwQy6Jme9AZSFI72NUvNePYhhTnIzO0QIaHG8vidWsWcl3v33E2UvbGfEk
 PxyeIqYjsIs91oUvVkUJgE4H63whxLn+foPMgNGxYHK7m6n41npmw3CdsmiVNNNK/qtc+3o0YB
 rs0=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:00:46 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 02/25] ata: libata: move NCQ related ATA_DFLAGs
Date:   Thu,  8 Dec 2022 11:59:18 +0100
Message-Id: <20221208105947.2399894-3-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ata_dev_configure() starts off by clearing all flags in ATA_DFLAG_CFG_MASK:
dev->flags &= ~ATA_DFLAG_CFG_MASK;

ata_dev_configure() then calls ata_dev_config_lba() which calls
ata_dev_config_ncq().

ata_dev_config_ncq() will set the correct ATA_DFLAGs depending on what is
actually supported.

Since these flags are set by ata_dev_configure(), they should be in
ATA_DFLAG_CFG_MASK and not in ATA_DFLAG_INIT_MASK.

ATA_DFLAG_NCQ_PRIO_ENABLED is set via sysfs, is should therefore not be in
ATA_DFLAG_CFG_MASK. It also cannot be in ATA_DFLAG_INIT_MASK, because
ata_eh_schedule_probe() calls ata_dev_init(), which will clear all flags in
ATA_DFLAG_INIT_MASK.

This means that ATA_DFLAG_NCQ_PRIO_ENABLED (the value the user sets via
sysfs) would get silently cleared if ata_eh_schedule_probe() is called.
While that should only happen in certain circumstances, it still doesn't
seem right that it can get silently cleared.

(ata_dev_config_ncq_prio() will still clear the ATA_DFLAG_NCQ_PRIO_ENABLED
flag if ATA_DFLAG_NCQ_PRIO is suddenly no longer supported after a
revalidation.)

Because of this, move ATA_DFLAG_NCQ_PRIO_ENABLED to be outside of both
ATA_DFLAG_CFG_MASK and ATA_DFLAG_INIT_MASK.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 include/linux/libata.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7985e6e2ae0e..9bba56f6d793 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -91,22 +91,21 @@ enum {
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
 	ATA_DFLAG_TRUSTED	= (1 << 8), /* device supports trusted send/recv */
 	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
-	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
+	ATA_DFLAG_NCQ_SEND_RECV = (1 << 11), /* device supports NCQ SEND and RECV */
+	ATA_DFLAG_NCQ_PRIO	= (1 << 12), /* device supports NCQ priority */
+	ATA_DFLAG_CFG_MASK	= (1 << 13) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_PIO		= (1 << 13), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 14), /* device limited to non-NCQ mode */
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
 	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
 	ATA_DFLAG_UNLOCK_HPA	= (1 << 18), /* unlock HPA */
-	ATA_DFLAG_NCQ_SEND_RECV = (1 << 19), /* device supports NCQ SEND and RECV */
-	ATA_DFLAG_NCQ_PRIO	= (1 << 20), /* device supports NCQ priority */
-	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 21), /* Priority cmds sent to dev */
-	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
+	ATA_DFLAG_INIT_MASK	= (1 << 19) - 1,
 
+	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 19), /* Priority cmds sent to dev */
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
-
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
 	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
 	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
-- 
2.38.1

