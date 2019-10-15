Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22BFECE58C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D56CC217F9
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfJOGSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 02:18:40 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:42690 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfJOGSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Oct 2019 02:18:40 -0400
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=balsundar.p@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  balsundar.p@microsemi.com designates 208.19.100.22 as
  permitted sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa1.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="balsundar.p@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa1.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: XlvfToVOwfeMgi37R1GGOfzIhWQK1EyqcEufj7GASVa59otj6IZek2YpqMJdfk2RLZTvhIrVYu
 f1p9/BZZQKHpua7NK6qsvIpa8p/QfEFcu93sJ9cAPNR3zSKdj9aIxkzM5EvLMCxq8Pb18Fl5bv
 DBfkc3DwdWcGz6/7WWmsLxdDyIAR4rJVYmSlcQ7ZpMBNBRtL1qjrfaWkMv4azYQpYMZH8qM6yA
 tzXsTfheJhscxuSd967iK1sDo3Ku3WWAt05Lm2P+YueDK5vbZgT7rpv5I6S5ENoMz5DpOjSSGS
 zyc=
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="54210888"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2019 23:18:39 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 14 Oct
 2019 23:18:39 -0700
Received: from localhost (10.41.130.77) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1713.5 via Frontend Transport; Mon, 14 Oct
 2019 23:18:38 -0700
From:   <balsundar.p@microsemi.com>
To:     <linux-scsi@vger.kernel.org>, <jejb@linux.vnet.ibm.com>
CC:     <aacraid@microsemi.com>
Subject: [PATCH 5/7] scsi: aacraid: check adapter health
Date:   Tue, 15 Oct 2019 11:52:02 +0530
Message-ID: <1571120524-6037-6-git-send-email-balsundar.p@microsemi.com>
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

Currently driver waits for the command IOCTL from the firmware
and if the firmware enters nonresponsive state, the driver doesn't
respond till the firmware is responsive again

Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index acc0250a4b62..2055307f4f3d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -613,9 +613,13 @@ static struct device_attribute *aac_dev_attrs[] = {
 static int aac_ioctl(struct scsi_device *sdev, unsigned int cmd,
 		     void __user *arg)
 {
+	int retval;
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
+	retval = aac_adapter_check_health(dev);
+	if (retval)
+		return -EBUSY;
 	return aac_do_ioctl(dev, cmd, arg);
 }
 
-- 
2.18.1

