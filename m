Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DADC43215
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B9282071B
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKNKIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:08:35 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:36976 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKNKIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 05:08:35 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: 6zDeMI6nDry/comMHTAgjTJps/L18kT3Y/bURJXGF2+tHNFcNLDagzdMItBi9yAp1gEaVYzfVB
 0NjQohhoHhEjEN//HVKuMSp/vOtGn/+tbg5ReD3E4XtBsA1TorB830QCysNQtUbAGVIMwAHDSU
 hoiLlyEsN+RCm44iCUAp07szXEGddWtotNMHdrm3j8Rowv51cVXG9pbY4DH+UYfKtcXmSia9wf
 QN8/mULUaINyCKvEzRFz1V7E/tulm5OwvlxG9googrk6pL3Nq3Jw0goOdd9yajijnyYWcPAD4y
 ZwU=
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="55582452"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2019 03:08:34 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 14 Nov
 2019 02:08:33 -0800
Received: from localhost (10.41.130.49) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 14 Nov
 2019 02:08:32 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH V2 03/13] pm80xx : Initialize variable used as return status.
Date:   Thu, 14 Nov 2019 15:39:00 +0530
Message-ID: <20191114100910.6153-4-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191114100910.6153-1-deepak.ukey@microchip.com>
References: <20191114100910.6153-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: John Sperbeck <jsperbeck@google.com>

In pm8001_task_exec(), if the PHY is down, then we return the
current value of 'rc'. We need to make sure it's initialized.

Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 7e48154e11c3..81160e99c75e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -384,7 +384,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	struct pm8001_port *port = NULL;
 	struct sas_task *t = task;
 	struct pm8001_ccb_info *ccb;
-	u32 tag = 0xdeadbeef, rc, n_elem = 0;
+	u32 tag = 0xdeadbeef, rc = 0, n_elem = 0;
 	unsigned long flags = 0;
 
 	if (!dev->port) {
-- 
2.16.3

