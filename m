Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45D8CA9ECB
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B2420862
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfJaWzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 18:55:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42798 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfJaWzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 18:55:40 -0400
Received: by mail-pl1-f195.google.com with SMTP id j12so1459916plt.9
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2019 15:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lnUdgdtjnyT8WApB6Dztq1Jd7auxRCekXUI0b3t7ONc=;
        b=Y0W/KBUmbyKOBxHojEU0YfCPrw39EF8EZAHvcWCU5OiNHHIvYZx4DLfVVkmPPSKk7A
         F1lO4roOfBcTSnTBal0U5MPPZ20UmIJoqDuhpmeyXHLsDFu9lj+/3dUl0gN4Hqnr1wH7
         Ct3/SNoZ3vkaNakhTZyZZEi8GK+e97us9nEHcnoMNFRSS/zjWSfTsCFvU2lHanXJ2Vkq
         Tycy6O3CpKc708Z0Y63WpvR+AkM1r/9MpG0Wo67ACltWzA84ymYuUMZ+e1aC7ft9l34f
         G9iqb78GgKkdzP9X+5aSuebpNFl5OKXgVCLAnk181lrGffQShqFBPwIQF0jqgv4tTANx
         c6CA==
X-Gm-Message-State: APjAAAVmeqJez4N1Vu8+/VfHW2DpJ6Fh9Yrlg425kasAIx2CNuj7JrSk
        /0Oej51FTNY7EY4BnxDVGY4=
X-Google-Smtp-Source: APXvYqxFtn90VoEfjAXK43O6rOTc9jgRmsc097bgQdWypN1hOr4txKXFConJjbQcU9JYNLpj5q8/hg==
X-Received: by 2002:a17:902:304:: with SMTP id 4mr9253642pld.106.1572562538546;
        Thu, 31 Oct 2019 15:55:38 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d139sm8391711pfd.162.2019.10.31.15.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:55:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Gilad Broner <gbroner@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/4] ufs: Remove the SCSI timeout handler
Date:   Thu, 31 Oct 2019 15:55:27 -0700
Message-Id: <20191031225528.233895-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191031225528.233895-1-bvanassche@acm.org>
References: <20191031225528.233895-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Whether or not an UFS command gets requeued, one of the hba->lrb[].cmd
pointers will point at that command. In other words, the UFS SCSI timeout
handler will always return BLK_EH_DONE. Since always returning BLK_EH_DONE
has the same effect of not defining a timeout handler, remove the UFS SCSI
timeout handler.

See also commit f550c65b543b ("scsi: ufs: implement scsi host timeout handler").

Cc: Gilad Broner <gbroner@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b7e27d86a0ec..8c969fab5d92 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6936,41 +6936,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
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
@@ -6989,7 +6954,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
-	.eh_timed_out		= ufshcd_eh_timed_out,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
-- 
2.24.0.rc0.303.g954a862665-goog

