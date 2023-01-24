Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A931C25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbjAXTEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbjAXTDw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:52 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F412E19696;
        Tue, 24 Jan 2023 11:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587028; x=1706123028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xQaojDl/zBRreCgbFNYyP4u+d54nre5JLHifYVnzUBw=;
  b=jyGysHVu0qEz56WQND2Uf75WfJSFchrDbbZBWk8etEySwm47HBDUM9Fb
   z3TjzBT39OKM1S0VC/1lwJHkU7oqVEoC0N2GhIHLseNvBdVO30AUUOTaZ
   sjTZ5aiRdPzaiXJTx3vIll+iHwQ0puPCuxCX00TxfbOHDpP+z1Cg6iDc4
   6kHBaai7WXxcL3gp+BNzxwAdqXH8oPKBgRhcXqo8wSX/qDcnpMqqIx6zZ
   ewqhe0bK72Wz4/8okjJugU/kHtMIZIlZ5m6YFIbUiYIlr5MPQYQ1R6XuQ
   3XqY4nRxasa5FVXlEq+4fSuITx13bJDGgkC82aIXAfVcRp1F2bXaec1wx
   A==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472966"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:48 +0800
IronPort-SDR: +PzpOKcGEa95q2nkJLfNvJnUN/Q+pjtb93z/8JJeRRCdxQXlT6B9wqn4KYRq+fqhRsO+oCzbeX
 OIYEM7eEsZCJpyXVlrPg+/X1XldH9mcKJm9D+PKZrlNOXiqdAnfaqQPDsNrsfTRHAGWR3rQquj
 U2F+QWssSIwcSDLrFl99gEdtHKx5+MjMIOki2yHW9/hYwFhgWetR+dZemM3Zx4p99N1GytzP15
 CwiIjd1ZkQCzv6ZArEBMHBL+VSZ4+jz2p3ozaJYbc0hHaQjmchLJR8KkUfCRMQN2RwQTPSZghX
 gEg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:37 -0800
IronPort-SDR: IoTpfbX3rV3FS6/lN8qLeO9B07tGetx9Y6VptVR0uPmkKfol2pDLblxlhfuSF2iJh0Bw2CykqS
 llvgsJfNbpcYa2hRYLIJWPJGP0G/KZuIFJSX/87pStgIOJYM/M/tYqCCrpoHbP0VaR+AEQv7hx
 KayZFRkAdzD1/8e2czFxrvMShK838hbYedOEM94EG5nb01s98gg62Tm0vHTeoHJoOEO7u9Nimo
 D6zWlOYekuYVFCtiRIgc/+1AJztVUyHlU9Su4uh/Qb74RAejuA79lqeoKoAf+kHf6uJJDoPGMM
 mGg=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:47 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 10/18] ata: libata-scsi: remove unnecessary !cmd checks
Date:   Tue, 24 Jan 2023 20:02:56 +0100
Message-Id: <20230124190308.127318-11-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to check if !cmd as this can only happen for
ATA internal commands which uses the ATA internal tag (32).

Most users of ata_scsi_set_sense() are from _xlat functions that
translate a scsicmd to an ATA command. These obviously have a qc->scsicmd.

ata_scsi_qc_complete() can also call ata_scsi_set_sense() via
ata_gen_passthru_sense() / ata_gen_ata_sense(), called via
ata_scsi_qc_complete(). This callback is only called for translated
commands, so it also has a qc->scsicmd.

ata_eh_analyze_ncq_error(): the NCQ error log can only contain a 0-31
value, so it will never be able to get the ATA internal tag (32).

ata_eh_request_sense(): only called by ata_eh_analyze_tf(), which
is only called when iteratating the QCs using ata_qc_for_each_raw(),
which does not include the internal tag.

Since there is no existing call site where cmd can be NULL, remove the
!cmd check from ata_scsi_set_sense() and ata_scsi_set_sense_information().

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-scsi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e093c7a7deeb..26746609bf76 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -209,9 +209,6 @@ void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
 {
 	bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
 
-	if (!cmd)
-		return;
-
 	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
 }
 
@@ -221,9 +218,6 @@ void ata_scsi_set_sense_information(struct ata_device *dev,
 {
 	u64 information;
 
-	if (!cmd)
-		return;
-
 	information = ata_tf_read_block(tf, dev);
 	if (information == U64_MAX)
 		return;
-- 
2.39.1

