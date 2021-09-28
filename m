Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6871FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5287761157
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243421AbhI1X4n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:12981 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243331AbhI1X4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873284; x=1664409284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yAeZ6A19ESeC77rZzmRoaHW06O7xLRp4pfTXZQJyOM8=;
  b=AeR4Rs4+UXDKniAyx74KnT4mV7b71RFneupM/N2N4hy5NwPLxhGDbGG3
   zkGWiS/N+a86Iz62LaGt+aq4goOjIYPw3j8CSh3ExDArUr4FW+WksYLmQ
   0B5TsCBae8t1jWK132ROQrNY46Atkw6bzufjtIofh9XSaKJsvpo0pZzST
   ABcXl6YT+RcGtmMR49ZY7C4OP9TgaxkU+JGroSXLcD7UxdTMnmbpn3FDX
   BA2nnwuQkahh3pA9P8JoJeXPB+HRliF3SmfcoLZ2gy3AUTw597b4/rc63
   /Tq5+X8EEVbcYNOUn7DgJYle4mhG/3Dv5/0og45pRcOvYd7izxz2vtRD+
   g==;
IronPort-SDR: wYb9FaJNJ0giolmDWSw0Kbw7psDOcJ/7xcfdQ8XwvSGB4+3b0g9c4vNtwZy447q3XkCWh9Q3Jb
 7xHBFRl3eY8vEv1oj0CTX4H9d9+BAhId83pD444iMtt/JQN8NAq1/U2XUdMKqKjpjTCr+mnBSd
 456YJwGP0cVj1xNUYBzpRG9cNT1XSBfvsKFTkaLOtwVNSYmy5zpAJUgHz1ukOt43OEtDk+eBuw
 89uwDcXkA8SkdPBkJbjBfKzdzVsHxSbk90a5WhrbNxONgc+Jr1ycgWckGCn12qmqKvrBhoj1BT
 XztizEfYFqdWnc86JZf/UyN9
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="70994975"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 7DE0B702895; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 06/11] smartpqi: avoid failing ios for offline devices
Date:   Tue, 28 Sep 2021 18:54:37 -0500
Message-ID: <20210928235442.201875-7-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Prevent kernel crash by failing outstanding I/O request
when the OS takes device offline.

When posted IOs to the controller's inbound queue are
not picked by the controller, the driver will halt the
controller and take the controller offline.

When the driver takes the controller offline,
the driver will fail all the outstanding requests which
can sometime lead to an OS crash.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 838274d8fadf..c9f2a3d54663 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8544,6 +8544,7 @@ static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info)
 	unsigned int i;
 	struct pqi_io_request *io_request;
 	struct scsi_cmnd *scmd;
+	struct scsi_device *sdev;
 
 	for (i = 0; i < ctrl_info->max_io_slots; i++) {
 		io_request = &ctrl_info->io_request_pool[i];
@@ -8552,7 +8553,13 @@ static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info)
 
 		scmd = io_request->scmd;
 		if (scmd) {
-			set_host_byte(scmd, DID_NO_CONNECT);
+			sdev = scmd->device;
+			if (!sdev || !scsi_device_online(sdev)) {
+				pqi_free_io_request(io_request);
+				continue;
+			} else {
+				set_host_byte(scmd, DID_NO_CONNECT);
+			}
 		} else {
 			io_request->status = -ENXIO;
 			io_request->error_info =
-- 
2.28.0.rc1.9.ge7ae437ac1

