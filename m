Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B8BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbiBNCTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiBNCTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:42 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3841B54BF2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805170; x=1676341170;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KKEtld2L9VCtiFRt0r0oB9Wq5zeRt+5cPZAoI4ozEXI=;
  b=KnY6aHUiW4jnJpPsewEdoqwcZ7bOnhTAQ/V1P+QMnMoGCGbnxf9Fitzo
   iR69LWE5ll/3tccdwM2Mota1Duw2uOYnYG1twC10RdYd2dUsITOrXT0Gk
   6QAoGVN6/3CjxCIxTfiQkneinjlmpFPW2cfVojJEwK/8ZF8pbObNiIqs3
   Qgb0Q5bAkcJYXbnp7H9cvfyUTgraEFX6PL5Bq2YJEjrVTBcrCQpoAaWH1
   b3gP+KnmGzpeWTd/38rQIVFDp1QTJPaA+CNuCrslcbvyEOTqTxkTNSVHb
   z7OeNDIp5Ou5KxZKNuTWGWcJqEpMQKfXm/MLIPMet4ZCwXOlytNFR8eAW
   g==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819746"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:30 +0800
IronPort-SDR: 0H3yW4aVBHex3V2vcrDsJSgBDDLmdsSikHUUYH1Bn2blTqFzOlg/6oTOaSdkGMgbe9ZgMSyp1E
 VL/779NTudoc21qHFgGpqXGdLiDnvNDCE2AEwlfdbv0ntw7QufozgCqOL9FxgAWj0YYQxL56ZW
 jbEv+EjhL+GMIQcijMF2XqJTqsMZCDo7CAxRHQO+FR/gZ03InG5Tlxz9Et510T27GfTV5SaZWR
 IRZ/EsBlBF6wITMmSOwHkHKFOCdVm6uv2rDpFs/T9NndF6zdVta+hh2FMAdBR+ijNino5gvuXX
 171usAl4kuHWsdMVK/dBZeKq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:22 -0800
IronPort-SDR: nbiM50gUBJKYwUbHdxLYNQfpENv4JYYckFN0FXiI5y2WGzyfXrpXIC/aTWDf2GjWwKoYlU4iif
 OoISpgD7ZuAbGLZFRyf7pjdgDwyuV6FngeWT0OP673+l3Tgpr3H3k0isNtVp3kpSy46wzbut8i
 KVI5xkZ/3Gsu5utJQj7sdsALiFdOpzdC1isng8gHhFGgsHwtI55SF82RKBiiT1KbtfGbgVOyCO
 KghyIZgRvLNJiJ/mZVVVjMFkjxDDWD7dV0+1mvvW0WML0m3igC0i+uT1VaCFrnyXWZL5JEM8pX
 xW0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwg3DYVz1SVp0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1644805170;
         x=1647397171; bh=KKEtld2L9VCtiFRt0r0oB9Wq5zeRt+5cPZAoI4ozEXI=; b=
        b8tkTFyNin8vjbV0O3mj2EuwzzTodbqxgRPirCmTQENj1ObNsAkDyPc1exRL4eEA
        5iCWl6KyuoUTt6tXn415CZvJVpA4JRj+sfwKFbd/ZWnjMJ4i4Uv4zz8AlnwDQRfS
        wHLmo6mKeDEbZQFBzfA9/RKqVdVOCAufEwZFpZl/6HhDFzyUE8aCCC9/ZhjL0nWJ
        By8EzsE42kzvS+dZekxjfi8paRWQDJYPEVwaawXwf5viau53LSqU7rMs0zbcMU4e
        fqIPfPifVWBdxbEz4lGD7Nd0nmU3BUTj0gH/F9bLZpKxVes7kIgWFrj0u4NyWPSc
        SnNT9aPe3jTFxOAsnjHS/w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4BG5Nkthu7cA for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:30 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwd3YCKz1Rwrw;
        Sun, 13 Feb 2022 18:19:29 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 00/31] libsas and pm8001 fixes
Date:   Mon, 14 Feb 2022 11:17:16 +0900
Message-Id: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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

The second part of the series (patches 25 to 31) iadd a small cleanup of
libsas code and many simplifications of the pm8001 driver code.

With these fixes, libzbc test suite passes all test case. This test
suite was used with an SMR drive for testing because it generates many
NCQ NON DATA commands (for zone management commands) and also generates
many NCQ command errors to check ASC/ASCQ returned by the device. With
the test suite, the error recovery path was extensively exercised. The
same tests were also executed with a SAS SMR drives to exercise the
error path.

The patches are based on the 5.18/scsi-staging tree.

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
  scsi: pm8001: Fix process_one_iomb() kdoc comment
  scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
  scsi: pm8001: Simplify pm8001_get_ncq_tag()
  scsi: pm8001: Cleanup pm8001_queue_command()
  scsi: pm8001: Introduce ccb alloc/free helpers
  scsi: pm8001: Simplify pm8001_mpi_build_cmd() interface
  scsi: pm8001: Simplify pm8001_task_exec()
  scsi: pm8001: Simplify pm8001_ccb_task_free()

 drivers/scsi/libsas/sas_ata.c     |  11 +-
 drivers/scsi/pm8001/pm8001_ctl.c  |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 450 ++++++++++++-----------------
 drivers/scsi/pm8001/pm8001_init.c |  11 +-
 drivers/scsi/pm8001/pm8001_sas.c  | 297 +++++++++----------
 drivers/scsi/pm8001/pm8001_sas.h  |  64 ++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 458 ++++++++++++++----------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +-
 8 files changed, 605 insertions(+), 693 deletions(-)

--=20
2.34.1

