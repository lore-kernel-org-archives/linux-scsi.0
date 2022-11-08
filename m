Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D93AC43217
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiKHTTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiKHTS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:18:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5660619284
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667935137; x=1699471137;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vz5T5I3aISwxwXiInuVNx/4TPKLTYbOy5c373IBLmpo=;
  b=Me/Qdi2U0ajVsR07ffnkbMvsx6cPeoqy5txKLQZPJ67f6ToSZ1OCgLUC
   Dp8WfUi8WeZUuh5fWD8u3iGpu2+4g4aGFrqKXSW0YnBNW/m/3dd6ElrhX
   Sx79+OvYQQ+WdtVXvDkk2tcsG4SsCs0TcNs/4khJ0pqQCIiUX7kQo38YI
   1voaAnYWAiGJPNpfINZ5tPhaYsut/y6FsJt4yZ23HHReFcU98oxPz/pdi
   9TNgJRFqwQcaXPIDuCzi5FjjnJiJOltthvlzLBWWH5MxmOLgo/NTqprEb
   B8P+asQiztjsK7NBj2GqtKoEaprSBM0J3juAglyU0FCuLy78wpfj47c2R
   w==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="198949019"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:18:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:18:56 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:18:56 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8JLmXM322596;
        Tue, 8 Nov 2022 13:21:48 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JLm11322594;
        Tue, 8 Nov 2022 13:21:48 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 3/8] smartpqi: correct max lun number
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:21:48 -0600
Message-ID: <166793530842.322537.816949081443241857.stgit@brunhilda>
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Correct maximum LUN number for multi-actuator devices.

When multi-actuator support was added to smartpqi, the maximum
number of LUNs supported for multi-actuator devies was supposed
to be changed from unlimited to 256, but the setting was
inadvertently left at unlimited.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6cda12078130..33059355f9cd 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7423,7 +7423,6 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->max_channel = PQI_MAX_BUS;
 	shost->max_cmd_len = MAX_COMMAND_SIZE;
 	shost->max_lun = PQI_MAX_LUNS_PER_DEVICE;
-	shost->max_lun = ~0;
 	shost->max_id = ~0;
 	shost->max_sectors = ctrl_info->max_sectors;
 	shost->can_queue = ctrl_info->scsi_ml_can_queue;

