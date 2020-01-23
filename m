Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F52C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A73F21835
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAWD4t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 22:56:49 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38986 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAWD4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 22:56:49 -0500
Received: by mail-pj1-f67.google.com with SMTP id e11so594994pjt.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 19:56:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PECrTPgQ/4zzlU3vcE8oG3CZR7wo45vqGAojOobzq4s=;
        b=VZw6bAWao6GGL9ODLni7ZE8u/kOLgjCn2Tvbhnhc+2OiNM9BBN+6U8452/qOIBsK1V
         Yl+4sJnJndSSjenzAUq7MX2ZuP06DakALJH6IKijNTteMCYU+vrRYzQ3amFAfZbbB0wJ
         E89Fnxi2IPRe9TWq1+5wD9plfb2EkY/SfjwlGvBxs7C7qHNwGn3Fb+094e5foFCLrPMK
         49fudp5cWzy20hfx4OKBZF52f14dvHEN1qD24rezKGdlMTzGo4m/0frL80XcqX2JCl0j
         zrVgDJYv6AaqZDO0x6oTG8TZNeWxZyJbzN5LnIq666qE/NXpwuAyq12nLWiUvcVl7GE9
         8LFw==
X-Gm-Message-State: APjAAAW9xLEp3VikOToLr6BK4tgmpDaYovTLyMweCl0P3zabh2pCJHTZ
        oTWi6I7rcIY23QI6VSEhC9I=
X-Google-Smtp-Source: APXvYqw091GXnWQT5wVLHu5MGtE3v4mUAwvQYUtBWuTTKSOTWt3TAZqfR4eRnkqEKqFdjCJACOTiMg==
X-Received: by 2002:a17:902:d711:: with SMTP id w17mr14650299ply.303.1579751808432;
        Wed, 22 Jan 2020 19:56:48 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id x197sm435287pfc.1.2020.01.22.19.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 19:56:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 3/4] ufs: Simplify two tests
Date:   Wed, 22 Jan 2020 19:56:36 -0800
Message-Id: <20200123035637.21848-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123035637.21848-1-bvanassche@acm.org>
References: <20200123035637.21848-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lrbp->cmd is set only for SCSI commands. Use this knowledge to simplify
two boolean expressions.

Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4cb610df76d6..51c466b2a07a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2473,7 +2473,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
+	ufshcd_vops_setup_xfer_req(hba, tag, true);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -2660,7 +2660,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
+	ufshcd_vops_setup_xfer_req(hba, tag, false);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
