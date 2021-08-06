Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE612C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E156611BF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhHFLMF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:05 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbhHFLME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248310; x=1659784310;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M0tFbJOdG/EYQ/+FQ43jhZm21fVPbmfD+f6jwA3S6uE=;
  b=kboq9Qh5WUcaBiyXekE/6fJHWKAf6lrqMgJeCl/pymeLg0xmz0fWZaxc
   AD4jjn2q9jl5sp1TKmfaqZIZJQV0aD2ozl9oDme67k/xikpKon87jDf2L
   z/jtQYloTmz2A1m7RZo7IXLT8hOAC8pLwfoXTdTCndnidwkftj3sbtzon
   wI/c9URSgmd5IjXKfKFbHoAHf4uHerb7CygxjabIQM4qNxKXaNdzHz+z7
   sObTNBODOKp+z44jF4zj0UIX/s7o698y9/fr39nF7+PnxID9KnijRL2mO
   NXQu6a1alcps/r15h0soTARdm7gpBVVNzp0n6UKefbFsgEeqouUCP8UCb
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055537"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:11:50 +0800
IronPort-SDR: n1d2SR2gXRWs9weScUpKaYbWJ4CDf2trncJGX/DvOqGMCw5/bDXL5Qs7YdepeHOM7FzYEGt1vc
 XEFdQ8ZCetHldC3wleQx3xCoXbY/RINqZds7vd0K8FYGr/GYoaBmI55CGSaZbA9HkU6w1VFl1H
 0BOkJnyd5f48eSHuv76pm/a1I+L6CqIrgNhj4DTGUHC9fo2nCEXCvpBgwGKT4+Y0UA/KtUjbIV
 hpihcVnuv2nftHhaHq4PjkOGL5Doyl0GAkO87SlkBPTbFKk3MrpP6yu3Qrvx5kfoAvspEtumz6
 cOsWaUSefL6dotNHnimn2hx1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:25 -0700
IronPort-SDR: eK9aDqUCgblWYXvipYeFKhjBfXUDLDvYOp5onjA61Af4JP+0JzpkxOMdgAVS77AvQjpT9g5v5a
 I18NiTIF6Zs5osK+gV8v5zN08ghFPhEQ47KM9JT8oDoZt8imKX/kxo4sSwxkSmPowifFNsIjbL
 0E2x8c/Ja73Nh/EuT7Q9jtQSXCVu+2iBiO2G0+rsnS1E7ZyMBrPGCy5hYwSkdz8dxgVQgvkAkF
 7VS6hqySBzxSl+z8N+JZPnUCra1oLqpSGkEH1IYgQcTLqOawWqlTujzX/fQz//zRBOajKUgseR
 CO4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:11:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 0/9] libata cleanups and improvements
Date:   Fri,  6 Aug 2021 20:11:36 +0900
Message-Id: <20210806111145.445697-1-damien.lemoal@wdc.com>
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

Patch 6 improves ata_read_log_page() to avoid unnecessary warning
messages and patch 7 adds an informational message on device scan to
advertize the features supported by a device.

Path 8 adds the new sysfs ahci device attribute ncq_prio_supported to
indicate that a disk supports NCQ priority. Patch 9 does the same for
the mpt3sas driver, adding the sas_ncq_prio_supported device attribute.

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
 drivers/ata/libata-core.c          | 274 ++++++++++++++++-------------
 drivers/ata/libata-sata.c          |  61 ++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |  19 ++
 include/linux/libata.h             |   5 +
 5 files changed, 208 insertions(+), 152 deletions(-)

-- 
2.31.1

