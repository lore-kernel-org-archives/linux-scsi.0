Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B52C43141
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEC8B206DC
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfKNKIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:08:35 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:36976 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfKNKIf (ORCPT
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
IronPort-SDR: t2iJah1b9vBZ9o4PEwGBJ7AiacLD5+R+2oXk3296QhEoFBUBnpbKSBvz5gwXncyWYZjhnW9V3n
 omQ9MqFe5/YyoArWf1fji7QJ8bqiYpVsGWXHNoxZbUmtyQP9w779T7AU2dTC+Y4MFyeBw9fs7i
 3YcLdbh1xW0oQubwgtTTF8i8Bfe7vrrze0ZbtsDyOfXmALPvH33dreaqo0kJkGX6yTK0b+HFo8
 whtkOmBOaALwu57E4rTLky1mTZ2tnSuo8IPHU3v8Tji8iE3P7rF73rCvw0EEcu9ecAUrU/I0Fh
 6Xc=
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="55582447"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2019 03:08:32 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 14 Nov
 2019 02:08:31 -0800
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 14 Nov
 2019 02:08:30 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH V2 02/13] pm80xx : Make phy enable completion as NULL.
Date:   Thu, 14 Nov 2019 15:38:59 +0530
Message-ID: <20191114100910.6153-3-deepak.ukey@microchip.com>
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

From: peter chang <dpf@google.com>

After the completing the mpi_phy_start_resp make phy enable completion
as NULL.

Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 161bf4760eac..ee9c187d8caa 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3132,8 +3132,10 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	if (status == 0) {
 		phy->phy_state = PHY_LINK_DOWN;
 		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
-				phy->enable_completion != NULL)
+				phy->enable_completion != NULL) {
 			complete(phy->enable_completion);
+			phy->enable_completion = NULL;
+		}
 	}
 	return 0;
 
-- 
2.16.3

