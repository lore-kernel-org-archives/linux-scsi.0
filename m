Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3895C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbhK3XiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:38:16 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:39594 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbhK3XiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:38:15 -0500
Received: by mail-pg1-f178.google.com with SMTP id r5so21487334pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=73edNt+G3LODt3CyOK2nQJJ1/G55cmNYSyUMKsGK9xo=;
        b=zeQq6CjaAW6E1FhMov9ziSovAKy0com4lbHWIrBIwnuukNiDOFQJq2W/5nPSADhACS
         oOEpMLI9NCBUToa61JyE9vTiCzRHy41fWMSnB4xr+hGqMmIBqf99e0cRpz8C5ZUIZtIV
         30xwFvgo9Na9RqcUck+9jIuKABV/XQaMAY9ux/dAngPU9EfMuLYw0sAjD5CKXXRlZVki
         JiW2etW5/eqIyQ0XwgQVYlcucHlilsmhkQepoWr8mViNeNXN9t8qM7UTGqZc+5gc12qT
         MUGoSZjLo+Gr861NfcLd4GVSmpOFF6lW4GguWbE5kq5LxuXil30fs9yBRo3N+T4Ra6vS
         XTCw==
X-Gm-Message-State: AOAM532VirRxU/piiWq5ulWzj8+pzz5Ss47wrPn3DazALfetHTU7xU+E
        rtfgqLTwIPu25J+tTtpClUIrSm8ch5I=
X-Google-Smtp-Source: ABdhPJxmkSuGW+aGybYktDPDNYw57ZslOKA/bNMxInNHsuRkcAIfIAzCIakS9vA493wLQn0cvQCtKQ==
X-Received: by 2002:a63:bf45:: with SMTP id i5mr1919152pgo.161.1638315294952;
        Tue, 30 Nov 2021 15:34:54 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 15/17] scsi: ufs: Stop using the clock scaling lock in the error handler
Date:   Tue, 30 Nov 2021 15:33:22 -0800
Message-Id: <20211130233324.1402448-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of locking and unlocking the clock scaling lock, surround the
command queueing code with an RCU reader lock and call synchronize_rcu().
This patch prepares for removal of the clock scaling lock.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 074ea9ae54e0..c4cf5c4b4893 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2684,6 +2684,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	/*
+	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
+	 * calls.
+	 */
+	rcu_read_lock();
+
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
@@ -2762,7 +2768,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	ufshcd_send_command(hba, tag);
+
 out:
+	rcu_read_unlock();
+
 	up_read(&hba->clk_scaling_lock);
 
 	if (ufs_trigger_eh()) {
@@ -5951,8 +5960,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	synchronize_rcu();
 	cancel_work_sync(&hba->eeh_work);
 }
 
