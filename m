Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5953C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3EDB20767
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JOkk5c/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgEOKbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:31:39 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:40620 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgEOKbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538698; x=1621074698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aPxI2eK/ay27sxXuvB12Qt7fEJWoSAOBVHuQP5fBlbg=;
  b=JOkk5c/gLeafZ2AHviqmee6Pie0TYoM2rWjk/k2+fJH6ap3qG6bMoX7z
   Z3pqqu7Rqg5BDc0xlFEaP6PWYCksOCSBs/o3pbZNqhI3Ws7tqH0RbRghD
   H3B7UfFs4HVvK4jDJFjADzmi1jsXSS/7jc2bzYoesCJccDtiLUrHyjS1b
   fIRZypyTEQ4x+k6e07ICxnmAmsDVuq2SEyhH3qm/4qPoFijGHMo5y5SfI
   wOe76WCDELs2J+cuZFMHFrLvNj79lnsSog0eot0NAM2QJ2kE0liYn5aO9
   T/rWBtWiHNw4Y7D0juGYaVG6D6m5vwDE8YvMwWEMYhlOusmm+uH8MtBgg
   w==;
IronPort-SDR: mWPmqim+HrM3pP77lrCCiATWktdQ4FmXMQfGYw2SwQOwyPJWPo6O2VLp1AwuDQOtNTcgF7X6H0
 wCwYhiAWyDrvciDyGlkcV12AznFCpKrXlrRTI3kI8jY+LXZ02XV58BSaBbmOkGxjzzoNbg/w/2
 Z1824nQis8b1D8FKC8iBhc1wB6jWZxyOyGTGsYVGzJO6UoqfJ8n5V4wecc6FF2tWXa+cTTLeJ2
 8ejuh1Iot1dmPpasWmAbGFM29pH9RztlZdTjvYm21ySYq7O5z+YerVcEmP5MwgoxcKSlS/8Y6u
 leo=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="246735797"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:31:37 +0800
IronPort-SDR: KZbjH8m7x/fhPvUNrWgQGYqMg+omdZc77jJh37hDg2BmsVlOTyOTZwkZ4Rp4Q6QVG72YoaK3Od
 y0YwCyYMLA5V+wTrC1Sjp1R1Ws2Liio/g=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:21:16 -0700
IronPort-SDR: CwaAg0AryuILN3tJ6YionGj+kx8L/+YH2AcB+5PNRjrrcne0g+BUTwtIObDz5TfMCLSXzVB3ek
 FgWx5aUq//rQ==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:31:34 -0700
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
Subject: [RFC PATCH 05/13] scsi: ufs: ufshpb: Disable HPB if no HPB-enabled luns
Date:   Fri, 15 May 2020 13:30:06 +0300
Message-Id: <1589538614-24048-6-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are disabling the feature altogether if reading the configuration
fails, or there are no HPB-luns configured, or no active regions are
configure.  Still, after reading the configuration successfully, there
can be no HBP-enabled luns, e.g. if their pinned regions allocation has
failed.

So to avoid keep checking the upiu responses for nothing, we are
verifying that indeed there are any HPB-enabled luns out there after
1min from the configuration read.  By then all the luns were scanned and
initialized their device handler.  If there are no HPB-enabled luns –
the feature is disabled altogether.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.h |  1 +
 drivers/scsi/ufs/ufshpb.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e7014a3..19a5613 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -743,6 +743,7 @@ struct ufs_hba {
 	struct request_queue	*bsg_queue;
 	bool wb_buf_flush_enabled;
 	bool wb_enabled;
+	struct delayed_work hpb_disable_work;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 4a10e7b..be926cb 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -299,6 +299,28 @@ static int ufshpb_get_unit_config(struct ufs_hba *hba, u8 dev_num_luns)
 	return ret;
 }
 
+static void ufshpb_disable_work(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+					   hpb_disable_work.work);
+
+	if (ufshpb_luns) {
+		unsigned int num_hpb_luns = ufshpb_conf->num_hpb_luns;
+		int i;
+
+		for (i = 0; i < num_hpb_luns; i++) {
+			struct ufshpb_lun *hpb = ufshpb_luns + i;
+
+			if (hpb->sdev && hpb->sdev->handler_data)
+				return;
+		}
+	}
+
+	hba->caps &= ~UFSHCD_CAP_HPB;
+	ufshpb_remove(hba);
+	dev_info(hba->dev, "HPB was removed - no active HPB luns\n");
+}
+
 /**
  * ufshpb_probe - read hpb config from the device
  * @hba: per adapter object
@@ -368,6 +390,8 @@ int ufshpb_probe(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	INIT_DELAYED_WORK(&hba->hpb_disable_work, ufshpb_disable_work);
+	schedule_delayed_work(&hba->hpb_disable_work, 60 * HZ);
 out:
 	kfree(dev_desc);
 	if (ret) {
-- 
2.7.4

