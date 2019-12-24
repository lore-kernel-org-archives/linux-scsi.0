Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939A5C2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70A1E206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLXWDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 17:03:04 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54242 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfLXWDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 17:03:03 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so1645935pjc.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 14:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kD1EFQykSQSQbKY7n8wmkMHV81Snhj0hoLt7Dg3p6Bo=;
        b=oH8vPEfOG2a10SP9GqeQ0GewyEkrrihLwQ4wy/EelU1EC7nWlZqFYDvgyTEPg0KQCy
         pmgo5hi6ejSltF+GbnRjP2c1nf/1uW6JZe28uoBRJywZTzndrXnDpxLR7wTIJ1i56G+A
         lvQlLFPYdVJURX1g3AMnghkK8PG5g882qG4T/iGwdFanbHiIx8JlMDjuly24IWjqIhlN
         QQIdSaD21byInWG4wFBGt9WRDSZTFVKR2hyF+fbt14vPRJlklzxLrycoCLU9KgwVedcE
         dG/Wl5F1l4SE9of5BortJfD9ykyYfutIXwzTnOWUURFzQHTYktqy8KNSVzy469LIxPRq
         FpIA==
X-Gm-Message-State: APjAAAVj9VxaTrX1F5q6XvT0Bz5WJ5Z/O+tTg6LyqpUt5xnGi/HEYBEx
        iUyYc/BhARYJjnbMskXygMs=
X-Google-Smtp-Source: APXvYqxrA78PCo3HpEruu0DtLbes7n6w9uyavlY+RiH/PAMWwtbQT/a5a/6eaZF3OkrS1kGqFwWQEw==
X-Received: by 2002:a17:90a:c301:: with SMTP id g1mr8442112pjt.67.1577224983386;
        Tue, 24 Dec 2019 14:03:03 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:1206:80fd:a97:a7d:f0c8])
        by smtp.gmail.com with ESMTPSA id m15sm26839779pgi.91.2019.12.24.14.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 14:03:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5/6] ufs: Remove superfluous memory barriers
Date:   Tue, 24 Dec 2019 14:02:47 -0800
Message-Id: <20191224220248.30138-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191224220248.30138-1-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling wmb() after having written to a doorbell slows down code and does
not help to commit the doorbell write faster. Hence remove such wmb()
calls. Note: detailed information about the semantics of writel() is
available in Documentation/driver-api/device-io.rst.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4d9bb1932b39..edcc137c436b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1879,8 +1879,6 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	/* Make sure that doorbell is committed immediately */
-	wmb();
 }
 
 /**
@@ -5766,8 +5764,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	wmb();
 
 	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
-	/* Make sure that doorbell is committed immediately */
-	wmb();
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
