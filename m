Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458FDC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB712074D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SlsCK9TA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEOKbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:31:32 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36645 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgEOKbc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538691; x=1621074691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=G79IPLEUy4pR/EJjfpHcLFxh1pI4Vg1GZOA2EV04Es8=;
  b=SlsCK9TA0SWutLj1BiaetsH+0yEUJBdXjEJK/VfVafP64AwZzzQHcQpU
   91aPgj/D3trUomttdm1s+HflCzVrLNkQF2Gl0AHp7pRxv7eG71gpNoHsn
   w1PleWUuF+zpYx7yVYx5JsfpgDBgJr7m6YEH7firdBY8ytZwTOBxLVgua
   tblkLsEoEQ1K5lXn3snNW7cKrXA0Drea70mIQ+6jdMlrz3pLvDv1jRlnF
   1Dump12nBAZxVZ01L2MtZrin0ykkKMWN0RQ2h4bS+QvoOx1HWBdCQg8aR
   HxAxifuFG9c+r/VgUT+tPr9dXMBV0vkn/QxSJ+a35dZ9WEzo/afCDOYaF
   A==;
IronPort-SDR: 82UC76aZ90lRLW+Dv+WHBDCm53hvi7LqzrGciF63qoSzTiyjB/scOhelNudd1Bs3Kj3tHnhzZZ
 gNiRDBOcdS7dUPjNWo/kFJvf0zxlNV9+fjWQ4ywoJ7EUCq7N4t+JOZ5Z2RJyj/f6YQC9BjI75i
 5bCeAllUH+5lJWr9GkxY2zmTdVIwDti6HVztujaBgOCWSs/ZqJIl8bL6aYDCqpHCeJXRtbt8cg
 AMZ/9l90Ps2cevLmYP+U3Dul3MrYQvBRj65QumEmI9WHTSChxeKCuK7gcUEqA18kMl3D2bC//d
 RTw=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="139202404"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:31:31 +0800
IronPort-SDR: Eq9HqaLeHNmS5xhxz1icn32Eu4hh/dj8iYGKavNllCOI5/hikVcj39TNopOASsb7k9Be38ZERp
 6Tm68f4uWNgCQZnAtjysXmD5AxMMmogxo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:21:08 -0700
IronPort-SDR: WkJLCxfkU7XpwUKWV5vIeirXeZ2mBGrGw3gKS2se27N/tGfvP4xdDeRcY3KWpT92Ek58wQTOK8
 GGkhK2jii9BA==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:31:26 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 04/13] scsi: ufs: ufshpb: Init part II - Attach scsi device
Date:   Fri, 15 May 2020 13:30:05 +0300
Message-Id: <1589538614-24048-5-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ufs boot process is essentially comprised of 2 parts: first a
handshake with the device, and then, scsi scans and assign a scsi device
to each lun.  The latter, although running a-synchronically, is
happening right after reading the device configuration - lun by lun.

By now we've read the device HPB configuration, and we are ready  to
attach a scsi device to our HPB luns.  A perfect timing might be while
scsi is performing its .slave_alloc() or .slave_configure().

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c |   3 ++
 drivers/scsi/ufs/ufshpb.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |   3 ++
 3 files changed, 109 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bffe699..c2011bf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4628,6 +4628,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 
 	ufshcd_get_lu_power_on_wp_status(hba, sdev);
 
+	if (ufshcd_is_hpb_supported(hba))
+		ufshpb_attach_sdev(hba, sdev);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index e94e699..4a10e7b 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -7,7 +7,9 @@
  */
 
 #include <asm/unaligned.h>
+#include <scsi/scsi_dh.h>
 #include <scsi/scsi_dh_ufshpb.h>
+#include "../scsi_priv.h"
 #include "ufshcd.h"
 #include "ufs.h"
 #include "ufshpb.h"
