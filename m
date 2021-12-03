Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCC1C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383437AbhLCXYw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:52 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:41708 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383434AbhLCXYw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:52 -0500
Received: by mail-pg1-f174.google.com with SMTP id k4so4502816pgb.8
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBecXUo6uc6jDRSeY7/hLNr5GsF+L2lRT9/DS17e4zc=;
        b=XW/KmmQqhthIAlilEillEw/GttkrVoXhtTTCxe+R4Db6bTOJUYFrHNpaQ4OPNT7mto
         sq3I8mtHRbhVxphvRyNHDDNGQ9g/UsVtSIWHIpNcB5y0THNaIHIrm5329a8uKVA5tFrS
         UCBALSMzgxpknkEP+YzWVJfzdGX5ptm9Z1yZL9ydxidKX3UPWwihmXjQ1fAEEPmY4I6O
         +rFKduDVW+jWhCmgbkNp5LUVQTGM2DXjHzXQ83TqB6zIhS4naUyodbGrYaqhZRkYFh+Y
         zxVZj8yggZ0bCw/yZDxTR8HztqSFy26sP/RsZ+KKxuUHJTk+xL2qznRkXv+cYeqwMRtk
         9vyw==
X-Gm-Message-State: AOAM531MIyfbTB5JFi19BpZi4JFLzMPrMa8GNcXvYE5DIOUE5Fm2WiC3
        V00sWT+qmSe5RljVDoDciFw=
X-Google-Smtp-Source: ABdhPJwxT6TMRZzQrGTnMIVZgiC1zgfyapan1z5CXfjNmeNXoOJSbA4KIJuo7DNyVm0r/M/JQE7GlQ==
X-Received: by 2002:a05:6a00:24d2:b0:49f:bbce:7bc1 with SMTP id d18-20020a056a0024d200b0049fbbce7bc1mr22398990pfv.37.1638573687233;
        Fri, 03 Dec 2021 15:21:27 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>
Subject: [PATCH v4 13/17] scsi: ufs: Improve SCSI abort handling further
Date:   Fri,  3 Dec 2021 15:19:46 -0800
Message-Id: <20211203231950.193369-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Release resources when aborting a command. Make sure that aborted commands
are completed once by clearing the corresponding tag bit from
hba->outstanding_reqs. This patch is an improved version of commit
3ff1f6b6ba6f ("scsi: ufs: core: Improve SCSI abort handling").

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5a641610dd74..06954a6e9d5d 100644
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
