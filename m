Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8F1C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87AC82073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAQHKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:30 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:10557 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgAQHKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:30 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: 3LZJcimiA6zRJVJNpW9yqlNiUB+YUBkabTAefEYLji1jh2eT+cijGJ3N5n2gYTptpU7mqR5y3N
 lEprXo5clca0myRf7kuym1H1K77KALGDP0YL1ce6PiKBUz7GavIz0TxT7rihUVTSxKGv7Wz3/O
 NMm1wi8Br98rB2JYA9i5MjqFPQlidudSKClXAESzc7T2vZ2BBa0Z2wZzk9+Y2bev/if9QVwkJ1
 8nSQSETKgS/U0iDlZ6eVwrJjW0qegHretaZgOI8cb+pgLQ98nxwy/9nwzys2gVNt7UD7ij+xLx
 gaY=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="61358142"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:27 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:26 -0800
Received: from localhost (10.41.130.51) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:25 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 00/13] pm80xx : Updates for the driver version 0.1.39.
Date:   Fri, 17 Jan 2020 12:49:10 +0530
Message-ID: <20200117071923.7445-1-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Deepak Ukey <Deepak.Ukey@microchip.com>

This patch set includes some bug fixes and features for pm80xx driver.

Changes from V1:
	For "Increase request sg length" patch.
		- Fix the compilation warning generated on xtensa architecture.
	For "Support for char device" patch.
		- Modified the description of patch.
	For "IOCTL functionality to get phy profile." patch.
		- Split the patch in two different patches.
		  IOCTL functionality to get phy status and
		  IOCTL functionality to get phy error.
	For "IOCTL functionality for SGPIO" patch.
		- Fixed the compilation warning generated on x86_64 architecture.
	For "sysfs attribute for non fatal dump" patch.
		- Modified the description of patch.
	For "IOCTL functionality for TWI device" patch.
		- Modified the description of patch.

Deepak Ukey (5):
  pm80xx : Support for char device.
  pm80xx : IOCTL functionality for GPIO.
  pm80xx : IOCTL functionality for SGPIO.
  pm80xx : sysfs attribute for non fatal dump.
  pm80xx : IOCTL functionality for TWI device.

Peter Chang (2):
  pm80xx : Increase request sg length.
  pm80xx : Cleanup initialization loading fail path.

Vikram Auradkar (1):
  pm80xx : Deal with kexec reboots.

Viswas G (4):
  pm80xx : sysfs attribute for number of phys.
  pm80xx : IOCTL functionality to get phy status.
  pm80xx : IOCTL functionality to get phy error.
  pm80xx : Introduce read and write length for IOCTL payload structure.

yuuzheng (1):
  pm80xx : Free the tag when mpi_set_phy_profile_resp is received.

 drivers/scsi/pm8001/pm8001_ctl.c  | 662 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_ctl.h  | 185 +++++++++++
 drivers/scsi/pm8001/pm8001_defs.h |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 303 +++++++++++++++--
 drivers/scsi/pm8001/pm8001_hwi.h  |  18 ++
 drivers/scsi/pm8001/pm8001_init.c | 104 ++++--
 drivers/scsi/pm8001/pm8001_sas.c  |  37 +++
 drivers/scsi/pm8001/pm8001_sas.h  |  70 +++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 390 +++++++++++++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h  |  55 ++++
 10 files changed, 1767 insertions(+), 62 deletions(-)

-- 
2.16.3

