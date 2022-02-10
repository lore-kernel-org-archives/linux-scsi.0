Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E857FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbiBJLmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiBJLmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:23 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8C7FF0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493345; x=1676029345;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Fv5JzuCDyvCng1JvW9c4aMs2wrSyOdrE5XGQA7lSKAY=;
  b=RT4VhEMXNaU7q922scx5vDxOjNOcplG6UMLd36dBLpyP4g6pqfPMFmlm
   X6EvRhK/bS6wZZY5PN/6aoG4b4Y+DfN6+VgdR/HAL0OQVPyGSu0YNXwjw
   UFVRH/UJgWNTz64JghbILtVD1HCxR2ek2RCUR3CJcPMXRyZkBvzyuzeex
   e3FGYR++t/PogJCYT8YTqA85VR9D0WpUYALUGfIFi9uawvf2NdNcLW2zG
   ZcxtwxgyhGqzMbNCqCMSWE+p/1Md71XvPOdi5qQdXzpnFxgbB6j7PYjVb
   g3kMqli3e6mieRndF6OBUN/ElmlDUhGqUiiD/EVIEk47kQPICDQUdVQaJ
   g==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575604"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:24 +0800
IronPort-SDR: GUd1d4ZyMcyYz9xAy6u+vagQYgtcUalCskNK0Vpr6tQkpHXmECtuFQoCjVgFYmlc0ki6msBoQw
 f1WhXTV/DeEXKBbCJdSFwcIWpZv/jmWao8P8ROUbGzqrGgzUlhZOZuR1fLujKG+oFQEZXT/Md5
 Ck78nYZ0sjA1IIs65YhmJ7czyOn8sMuNCsLwxYJWBTj+Q+bTWPhiOrQY8v7I1LDeer1d/9UKjv
 cadFjZiZ9+dBGMAQxp3K9CjzwwR51od6HHwXkPkOWb8wydDa5V2A3r4cxrwWyUljX0ribwjGzQ
 8KEYziuJGJmOLja4gdeo42Zw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:21 -0800
IronPort-SDR: WXiycAlpFI4pCgiYPzw4BdKkQFTSCJTyOymWUoJm09Y+ePpfMX9/3LdbjV84ZkKjA0Dq6zicT9
 6BhfwOTuHd6krvwKmJVrgQ3AhHWGY4AhgudqrcfIpRIlTYuiqMXxVJwCEbVqvtHFEe7cW0C0Om
 lwoVAxpzWNwNSzv7SyL9Xs8kYIdUT5TPo1c8Spi5gY/9MEe486aLp4yjheaDqHRNCHjzfa8vEM
 2iyxTv3z2SiC3tDjUp0A1ZE6135vqCTjfuXSzK2q6uFd2a4Thij2FpI3nxVxxyH4nKFVc4A17S
 W1U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZbz3sMDz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1644493343;
         x=1647085344; bh=Fv5JzuCDyvCng1JvW9c4aMs2wrSyOdrE5XGQA7lSKAY=; b=
        DwoYU8E3USDIe9JwZ6Ks9yqrzlJXf2TmdyMom8i4UadNKwOBYoCRODdNqMX0BmST
        hJIJyjYFJExrc7kzpOP1LPkRHY5VtcpM/HrFJGOekYhHnumBOP0XAaKtvUUyzgNt
        9NdEBZSLFi1xmw17jhrOQgS7dO5Pj+ow8K4I4BtH991dadrRf5HqwxBG7zRjBkLe
        fxqgDiep+bgY8Y3uC23zrbmKAM0Elfg03aWiM19Ox/JNG/qrEIyQJC07G9bBD/dB
        iHc5pszV0jiGvRgOiokr0mSyjjh5yoS2BqYRUfUP30oasQoobcp9WAgi/sIDOCq3
        vb8kWydxy2zHy6A7nG/Tvg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xV4i7wnyLMM5 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:23 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZby0nGCz1Rwrw;
        Thu, 10 Feb 2022 03:42:21 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 00/20] libsas and pm8001 fixes
Date:   Thu, 10 Feb 2022 20:41:58 +0900
Message-Id: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first 3 patches fix a problem with libsas handling of NCQ NON DATA
commands and simplify libsas code in a couple of places.
The remaining patches are fixes for the pm8001 driver:
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

Damien Le Moal (20):
  scsi: libsas: fix sas_ata_qc_issue() handling of NCQ NON DATA commands
  scsi: libsas: simplify sas_ata_qc_issue() detection of NCQ commands
  scsi: libsas: Remove unnecessary initialization in sas_ata_qc_issue()
  scsi: pm8001: fix __iomem pointer use in pm8001_phy_control()
  scsi: pm8001: Remove local variable in pm8001_pci_resume()
  scsi: pm8001: Fix pm8001_update_flash() local variable type
  scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
  scsi: pm8001: Fix local variable declaration in pm80xx_pci_mem_copy()
  scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
  scsi: pm8001: fix payload initialization in
    pm80xx_set_thermal_config()
  scsi: pm8001: fix le32 values handling in
    pm80xx_set_sas_protocol_timer_config()
  scsi: pm8001: fix payload initialization in pm80xx_encrypt_update()
  scsi: pm8001: fix le32 values handling in pm80xx_chip_ssp_io_req()
  scsi: pm8001: fix le32 values handling in pm80xx_chip_sata_req()
  scsi: pm8001: fix use of struct set_phy_profile_req fields
  scsi: pm8001: simplify pm8001_get_ncq_tag()
  scsi: pm8001: fix NCQ NON DATA command task initialization
  scsi: pm8001: fix NCQ NON DATA command completion handling
  scsi: pm8001: cleanup pm8001_queue_command()
  scsi: pm8001: fix abort all task initialization

 drivers/scsi/libsas/sas_ata.c     |  12 +-
 drivers/scsi/pm8001/pm8001_ctl.c  |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  23 +--
 drivers/scsi/pm8001/pm8001_init.c |   8 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  48 +++----
 drivers/scsi/pm8001/pm80xx_hwi.c  | 226 ++++++++++++++++--------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +-
 7 files changed, 169 insertions(+), 155 deletions(-)

--=20
2.34.1

