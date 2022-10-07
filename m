Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E8BC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Oct 2022 13:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJGNYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Oct 2022 09:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiJGNYB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2022 09:24:01 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9F2D01BF
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 06:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665149039; x=1696685039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VwK5hWn3Fq1jl8EHUvDOpipOTYDAcnYPnxBi5VA2Wag=;
  b=Uw7IRv/X7GWLMO7LOsNw16/RT3xAvL0HL2HXMk5vtkZp2rfav0AeRsq8
   7hV5Rtqj+lhViuHx3vJgFL1Ij2UcDwAVac0QzStO4DoGEGo8rWKTjGJ1A
   4EuS+iQIJUvD8jSULt3uwKyFk5v/x6qCx25eHHnEykKypMjl7VivJ2y9V
   5UR1VzNHXkGLGHxuoFpRj43R6Gd1O/qNOQ9ZnkY0JE44jiyD/KaqzvUKn
   +3KBII66mo8Bm2hEhK0Fo01BPmXaUZLcinLcbccuzTorPbX140bwkGIM7
   85zMkSGVMKUen+8COb5YDoEuqhIbZDSqF0BnfIVeMW93eE0KL1HzM79Cq
   g==;
X-IronPort-AV: E=Sophos;i="5.95,166,1661788800"; 
   d="scan'208";a="213238174"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Oct 2022 21:23:59 +0800
IronPort-SDR: RGhcho9LBEsxsTSLoBFCG6aoZz6zopty7ZmNc82tLKJ39KxHb9Ojttm63UG8vNXBqrNsjeHY8X
 5Qrygp1dJwbIcQ+bk5ZPqjw4pbA8HfKkKfInoAobxP1hv8L9RVz9X/eDXwlkswdsRpWnQb3r8d
 +ZlH/vhREsOl2r1c0E3O1tocGAGUUGnFiKaEbAKDiesyQFeRWNQbW9muYBeGwh/i5qLJu1ELvN
 YcPauFWh+5C873wDBn62ia7CMY4fMs+oIH88iCcxIcXwSrxRHiWfjeIwzXz24MIrVZBfxFhcZb
 zwUwTIMcEqU/eLdw/y3Kptr5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2022 05:38:09 -0700
IronPort-SDR: zFgnxc7515cnqxauiH8N+hEpCAqJRVGXBxF1NDMgVrHWMreo+iew5FI+PPk9KEXcFDlHirharV
 dsjp37DAhVa8MSBSuUkmqBkROtdyNlCae9WrjGN4uoT3yG89YsqynRxsuH0ZOzMyl7WbXSL6tK
 UWkkRhg68ilSjOQ5izg+iYyqy4dpZ4SaUIFydb7gwifvg1Bi1YHv59Ui3WmWqV19/cNN9TEBiP
 of70sMV+PW8/OP4N8/uHDqU4OCKP84CYVwZTXTsF/GzE9hs7yBvIgMZCS5SLUxPh+gzco1daxI
 OW0=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.69])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Oct 2022 06:23:57 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     john.garry@huawei.com, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] scsi: libsas: make use of ata_port_is_frozen() helper
Date:   Fri,  7 Oct 2022 15:23:39 +0200
Message-Id: <20221007132342.1590367-4-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221007132342.1590367-1-niklas.cassel@wdc.com>
References: <20221007132342.1590367-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clean up the code by making use of the newly introduced
ata_port_is_frozen() helper function.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d35c9296f738..5692577f82e3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -101,7 +101,7 @@ static void sas_ata_task_done(struct sas_task *task)
 
 	spin_lock_irqsave(ap->lock, flags);
 	/* check if we lost the race with libata/sas_ata_post_internal() */
-	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN)) {
+	if (unlikely(ata_port_is_frozen(ap))) {
 		spin_unlock_irqrestore(ap->lock, flags);
 		if (qc->scsicmd)
 			goto qc_already_gone;
-- 
2.37.3

