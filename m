Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E0CC1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C9B20719
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgCPHkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 03:40:05 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17652 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729582AbgCPHkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 03:40:04 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dkim=none (message not signed) header.i=none; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: uQnl8LaxAE/m91/3VJ6AQ9DA8xxlBpIs96r80sJMMBmSupBe4smPtC2ScusRoltimLGzNxf0fz
 ffYEYww8QvFtU0eLDr1usY5v1VGNCRT9rbs4ntVCKFrlkrRii/MSXtr2zP1uycsZqrslhrQbgW
 eBLHxDCuDuGUE2M8UYsnv0u7Y+hW0qKlbG2UV1csi/H2VR9u3PJNwVsKpmnAZ6iEKZcnfNLksO
 8PRCWyZWUN4LI+UogwzX3A7f0lYXQg+vL7w4mdJUHO2YliOclLssZ3Ef8+7V7UvWML33gCR7R0
 2sw=
X-IronPort-AV: E=Sophos;i="5.70,559,1574146800"; 
   d="scan'208";a="67282752"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2020 00:39:59 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 16 Mar
 2020 00:39:58 -0700
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 16 Mar
 2020 00:39:57 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V3 3/6]  pm80xx : Free the tag when mpi_set_phy_profile_resp is received.
Date:   Mon, 16 Mar 2020 13:19:03 +0530
Message-ID: <20200316074906.9119-4-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200316074906.9119-1-deepak.ukey@microchip.com>
References: <20200316074906.9119-1-deepak.ukey@microchip.com>
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
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
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

