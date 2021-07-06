Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B941C07E9C
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FFBC61C5D
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhGFSS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:18:59 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6083 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595379; x=1657131379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OA+71b/TLdI1LxAdJVq9KKP8JUaFaLf4wnqPPllcBoY=;
  b=L+kZRDvCG3JKnO+4uPLJ7N0RifM+hsFndkRmUhusOO82XV2yqQQ7xyuW
   2Xc/fviGcl+cIOGw7j69+yq+a76ZeEcfAJtEmYrJkIWAOxXY2YcU9twBX
   ECPpVZYtcTd0U8cB5Iw6EaCU7L0x5MdPDVc0GIS7MYmET0WsHNmmCfNZv
   pRVyJDXBTF+MvZmH2hWyHuGKwqpNMthArzS+lWsXv3XZDO+oU/UTd8ErC
   NLv2qk6tk+TX3yQSfXUTzLNIP7m72T6xaW3NsbVdBsCk3kVd4ipIIdInU
   7m7RbtM8xpDCoIucTzLJD3cUx1HP9enG5dqLvNO2WxbGu5meX6CdFrLyS
   A==;
IronPort-SDR: 4JOawFvAbQYOprt4nGOegK7Z+8QHaZXMNxrT2kytqqKkb/o4g+IV1mNqtfwtvXbl91TStVZp69
 ZP2UJN6LCneo4g3MpbuS1gW+Po0wjqkoxWruDyxsNUkBsfZgUCK7/Qp9cGE4xUrwsuviV5jJfd
 W0F1nBneM1eqepWSKBnR6gLEpRqZ4kNcL9rmkts6j5ic2EKaw0r5JnExH9nHEeAJey3GIUBIsS
 3GCOZ8DYuOfVGo0Pyuc9osIeQAbplm8SMKG+MwwPkoTB4XvpZmXxd0ZbIMZoofBpYpx9rUmSIg
 AHE=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="127846822"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:18 -0700
Received: from AVMBX2.microsemi.net (10.10.46.68) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 6AA067025B5; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates  PATCH 4/9] smartpqi: add SCSI cmd info for resets
Date:   Tue, 6 Jul 2021 13:16:13 -0500
Message-ID: <20210706181618.27960-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210706181618.27960-1-don.brace@microchip.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Report on SCSI command that has triggered the reset.
 - Also add check for 0 length SCSI commands.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5ce1c41a758d..c2ddb66b5c2d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6033,8 +6033,10 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"resetting scsi %d:%d:%d:%d\n",
-		shost->host_no, device->bus, device->target, device->lun);
+		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
+		shost->host_no,
+		device->bus, device->target, device->lun,
+		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
-- 
2.28.0.rc1.9.ge7ae437ac1

