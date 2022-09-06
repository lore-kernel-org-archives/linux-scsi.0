Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAE7ECAAA1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 07:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbiIFH5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 03:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbiIFH5U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 03:57:20 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31F671704;
        Tue,  6 Sep 2022 00:57:19 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 163DD44F8B;
        Tue,  6 Sep 2022 07:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1662451036; x=
        1664265437; bh=XL5F/oXsCoOIFfj/qDCbchJ8n++/oI50YVboIcVfVwA=; b=l
        uzIgEbaU34wEsa9CE8jpC8qgCC9wRwG2IIWDOyGZXqckW8UdsQDhYBfGqNph27lQ
        dHWfiChsNrc8UcVIwCnJkWj8LYA4G92mRC5+4EnAvtbKuSJUBERMgINEBhjdq/T0
        szOI3qCKm1I1owgD22YGkZ9yi06r6VxTCG79boeV70=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0U2t-D0uZS4s; Tue,  6 Sep 2022 10:57:16 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 64F1056164;
        Tue,  6 Sep 2022 10:48:56 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 10:48:56 +0300
Received: from NB-591.corp.yadro.com (10.178.114.42) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 10:48:55 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] scsi: target: core: Set MULTIP bit in INQUIRY
Date:   Tue, 6 Sep 2022 10:48:20 +0300
Message-ID: <20220906074820.18685-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SAM-5 4.8.3 (SCSI target device with multiple SCSI ports structure)
obligates to set MULTIP bit when there's multiple SCSI target ports:

> Each device server shall indicate the presence of multiple SCSI target
> ports by setting the MULTIP bit to one in its standard INQUIRY data
> (see SPC-4).

The change sets MULTIP bit automatically to indicate the presence of
multiple SCSI target ports within standard inquiry response data if
there are multiple target ports in all target port groups of the
se_device.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
The patch is intended for 6.1/scsi-queue branch.
---
 drivers/target/target_core_spc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c14441c89bed..32fb38ce98f4 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -75,6 +75,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	struct se_portal_group *tpg = lun->lun_tpg;
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
+	struct se_lun *tmp_lun;
+	size_t dev_ports = 0;
 
 	/* Set RMB (removable media) for tape devices */
 	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
@@ -115,6 +117,20 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 			buf[5] |= 0x1;
 	}
 
+	spin_lock(&dev->se_port_lock);
+	list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
+		dev_ports++;
+		/* Exact number of ports does not matter for MULTIP bit */
+		if (dev_ports > 1)
+			break;
+	}
+	spin_unlock(&dev->se_port_lock);
+	/*
+	 * Set MULTIP bit to indicate presence of multiple SCSI target ports
+	 */
+	if (dev_ports > 1)
+		buf[6] |= 0x10;
+
 	buf[7] = 0x2; /* CmdQue=1 */
 
 	/*
-- 
2.25.1

