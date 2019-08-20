Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF54C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 09:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAE5822CF7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 09:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Hf+CgrYr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbfHTJE4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 05:04:56 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16075 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbfHTJE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2019 05:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566291897; x=1597827897;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N6U+iFU3I1ObSGYxaMPWqYiwaAzsH4dwhnKXRvXgoFk=;
  b=Hf+CgrYrVVCmqpnMZ86MxI2T7WETKfSl2q5bddPfuZPiwbcIuDNUPArG
   EODCyly0hrrZEPc8c/66vdt4xagrpk0ArE6WQMc+JAt1wzAC4AgIu1i0n
   cKxiUr65vwXIeQjghltIrU7nd2sZSVd757VtjFpFMeEi4th+AhYxfcORJ
   7qcsDjG8TUbl87EbDm+LbppuHXQa0dSeYG2OQZW4AgvrUVxC3Ady3XQbF
   ih88itlGuQeJHm/fn9jQv5moKKEsGX2SEasRgRnaZNVgvLlhLv/IfC9Rt
   mlTA3XfR/qDYNGU1xSmTw6PuhJZrO21XyPi+B6CyUDjrjR8ZVxoRGdytj
   A==;
IronPort-SDR: dhYOHztZwsvsC+eGfpNZMjUY0NYR2G97ftHOAaqX+Gd8VGRfsZxH3xNewOIIAsuwyo39iIWmXX
 6q4MwGhMd35oWclXFPOOqWk9LTQKikKa0fT4TP0mS83OEC6Yju9vcjWqnOHHeooE5Z4DHqfTjC
 zy9wzIA9JSf48mdm24wMa8nLuZtwRugybe+ZjRL1crqHzsANfMx/fbs4lwElJTiwPv9pGG1ApP
 cufatIiqu67Edz3GziG9woXbnszgTKDjqPsUw1Fw9F775sg4FMWYauZQte7KrqrU9rm5cC5Tf0
 Sa8=
X-IronPort-AV: E=Sophos;i="5.64,408,1559491200"; 
   d="scan'208";a="216621446"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2019 17:04:56 +0800
IronPort-SDR: NhsAtYlw8JeFLKj5EtsNsRis+GHgeSBtnJpvIFgZHTMKrzu7945uUUIe1yBYrU2rQGc7tFt9n3
 j1j0ABuKCdhiy/aF0HSAoBsRLgSp9pud0jX1bTejnGMsAyRDUOUN+XHFrtOjn1vVaeyeAXl6JM
 1qRGIjZ+JTL3aXuWIRsTHDOnGGgbzfuR/yAUigxgkAE4fckZe0uePknf+yQbCT2YkQp6yAlor9
 3o1HcG2Mli+AQbUAaZnxsdMMatJIaLtQzH3ici7Ta/a5pibRMjogPaQMJyrgLIb9MbR2FOTCN3
 oknLvkYbFo4nMTOF3avpbYMv
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 02:02:18 -0700
IronPort-SDR: LaXarf7EZDW3MYdUaentUq8JX8Kwi4FMMCiEqc6hVQH+ijlFVcFndwoXq6pYGmhIavNsHdiChm
 a6f9axgf2adCjiXQCy4eed7wrqJFrrDQOjPMJaPkYnSTFpY/MVXyYgnCvzMMOeKyj9bu13C3db
 sgtqpPbF9woFuzsfBmy77kSAxsegFYvsix9d18lU12jDrmEfjh0iWnLO+8pOYsPi7uo9T0elKq
 kEgFhhqZw4ePK1QMZkcZ4iOKb94xs5Id5Z2FkXOhCXeNi9DgSVay95Yy7M5eBzxXelhsV1DhPW
 T3M=
Received: from naota.dhcp.fujisawa.hgst.com (HELO naota.fujisawa.hgst.com) ([10.149.53.115])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 02:04:54 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted scsi device
Date:   Tue, 20 Aug 2019 18:04:28 +0900
Message-Id: <20190820090429.1961085-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If there is no corresponding scsi_device for a LUN,
tcm_loop_port_unlink() complains that it "Unable to locate struct
scsi_device for " the device and keep %tl_tpg_port_count as is. However,
such situation is legal when we delete a SCSI device using
/sys/class/scsi_device/${lun}/device/delete. We can safely ignore the
missing SCSI device case here.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 drivers/target/loopback/tcm_loop.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3305b47fdf53..0942f3bd7eec 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -654,16 +654,16 @@ static void tcm_loop_port_unlink(
 
 	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
 				se_lun->unpacked_lun);
-	if (!sd) {
-		pr_err("Unable to locate struct scsi_device for %d:%d:%llu\n",
-		       0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
-		return;
+	if (sd) {
+		/*
+		 * Remove Linux/SCSI struct scsi_device by HCTL
+		 */
+		scsi_remove_device(sd);
+		scsi_device_put(sd);
+	} else {
+		pr_debug("Unable to locate struct scsi_device for %d:%d:%llu\n",
+			 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
 	}
-	/*
-	 * Remove Linux/SCSI struct scsi_device by HCTL
-	 */
-	scsi_remove_device(sd);
-	scsi_device_put(sd);
 
 	atomic_dec_mb(&tl_tpg->tl_tpg_port_count);
 
-- 
2.23.0

