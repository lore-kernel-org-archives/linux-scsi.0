Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9B3CA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF7B120848
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbfKEAmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:42:37 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38126 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfKEAmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:42:37 -0500
Received: by mail-pf1-f196.google.com with SMTP id c13so13816270pfp.5
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:42:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZN1e5YU8qUPg4lH3VF1ceRQFZ1ZF+7ipJSZXQs3B54=;
        b=BkuyV2XNsc92YEwQWSr+dqcfmP7M+VWRPpeIR/cOC0mPlMYDeiE2e6KoV8HxegSMQc
         UIrIO+l3rB/NbLp2olh+CK8D+O91gTG/yX+ONAETpBgPgNp9jEpWMpF4POOLeA7HdAgL
         h45PL1/lxQr4kXWR0IZNY2jkrGrlkf3w909nK4SS8Fe+hPjCS3RNpAAtp9pgA4T5Rvyj
         pA2M9YSEqqt9WVpEkvuV3EdvU+a44MKgFXvU8sY7NsFyNRhSYSLPJrRt3mtCo9rZVdz2
         Qr67v3hCoqk1QTAa6TS6GILwaxdr6TzANDlZB93XjfqSOVyKpbK9//5UpgA0ErdAPJuH
         7yRg==
X-Gm-Message-State: APjAAAUOLOU8IWdV2n2mYp2GgJj46i+hsWjV5AHb4qmorjew2o94xNLN
        FCRwaSBfYssl1gf8fekrg5M=
X-Google-Smtp-Source: APXvYqwMDYc91ZhGAjI1dAro38nYs8vLdSmI2Q7aY7WiBos6esalwsEaN0Q9lodxPBRMn+qCyBvipQ==
X-Received: by 2002:a63:1d60:: with SMTP id d32mr34022398pgm.37.1572914555566;
        Mon, 04 Nov 2019 16:42:35 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a21sm4235449pjv.20.2019.11.04.16.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 16:42:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH RFC v2 2/5] ufs: Use reserved tags for TMFs
Date:   Mon,  4 Nov 2019 16:42:23 -0800
Message-Id: <20191105004226.232635-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191105004226.232635-1-bvanassche@acm.org>
References: <20191105004226.232635-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reserved tags are numerically lower than non-reserved tags. Compensate the
change caused by reserving tags by subtracting the number of reserved tags
from the tag number assigned by the block layer.

Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9fc05a535624..3e3c6257a343 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2402,7 +2402,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	hba = shost_priv(host);
 
-	tag = cmd->request->tag;
+	tag = cmd->request->tag - hba->nutmrs;
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
 			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
@@ -5965,7 +5965,8 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
+	tag = cmd->request->tag - hba->nutmrs;
+	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	lrbp = &hba->lrb[tag];
 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
@@ -6036,7 +6037,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
+	tag = cmd->request->tag - hba->nutmrs;
 	lrbp = &hba->lrb[tag];
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
@@ -8320,7 +8321,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
+	host->can_queue = hba->nutrs + hba->nutmrs;
+	host->reserved_tags = hba->nutmrs;
 	host->cmd_per_lun = hba->nutrs;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFS_MAX_LUNS;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

