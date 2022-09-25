Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D1BC04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 23:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiIYXI0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 19:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYXIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 19:08:24 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8612982C
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 16:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664147303; x=1695683303;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=l3JCm5qSZzb6ujJKtq3kEW3pKkqRShXgolJdPRSTV/o=;
  b=DQXv5DawfnknhUAMTwHkjdAZnKVRQjw1sBdNJIF2zfKGbHPhH4fPuB6a
   4YA3CDAJxOWLMBdfZ872/LDgV6Yl47bFynjgvYZJfLZay2o9hJ/jRyDKZ
   kM5UoNbKAmYas3AkDJ03/q6GpORsJt7AVZFMWqBkpy4bGvlMV98i/44BZ
   YmFXb0K2GU/ht2ey6O4WV65gdFqVpFpRiQZ8B1N2KtaIuZg2QfpXEaWDD
   H7wo28CCVoRFR5BipLAn3o2oUU+okUdjKxyV6pUFpulJh5A/t/hehAn0k
   HwFh37rC4Lpqfr0u9IMCojRF3k1Hu97Z9hpD7CJRPEimotV/eZuBtFv9k
   A==;
X-IronPort-AV: E=Sophos;i="5.93,345,1654531200"; 
   d="scan'208";a="217414823"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Sep 2022 07:08:22 +0800
IronPort-SDR: 64x8uLkog3I970x2CfA8D3hJWCHi72D3yFE8KAwWAxHlMJP1XArAM/r5Eh3N+kdZifm51hjQG5
 WWNUTacO3S5iKCGhQsWJyyYcqhCqxdKkuBqA1z5BlpEzFfj7OSxAw3UhLAVwl1zZXYEkpw3JDZ
 MCrpmaxaE1STQgimCjfrIrnAautyt6AudZexmB+JJW2qwNs7vrkg5bOS+gimsXlyixxKR/rMPU
 +TjcWo4Nnp3gqZpj0m92d42132TR4Gwa8tsmbcb4LoYGRODU9Y0DxlogGSF1ATT4G1sgNJCmfF
 UoIVcpj8smTkR8dlb6N7tjuc
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2022 15:22:50 -0700
IronPort-SDR: EX+O3i1AOFXb5Bz2lvOqR5ppcGQMUCktI7KdcxibH5P7Xkmrvy3pXQ+Q4mTeQhc5p9NyyMYqFV
 1l9qw0hvAWWIuffiyZx9yHycYWvmAVbec1f51CSNgGEpTQXxpTb3wNWnYnsNEJoBUbHEq+3eqB
 k3y6GkfOxxDfJtvPcZOrujlbYZqiKYUf54+LAY9X/XvnL2scO8VISOO7eTYYYHi3GVjuvG6sFB
 zQy5wma4gZr0q76T+gzk5R+acjfpBel6eCblUQgLp8MvyazmE4hgoqw9kJaMTp5GDsMCq72UJS
 ObY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2022 16:08:23 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MbM4j56Hzz1Rwrq
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 16:08:21 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1664147301; x=1666739302; bh=l3JCm5qSZzb6ujJKtq
        3kEW3pKkqRShXgolJdPRSTV/o=; b=D7/U/R+W/p6DOuXn7a1u53K0vWbysOvJ/n
        cHUYppCcKyy60ASrVJHM4JhIe+w7aa4QyPTBRxKQhp5GoKG0h/cBP1TP8T3KFONq
        SV0gEXQDqfHURBuHBB3HxUVbFiunrvtnIfTfKy8jWx3HtOvfGN3t0xPe7cAyD95S
        E+5hb1q+jE+caQnYQLLhT/SYsPiWh2IVVXkjteHRYumkYgiFcv4uU/nNEy4vHA1r
        LQ+tNAdyQvR6z6XFGDWWVTPdwGuaa4l33Iw/9dsW4RfT/UKBxO7xu4Qu4ApXc64m
        kOtwxy0w4GiM5h64FDKSvLizUZvPjVSE2bPQegaZTBciQ9RK8/xw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QUDpm4s-t7DU for <linux-scsi@vger.kernel.org>;
        Sun, 25 Sep 2022 16:08:21 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MbM4h4ChZz1RvTp;
        Sun, 25 Sep 2022 16:08:20 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/2] ata: libata-scsi: Fix initialization of device queue depth
Date:   Mon, 26 Sep 2022 08:08:16 +0900
Message-Id: <20220925230817.91542-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
References: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SATA devices supporting NCQ, drivers using libsas first initialize a
scsi device queue depth based on the controller and device capabilities,
leading to the scsi device queue_depth field being 32 (ATA maximum queue
depth) for most setup. However, if libata was loaded using the
force=3D[ID]]noncq argument, the default queue depth should be set to 1 t=
o
reflect the fact that queuable commands will never be used. This is
consistent with manually setting a device queue depth to 1 through sysfs
as that disables NCQ use for the device.

Fix ata_scsi_dev_config() to honor the noncq parameter by sertting the
device queue depth to 1 for devices that do not have the ATA_DFLAG_NCQ
flag set.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/ata/libata-scsi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 29e2f55c6faa..ff9602a0e54e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1055,6 +1055,7 @@ EXPORT_SYMBOL_GPL(ata_scsi_dma_need_drain);
 int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev=
)
 {
 	struct request_queue *q =3D sdev->request_queue;
+	int depth =3D 1;
=20
 	if (!ata_id_has_unload(dev->id))
 		dev->flags |=3D ATA_DFLAG_NO_UNLOAD;
@@ -1100,13 +1101,10 @@ int ata_scsi_dev_config(struct scsi_device *sdev,=
 struct ata_device *dev)
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
=20
-	if (dev->flags & ATA_DFLAG_NCQ) {
-		int depth;
-
+	if (dev->flags & ATA_DFLAG_NCQ)
 		depth =3D min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
-		depth =3D min(ATA_MAX_QUEUE, depth);
-		scsi_change_queue_depth(sdev, depth);
-	}
+	depth =3D min(ATA_MAX_QUEUE, depth);
+	scsi_change_queue_depth(sdev, depth);
=20
 	if (dev->flags & ATA_DFLAG_TRUSTED)
 		sdev->security_supported =3D 1;
--=20
2.37.3

