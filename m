Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99261C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 06:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhKVGPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 01:15:31 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48951 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhKVGPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 01:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637561545; x=1669097545;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1HpaCmfnQ5F+oKEiqkHejRsAAkNuJFeRPz4qTYCGcmY=;
  b=FyvhlBXDeBNhNtY1j2pjQdEvtcWVFMleNQ3xnmGFTtHyZT6LYtwnx9rb
   NjeMlqzpYGtDaVA7T4ZasvosFFkzzoPXK879YS4cl6XjtdrmODAngxtDz
   6Bnf0PJq8G6hCquZiO54+zDbQi0dx96TpvIZx0NFkI8RRtCLqL8X9I16i
   fYn7WqHCsdeEHWq1FZGSPrzZRYpYdE0CrTExgneRfVXAB4b/jBAMEJGQm
   HqKWFsTfq5jUkeqbEIUXGDgqj5JwctRTJOZ4HA+rxfdgXRxbW3dlYflll
   J/aZKGIRKHVX5tKwK4O1P01dXCS9IdaLwxUzF4glufEGXtWMswIbWP8+Y
   w==;
X-IronPort-AV: E=Sophos;i="5.87,254,1631548800"; 
   d="scan'208";a="185274583"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Nov 2021 14:12:24 +0800
IronPort-SDR: wu/WKahT2zGgX6oFwk+Ozxu/mP++k9k92TzrJW0CEc9tGwspVlxC5BcSaGBztuSadKb+P6RVE2
 7d5CfqBJYzyLgEplq6IXBlejjHe6eICYEYgjQIE3ebE/Nmvjl0ZR5mne07M8t/fTGtjsCQ9KHe
 ttjq7DrI6aWSn6uLsIxI4a3k9IexZ9F619OLTyv1ell4I5OYeMiXP4Xf7NwBTxhB3Ps1NgwWPS
 VNVsdNveR6qlTjSYfAuC8Ikw3oymOEyR/C+kunGxp1nVeK6ofUsQ9CwYHHAsZAbWaqwzfYg4Ls
 vNwnNoT+oM+T54pR+ZhjIDA6
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2021 21:47:20 -0800
IronPort-SDR: B5IPsCJKsR/mahkmibk9IJ61+rwkwWBvH8DOoTV1dM5q3kV1LuPzLSTx1HUlpj40L71DIK7bEB
 9qtzXxm3H3Wjh3H8EWnYeli0sk0nzJ/nZz/0vCiRSodR1jWrMH2ABETsVuXdYfHktVnKi3hZaC
 EgpQunGy6s+tvWG53IY0a6yOxV/VYZMaQghBQWp8XJg3KN55iaUHqSkfYoRxJL1xyvdbANIJf4
 Uz/2qU9P9l1UXlIW1aTTLJG0uYzK+Ub37zwu9x0R9G2l31ItM6b6ZaaRj5cyk35rra3aKy7wvS
 u1g=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip01.wdc.com with ESMTP; 21 Nov 2021 22:12:24 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2] scsi: scsi_debug: Zero clear zones at reset write pointer
Date:   Mon, 22 Nov 2021 15:12:23 +0900
Message-Id: <20211122061223.298890-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When reset write pointer is requested to scsi_debug devices with zoned
model, positions of write pointers are reset, but the data in the target
zones are not cleared. Read to the zones returns data written before the
reset write pointer. This unexpected left data is confusing and does not
allow using scsi_debug for stale page cache test of the BLKRESETZONE
ioctl. Hence, zero clear the written data in the zones at reset write
pointer.

Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
Changes from v1:
* Zero clear only the written data area in non-empty zones

 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1d0278da9041..1ef9907c479a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4653,6 +4653,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 			 struct sdeb_zone_state *zsp)
 {
 	enum sdebug_z_cond zc;
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (zbc_zone_is_conv(zsp))
 		return;
@@ -4664,6 +4665,10 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 	if (zsp->z_cond == ZC4_CLOSED)
 		devip->nr_closed--;
 
+	if (zsp->z_wp > zsp->z_start)
+		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
+		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
+
 	zsp->z_non_seq_resource = false;
 	zsp->z_wp = zsp->z_start;
 	zsp->z_cond = ZC1_EMPTY;
-- 
2.33.1

