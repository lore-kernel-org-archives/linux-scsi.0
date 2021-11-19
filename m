Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DADC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D6BD610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhKSUBl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:41 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:53872 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbhKSUBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:25 -0500
Received: by mail-pj1-f51.google.com with SMTP id iq11so8689248pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUTfpKUOajvkqCjSfXNQC91Dp15DuHlS32VtdMmuaQc=;
        b=F9edPJAkPX/RkuCu+LHt7tJDNNuhbQdi2QRbV0PFAKW51ythQuANlqDYD/n8rtlqn5
         9veC0BmwGOh4Fu0a9OH8r+ksm9n+3+va6B9jO7hCS7KkL7NU1EsWWLRwBbN2bXEW0f3+
         378TDdW5whrc8k9LERC9LRmwrhmA4yy5gzqlS5CGub9DtBTu5JirkKw4iRSAjhRZCwl4
         F1l0vY6KibROd4Djhctzq0oK9ZzadKtw8oskerRf2Sqyo+ZA9uWCUU+GdubP7iZdIlVD
         cLb7C2q0KD8qxgZH65ch2qi4aCM8OpwkoYqpUUoZNNcQt4iopjX1TQXhptgn872/EMZj
         ZYTg==
X-Gm-Message-State: AOAM533cJtOEp09707WA8vthdZNVBrOFrgNpws8bk3rLp5HUioqkt3+N
        FQBMbUo2I0BNTJaoncMNJyU=
X-Google-Smtp-Source: ABdhPJwmmyL/NPdR7mPJTwXwX3oghynLQ9e7bo9f+WWzkWonkEEHvZLwFuTwin1ExVe2ZLARIlk+/w==
X-Received: by 2002:a17:90a:6045:: with SMTP id h5mr2801452pjm.147.1637351903539;
        Fri, 19 Nov 2021 11:58:23 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 12/20] scsi: ufs: Rework ufshcd_change_queue_depth()
Date:   Fri, 19 Nov 2021 11:57:35 -0800
Message-Id: <20211119195743.2817-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for making sdev->host->can_queue less than hba->nutrs. This patch
does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dfa5f127342b..a241ef6bbc6f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4960,11 +4960,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
  */
 static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	struct ufs_hba *hba = shost_priv(sdev->host);
-
-	if (depth > hba->nutrs)
-		depth = hba->nutrs;
-	return scsi_change_queue_depth(sdev, depth);
+	return scsi_change_queue_depth(sdev, min(depth, sdev->host->can_queue));
 }
 
 static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *sdev)
