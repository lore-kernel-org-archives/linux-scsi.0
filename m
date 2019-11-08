Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E49FA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C04E22178F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bHhqIiqR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JUv2uRvR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfKHIPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:15:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49514 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHIPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:15:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0C9E260DA7; Fri,  8 Nov 2019 08:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200949;
        bh=ZIPu4gT4HYxGcpXO8G7/FKIaTnRGQoh2m4/H7iQslC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHhqIiqRU2gB+S/KidQwPZvOYunorKkq6j9LQq4xqCJsvl7yTUJpIcZ/7hrlNuK3x
         6QHiyRDsM82klpRqi/G1WCmNAHK6cEbLiVoEyGynv4UY6V1v3WYXFAsNXSI6cveu5K
         SIf0KyX7ngqminC3ExW2yiNsivtuvCgAm0CyDrQU=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA0C560A0A;
        Fri,  8 Nov 2019 08:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200946;
        bh=ZIPu4gT4HYxGcpXO8G7/FKIaTnRGQoh2m4/H7iQslC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUv2uRvRKc5FS6dVBkxSkrUH90kACnHZN7jQdx824WUxLTyHDcbU/6uiOEA4qsPKv
         39MpDZmTfEADpQvT2vpf3XyJ4Xd6EfXYic5yASfp6rMSfc/td7Mew1H5BLqv1mhNP4
         Cv4Yg8Y8OXLuOzbY1o9cXGgPcqVCQXUaeVmqmB7Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA0C560A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/5] scsi: ufs: Recheck bkops level if bkops is disabled
Date:   Fri,  8 Nov 2019 00:15:27 -0800
Message-Id: <1573200932-384-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573200932-384-1-git-send-email-cang@codeaurora.org>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Asutosh Das <asutoshd@codeaurora.org>

Bkops level should be rechecked upon receiving an exception.
Currently the bkops level is being cached and never updated.

Update the same each time the level is checked.
Also do not use the cached bkops level value if it is disabled
and then enabled.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3910c58..8e7c362 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5099,6 +5099,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 
 	hba->auto_bkops_enabled = false;
 	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Disabled");
+	hba->is_urgent_bkops_lvl_checked = false;
 out:
 	return err;
 }
@@ -5123,6 +5124,7 @@ static void ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
 		hba->ee_ctrl_mask &= ~MASK_EE_URGENT_BKOPS;
 		ufshcd_disable_auto_bkops(hba);
 	}
+	hba->is_urgent_bkops_lvl_checked = false;
 }
 
 static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
@@ -5169,6 +5171,7 @@ static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
 		err = ufshcd_enable_auto_bkops(hba);
 	else
 		err = ufshcd_disable_auto_bkops(hba);
+	hba->urgent_bkops_lvl = curr_status;
 out:
 	return err;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

