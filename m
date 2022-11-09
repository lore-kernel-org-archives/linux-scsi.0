Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D75C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 02:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiKIC7s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiKIC7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 21:59:47 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EF414D24
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 18:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667962784; x=1699498784;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OfIQdN3NjKqG7KYfy70+ohBS72pcj7SOga4MFPABIEo=;
  b=R2CJfEJ4rJrRpbthIDm2PhqOyPYiS99NN1SyLyH1n//MFoS9axKO0aSF
   3Hjt5PaPhFVFgHVj5nEHG0uFE5JrVRyTgOc1hTaN4DWadJoDl2v7qMoUB
   NyNxHV1sCY1uySSzFBMPIOOd6ycvk+2HWVSN1lL7ka5R8qw6fvdGYiamT
   Yv+8HGULv83k/kGJGu0doH1i6/t83oOLAjBBQxjYDO+FSLky4wgdbKruv
   Hea4uKDhF9qqaza0uSxt3sk6kYDAjgDFXLZBSuFdX7IqNJ4s5G5N/Qjed
   1Fe2tbNEOxpP1nufDP6tedj1yLDhfQg306iDt8V1eT+yfeNYA2NGqv9Cw
   g==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="220979687"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 10:59:43 +0800
IronPort-SDR: 1lbFgN9rMWoSBsiNqSfy+9V7mTpJCLUsFqL+0m0KuWeRUBocmejGoFP1nSLbkI3PPW8GFGxOOD
 BQThwLec+64VensvE+vuQcYYR+yNmIk0QXJmWXnToNCtoFwIhSrWB0s+IAc29Dghha4cboZoaw
 r+KEqz9Ld1BWNNT4yEQwGdgPOIEoBWN4ulg0BEk477l5Lr3PimvTpXQo1c4iLNDRCFX0Pnn4H4
 uvKAZZQJNXACINgASQ7tyrkN0dkjmVZ0+bjBqjXfcgEyjKc3MtQ+SwxPt7fT8pf0TtQPAldP+u
 PG8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 18:18:48 -0800
IronPort-SDR: aH1p7lCbZ8o/q66BV5+kh7MbvjsID4vmlnPlGKL0yhonIZgq+oAvSI8R0q8pF3n+C535Vsdpb+
 isEqNeTif2serT+7fPM2lTtKsDagYsVmAaOjl0vcoBq/vvmTc1CdGVXC3J9+NKft8DBhxDjJyi
 gybmwNgLjTukJIF+tZyw6jzLdMGYE8qTXn16IPSKfvAR9X7E+tkTBcUxcPsKvwITNIBAE9vQja
 XAAGkm2Vv7yqTkbuR+SR8avIlbPXDcC0MNze9vzu5wlkDSjWHwdZJ8CgovhXgp+xqPmfpStXRH
 878=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 18:59:42 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] scsi: sd: use READ/WRITE/SYNC (16) commands per ZBC
Date:   Wed,  9 Nov 2022 11:59:39 +0900
Message-Id: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During work for a recent fix in libata-scsi [1], we checked which commands ZBC,
or Zoned Block Commands specification, mandates for zoned block devices. We
found two points to improve and this series has two patches to address them.

The first patch improves READ/WRITE (16) command enforcement. ZBC does not
mandate these commands to host-aware zoned block devices but current code in
sd_zbc_read_zones() assumes it. The second patch improves SYNCHRONIZE CACHE
(16) command enforcement. ZBC mandates it for host-managed zoned block
devices, and it should call it in place of SYNCHRONIZE CACHE (10).

Of note is that the second patch depends on the libata-scsi fix [1], and should
be merged to upstream after it.

[1] https://lore.kernel.org/linux-ide/20221107040229.1548793-1-shinichiro.kawasaki@wdc.com/

Shin'ichiro Kawasaki (2):
  scsi: sd_zbc: do not enforce READ/WRITE (16) on host-aware devices
  scsi: sd: enforce SYNCHRONIZE CACHE (16) on host-managed devices

 drivers/scsi/sd.c          | 16 ++++++++++++----
 drivers/scsi/sd_zbc.c      |  9 ++++++---
 include/scsi/scsi_device.h |  1 +
 3 files changed, 19 insertions(+), 7 deletions(-)

-- 
2.37.1

