Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7341EC43217
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347701AbiBKHhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347691AbiBKHhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:09 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AD810B1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565026; x=1676101026;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xiLsP9CFhL30X8+2XhFRoBf+VMG7+gFXJS7seKvJFH0=;
  b=BIsQsuolsIQIeFZ4upITiWP7D3zY5lhaKEPUyWyYLhv4zWEqvpaWPErm
   ZXt+NyV++26kHsyZf3jAlkY5KExfIZnh5ieLdvls9IsJG93ZHrh7AVZ4g
   rlJOvmbTxf+JOy1HX/Bzuw2oJl8kZCxZlPzTecaZhhPbqaBIhsQY62kxU
   X+uMbQbS2aE6TcRGWSuxgcJucj/Un+siDeA0MuJeFvq+eJVl6gbJTs7Zu
   wGqy6F+EGOH7S8vlpC/FBiaasGjjXLoIpJA4BJMYNDzKJDMCorv54vKrt
   lzxwDnF8BI5+y7Z4163J9A9JVAgC4x1bcaimjrrlhqg6P7pgDX8oMYF98
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675109"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:06 +0800
IronPort-SDR: MgJG+JRGr3hx+GQMTWdX/BVbwgC13ReH6f1SCm5xBtnpprXP7woQ6Z5VvHWfT6X69gdxRVTwzB
 Kbv/aZsOWrWkOeFtNwfjlV5Wrw0g1BFbojPjaF7gqyYpt3JnbbXgW0d3nXDssVWxCkM8gGhND5
 jDjEpqyrrpHseVc0rom6Bo+n182OLH17JmVgdClIcRRsMLRHKwppJ/YOpRxVmmXW+IXrjuUr7w
 EQV0nvZJuRQ8EtWVejokj72Vgub6qxX7DxSDWH4+U5rXJju9eCDCKPqoAdmITXsaO+Tc/tF9VD
 GTSZLjZY8KZxyFxR4Eyzmucq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:08:54 -0800
IronPort-SDR: oJ3gFAtX7a2g167aCbU4kp3rbn1PnS4HZHqopngLhHt6kCtoDUf5rptsTJrO/CFQWiBoVX9OGI
 DqhJ6mL06jxBJd8DoBqLZSw6GnR6kZav0KhvunYnS2AVXtCIE9evzGIemOJ/m7YOq0QitqJJHW
 nsHSf3sGtV28lPQGDpcNjWICCtXexhRJ5XpKl7OA7cI2x1YN0jGkdLTGKTdd989F2qwszOEbkg
 tepVlmMzja74aqtNXYTsm2auNvft5Xb1IwOdZWmVZ6MKnPndKwT+lmJUQVvhgBz8V7BgMk80x9
 Rss=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:08 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56W3N3Hz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:07 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1644565026;
         x=1647157027; bh=xiLsP9CFhL30X8+2XhFRoBf+VMG7+gFXJS7seKvJFH0=; b=
        qgIlrY0dq8cLEawzuNXAAfTFdkSAhp5rpPGNeo5flQL0oN9CQJH/ovJEw47dDI2v
        g54pWvHj5cCDlyRHZUva7nzHzPQw1de67vSzp5sekjq2qojkDvjFLMKDbiAEETWL
        lMMqzHSkxEthjYz0TCt5Y8J2DZEQh4pz0vtqysazfVip6MCQ85PzMzMvJY1Cogcm
        6emuTYHn1UR5l+5TU8whm7YO/CeXxrghPMLtcvDXmh3rZU0rxuJX74BwtkMKQQqd
        xXoFH8wkhQMej0lAYJjhZYsPdvyqZtXQJ+OuL24jkuqFEpeS1Rgi27yl0QLg6L8U
        5bdwt7mUaij3oFjB7YyNxg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id n_K5sySF40Q4 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:06 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56T6G4dz1Rwrw;
        Thu, 10 Feb 2022 23:37:05 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 00/24] libsas and pm8001 fixes
Date:   Fri, 11 Feb 2022 16:36:40 +0900
Message-Id: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first 3 patches fix a problem with libsas handling of NCQ NON DATA
commands and simplify libsas code in a couple of places.

The remaining patches are fixes and cleanups for the pm8001 driver:
* All sparse warnings are addressed, fixing along the way many le32
  handling bugs for big-endian architectures
* Fix handling of NCQ NON DATA commands
* Fix NCQ error recovery (abort all task execution) that was causing a
  crash
* Simplify the code in many places

With these fixes, libzbc test suite passes all test case. This test
suite was used with an SMR drive for testing because it generates many
NCQ NON DATA commands (for zone management commands) and also generates
many NCQ command errors to check ASC/ASCQ returned by the device. With
the test suite, the error recovery path was extensively exercised.

Note that without these patches, libzbc test suite result in the
controller hanging, or in kernel crashes.

Changes from v1:
* Added reviewed-by tags
* Addressed Christoph's comments on patch 4 and 8
* Added patches 21 and 22 to fix 2 additional problems found while
  preparing this v2 series
* Added patch 23 and 24 to cleanup the code further.

Damien Le Moal (24):
  scsi: libsas: fix sas_ata_qc_issue() handling of NCQ NON DATA commands
  scsi: libsas: simplify sas_ata_qc_issue() detection of NCQ commands
  scsi: libsas: Remove unnecessary initialization in sas_ata_qc_issue()
  scsi: pm8001: fix __iomem pointer use in pm8001_phy_control()
  scsi: pm8001: Remove local variable in pm8001_pci_resume()
  scsi: pm8001: Fix pm8001_update_flash() local variable type
  scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
  scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
  scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
  scsi: pm8001: fix payload initialization in pm80xx_set_thermal_config()
  scsi: pm8001: fix le32 values handling in pm80xx_set_sas_protocol_timer=
_config()
  scsi: pm8001: fix payload initialization in pm80xx_encrypt_update()
  scsi: pm8001: fix le32 values handling in pm80xx_chip_ssp_io_req()
  scsi: pm8001: fix le32 values handling in pm80xx_chip_sata_req()
  scsi: pm8001: fix use of struct set_phy_profile_req fields
  scsi: pm8001: simplify pm8001_get_ncq_tag()
  scsi: pm8001: fix NCQ NON DATA command task initialization
  scsi: pm8001: fix NCQ NON DATA command completion handling
  scsi: pm8001: cleanup pm8001_queue_command()
  scsi: pm8001: fix abort all task initialization
  scsi: pm8001: Fix pm8001_task_exec()
  scsi: pm8001: Fix pm8001_tag_alloc() failures handling
  scsi: pm8001: Introduce ccb alloc/free helpers
  scsi: pm8001: simplify pm8001_mpi_build_cmd() interface

 drivers/scsi/libsas/sas_ata.c     |  12 +-
 drivers/scsi/pm8001/pm8001_ctl.c  |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 319 ++++++++++--------------
 drivers/scsi/pm8001/pm8001_init.c |   8 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  93 +++----
 drivers/scsi/pm8001/pm8001_sas.h  |  36 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 401 ++++++++++++++----------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +-
 8 files changed, 404 insertions(+), 472 deletions(-)

--=20
2.34.1