@@ -25,6 +27,7 @@ enum ufshpb_control_modes {
 
 struct ufshpb_lun {
 	u8 lun;
+	struct scsi_device *sdev;
 };
 
 
@@ -34,6 +37,91 @@ struct ufshpb_lun *ufshpb_luns;
 static unsigned long ufshpb_lun_map[BITS_TO_LONGS(UFSHPB_MAX_LUNS)];
 static u8 ufshpb_lun_lookup[UFSHPB_MAX_LUNS];
 
+void ufshpb_remove_lun(u8 lun)
+{
+	struct ufshpb_lun *hpb;
+
+	if (!ufshpb_luns)
+		return;
+
+	hpb = ufshpb_luns + lun;
+	if (hpb->sdev && hpb->sdev->handler_data) {
+		if (scsi_device_get(hpb->sdev))
+			return;
+
+		scsi_dh_release_device(hpb->sdev);
+		scsi_device_put(hpb->sdev);
+	}
+}
+
+/**
+ * ufshpb_attach_sdev - attach and activate a hpb device handler
+ * @hba: per adapter object
+ * @sdev: scsi device that owns that handler
+ *
+ * Called during .slave_alloc(), and after ufshpb_probe() read the device hpb
+ * configuration.
+ */
+void ufshpb_attach_sdev(struct ufs_hba *hba, struct scsi_device *sdev)
+{
+	struct ufshpb_lun *hpb_lun;
+	struct ufshpb_dh_data {
+		struct ufshpb_config *c;
+		struct ufshpb_lun_config *lc;
+	} h;
+	int ret = -EINVAL;
+	u8 lun = sdev->lun;
+	u8 i;
+
+	/* ignore w-luns as those can't be hpb luns */
+	if (lun >= UFSHPB_MAX_LUNS)
+		return;
+
+	/* ignore non-hpb luns */
+	if (!test_bit(lun, ufshpb_lun_map))
+		return;
+
+	i = ufshpb_lun_lookup[lun];
+
+	if (sdev->handler && sdev->handler_data) {
+		dev_err(hba->dev, "trying to re-attach lun %d ?\n", lun);
+		goto out;
+	}
+
+	if (!ufshpb_luns) {
+		dev_err(hba->dev, "HPB was already removed\n");
+		goto out;
+	}
+
+	if (scsi_device_get(sdev)) {
+		dev_err(hba->dev, "failed to get sdev for lun %d\n", lun);
+		goto out;
+	}
+
+	hpb_lun = ufshpb_luns + i;
+	hpb_lun->sdev = sdev;
+
+	ret = scsi_dh_attach(sdev->request_queue, "ufshpb");
+	if (ret || !sdev->handler || !sdev->handler_data)
+		goto put_scsi_dev;
+
+	h.c = ufshpb_conf;
+	h.lc = ufshpb_luns_conf + i;
+
+	memcpy(sdev->handler_data, &h, sizeof(h));
+
+	ret = scsi_dh_activate(sdev->request_queue, NULL, NULL);
+
+put_scsi_dev:
+	scsi_device_put(sdev);
+
+out:
+	if (ret) {
+		dev_err(hba->dev, "attach sdev to HPB lun %d failed\n", lun);
+		ufshpb_remove_lun(i);
+	}
+}
+
 /**
  * ufshpb_remove - ufshpb cleanup
  *
@@ -41,9 +129,24 @@ static u8 ufshpb_lun_lookup[UFSHPB_MAX_LUNS];
  */
 void ufshpb_remove(struct ufs_hba *hba)
 {
+	if (!ufshpb_conf)
+		goto remove_hpb;
+
+	if (ufshpb_luns) {
+		unsigned int num_hpb_luns = ufshpb_conf->num_hpb_luns;
+		int i;
+
+		spin_lock(hba->host->host_lock);
+		for (i = 0; i < num_hpb_luns; i++)
+			ufshpb_remove_lun(i);
+		spin_unlock(hba->host->host_lock);
+	}
+
 	kfree(ufshpb_conf);
 	kfree(ufshpb_luns_conf);
 	kfree(ufshpb_luns);
+
+remove_hpb:
 	ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
 			  QUERY_FLAG_IDN_HPB_RESET, 0, NULL);
 }
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index ee990f4..276a749 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -14,9 +14,12 @@ struct ufs_hba;
 #ifdef CONFIG_SCSI_UFS_HPB
 void ufshpb_remove(struct ufs_hba *hba);
 int ufshpb_probe(struct ufs_hba *hba);
+void ufshpb_attach_sdev(struct ufs_hba *hba, struct scsi_device *sdev);
 #else
 static inline void ufshpb_remove(struct ufs_hba *hba) {}
 static inline int ufshpb_probe(struct ufs_hba *hba) { return 0; }
+static inline void
+ufshpb_attach_sdev(struct ufs_hba *hba, struct scsi_device *sdev) {}
 #endif
 
 #endif /* _UFSHPB_H */
-- 
2.7.4

