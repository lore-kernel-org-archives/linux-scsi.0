Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AD2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240486AbiBQNaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiBQNaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:15 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841792782B3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104600; x=1676640600;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o3LUgV0nRHpj6ufJ0oI6ChgmJjGonmRF4vif/w+ypiY=;
  b=qFqdSNVE3in2togiIgzKzlqlODW5/7tyEVxFp7QliHWlEP+yw4c8Y6NB
   CyX9GyRftSdy+iYT6RGFxtL1VjeOPXy5+zz0EHKN8gyfPec58fP4ysu08
   OQPfiAMshVIvzgGbw/g5B4/TNgjXFUFdL1kl2JV2AUOLWGWZgKegpy8A8
   4Bj2EQcw0TEupNDL9AGtelrHOYuGr41gfarBDfTYX6ZFz3NkZOuynCs3w
   80mChKvnw1TsQhwzUmrtEsZMKux7G8Q/FH5Y59LKxaP0bn6xt42r+k1Wr
   ykZLlQRnzEUx3LvVu4mlxezpBGfoamLY9x0PeZYaHGdUyACijOQVRPAja
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303127"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:29:59 +0800
IronPort-SDR: ukOe8LZ/AAHxbJwW/fFaxCSnTy6imiU+8z/Q6SyVVPSoRYq5ClJsD7ls4JC+FMBp+F4QKBHcsR
 HaCw69uysKOwjWJxtppV56IH+hbKzesQL7Tr7zIEX3LN5gsnc/K5lPd8FNzrQvnTtuEj+DcNAt
 dExdF9AiiQpf/lcCOdXbt2k0u3Mqv9g9M1+K7aelFv6eJ5RzlU47uAywaZcKv2jjD8c6ugVyet
 9mceH3w7vqqudaE22C8koCGzbj1aqvYtenLkAxQVmEHMQmgAv1H6TuwSmn4h/hgNUxsRQmFrIj
 z56B36Jen6W1ZA+mzfob7ZF7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:38 -0800
IronPort-SDR: ws6FnHH2ZqM3gR9FWYE+5JuN2pS+HqEdYh3+D/jGuX0n/DsCJB2o4LcyDROVl5kP1sZWyKotgz
 rShEctgevlrXyY4zgMPe0F3KafwJXIrECmcQTfoxAUzHCW64/YshWLZ8bsalHtl9/fsgOgQpXG
 k3YAoCTGVE10pNgLWbyuJIn+scmJRocPFkmeByDBOSh3YCSLHGVNOJeOX11+w4jxDgxtQFRPwc
 wboRAyLx77dPhNxeUb/Du4yPRlyVYctJT1CSkZk21YMf5u5PhXQUKMVPO/TLI9fDsaLs2HCU9r
 C18=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwfv44Hlz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:29:59 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1645104598;
         x=1647696599; bh=o3LUgV0nRHpj6ufJ0oI6ChgmJjGonmRF4vif/w+ypiY=; b=
        sQUcvqGAViFRvFk3ajincS+WncaK+7EAQMNZCfuRYsgayMH1lMXOXWGUrrJWTPNw
        dDVlU3yIJlwJNzwUOmQECGQVY92lIh3K3dTt7dB/piIlX1XMdJ4coKf7PHMcvD9/
        pyqf/Wc5YZB1GLAQV+UCFKFguFV2nQBIQUjI5sxe1eTt8auaP3ENTMmEl889PNQ8
        WlT/6yLGpf9vfa+Vltqd6xBo7lyBZl6FE5YK6l4UPvXeyw7nY7pwuHVA/Bw/P4uF
        nbCMgbKFhGlBUPrOeUKV+FJ9bPzKhll0WsOl6PnUd0DwlmU6VcvMR+dKvQJJtqxS
        TRnDNsvxORDI9uFI4xnIDQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LGbKsB2O9zQh for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:29:58 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwfs5d4Zz1Rwrw;
        Thu, 17 Feb 2022 05:29:57 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 00/31] libsas and pm8001 fixes
