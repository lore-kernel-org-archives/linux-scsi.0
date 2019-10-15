Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B76ECE58C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 492D2217F9
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfJOGS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 02:18:56 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:49239 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfJOGSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Oct 2019 02:18:55 -0400
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=balsundar.p@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  balsundar.p@microsemi.com designates 208.19.100.23 as
  permitted sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="balsundar.p@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: joKFdKftwG/jtS5QM8TYCcnc7BXXDaG6DGyknyi/6W8cWgY0uqiKjTdEPckLabYLqwJ52KxQx0
 pD5FZ/QQEDamCt91AknsOe3zfZtVdkpE5ff6vX1IPE+FB9bEuqbKdG8p+2SMP8IU1JmCSdrlNo
 jlWyRO4h2c2gDVYvHAgyu9MBC0X05szUnNqPx22X8hrk5LV2OIdjy6efaEMmkFtgUePsstLxE1
 X4v0RnA+vBDKSBW5IBBwFZaoIIMfECai48l1YF+RAMgeO3bNsndLUUVlSD/++3q3RZsPv02ZKf
 Uxs=
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="52970458"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2019 23:18:35 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 14 Oct
 2019 23:18:26 -0700
Received: from localhost (10.41.130.77) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1713.5 via Frontend Transport; Mon, 14 Oct
 2019 23:18:25 -0700
From:   <balsundar.p@microsemi.com>
To:     <linux-scsi@vger.kernel.org>, <jejb@linux.vnet.ibm.com>
CC:     <aacraid@microsemi.com>
Subject: [PATCH 3/7] scsi: aacraid: fixed firmware assert issue
Date:   Tue, 15 Oct 2019 11:52:00 +0530
Message-ID: <1571120524-6037-4-git-send-email-balsundar.p@microsemi.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
References: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microsemi.com>

Before issuing IOP reset, INTX mode is selected. This is triggering
MSGU lockup and ended in basecode assert. Use DROP_IO command when
IOP reset is sent in preparation for interrupt mode switch

Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h  |  1 +
 drivers/scsi/aacraid/comminit.c |  5 +++++
 drivers/scsi/aacraid/src.c      | 10 ++++++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3fa03230f6ba..3fdd4583cbb5 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1673,6 +1673,7 @@ struct aac_dev
 	u8			adapter_shutdown;
 	u32			handle_pci_error;
 	bool			init_reset;
+	u8			soft_reset_support;
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index d4fcfa1e54e0..f75878d773cf 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -571,6 +571,11 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		else
 			dev->sa_firmware = 0;
 
+		if (status[4] & le32_to_cpu(AAC_EXTOPT_SOFT_RESET))
+			dev->soft_reset_support = 1;
+		else
+			dev->soft_reset_support = 0;
+
 		if ((dev->comm_interface == AAC_COMM_MESSAGE) &&
 		    (status[2] > dev->base_size)) {
 			aac_adapter_ioremap(dev, 0);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b66e06726c8..787ec9baebb0 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -733,10 +733,20 @@ static bool aac_is_ctrl_up_and_running(struct aac_dev *dev)
 	return ctrl_up;
 }
 
+static void aac_src_drop_io(struct aac_dev *dev)
+{
+	if (!dev->soft_reset_support)
+		return;
+
+	aac_adapter_sync_cmd(dev, DROP_IO,
+			0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
+}
+
 static void aac_notify_fw_of_iop_reset(struct aac_dev *dev)
 {
 	aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS, 0, 0, 0, 0, 0, 0, NULL,
 						NULL, NULL, NULL, NULL);
+	aac_src_drop_io(dev);
 }
 
 static void aac_send_iop_reset(struct aac_dev *dev)
-- 
2.18.1

