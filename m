Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D23C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbiGHSps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbiGHSpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:45:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E805724F
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305945; x=1688841945;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bzfhQpZh2tiuTsI2I1arhHSYlhM0VHeCsIL+XG708X8=;
  b=an7Fheig7BwA9MpEOME+okcTwItjGyR2/yjO9nnBs6J+uPv3GwUKm5bO
   fjMJMxHo1EX330OLiN9taIcU0BfUef/zKCZ7sXzrY9vstQFy3TJJUzg+H
   OxJgnPxLTa5BWjf2bvqElOWlezXuaIm5VF/pDpk/hJN7GM3Z75trEFuoh
   CqiXwtzFYIvb7uwZW7p7YdCmdG4wWBEsmcQExux6IS/TDn4RPDWRFNRle
   oWMmTwndeDJO2LgdvfryraeRnHrolX4dIPEAFrzpv0aE+mbV1mXWekTik
   Nb2Kg9e6tBuZ9rCiBbPkUCN5oQ3//Yi0+dN3ISoO21yWAofu5YiCC31tD
   A==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="171374287"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:45:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:45:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:45:42 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268Ikoos177284;
        Fri, 8 Jul 2022 13:46:50 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IkoU0177282;
        Fri, 8 Jul 2022 13:46:50 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 01/16] smartpqi: shorten drive visibility after removal
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:46:50 -0500
Message-ID: <165730601025.177165.9416869335174437006.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <Mike.McGowen@microchip.com>

Check the response code returned from the LUN reset task management
function and if it indicates the LUN is not valid, do not retry.

Reduce rescan worker delay to 5 seconds for the event handler only.

The removal of a drive from the OS could have been delayed up to 30
seconds after being physically pulled.

The driver was retrying a LUN reset 3 times even though the return
code indiciated the LUN was no longer valid. There was a 10 second
delay between each retry. Additionally, the rescan worker was
scheduled to run 10 seconds after the driver received the event.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 +
 drivers/scsi/smartpqi/smartpqi_init.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 2e40320129c0..49895c6ca64c 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -708,6 +708,7 @@ typedef u32 pqi_index_t;
 #define SOP_TMF_COMPLETE		0x0
 #define SOP_TMF_REJECTED		0x4
 #define SOP_TMF_FUNCTION_SUCCEEDED	0x8
+#define SOP_RC_INCORRECT_LOGICAL_UNIT	0x9
 
 /* additional CDB bytes usage field codes */
 #define SOP_ADDITIONAL_CDB_BYTES_0	0	/* 16-byte CDB */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7c0d069a3158..fa5cd2dfa3ad 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3322,6 +3322,9 @@ static int pqi_interpret_task_management_response(struct pqi_ctrl_info *ctrl_inf
 	case SOP_TMF_REJECTED:
 		rc = -EAGAIN;
 		break;
+	case SOP_RC_INCORRECT_LOGICAL_UNIT:
+		rc = -ENODEV;
+		break;
 	default:
 		rc = -EIO;
 		break;
@@ -3697,8 +3700,11 @@ static void pqi_event_worker(struct work_struct *work)
 		event++;
 	}
 
+#define PQI_RESCAN_WORK_FOR_EVENT_DELAY		(5 * HZ)
+
 	if (rescan_needed)
-		pqi_schedule_rescan_worker_delayed(ctrl_info);
+		pqi_schedule_rescan_worker_with_delay(ctrl_info,
+			PQI_RESCAN_WORK_FOR_EVENT_DELAY);
 
 out:
 	pqi_ctrl_unbusy(ctrl_info);
@@ -6256,7 +6262,7 @@ static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct pq
 
 	for (retries = 0;;) {
 		reset_rc = pqi_lun_reset(ctrl_info, device);
-		if (reset_rc == 0 || ++retries > PQI_LUN_RESET_RETRIES)
+		if (reset_rc == 0 || reset_rc == -ENODEV || ++retries > PQI_LUN_RESET_RETRIES)
 			break;
 		msleep(PQI_LUN_RESET_RETRY_INTERVAL_MSECS);
 	}

