Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE44DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiBRDPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiBRDPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:06 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D882B888D1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154091; x=1676690091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zjQtSMfQ52GW0Ojk1j2LnM07JZeQhoDWUTYkj/74bAE=;
  b=B6L6wlMn/jNXWVwEtObkPcK/nceMJpL4B6h8jObk9SPB4LvznTlTuLME
   2Cpu5AwwJaF7SR3Fqugl/RTwmROImedoT9WWn/q60O8qY9+NivMNeMr6Y
   dMO027wQ90j2gDtgXG9F4K9MdyQaFfTbA1DErznXVTduH3l9S/qfZVD/J
   3wJSrlWKPXkSJu8p2XDZNPKep9deuZfpD0b1e1MSbzuMokLhKcS/ZH/6p
   BsrIdgAMr4ouP81vCtrDss9s0wgGgXPYShIO5b7UFivsrZwiihyoyCLoU
   ETANusyV5W/Asgvy7bSI3cYFfLeIDrF9GknJoe8BmvL3gfNQjWpCYz3hz
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225695"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:50 +0800
IronPort-SDR: Ky0gHAHbkjnAb6gHTzokO7Jh/Hbi8tjRbY8Nd1X8oo643yXQ6fgwTCAFZoSSc//boEmcKpVzgP
 FVw+RojtjZ/5SaDdm1OvF1R0g9jvYaK1xkcY0MfnFTz/D0wXeQEbsiIzJ85s73qGkSaHy7yoSA
 FqBozUr3FP2bIS8Lz9ARL1bcmLhMEmUHY+fCVCou+BUWRtkGCMjNf2yHPyvEraYckJFVkijZYx
 hMXLYPlTmM+6sd/hBJ5/aEZ8ffh1pBdf4hHxQ16bXxomQtq55k+QnAYrZRyJeirp4/6PJTnHgs
 cSfpZck5kJKqEm8o0JYsUrRi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:27 -0800
IronPort-SDR: hYZcvjILxERGOSQFulRDny3/5OdeZeGJgXB5pqowNfzITT/kB3HTRQWFsjoLgGqDX1gw9fjqGe
 tDaFekp8vj775OD2zohvhKY98vBYt5hTHpFut1AFhUiPoQnKx7c3UtQ15PY3fx+8xUuv95LqbO
 PRnMynYxIHaaBQ8h/kZ+apHqyRHEzfg6X8zPiO0gpV4eiMnZ5dDQ4e2Zcaoo3uXr6us/sdrBwv
 iqk7k2x7NmfMz0kkYGVgiDyGYyxh0nljSkE7qUOsZJL2ElM3RS6XzNtfvr1+nDWm4dZMYs/kYL
 I2k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:49 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyd2rJNz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:49 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1645154088;
         x=1647746089; bh=zjQtSMfQ52GW0Ojk1j2LnM07JZeQhoDWUTYkj/74bAE=; b=
        s2GsU+3kKFwUHdAu9UvyTpq9hHT96EGVau0p+w89NKA4Wc2FGdjMc9wLzNhVb+se
        J6LaCXT/0Zn80Jg4Y8sS8pyiAW9a26kEKTE2NBoHvjqlYt/TdULpo11FdkUhR3ZD
        GKMIsq9j0K9VQAhm7cWbOMn9b4ra5iSVHDQJONboCK9rHyBj6n/rkxXykjTdCsht
        q94MOyUKZ5/oCjUHKMOn2BQNzqMwS9riAxHWV4ThaIT99dlPYXSIQWYJvNwf3FMM
        +Wpc5+rnwHHjMfsNwqld1wD28X6oRO7HZx4A3p22eytJZXtwxx6neLHdIflS5gJk
        mZilxvykFM3XvKDDoEW6vg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id f1xT5XPHWqxF for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:48 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyb1pC4z1Rwrw;
        Thu, 17 Feb 2022 19:14:47 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 00/31] libsas and pm8001 fixes
Date:   Fri, 18 Feb 2022 12:14:14 +0900
Message-Id: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
 drivers/scsi/pm8001/pm8001_sas.c  | 301 +++++++++----------
 drivers/scsi/pm8001/pm8001_sas.h  |  66 ++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 467 ++++++++++++++----------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +-
 8 files changed, 611 insertions(+), 710 deletions(-)

--=20
2.34.1

