Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36254C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE63023E51
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393271AbgLJUi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:38:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:13293 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404653AbgLJUhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632641; x=1639168641;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n26blj5N7CQZKCNhBxhXS0TfPvrHTI1mUYbPNBWrfoI=;
  b=x+BMEGg1+ZNMtAzy7HnkM98nb1hTIWIeWLn536E/DCMwFo+CB3Tc0jRO
   i2sz2dFU6gIL+5JiP4Rk3CgsrO4B70LLjlV1dUJNAsvkTVb9bmgKtwxX3
   IhMSyoKWdfzpEQswMFE83z53n44KYMeOfrhYwyoyFmgrrrrhsrBLRR64N
   v5rCd9Vt/i6ttRRpaXTzSSfgbC+AFDF1673teTuBAKa/vLbtu1k2pKkS2
   1eMf6MvdIEC9dvoJXrZtCCFGso7O7DP1dxPIiv1p01snuy4sdMUNesBKL
   O+Yo5OEfV/LfUNpCjXhrVeuPiPiwGuS64mvkRSv90/Zoxgamg6t2AlxeC
   g==;
IronPort-SDR: 943p/+GvSbTPKorlgBMCy/D73MSCQtc0u7oVho+ocGIj8OYWYBQjraGGy1aQDvOJ9niKElyDwi
 EBYihim8auXqiwHuR8cRstc9cMRaWLb3N6uiNFQLp1Ok8OPbVxgZlkYBpdaug+tQeQzEHIxYxe
 fGSNsAtVcdkfEidAADGoxBf0PnmWHWg25ynERem5EWn0FekeyUKDSzv18xSphWffRGxlGD1bYj
 opOZuD7wQqIeoGs8ARGFU87+OAvsTWDexZBr4e5mRD2/qxmSNouq2UKOh+MOimh8S4s687ua6q
 wBg=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="102325193"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:36:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:35:59 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:35:59 -0700
Subject: [PATCH V3 17/25] smartpqi: change timing of release of QRM memory
 during OFA
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:35:59 -0600
Message-ID: <160763255925.26927.7798016026983421676.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
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
index 456ea8732312..552072812771 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3305,8 +3305,6 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 	else
 		reset_status = RESET_INITIATE_FIRMWARE;
 
-	pqi_ofa_free_host_buffer(ctrl_info);
-
 	delay_secs = PQI_POST_RESET_DELAY_SECS;
 
 	switch (reset_status) {
@@ -3322,6 +3320,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		ctrl_info->pqi_mode_enabled = false;
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
 				"Online Firmware Activation: %s\n",
@@ -3332,6 +3331,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 				"Online Firmware Activation ABORTED\n");
 		if (ctrl_info->soft_reset_handshake_supported)
 			pqi_clear_soft_reset_status(ctrl_info);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
@@ -3341,6 +3341,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		dev_err(&ctrl_info->pci_dev->dev,
 			"unexpected Online Firmware Activation reset status: 0x%x\n",
 			reset_status);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info);

