Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC25EC2D0D0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 894C8206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfLXElF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:41:05 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:31014 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfLXElE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 23:41:04 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa6.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa6.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: cpy+TZupZmmf2k905cFyBfF9jbBdTMDXiLd0BTwls/a4lEY0EEMQq+OzSNtRWpO+0+LmHwVYQX
 Wtr+zJbvcMiY28sO6/KhcaGqvSvKS2QsfUNkYW9wt9jJvrWpfIM6I0zmMRoJltqYRTRVCrTro+
 dS7hg/rJCzBWS6onT//i+1SbBkpCQvyn6WoP7XYSW5TUIIO3CcdLErCdx5ajN0T7ADKQ9Grq8O
 nioyarD96u89EhpFPOVuUb00cz8NyRAf5HGpzDPxg2y7EJNOSIlvCpNXiOcfRb7JIV8MkoFrtJ
 2eg=
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="58809210"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2019 21:40:58 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 23 Dec
 2019 20:40:58 -0800
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 23 Dec
 2019 20:40:57 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 03/12] pm80xx : Free the tag when mpi_set_phy_profile_resp is received.
Date:   Tue, 24 Dec 2019 10:11:34 +0530
Message-ID: <20191224044143.8178-4-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191224044143.8178-1-deepak.ukey@microchip.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: yuuzheng <yuuzheng@google.com>

In pm80xx driver, the command mpi_set_phy_profile_req is sent by host
during boot to configure the phy profile such as analog setting page,
rate control page. However, the tag is not freed when its response is
received. As a result, 16 tags are missing for each HBA after boot.
When NCQ is enabled with queue depth 16, it needs at least, 15 * 16 =
240 tags for each HBA to achieve the best performance. In current
pm80xx driver with setting CCB_MAX = 256, the total number of tags in
each HBA is 255 for data IO. Hence, without returning those tags to the
pool after boot, some device will finally be forced to non-ncq mode by
ATA layer due to excessive errors (i.e. LLDD cannot allocate tag for
queued task).

Signed-off-by: yuuzheng <yuuzheng@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Akshat Jain <akshatzen@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d805fd036ddf..37b82d7aa3d7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3715,28 +3715,32 @@ static int mpi_flash_op_ext_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 static int mpi_set_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
+	u32 tag;
 	u8 page_code;
+	int rc = 0;
 	struct set_phy_profile_resp *pPayload =
 		(struct set_phy_profile_resp *)(piomb + 4);
 	u32 ppc_phyid = le32_to_cpu(pPayload->ppc_phyid);
 	u32 status = le32_to_cpu(pPayload->status);
 
+	tag = le32_to_cpu(pPayload->tag);
 	page_code = (u8)((ppc_phyid & 0xFF00) >> 8);
 	if (status) {
 		/* status is FAILED */
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("PhyProfile command failed  with status "
 			"0x%08X \n", status));
-		return -1;
+		rc = -1;
 	} else {
 		if (page_code != SAS_PHY_ANALOG_SETTINGS_PAGE) {
 			PM8001_FAIL_DBG(pm8001_ha,
 				pm8001_printk("Invalid page code 0x%X\n",
 					page_code));
-			return -1;
+			rc = -1;
 		}
 	}
-	return 0;
+	pm8001_tag_free(pm8001_ha, tag);
+	return rc;
 }
 
 /**
-- 
2.16.3

