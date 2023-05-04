Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFB4C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 23:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjEDXvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 19:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjEDXva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 19:51:30 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BC313293
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 16:51:29 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1aaebed5bd6so7824305ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2023 16:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683244288; x=1685836288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hJO4H87eOprV7wY9RkTcEehuFFsAgczKpnmXGyKNCQ=;
        b=G2WBRgU3Zj7OkBIycBLB1vkL/0F0tuy/odkP2qBa0b23XpoRWWzBsthXHWG0IqgnoZ
         fJRpDISG5DKBxLaRnLqJjbPVwcnr+RQSS9IsvroGAi8vnagAL1VTRCH+5xaCx1f0BAMM
         1WxhefBzZMD7WBl9E+gKbh7+6opnP7Us8wZyvevDDfGpl/HcmB0dFuke4uD9p34OxpPq
         rkGO3CPFBvxiRTXIqwzWuNtbjJo3CAXzI+KI8exsq7E+hYo/KMOR4e0/ghNTQhRe5wQR
         tnjepHVJ4AaFo/rJ52qDvLegYS3Rd3bFRCNL08oQ3BV7GOBGSgsa/CaY34jgC/oAJbyu
         BjZQ==
X-Gm-Message-State: AC+VfDx2zFjLaBIT44yktiZ160udrYUKVRn/wCqWBYJJxIQKFiQYQMkm
        ybOM0gd8EsDJVNFoRt/y39Y=
X-Google-Smtp-Source: ACHHUZ6bvdxAY5N++r7Q1zZMr+YOQDVv6oGzZTJxQW9hayDWXB2mJMviyvjLIsh+WBgY0QFZzNdXsQ==
X-Received: by 2002:a17:902:e5c3:b0:1a9:a672:12b8 with SMTP id u3-20020a170902e5c300b001a9a67212b8mr5540781plf.68.1683244288416;
        Thu, 04 May 2023 16:51:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902758d00b001aad4be4503sm143169pll.2.2023.05.04.16.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:51:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <quic_cang@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 4/5] scsi: ufs: core: Unexport ufshcd_hold() and ufshcd_release()
Date:   Thu,  4 May 2023 16:50:51 -0700
Message-Id: <20230504235052.4423-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230504235052.4423-1-bvanassche@acm.org>
References: <20230504235052.4423-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unexport these functions since these are only used by the UFS core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 --
 include/ufs/ufshcd.h      | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a1bce9c6aee5..54f91d7d0192 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1847,7 +1847,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 out:
 	return rc;
 }
-EXPORT_SYMBOL_GPL(ufshcd_hold);
 
 static void ufshcd_gate_work(struct work_struct *work)
 {
@@ -1950,7 +1949,6 @@ void ufshcd_release(struct ufs_hba *hba)
 	__ufshcd_release(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
-EXPORT_SYMBOL_GPL(ufshcd_release);
 
 static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d6da1efb0212..13824462452d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1358,9 +1358,6 @@ void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
-int ufshcd_hold(struct ufs_hba *hba, bool async);
-void ufshcd_release(struct ufs_hba *hba);
-
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
 
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
