Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8A7C47434
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F13F23AC8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgLHU2Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:28:25 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25043 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgLHU2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:28:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459304; x=1638995304;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fqD7fIXJQqqYfdO/Mbuy67NUTWTwq/GqW2j5bgoM1y8=;
  b=FYjFVMFW8FwXRZque7O7ZNcC6PR9W/gZ5mSU+HRJxJUzgX70uPnQKRiq
   UAHnD+3vgtcS6ka428kXS/t8UzHhSlo2QSjrET1yyGQbJLJuJxN6TfV/y
   emoMk9xIwHIs4RhOidj2yoObyqlkxzP8ob/BsaGW+eROhEHaWqcaQLxZ8
   RDv2arQ0c6wben/6R3mGg2wheN5i310lyQI5/+cMFPbUxdZp5W3sljYQ9
   x769ddWiuGjYKqhahWbRK+ZuD/japVoshnJM9aNwFK3RX9rIBT9ecZ7SS
   Qjbti0beQvvh1m1SNJtWOScX1yKL3HSOuoZvNCxokZMFB4+TCLE0a8Bej
   w==;
IronPort-SDR: jz94RpKbISzteC7pGtjBKcnHX7VfpA+a1gPKw+VBvwouiQQDQYUNQOH5axcX4LUafcoScOWjNt
 CypNfK7Ir8qal3+y5vnrZgrhBNFieFrsmIkwQghwrTCRPEPLmWx614XpagTuTRr0I3jEeFVkye
 NZGGv4e5BTjENk2qjbYvN38cYrBSHQUKyM9X1JOE6e1GjVA0z2/Pf7fBIOz0lMd9Hl5NmqyKm+
 p7/T2LYT9dRZw63glaxKafEaG1098vVpu5b9+aU+OqoDmEYDEOfw2cwjI28S5Ixt5C+1qwdRXb
 pCI=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102012247"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:14 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:14 -0700
Subject: [PATCH V2 17/25] smartpqi: change timing of release of QRM memory
 during OFA
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:14 -0600
Message-ID: <160745629407.13450.7299440442704498059.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index cdeaeb162504..e7d86356bc5a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3299,8 +3299,6 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 	else
 		reset_status = RESET_INITIATE_FIRMWARE;
 
-	pqi_ofa_free_host_buffer(ctrl_info);
-
 	delay_secs = PQI_POST_RESET_DELAY_SECS;
 
 	switch (reset_status) {
@@ -3316,6 +3314,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		ctrl_info->pqi_mode_enabled = false;
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
 				"Online Firmware Activation: %s\n",
@@ -3326,6 +3325,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 				"Online Firmware Activation ABORTED\n");
 		if (ctrl_info->soft_reset_handshake_supported)
 			pqi_clear_soft_reset_status(ctrl_info);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
@@ -3335,6 +3335,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		dev_err(&ctrl_info->pci_dev->dev,
 			"unexpected Online Firmware Activation reset status: 0x%x\n",
 			reset_status);
+		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info);

