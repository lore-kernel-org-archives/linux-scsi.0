Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7A9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345034AbhK3XiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:38:09 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:40958 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241396AbhK3XiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:38:05 -0500
Received: by mail-pg1-f176.google.com with SMTP id l190so21542877pge.7
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wfQuYA0v5AGpeWacISPDNlA0H6jLiK+GpLahmP0hicc=;
        b=mR1oJO2DnT2yqsMJHxfsf1KzpsuBRPbZByYHM7afY6ZzcdGJtEyK97PsFfeORQcezo
         llPk8vSgom7sDuknNTTv5EmyDXu7Bj0D7X2g0EyPsBsVii7XOZ/pK7dcjS8nfCrfuvO4
         uxk9JaJdWJ3vrWlzHvgKzPWqchFBtgvwMyIgsXrNqoiYLOqL3HLN0ElIkgjMiL3cUqd1
         OubnMBCoflQmqa1AAynWsuQc04KAna+CMnvKmsCm7zCej2JQFGjSKh/0HOISuOXNKHpN
         ihn4UI3DAXaDt9/TPdSW+fwF5ZYdECGCPiPDflovs3VLj3iDqEzDUDd8ON4ngf+A8w7O
         5EIQ==
X-Gm-Message-State: AOAM531njAYkoPNBhWIiEsJYSbA4ZOz2j6fwEVxvkSsz5bmC77BQjaTH
        ihZg9qoT21OvbllBpekMJ/0=
X-Google-Smtp-Source: ABdhPJzwub6gcqu76uzUEJnqMYDcyKBOaJA98G1XtZSB0yRrVQjIxJ57XPN1wn8yoqakQZlxUIJnsg==
X-Received: by 2002:a63:ef58:: with SMTP id c24mr1929421pgk.94.1638315284965;
        Tue, 30 Nov 2021 15:34:44 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Vishak G <vishak.g@samsung.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v3 13/17] scsi: ufs: Improve SCSI abort handling further
Date:   Tue, 30 Nov 2021 15:33:20 -0800
Message-Id: <20211130233324.1402448-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Release resources when aborting a command. Make sure that aborted commands
are completed once by clearing the corresponding tag bit from
hba->outstanding_reqs. This patch is an improved version of commit
3ff1f6b6ba6f ("scsi: ufs: core: Improve SCSI abort handling").

Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8703e4a70256..1a4f2ebf955e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6984,6 +6984,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
+	bool outstanding;
 	u32 reg;
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
@@ -7061,6 +7062,17 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
 
+	/*
+	 * Clear the corresponding bit from outstanding_reqs since the command
+	 * has been aborted successfully.
+	 */
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	if (outstanding)
+		ufshcd_release_scsi_cmd(hba, lrbp);
+
 	err = SUCCESS;
 
 release:
