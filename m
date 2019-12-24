Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5F2C2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F624206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfLXElJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:41:09 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4165 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfLXElJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 23:41:09 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: Ls9NNyoimWvRXiwZbyPixfe79qHUnr1AJ7qMFc2imxBN/odfv0eK0M4FSCiDbsKwx30RV4jpwL
 Ni/jd/VdkKlzoTZjQ3U2LgYhAWKqp3SnX4RDraDLxZbHMRd/1NmAxuGjhbOj5s7UgL6Rc8WoyY
 JuYdlmX6c6cz5dtQr5IpflOZzJFhWcy/BQL3fpv/HxV1u5IroDQrySAUqCs8H1uFE04qjQFbuE
 HSIeIxrkNJKQ7OqM498HOHoUoYm6U9Tq/CLZ4bC1792pmPqBssloA6sz51mFqf22cNDM/6E49u
 1L8=
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="61418496"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2019 21:40:52 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 23 Dec
 2019 20:40:51 -0800
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 23 Dec
 2019 20:40:50 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 00/12] pm80xx : Updates for the driver version 0.1.39.
Date:   Tue, 24 Dec 2019 10:11:31 +0530
Message-ID: <20191224044143.8178-1-deepak.ukey@microchip.com>
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

Deepak Ukey (4):
  pm80xx : Support for char device.
  pm80xx : IOCTL functionality for GPIO.
  pm80xx : IOCTL functionality for SGPIO.
  pm80xx : sysfs attribute for non fatal dump.

Peter Chang (2):
  pm80xx : Increase request sg length.
  pm80xx : Cleanup initialization loading fail path.

Vikram Auradkar (1):
  pm80xx : Deal with kexec reboots.

Viswas G (4):
  pm80xx : sysfs attribute for number of phys.
  pm80xx : IOCTL functionality to get phy profile.
  pm80xx : Introduce read and write length for IOCTL payload structure.
  pm80xx : IOCTL functionality for TWI device.

yuuzheng (1):
  pm80xx : Free the tag when mpi_set_phy_profile_resp is received.

 drivers/scsi/Kconfig              |   7 +
 drivers/scsi/pm8001/pm8001_ctl.c  | 665 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_ctl.h  | 185 +++++++++++
 drivers/scsi/pm8001/pm8001_defs.h |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 303 +++++++++++++++--
 drivers/scsi/pm8001/pm8001_hwi.h  |  18 ++
 drivers/scsi/pm8001/pm8001_init.c | 104 ++++--
 drivers/scsi/pm8001/pm8001_sas.c  |  37 +++
 drivers/scsi/pm8001/pm8001_sas.h  |  72 ++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 390 +++++++++++++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h  |  55 ++++
 11 files changed, 1779 insertions(+), 62 deletions(-)

-- 
2.16.3

