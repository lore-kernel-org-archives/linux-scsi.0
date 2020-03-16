Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206BCC0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02E2B20719
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgCPHkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 03:40:07 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17637 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbgCPHkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 03:40:07 -0400
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
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dkim=none (message not signed) header.i=none; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: xVscgpJuSRGUXQ0xrVWiBaPlCHzgfjAl2BICXyh01jIYZ76jO64ObXPzOPtuz1ep01NW2KnbYd
 h4VdoQy0/s1kBW8WPPucfKm0Y8NPbWc74ADLzrNsPd6b5aVm/OK5SZ2auM5kd1R+e5abJJ/pAO
 Bl1+PoY0SuiRRo/nI0UPJpG0TLJh6LobMXvnly4rwHmw5fG1P/yim5kJmQ5RjtpFCewwIOJZwO
 uR7zHSU/5F5Lyfjxg7KR7cTp4KSqr2aeuAZzlx0B79trs6Tp6KNuo0fVgPk1rN2xgkKTV8IA2L
 3fg=
X-IronPort-AV: E=Sophos;i="5.70,559,1574146800"; 
   d="scan'208";a="67282742"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2020 00:39:52 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 16 Mar
 2020 00:39:51 -0700
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 16 Mar
 2020 00:39:51 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V3 0/6] pm80xx : Updates for the driver version 0.1.39.
Date:   Mon, 16 Mar 2020 13:19:00 +0530
Message-ID: <20200316074906.9119-1-deepak.ukey@microchip.com>
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
		- Modified the description of patch.
	Removed below patches from the patchset.
		- Support for char device.
		- sysfs attribute for number of phys.
		- IOCTL functionality to get phy status.
		- IOCTL functionality to get phy error.
		- IOCTL functionality for GPIO.
		- IOCTL functionality for SGPIO.
		- IOCTL functionality for TWI device.

Deepak Ukey (1):
  pm80xx : sysfs attribute for non fatal dump.

Peter Chang (2):
  pm80xx : Increase request sg length.
  pm80xx : Cleanup initialization loading fail path.

Vikram Auradkar (1):
  pm80xx : Deal with kexec reboots.

Viswas G (1):
  pm80xx : Introduce read and write length for IOCTL payload structure.

yuuzheng (1):
  pm80xx : Free the tag when mpi_set_phy_profile_resp is received.

 drivers/scsi/pm8001/pm8001_ctl.c  |  51 ++++++++++++-
 drivers/scsi/pm8001/pm8001_defs.h |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  22 +++---
 drivers/scsi/pm8001/pm8001_init.c |  80 +++++++++++++++-----
 drivers/scsi/pm8001/pm8001_sas.h  |   7 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 155 ++++++++++++++++++++++++++++++++++++--
 6 files changed, 278 insertions(+), 42 deletions(-)

-- 
2.16.3

