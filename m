Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFF5C55191
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 13:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE43B20767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 13:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="DtZIrkwL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgDXNpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:45:04 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:45410 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbgDXNpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 09:45:04 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DFC044049F;
        Fri, 24 Apr 2020 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587735904; bh=SPjxNuDzWiud56RftbTam+lOBwj9rLiqknpfyq50zzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DtZIrkwLnemlp38puCnXFuzpplsedzEhq1AFwnwSmjzFL3R8Eazwg2wuctQBzUGpr
         emtLbUqiUpV7xVkUc/NIZ8nqEaWq8xImzWUwpUf4vZHx4nssZTJwojEt6fgeCh+n96
         04I4vFgA8ofGlUnC4eRF5FeoX4vAR4AzfyEfyBlklZtZBr13hP9mVYZbByDFbuDZy1
         GNbM806znl5h2eTj3pF2idJLZawMt1x/9/dLLcoHIbJFmKcK40SovQiz0DPfIR9QWk
         WnZNDsSIjWO4Qog9eTdl7hYaTkN8RY/L7fTPtYHy6gVkV0JJ7vjc65SNbqDhUCG/Ef
         J2Dv7De53bw/Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B167DA005C;
        Fri, 24 Apr 2020 13:45:02 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-scsi@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Date:   Fri, 24 Apr 2020 15:44:45 +0200
Message-Id: <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1587735561.git.Jose.Abreu@synopsys.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1587735561.git.Jose.Abreu@synopsys.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a define for UFS version 3.0 and do not print an error message upon
probe when using this version.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Joao Lima <Joao.Lima@synopsys.com>
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Joao Lima <Joao.Lima@synopsys.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshci.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7d1fa1349d40..2e5c200e915b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
 	    (hba->ufs_version != UFSHCI_VERSION_11) &&
 	    (hba->ufs_version != UFSHCI_VERSION_20) &&
-	    (hba->ufs_version != UFSHCI_VERSION_21))
+	    (hba->ufs_version != UFSHCI_VERSION_21) &&
+	    (hba->ufs_version != UFSHCI_VERSION_30))
 		dev_err(hba->dev, "invalid UFS version 0x%x\n",
 			hba->ufs_version);
 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index c2961d37cc1c..f2ee81669b00 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -104,6 +104,7 @@ enum {
 	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
 	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
 	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
+	UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */
 };
 
 /*
-- 
2.7.4

