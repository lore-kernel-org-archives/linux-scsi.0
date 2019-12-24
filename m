Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23236C2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2180206D3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfLXWDF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 17:03:05 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:47007 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfLXWDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 17:03:05 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so8866698pll.13
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 14:03:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uaJCYD3m3+UjkYd0MfPifAIhHgQM87sEJJtnQllKg+w=;
        b=Bxdmpk2RzgNSz1ltaG8UK4zwNtRUrHBEu3h1ckBC/mXtMBVHuVVW6asZwkQxsWQQ7X
         YcPvqsOO4vLJHU9RV4Zsw82C0i43rbEt4DGxd1gPN7B028yp7nTx5F2c/ua08vFnWHie
         /R3mUzcP2CwN7drmG8jxBL/iydwCQpvwlDno5bIIHYRHbhL4+P8v23fywQqZK6ivmHdQ
         Xj5hhPflKkr17z3j2qk6698eqo/wS6QEVxQMj5cHlNFuNHZx/zeKfYwVO/cZcECMzxL6
         vAlaG0vmBgC6olD3R7IXY8z9hFXtGMbZn7HZKgv1vpjORg+/sClt4fWHMB/Jg3SL7iLa
         dK9A==
X-Gm-Message-State: APjAAAVFf32Wmc4ieh2JhLoqRt9+vhAFCnYU+qKakvwtVKP0OBv8Tfwl
        nodY5csMaQIHpq9ciQp6F7Y=
X-Google-Smtp-Source: APXvYqwssO2nMDQ+0GTJGNui+QXj7COGETmVvtqLEFM+rRgAkOsM+pe4p3aWhcadB8VzqOSewqrI7g==
X-Received: by 2002:a17:90b:3c9:: with SMTP id go9mr8503070pjb.7.1577224984925;
        Tue, 24 Dec 2019 14:03:04 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:1206:80fd:a97:a7d:f0c8])
        by smtp.gmail.com with ESMTPSA id m15sm26839779pgi.91.2019.12.24.14.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 14:03:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6/6] ufs: Remove the SCSI timeout handler
Date:   Tue, 24 Dec 2019 14:02:48 -0800
Message-Id: <20191224220248.30138-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191224220248.30138-1-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The UFS SCSI timeout handler was needed to compensate that
ufshcd_queuecommand() could return SCSI_MLQUEUE_HOST_BUSY for a long
time. Commit a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by eliminating
tag conflicts") fixed this so the timeout handler is no longer necessary.

See also commit f550c65b543b ("scsi: ufs: implement scsi host timeout handler").

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index edcc137c436b..763e41286a4b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7092,41 +7092,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	ufshcd_probe_hba(hba);
 }
 
-static enum blk_eh_timer_return ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
-{
-	unsigned long flags;
-	struct Scsi_Host *host;
-	struct ufs_hba *hba;
-	int index;
-	bool found = false;
-
-	if (!scmd || !scmd->device || !scmd->device->host)
-		return BLK_EH_DONE;
-
-	host = scmd->device->host;
-	hba = shost_priv(host);
-	if (!hba)
-		return BLK_EH_DONE;
-
-	spin_lock_irqsave(host->host_lock, flags);
-
-	for_each_set_bit(index, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[index].cmd == scmd) {
-			found = true;
-			break;
-		}
-	}
-
-	spin_unlock_irqrestore(host->host_lock, flags);
-
-	/*
-	 * Bypass SCSI error handling and reset the block layer timer if this
-	 * SCSI command was not actually dispatched to UFS driver, otherwise
-	 * let SCSI layer handle the error as usual.
-	 */
-	return found ? BLK_EH_DONE : BLK_EH_RESET_TIMER;
-}
-
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
@@ -7145,7 +7110,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
-	.eh_timed_out		= ufshcd_eh_timed_out,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
