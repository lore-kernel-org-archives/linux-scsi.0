Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0165C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 968EA206DC
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfKNKIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:08:35 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:36976 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKNKIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 05:08:35 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: D5U4isC9GiIq44RP/shB+f8pOc1+5JB/pTGRkDzd/HBtqrmisYCh16qp0fbsVpSXgoKpnUTmtp
 Cj8HyZKVpgVEkGGUUcttwM0Cw/RngJYEN+gYYx8+YtEZW50+JRfEegSS4Uk4U3s8AXg515//ax
 X9yGAT5RyuaRCXkhOzPVZX6yhPTWa7iS8QKmtbe7/e9cprfvggs9yBmpp5ORzDhvH/uyZeTgAo
 UDpFnRLq6AhDX8CwiBwuiTKQtYRyoYU2AM1SJQ6KsETAVaXCFXtZbDOGb1+JZqdDymS2RQVpnn
 lZA=
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="55582441"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2019 03:08:27 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 14 Nov
 2019 02:08:26 -0800
Received: from localhost (10.41.130.49) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 14 Nov
 2019 02:08:25 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH V2 00/13] pm80xx : Updates for the driver version 0.1.39.
Date:   Thu, 14 Nov 2019 15:38:57 +0530
Message-ID: <20191114100910.6153-1-deepak.ukey@microchip.com>
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
	For "Fix for SATA device discovery" patch.
		- Spilt the patch in two different patches
		that is "Fix for SATA device discovery" and
		"Make phy enable completion as NULL"
	For "Cleanup command when a reset times out" patch.
		- Fix the typo mistake.
	For "Controller fatal error through sysfs" patch.
		- Updated the function name in comment section.
	For " Modified the logic to collect fatal dump" patch.
		- Fixed the compiler warning for mips and i386
		  architecture.

Deepak Ukey (2):
  pm80xx : Controller fatal error through sysfs.
  pm80xx : Modified the logic to collect fatal dump.

John Sperbeck (1):
  pm80xx : Initialize variable used as return status.

Vikram Auradkar (3):
  pm80xx : Convert 'long' mdelay to msleep.
  pm80xx : Fix dereferencing dangling pointer.
  pm80xx : Tie the interrupt name to the module instance.

ianyar (1):
  pm80xx : Increase timeout for pm80xx mpi_uninit_check.

peter chang (6):
  pm80xx : Fix for SATA device discovery.
  pm80xx : Make phy enable completion as NULL.
  pm80xx : Squashed logging cleanup changes.
  pm80xx : Fix command issue sizing.
  pm80xx : Cleanup command when a reset times out.
  pm80xx : Do not request 12G sas speeds.

 drivers/scsi/pm8001/pm8001_ctl.c  |  20 ++
 drivers/scsi/pm8001/pm8001_hwi.c  | 131 +++++++----
 drivers/scsi/pm8001/pm8001_init.c |  34 ++-
 drivers/scsi/pm8001/pm8001_sas.c  |  70 ++++--
 drivers/scsi/pm8001/pm8001_sas.h  |  24 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 451 ++++++++++++++++++++++++++++----------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   3 +
 7 files changed, 550 insertions(+), 183 deletions(-)

-- 
2.16.3

