Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FCCC4320A
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2325161050
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhHGETU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:20 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14369 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhHGETU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309942; x=1659845942;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BoNho951di+wnT67CW7p6oJQoJiFEgaX4f5KUd9n1gc=;
  b=Tp5WVs30YgNNMgP8FrAQDUUTh+kk7eyR2T7tslUB/28nWTygv5ulwj2I
   rIb8sRWwMIDyio7V0e5LFKZGfQoKFOe7755mktX+xENbiCKrN/LqkvTUb
   RHCGcQU4uY4CxQ0/SBy+dLkdOmKigusKaVA9YOtPB19BA1HWEpOq8V1TF
   H38NZk4KgRk/fIbE0UBOGlbb61nu3vJIs+lk6rAbPi0A6xfLbnPuvY2FY
   XCWzgLN/C1wBaigw6v7bC+aSXtYn7om0ITUXCZg5aUs6i9kFOmvQE+BOT
   B0wyEmUV/FfdkOAak4sf+KQqdO6dRn83nS0w5DdB/pUpnPNLZYHKcvKSU
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363638"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:01 +0800
IronPort-SDR: CyfX6XwMluT5R36VHFSPOOZb7pDqUhuGiFp7pb20vRXtHFNnqGg/ufvXZA0g5R1r8jdvAs8TQ4
 VhVBzHxb9TbUUic2SnEQ3W4n1MAxl8W3BIzhQzbCYXgBApdOreQuTwwUA4wQmxwVUUFODCKy9e
 93LmCQIq9q54/DT449Rh+rpJXYQccYi2oKoyHk++bduIM24Wmm0W1VbgHGq80lDEIb1pe6Azsb
 eENnQHer93wjQjcJKbp+T1xtOGvQvAgw+lCXwGRN1mNfO6MU3fCcDCO4yI8FCIyK0Gfc8od59I
 pacmNfY8s3Bsb4m1NqWlLceq
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:29 -0700
IronPort-SDR: b0GmPZiljqFWW3kjlBg8P9hyvXvN2azo93Qde7z5VhT8eArjHjW3nk5tGX8Ri39LBpuQnSh2An
 pi8ldqTVOjqfo/vPFWZSKqXDizLxjRfZCnoKC/HRtXUHpI6UJMegC3HL5gZ4gNBw4tmYUNPVSb
 c+hcZ8CzEFAKJNs0NLyRSFi3O7WVE2p3dPUiaA7CR43uTHGM3JlhlEk4dFNBjdhEyBjjco8XJL
 4Sk1SHs5yh/YB2hHrOAnwzU40IQjY1IsgGp7JEbzIUXGTEFwtZIZb1XInz8ZhNcbafPOoiBEvY
 Tho=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:01 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 00/10] libata cleanups and improvements
Date:   Sat,  7 Aug 2021 13:18:49 +0900
Message-Id: <20210807041859.579409-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first three patches of this series fix sparse and kernel bot
warnings (potential NULL pointer dereference and locking imbalance).

The following three patches cleanup libata-core code in the area of
device configuration (ata_dev_configure() function).

Patch 7 improves ata_read_log_page() to avoid unnecessary warning
messages and patch 8 adds an informational message on device scan to
advertize the features supported by a device.

Path 9 adds the new sysfs ahci device attribute ncq_prio_supported to
indicate that a disk supports NCQ priority. Patch 10 does the same for
the mpt3sas driver, adding the sas_ncq_prio_supported device attribute.

Changes from v3:
* Reworked patch 1
* Added patch 3 to fix a sparse warning discovered while checking
  patch 1 & 2
* Added reviewed-by tags

Changes from v2:
* Reworked patch 4 to avoid the need for an additional on-stack string
  for device information messages
* Added reviewed-by tags

Changes from v1:
* Added patch 1 and 2 to fix problems reported by the kernel test robot
* Use strscpy() instead of strcpy in patch 4
* Use sysfs_emit in patch 8 and 9 as suggested by Bart
* Fix typos in comments of the new sas_ncq_prio_supported attribute in
  patch 9

Damien Le Moal (10):
  libata: fix ata_host_alloc_pinfo()
  libata: fix ata_host_start()
  libata: fix sparse warning
  libata: cleanup device sleep capability detection
  libata: cleanup ata_dev_configure()
  libata: cleanup NCQ priority handling
  libata: fix ata_read_log_page() warning
  libata: print feature list on device scan
  libahci: Introduce ncq_prio_supported sysfs sttribute
  scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute

 drivers/ata/libahci.c              |   1 +
 drivers/ata/libata-core.c          | 288 ++++++++++++++++-------------
 drivers/ata/libata-sata.c          |  61 +++---
 drivers/ata/libata-scsi.c          |  60 +-----
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |  19 ++
 include/linux/libata.h             |   5 +
 6 files changed, 227 insertions(+), 207 deletions(-)

-- 
2.31.1