Date:   Thu, 17 Feb 2022 22:29:25 +0900
Message-Id: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This first part of this series (patches 1 to 24) fixes handling of NCQ
NON DATA commands in libsas and many bugs in the pm8001 driver.

The fixes for the pm8001 driver include:
* Suppression of all sparse warnings, fixing along the way many le32
  handling bugs for big-endian architectures
* Fix handling of NCQ NON DATA commands
* Fix of tag values handling (0 *is* a valid tag value)
* Fix many tag iand memory leaks in error path
* Fix NCQ error recovery (abort all task execution) that was causing a
  crash

The second part of the series (patches 24 to 31) add a small cleanup of
libsas code and many simplifications and iomprovements of the pm8001
driver code.

With these fixes, libzbc test suite passes all test case. This test
suite was used with an SMR drive for testing because it generates many
NCQ NON DATA commands (for zone management commands) and also generates
many NCQ command errors to check ASC/ASCQ returned by the device. With
the test suite, the error recovery path was extensively exercised. The
same tests were also executed with a SAS SMR drives to exercise the
error path.

The patches are based on the latest 5.18/scsi-staging tree.

Changes from v3:
* Rebase on latest 5.18/scsi-staging tree
* Dropped former patch 24 (kdoc comment fixed upstream already)
* Merged former patch 27 and 30
* Fixed patch 26 commit message
* Added patches 30 and 31
* Added reviewed-by tags

Changes from v2:
* Reorganized the series: fixes first, cleanups second.
* Added more bug/leaks fix patches
* Addressed Gary's comment for the ccb alloc helper (patch 28)
* Rebased (and tested) all patches on 5.18/scsi-staging

Changes from v1:
* Added reviewed-by tags
* Addressed Christoph's comments on patch 4 and 8
* Added patches 21 and 22 to fix 2 additional problems found while
  preparing this v2 series
* Added patch 23 and 24 to cleanup the code further.

Damien Le Moal (31):
  scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
  scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
  scsi: pm8001: Fix pm8001_update_flash() local variable type
  scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
  scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
  scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
  scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
  scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer=
_config()
  scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
  scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
  scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
  scsi: pm8001: Fix use of struct set_phy_profile_req fields
  scsi: pm8001: Remove local variable in pm8001_pci_resume()
  scsi: pm8001: Fix NCQ NON DATA command task initialization
  scsi: pm8001: Fix NCQ NON DATA command completion handling
  scsi: pm8001: Fix abort all task initialization
  scsi: pm8001: Fix pm8001_tag_alloc() failures handling
  scsi: pm8001: Fix pm80xx_chip_phy_ctl_req()
  scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
  scsi: pm8001: Fix tag values handling
  scsi: pm8001: Fix task leak in pm8001_send_abort_all()
  scsi: pm8001: Fix tag leaks on error
  scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
  scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
  scsi: pm8001: Simplify pm8001_get_ncq_tag()
  scsi: pm8001: Introduce ccb alloc/free helpers
  scsi: pm8001: Simplify pm8001_mpi_build_cmd() interface
  scsi: pm8001: Simplify pm8001_task_exec()
  scsi: pm8001: Simplify pm8001_ccb_task_free()
  scsi: pm8001: improve pm80XX_send_abort_all()
  scsi: pm8001: Fix pm8001_info() message format

 drivers/scsi/libsas/sas_ata.c     |  11 +-
 drivers/scsi/pm8001/pm8001_ctl.c  |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 458 ++++++++++++-----------------
 drivers/scsi/pm8001/pm8001_init.c |  11 +-
 drivers/scsi/pm8001/pm8001_sas.c  | 296 +++++++++----------
 drivers/scsi/pm8001/pm8001_sas.h  |  66 ++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 467 ++++++++++++++----------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +-
 8 files changed, 608 insertions(+), 708 deletions(-)

--=20
2.34.1

