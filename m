Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E532C3524A
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F09C206D3
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Zn/grn00"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgBBKrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 05:47:05 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8763 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgBBKrF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 05:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580640424; x=1612176424;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yjQuSD40krTJ5lbMtA0mAHZ+m2VaBFNpM0wv92vjO+w=;
  b=Zn/grn00BluzHpNNHkpeSi9GnIMUpCPrAx024twF5YKT40DTS4eORtMM
   U/SMqwStcAjuGJdRnGrw3qRV1V7At5fT/Gh6RMb78r0kUupZpfiPIOH5f
   Y+7srgYBgJW5Fit5FgvDLP66ANedS87AfoRc5Xq/e9miV1QPFOpq2Cnw/
   P67MkZPsEDWS1P/UGS67nIJwIfdBIJoAhYgcvyDio3ijz+Kd13Alkgjp1
   yRtfzomGH0Ywr8UfnyTuJAnHnOXurxoneFcJ2sNLUdQEHvpW8WLBN6g4M
   aM398K3BgU7fplqYkYKlKuRITggBKIuCXepJ9ZfwY6wjUkdtr4a9TX0bH
   A==;
IronPort-SDR: rFEBJ/1hooDXnzcwk5Ok5OV0PjUkIaUsHad/2Y0BiRVSbVh/+LJNCtErWBQ2sOlWGF05+QjCQc
 QSU0Nt9tVFDATvpvadhhpmcRkVNYRSshn7VfHgvlmqNsao3SRd7axJlyX1MMuKUqW6d2lnZ5z9
 vZnvKLnhwqc5QdQYTUngvEkZ7dzjKw2AdMK2VBcffHkdrQCPY3AHGJnyE64VB81VxCYnQEYozF
 9/b5socf9+hUCkf+6ZZGr3LdPmkW83wNPkU77JGOw5wvnxyysGD9Tbp6sRAMQlrBhV/IjPkUYV
 8fw=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="128925954"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 18:47:04 +0800
IronPort-SDR: uWC/UjAy3RSeXoawdu71gaPnTIkUpcSquMBkylKgNYoSFtvK29Ec4vAt8BlAp8X5h2hNwcxd4V
 QeQTd3kW4IQX0aifVvwSTZtCvduIvM/OV/F3iYLBVqTsvYg51js7vLIBHKIYiJ/k+IIaJ2hcnD
 EQawLYtQas8zISsC1PVoTQ7Ki9O3A4XHQIBQhz0dgtTEZGWvlaKb1ku3wkQbCD7pxaIXOLGIbp
 KwK/2D0ds8+G4MBdi03f1Ljo+t8fFQtTv2Z9GeHo5WhAajOi0A1lunYZCAZVt4+jw8J8zuEbTh
 ClCjFMyUJHvVuVl3KxER4mPY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2020 02:40:11 -0800
IronPort-SDR: g+9jY9rY9xTXIIquZP0DDVLcZSPrWRPo0vTrMzg+040639CnXVwSeI6U80xQFEATz74GDlXKSa
 cNIo6iZAk9RQ9T7Bw5rpccjU31iLscLc0yXwxhRwuECepKHv8UEkAphwTxX/L0iU03GHvxCKHn
 ZV3E8/HVRkIWmDEn5/W844o+tuBWGt/eMmIARHkte4jmNI5JGM+kvlJLBdAGDAi+CEHFXjhP6E
 VuflnumyduM2YD4ClhaAIJw60vaZhg1/Gy3h6Cu0FS9hxUvTkcFVbGgb1Q8xXuJwTBUWxeCSo1
 TLE=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2020 02:47:02 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Avi Shchislowski <avi.shchislowski@wdc.com>
Subject: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Date:   Sun,  2 Feb 2020 12:46:54 +0200
Message-Id: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS3.0 allows using the ufs device as a temperature sensor. The
purpose of this feature is to provide notification to the host of the
UFS device case temperature. It allows reading of a rough estimate
(+-10 degrees centigrade) of the current case temperature, And
setting a lower and upper temperature bounds, in which the device
will trigger an applicable exception event.

We added the capability of responding to such notifications, while
notifying the kernel's thermal core, which further exposes the thermal
zone attributes to user space. UFS temperature attributes are all
read-only, so only thermal read ops (.get_xxx) can be implemented.

Avi Shchislowski (5):
  scsi: ufs: Add ufs thermal support
  scsi: ufs: export ufshcd_enable_ee
  scsi: ufs: enable thermal exception event
  scsi: ufs-thermal: implement thermal file ops
  scsi: ufs: temperature atrributes add to ufs_sysfs

 drivers/scsi/ufs/Kconfig       |  11 ++
 drivers/scsi/ufs/Makefile      |   1 +
 drivers/scsi/ufs/ufs-sysfs.c   |   6 +
 drivers/scsi/ufs/ufs-thermal.c | 247 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-thermal.h |  25 +++++
 drivers/scsi/ufs/ufs.h         |  20 +++-
 drivers/scsi/ufs/ufshcd.c      |   9 +-
 drivers/scsi/ufs/ufshcd.h      |  12 ++
 8 files changed, 329 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-thermal.c
 create mode 100644 drivers/scsi/ufs/ufs-thermal.h

-- 
1.9.1

