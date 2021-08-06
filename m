Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B114C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27ED60F38
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbhHFHnK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:43:10 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24064 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhHFHnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 03:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628235774; x=1659771774;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A0KuRh0UPtzurt2GlNEMB8FVWMOxKIxeUcV1alAGh6k=;
  b=qgvoH5D8vIH//JRvvZcnvofZ5tzy3kq0q2YdViMNdM+YKmJbZ2B7eNfN
   bLk41xCWduxWOO6VV/JNn06J9ykpk4W+AiOZC6ztjeCU2+z8VCgThAly9
   Jr5/LV9WQG9+FcsB/iTh3EX/NSC6kx79GQbV0qotI2yLrJkgikENrkw7f
   TtachOoy9xfCy50ntCWIJMxtf4yhcy+8Nl6DlrXvpls+R7tcchjoh9Yj2
   5URf5D0EW4MPPrJ7+iPrWvpkozM3+xVDZ29Ywci5gKL+/WkN6GQjQFVxE
   Cd4vOkqOpxUufiPbKI3/GENC+EyGMAV1xInulC3xf2OBV2SC2FClpPE7P
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181296839"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 15:42:53 +0800
IronPort-SDR: EqHd7YH1kxlB0iRmDzst4IRX9mPPgNOoqvvOWnvambkalbEHVInjcr80XWjyq97sU9rtA5oInY
 sBidpe6W303hMuZGUi/SFViiP+dTE9oJcF4PYVG3uOn5DtUH9VGc/vrHQ16W3vC05rX/oGGGCe
 AD48K6gbUvoHQbzMG5PEqhz3k2sv9fqQ7JvLN+1cLyly/lIMBIMvk6iiI+CVKJgRjjjPmLgmWR
 xsFknzUsjSByfiCGH8WegvkJLWAwsYESh/v15XSGqLJedwGbYKNKN98FgAZX+v47UmhTqp1u2X
 1lKI9CKE5/lEGgufAgA0N/BX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:20:22 -0700
IronPort-SDR: YAvcNGLkkx3czfg4CB5iwxC0jdTIz/VaLHoc+ZuX+Mvefp5yaVqfmYHSMczbB+l7tIdLc6Tkln
 fgoxJQ9lOdzMgq1/TcOXfe/CAj4GWIeBsIVQezrjVSkPHrhYxFmWt3MXVdkSvOWRHOmaFCJKj4
 V6Tzob02kpNxtsK+L1xJOvqexZA4gUg9+s1ycNJDVc3GAHqLod80mi3NuHyOK+d0Pt4MsyoEsN
 HCax5hZEofqGgHt603FPqulEtlZvGyh3Mvh81FLgg6TalVQoW/YYlCBTYsx0xzLcMoLTCcd+LH
 r1A=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 00:42:53 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 0/9] libata cleanups and improvements
Date:   Fri,  6 Aug 2021 16:42:43 +0900
Message-Id: <20210806074252.398482-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first two patches of this series fix potential NULL pointer
dereference problems.
The following three patches cleanup libata-core code in the area of
device configuration (ata_dev_configure() function).
Patch r64 improves ata_read_log_page() to avoid unnecessary warning
messages and patch 7 adds an informational message on device scan to
advertize the features supported by a device.

Path 8 adds the new sysfs ahci device attribute ncq_prio_supported to
indicate that a disk supports NCQ priority. Patch 9 does the same for
the mpt3sas driver, adding the sas_ncq_prio_supported device attribute.

Changes from v1:
* Added patch 1 and 2 to fix problems reported by the kernel test robot
* Use strscpy() instead of strcpy in patch 4
* Use sysfs_emit in patch 8 and 9 as suggested by Bart
* Fix typos in comments of the new sas_ncq_prio_supported attribute in
  patch 9

Damien Le Moal (9):
  libata: fix ata_host_alloc_pinfo()
  libata: fix ata_host_start()
  libata: cleanup device sleep capability detection
  libata: cleanup ata_dev_configure()
  libata: cleanup NCQ priority handling
  libata: fix ata_read_log_page() warning
  libata: print feature list on device scan
  libahci: Introduce ncq_prio_supported sysfs sttribute
  scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute

 drivers/ata/libahci.c              |   1 +
 drivers/ata/libata-core.c          | 253 +++++++++++++++--------------
 drivers/ata/libata-sata.c          |  61 ++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |  19 +++
 include/linux/libata.h             |   5 +
 5 files changed, 192 insertions(+), 147 deletions(-)

-- 
2.31.1

