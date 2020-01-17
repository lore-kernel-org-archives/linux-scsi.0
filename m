Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591ABC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 363752073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgAQHKf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:35 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35597 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgAQHKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:34 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: 4xdC3XbxFilxY6Cc95kmitIRvuYIZyTPcOB/qbLSzDQ0M8sv++jpRZclePjWN7+DqCv3FQK7pm
 PzWmZk+Phoxvoph1NG/wmLXvKftD7xc1jI179IKnh5V/4eapfLscKJ6+CURvbD+xBjzaDzSHyo
 9VLI6GtMk3zbX2IpUpH/8Ug3sMYRRLyHVEYc84jkIArmqMRpOfMcCxpzKp/qf5RrFlutc26OcI
 M8UXyeNKlnG4DC2azcKgzotzYshZQ5PrRKD/YdZuK/l+J1HZVqJdTdgdDPRZ4VxRn0qo1OQPXU
 CYs=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="63598486"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:33 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:32 -0800
Received: from localhost (10.41.130.51) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:32 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 03/13] pm80xx : Free the tag when mpi_set_phy_profile_resp is received.
Date:   Fri, 17 Jan 2020 12:49:13 +0530
Message-ID: <20200117071923.7445-4-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200117071923.7445-1-deepak.ukey@microchip.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
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

