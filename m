Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C418C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7BF603E5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbhJGUsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:36 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:34674 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241560AbhJGUsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:35 -0400
Received: by mail-pj1-f46.google.com with SMTP id q7-20020a17090a2e0700b001a01027dd88so4630383pjd.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tk1iMfDg8FJsNJNO4AOwwGjgSN3v5RCO/M89yAZxYH8=;
        b=Z2AhhRaWi2Nq8dG4TB0kS4TeWzzkkGMlpdWeW8FBMo73B8pScafEvqdThqkVHbtUq0
         g3KL1A3gK5syXQCIwbp8GHc2GeSRpgsP0u4nOIq95eP+cuHpQCpB8nKg2rKkEpKTGclI
         y7c3145Kv4tF3s99kEnheTfg/PgzT/mq1JnGW5cEd+p+glZF6kb7sLEQSe8wIxBVOQOe
         NaHCz+NjyUyi/ShHwtHQG5FtAArCCsszGQC56lSBgilo3ZKkkFqjzl70ONP2+a9ZchbV
         uupaSTlEzz3+QXHRoGrjKubHPqQ+Y2jIeZxc7zq2X3YbOzDTC0r4K+jGvWsRdiii4sQD
         pLXw==
X-Gm-Message-State: AOAM5320B3DZxPvPA1tHRW/sl0jbSD0l/YDDSHg47UZEn3jeOpVdER5V
        Zh4TUWzMxBYA3eRmK3584AM=
X-Google-Smtp-Source: ABdhPJxYbdAlfIG+06ySICW6aFCb92EDodKmipSm2oS00bCxYTxoMPC5UdVQcSmTahqekadF25eTvw==
X-Received: by 2002:a17:90a:1b8b:: with SMTP id w11mr7298315pjc.58.1633639600586;
        Thu, 07 Oct 2021 13:46:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 81/88] staging: rts5208: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:07 -0700
Message-Id: <20211007204618.2196847-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/rts5208/rtsx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 898add4d1fc8..f1136f6bcee2 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -140,7 +140,6 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	}
 
 	/* enqueue the command and wake up the control thread */
-	srb->scsi_done = done;
 	chip->srb = srb;
 	complete(&dev->cmnd_ready);
 
@@ -423,7 +422,7 @@ static int rtsx_control_thread(void *__dev)
 
 		/* indicate that the command is done */
 		else if (chip->srb->result != DID_ABORT << 16) {
-			chip->srb->scsi_done(chip->srb);
+			scsi_done(chip->srb);
 		} else {
 skip_for_abort:
 			dev_err(&dev->pci->dev, "scsi command aborted\n");
@@ -635,7 +634,7 @@ static void quiesce_and_remove_host(struct rtsx_dev *dev)
 	if (chip->srb) {
 		chip->srb->result = DID_NO_CONNECT << 16;
 		scsi_lock(host);
-		chip->srb->scsi_done(dev->chip->srb);
+		scsi_done(dev->chip->srb);
 		chip->srb = NULL;
 		scsi_unlock(host);
 	}
