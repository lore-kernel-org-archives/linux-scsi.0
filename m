Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E406C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE5C22C9E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgLDXDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:54 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1478 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgLDXDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123034; x=1638659034;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EAW0KLglLv6Sbl5qFiNslj10+GLqM/6dOaN0YY8QieI=;
  b=OThHDZVCA7t/ZWCQ9lk218sQc16z5D1TAYoHuCfr2A+S7tZ1UjZ9rKie
   qBi5HAFuFv9KeSUvG2ISqNska6WVx14NrvyWQ8pV06CI6TVaRx85Imchx
   1pYg7Q/M8ZvGAOgvxcNpNCHTXvbBtV7ftN+eP6pgSuuOD3tglo/5VejUO
   4VTseQm+3BCaYpR9YlsxkNmWLTiCSYOYEjl7C29L14hKajRZrBkqD2rkJ
   iY2x7ZQu/UkR3TJ4S+vNFKTqi5OV856PjhCDNetwmqghPiQqPfj6ep2eC
   HXHrPhB3OXKeYZrXz53LcXi3JOaYUjc/THLGoAiuG0mmlyUt8AxYCFnCg
   Q==;
IronPort-SDR: 9xCAEen3VfUoeLoaywkR4/c7OlYO2i4vF18wWZ3t6aAKiXavBqkHNx0OAZ5MVyQFVRI7/cAhYV
 X32QRq7Xw/eVF/PczMs68Eqz/eaUzVCgc4oyJu4YXHWbXmiB49kHsNtwef5UZl1HD6mRWSt9kM
 FA+CdMZ9s6kfBPSTsehtvQE/7L2UtAbt4Vxd8NeVwLTpb+0W0meUFE1jPUoA0WvcdzQQ/Uh/FF
 UfmaS0mLNi0NTlR3KoOPo32ypwY/O4q1fPpYTLua2wmEnbE1iDWhbAdzP5qCVoYthq0iQ/e+vx
 UpA=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548884"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:30 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:29 -0700
Subject: [PATCH 17/25] smartpqi: change timing of release of QRM memory
 during OFA
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:29 -0600
Message-ID: <160712294945.21372.4369424711794317420.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Release QRM memory (OFA buffer) on OFA error conditions.
* Controller is left in a bad state which can cause a kernel panic
    upon reboot after an unsuccessful OFA.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f96b8ce2edba..52f59ae50fda 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3236,8 +3236,6 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 	else
 		reset_status = RESET_INITIATE_FIRMWARE;
 
-	pqi_ofa_free_host_buffer(ctrl_info);
-
 	delay_secs = PQI_POST_RESET_DELAY_SECS;
 
 	switch (reset_status) {
@@ -3253,6 +3251,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		ctrl_info->pqi_mode_enabled = false;
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
 				"Online Firmware Activation: %s\n",
@@ -3263,6 +3262,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 				"Online Firmware Activation ABORTED\n");
 		if (ctrl_info->soft_reset_handshake_supported)
 			pqi_clear_soft_reset_status(ctrl_info);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
@@ -3272,6 +3272,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		dev_err(&ctrl_info->pci_dev->dev,
 			"unexpected Online Firmware Activation reset status: 0x%x\n",
 			reset_status);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info);

