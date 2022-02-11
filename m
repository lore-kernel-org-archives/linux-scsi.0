Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC37DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346657AbiBKWeo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354152AbiBKWei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:38 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4F6D64
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:34 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso13315569pjg.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8cAj+tJuPIKozznNrLmzscvz/gVTHABu45oATBtvY+g=;
        b=w95Hq2EIgZgpSTxnqAvzrwCWXXfIrocJLc6VZ7jph8QR5FYq1ke8UXGaTV6hxmvM7b
         ZPdM/ZCdr/E6VoSY6BDX8gDp9MZp6Jz7eu5K6gapGTWWZ773GBS9knRYuwAhKUrhfkqj
         sCxSlO9NJGxpqMTzNadhtXwfrFU4hbp8wtxBxHTBgCD22h9JZ4n/HtaVsKzlCq04vmfT
         n3zBya08qm9ebe8DKBKpDiNutlvUbigZYrAsNAlBF79OisRMmBmfUlP8K5cUWU1lcGa7
         IDRp9+lAC5QjUbTkOUH+rWdAAMF0ro2MLjucnL0MeYdI6S/4OEY7MZ2OIezywy9ZIZom
         XQkg==
X-Gm-Message-State: AOAM530oCXfYs3wz6nbJZ/d9zZeAjBvLwouNPb7v71S+hWpYBkNKEhl1
        15h0V0zZgEhHIamDvaCSyQw=
X-Google-Smtp-Source: ABdhPJx+H0eAtmMPFpTdcXsIzB/PBOwfpZHPugtUm2kBPJFDr2e9cLFoBSzvrKGBWgIuij446EUDYA==
X-Received: by 2002:a17:90b:2516:: with SMTP id ns22mr2585253pjb.242.1644618874293;
        Fri, 11 Feb 2022 14:34:34 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 42/48] scsi: smartpqi: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:41 -0800
Message-Id: <20220211223247.14369-43-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f0897d587454..74426974309f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,6 +54,15 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
+struct pqi_cmd_priv {
+	int this_residual;
+};
+
+static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
@@ -5555,7 +5564,7 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	scsi_dma_unmap(scmd);
 	if (io_request->status == -EAGAIN || pqi_raid_bypass_retry_needed(io_request)) {
 		set_host_byte(scmd, DID_IMM_RETRY);
-		scmd->SCp.this_residual++;
+		pqi_cmd_priv(scmd)->this_residual++;
 	}
 
 	pqi_free_io_request(io_request);
@@ -5779,7 +5788,7 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd)))
 		return false;
 
-	return scmd->SCp.this_residual == 0;
+	return pqi_cmd_priv(scmd)->this_residual == 0;
 }
 
 /*
@@ -7159,6 +7168,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.map_queues = pqi_map_queues,
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
+	.cmd_size = sizeof(struct pqi_cmd_priv),
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
