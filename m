Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB23CCA47B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbiGHSq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbiGHSqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EB4796BF
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305984; x=1688841984;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sh3jOZv5h9DRhdT85tTH26IEhgIKdl5yKeZHMB8t508=;
  b=BScXNioIPg9jAwhISTBbk0S2o2Mamab09d1MzZaen13RRUsL6V173Yil
   I+7UVVuDbn66Xvfs4QqF5RsgGip+Gk2YgpFtvCxYItjgulRzm7GyG9gwP
   0jca0RDU14y6+385Xeoi0wlInoMIR9lMGB3jXeP372Lm09pn5MlDIQmFs
   6UpkOH6IAXO2AB4c+cF5MBZYQV2jkA6Fm233r/XT26EBRrXXBaINto75I
   SKKkZm8sJjK9aLnN21qWyDiRbyKpxpp/st4SMTFZVmUARoAPBlxYYXyRq
   k7ATVotaCOWMHi6kkX6/NKEG4l1dmV3y98gFT4c6asAqekKvHX0U3M3pS
   w==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="181377282"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:23 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:23 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlV1E177434;
        Fri, 8 Jul 2022 13:47:31 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IlVVD177433;
        Fri, 8 Jul 2022 13:47:31 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 09/16] smartpqi: stop logging spurious PQI reset failures
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:31 -0500
Message-ID: <165730605108.177165.1132931838384767071.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Change method used to detect controller firmware crash during PQI reset.

PQI reset can fail with error -6 if firmware takes > 100ms to complete
reset.

Method used by driver to detect controller firmware crash during PQI
was incorrect in some cases.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 77a8e0ed91a8..96b206ab5ecf 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7412,8 +7412,7 @@ static int pqi_wait_for_pqi_reset_completion(struct pqi_ctrl_info *ctrl_info)
 		reset_reg.all_bits = readl(&pqi_registers->device_reset);
 		if (reset_reg.bits.reset_action == PQI_RESET_ACTION_COMPLETED)
 			break;
-		pqi_check_ctrl_health(ctrl_info);
-		if (pqi_ctrl_offline(ctrl_info)) {
+		if (!sis_is_firmware_running(ctrl_info)) {
 			rc = -ENXIO;
 			break;
 		}

