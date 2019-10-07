Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA92EECE596
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88BAF206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfJGWby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:31:54 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:54469 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbfJGWby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:31:54 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: etRitgYiu3Rdtc7q+vNSApdAtZomieeCApTTBwezG27m4rFSQgoZIFjmKGU+77n/616bQQejAm
 lWr0zRyw0sdIRmt9xAn8Y/zgGol2WhIs7N73UBl3VEht5mXNYz6zF5KEgOkGmjJSMrSQpa/Rmg
 tM93TdYl8UNuefRvT7IObpg5Vb7+4VcDxUbcVJhrS7xtuTp6WRZUfJREz1L6SG9mLIxYfImYAX
 3W+SF2ZnjxGED1780IYJKn9DzvKrCNva7Qi3uFyPzxN7PVY+84buB3pnG8ckvGd/VNbL7Z+Q5d
 /4A=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="50540830"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:31:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:31:52 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:31:52 -0700
Subject: [PATCH 06/10] smartpqi: correct syntax issue
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:31:52 -0500
Message-ID: <157048751247.11757.1727592925624138646.stgit@brunhilda>
In-Reply-To: <157048745695.11757.6602264644727193780.stgit@brunhilda>
References: <157048745695.11757.6602264644727193780.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f8541edfa6ca..3085e88c2c9a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3861,7 +3861,7 @@ static int pqi_create_admin_queues(struct pqi_ctrl_info *ctrl_info)
 		&pqi_registers->admin_oq_pi_addr);
 
 	reg = PQI_ADMIN_IQ_NUM_ELEMENTS |
-		(PQI_ADMIN_OQ_NUM_ELEMENTS) << 8 |
+		(PQI_ADMIN_OQ_NUM_ELEMENTS << 8) |
 		(admin_queues->int_msg_num << 16);
 	writel(reg, &pqi_registers->admin_iq_num_elements);
 	writel(PQI_CREATE_ADMIN_QUEUE_PAIR,

