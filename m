Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC627C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjCIV5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjCIV41 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:56:27 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0CCF5D38;
        Thu,  9 Mar 2023 13:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398962; x=1709934962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SKr53a+4HkUDLloHC91hlz8kV1d34tzge8lDPwkLtLg=;
  b=J/yqw2ZlhyxXAA/TY8/MQjrAPUymy2OcPvvqmuilVstpxxyG/V4O8Y+W
   9yERGbODqj1aDx3XstmTI03+mm1FqEySnuYI5MsnvJFlKtvgVosZHZ4PV
   yQGgUY1E5crR7UBSdHeohczzdMCvIM2Ryq55EVVZZrUhOw9Lo0BUliGA1
   zLtYkxLg4P4PqdAvuIsTvfwoi3weHqzifQphPxGvtqGD7ruH7geLudpQw
   B2mixQmZYX6n86F/5bt5FlzrK77PvewPYDm64OV1UeOnPqnXJ4MRAloMW
   GVkYHpaKJtTH0cEmA+6FTbdl523ucoWgILygE0wVdztbpxhip8RU/v1lE
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271033"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:56:02 +0800
IronPort-SDR: 3T7Y7PbJAn+zrLcavq7DWr0vKkROsH4OBPM3BIFENBluIeA6pBVvZDkzIO3/MJ3FFnoZ7CVOTS
 +tshRjsEhoq8lh5kkYEjgaiR6tXFgux8XcLpykVaaqJ710fwRD3vpnYqjdc4jpdZ0W3Fu8Qq6F
 XpGP9xhZ5uV22LSPlXj0B3nU7jpBN8erSQ6459cDuStNHnobG59bCcOnClXKQFfmHLwk/kYdty
 gPZePuy9UDjkEzmsWAylVpa+OeCwKmVFam2l6C7HKqLMLVmfAuofUAnKYgCuZ2/W06CSjwRLKX
 mUc=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:55 -0800
IronPort-SDR: /edO0gZsdQvmwQvqoeJMKPU5GVszkO60+ElZkX8nD6vG5WsvbYpx6IB+N4jyuK6RcuKZCoF0ry
 AwGOqnNq0zyGvs+Cn0t94oHZUG+h2OOa+NiF9oqOSu0p1yF92wV2GdAgmGr4H29R2PQAX7LOeg
 ebhX7dzZ0AHpS8HGJDet3XBgkqg1wmHPBnV604Dpj1Wx2dCF0PNtKKhIXlevtzcwCGlzdwMJ2q
 qx8OPVthm0PBONuOdyA2nX8zMUWuk+pI59bAV05hWD0DHKMvfVV0mJ7ppFsA8yxbf0FEoaxLeb
 84o=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:56:01 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 12/19] ata: libata-scsi: remove unnecessary !cmd checks
Date:   Thu,  9 Mar 2023 22:55:04 +0100
Message-Id: <20230309215516.3800571-13-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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
2.39.2

