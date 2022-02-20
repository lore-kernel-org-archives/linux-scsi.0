Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420F2C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiBTDSh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiBTDSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:36 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70397340CD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327095; x=1676863095;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=imM2XLPuQNqqDele+oBOSkRywJGMm40zxouHcybLwXA=;
  b=hNVXSfVzAj19UV30m0TRxAi7H8eZblhCirK3itBWYsCHvA9LI97/DALn
   vX9xiCQZ83+FRmhOrFek+SfQoVYdLSegh7zSrnLSlnxR39Lk90lhww85V
   UGwadFXoQZJxGhGBuj8gXf/nIa+Zf3hvUIMJumr7z03efOwjk9KA4L+bx
   /Ba9OUh4oNv4zHdmB6cO8m+PL0shc16wmWMjPyeWa1VitzqV5LoQllO4R
   mcXaaRKjeZl7XqrR34QMnNyujsK1AfzxdXkDtMi7mv1QChZvNLW7LhJDF
   EFYf1dgpdQnWwhsc2Jz+UJRHZ9puuoTzw1AXEulkvkb2yoZO62LFD2bN9
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405722"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:14 +0800
IronPort-SDR: E355Dq7RkirdULBYDcGubE5McoOYkhzubvHdvz0hQa0/9z//d6lIJ1y+htnS1CXRbvRyHbQcBb
 ezi1f2Y1XZfjXom3L1Rc1ZkaGmacWEs9t259uW2fKAuX8atkyayHFXJcfOtnCQQmQhSlAbZFSw
 EboKcQf7Zc3BaCPJgrqrZazlshuwK7A95VkP/2B3qydy9k9pcf1qAjPbgvMNnk/3is/qMwrjO1
 uLWbsgMGrTfWKON5PtN7THhcyekaaEPMdZInanDjPOJzPy+NDrFIvOPFl6xFrFPclwjXl2hLXY
 sMKWYe93aejfdzQbjt5frFbq
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:49:51 -0800
IronPort-SDR: BuMpMBf8vhEyb7LAYu2Jy4USu1XNUotQiAm9q09GpBvz4Y1yB+iAHfUJcwP0UvG47o1RmmAOcd
 JgUTPkx0TEFw4ThFp55xdl8P1oAnX7PL6JFR4LLTCLesTCimMfPXt5QMkwnlVy5sasEHauvpF4
 ftQQl4v9kPZJWFPm20z8jIm4gVF3QqwmoULbYT29ZCYi35h3Dya8Pb6HFMhIUv4DRKNo4Uiawo
 3e6lAnMIufW7Y7y6sdHseEQFYoDPIjAE8zaqIW/3hEk07/PtLha34y/bklxc8OsXDblMj4YMk6
 Uj0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:15 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxg2M8dz1SVp2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:15 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1645327094;
         x=1647919095; bh=imM2XLPuQNqqDele+oBOSkRywJGMm40zxouHcybLwXA=; b=
        da8++69g156hL4csuylKdOcGgrgiAmWTwRE562crc3HPsoJ837zxdpC7iYivg4DV
        qs1FZxOgXpA9yHiX0gDxwT9oULCZGYjq/Y8DirybFBNWq2Q2dNGUQBWWkRUBB4vS
        Pq643uUbt0ssTKqQB34r4jUAPl2oazGZJUlvw99PHJAqEAwbnUtpPh7vCtDeCvB5
        o75300dv8MdgUVdpkUTdoB5O1iShTy894SX21mWpoQf9rstHrCm4ao4XrTq8357x
        WEmomp3n2fFMSIm8G5oV+QZq0udxI57KcvOIUVYdrPPIgs+aKk+AAy3DxHfoUy+U
        Gfapo7aq4AvcfvZp7E5W2Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yFIHfPzwusG2 for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:14 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxd2mKzz1Rvlx;
        Sat, 19 Feb 2022 19:18:13 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 00/31] libsas and pm8001 fixes
Date:   Sun, 20 Feb 2022 12:17:39 +0900
Message-Id: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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

Changes from v5:
* Rebased and retested on top of the latest 5.18/scsi_staging tree

Changes from v4:
* Extracted code style changes in patch 22 into the new patch 24
* Squashed patch 18 into patch 22 (now patch 21)
* Added reviewed-by tags

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
  scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
  scsi: pm8001: Fix tag values handling
  scsi: pm8001: Fix task leak in pm8001_send_abort_all()
  scsi: pm8001: Fix tag leaks on error
  scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
  scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
  scsi: pm8001: Cleanup pm8001_exec_internal_task_abort()
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
 drivers/scsi/pm8001/pm8001_sas.c  | 297 +++++++++----------
 drivers/scsi/pm8001/pm8001_sas.h  |  66 ++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 467 ++++++++++++++----------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +-
 8 files changed, 609 insertions(+), 708 deletions(-)

--=20
2.34.1

