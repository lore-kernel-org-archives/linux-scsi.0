Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463CDC7EE2D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 01:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjFEBcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jun 2023 21:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjFEBcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2023 21:32:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EC5BC;
        Sun,  4 Jun 2023 18:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CE6960BDB;
        Mon,  5 Jun 2023 01:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0CDC433EF;
        Mon,  5 Jun 2023 01:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685928735;
        bh=z7a2AsF7SuoQCtQgPKBcjmXe8UPStzsCuEbrWENzIWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOfsGjlUXEhlJ3oB997GPzGlumvlygp2sz3ez4oTk+9wBlHHKQDzmkGTK5VICbM3H
         ZdoJNOA003eXabczOm40fOaZYDBAmFE+RTLpQi8rRgIvZRIVP0io2oXVEnT4d5Po32
         lctgjioy0bpuxOm4cRO6pP2BD8okWqDLpCipUVhXW7cllNv30NuIm9wRFVwLkFGHLY
         gKGVbjwhQkm3GySdXWrFMLuqLV74LMzfp3eoGHpZSnUf4jwMdKyRS8BKdouC4SBBwI
         xx5qCn3NkXMLZUQmudqp8SwBzMGpytiD3Wc3GJHBo9vNiiPBXOrUh5qOnZ/+mbIbL1
         sb+uSMV+UI+EA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 2/3] ata: libata-eh: Use ata_ncq_enabled() in ata_eh_speed_down()
Date:   Mon,  5 Jun 2023 10:32:11 +0900
Message-Id: <20230605013212.573489-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605013212.573489-1-dlemoal@kernel.org>
References: <20230605013212.573489-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of hardconfign the device flag tests to detect if NCQ is
supported and enabled in ata_eh_speed_down(), use ata_ncq_enabled().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a6c901811802..c0993d755e8d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1817,9 +1817,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
 	verdict = ata_eh_speed_down_verdict(dev);
 
 	/* turn off NCQ? */
-	if ((verdict & ATA_EH_SPDN_NCQ_OFF) &&
-	    (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ |
-			   ATA_DFLAG_NCQ_OFF)) == ATA_DFLAG_NCQ) {
+	if ((verdict & ATA_EH_SPDN_NCQ_OFF) && ata_ncq_enabled(dev)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
 		ata_dev_warn(dev, "NCQ disabled due to excessive errors\n");
 		goto done;
-- 
2.40.1

