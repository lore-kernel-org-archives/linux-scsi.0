Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF02DC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 584A922268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgKBQpc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:45:32 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57489 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKBQpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:45:32 -0500
IronPort-SDR: SMZhZyNGrxxZpLmhyc2aLw75QwrUN23xO8zGen7s5sZFZY4rfU2uoTm62kaUZgNxdRQRzj5Rhi
 H2iTLob8+G9TYRUl/jUtxC70pz7AADIdl7CEoCMFz4JJt1DK0dz3EDp/6KZ716ne6/UUuHBmZt
 amwt4O88Q6KJjPCVhDI7jK4l95Ii5I65lRizNCBPckfmPcm7AO++BR2Off/aC1kRmLoRw0PgoU
 iZcRvw3diL1A+qXep8mm2QTePEfSSO/XETz7RxneWtI1H4Ap6AGKf8o25ybtQWFyVxvDXU5OHJ
 ltA=
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="96859254"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2020 09:45:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 09:45:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 2 Nov 2020 09:45:31 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <jinpu.wang@cloud.ionos.com>
Subject: [PATCH V3 0/4] pm80xx updates
Date:   Mon, 2 Nov 2020 22:25:24 +0530
Message-ID: <20201102165528.26510-1-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

This patch set include some bug fixes for pm80xx driver.

Changes from v2:
	- Corrected commit message for make pm8001_mpi_get_nvmd_resp
	  free of race condition.patch.

Changes from v1:
        - Improved commit message for "make mpi_build_cmd locking
          consistent.patch"

Viswas G (1):
  pm80xx: make running_req atomic.

akshatzen (1):
  pm80xx: Avoid busywait in FW ready check.

peter chang (1):
  pm80xx: make mpi_build_cmd locking consistent

yuuzheng (1):
  pm80xx: make pm8001_mpi_get_nvmd_resp free of race condition.

 drivers/scsi/pm8001/pm8001_hwi.c  |  86 +++++++++++++++++++------
 drivers/scsi/pm8001/pm8001_init.c |   2 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  11 ++--
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 130 ++++++++++++++++++++++++++++++--------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   6 ++
 6 files changed, 185 insertions(+), 52 deletions(-)

-- 
2.16.3

