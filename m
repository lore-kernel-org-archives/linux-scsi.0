Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E903CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8C322084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U1aDYPFD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O9aH/IV3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfKBFGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:06:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFGC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:06:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 567D861643; Sat,  2 Nov 2019 05:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671072;
        bh=Ykm1fLX9tqygHu3LFH589qU14CQgP2B1rCHt0laWkNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1aDYPFDB0s/kNhxRgYKKlU/StObpXjig4djtauH+QB//xyiwSVea1qk/AdDrXNJh
         CFX2DI8PWQT1VH26AvSKF+UtGVfpAWiQuHFUbSEf1zkSd33n5FdyJ51b7f5wBBl1lw
         YmY3E1kJSlRnXHxASu7/c+4Zqot13hfXnQSJ6bYg=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3D16E6164F;
        Sat,  2 Nov 2019 05:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671057;
        bh=Ykm1fLX9tqygHu3LFH589qU14CQgP2B1rCHt0laWkNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9aH/IV3X426dxO09auih4P0UWo8I/N8bandxD1m54QnuGRqwPQ9tTPaxlGUQeI74
         5jZd/Jg1dkFnJ9cJ5NVtyp0HzYTXXE6NwmAH3Toc1cJku+yBFR0wjPOKV5eTo0K7Ba
         hfsMGrmXgjr9ZtGASvEkEmZuIKjbdDxAl3O4XpaQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3D16E6164F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 6/6] scsi: ufs: Fix error handing during hibern8 enter
Date:   Fri,  1 Nov 2019 22:03:36 -0700
Message-Id: <1572671016-883-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572671016-883-1-git-send-email-cang@codeaurora.org>
References: <1572671016-883-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

During clock gating (ufshcd_gate_work()), we first put the link hibern8 by
calling ufshcd_uic_hibern8_enter() and if ufshcd_uic_hibern8_enter()
returns success (0) then we gate all the clocks.
Now let’s zoom in to what ufshcd_uic_hibern8_enter() does internally:
It calls __ufshcd_uic_hibern8_enter() which on detecting the LINERESET,
initiates the full recovery and puts the link back to highest HS gear and
returns success (0) to ufshcd_uic_hibern8_enter() which is the issue as
link is still in active state due to recovery!
Now ufshcd_uic_hibern8_enter() returns success to ufshcd_gate_work() and
hence it goes ahead with gating the UFS clock while link is still in active
state hence I believe controller would raise UIC error interrupts. But when
we service the interrupt, clocks might have already been disabled!

This change fixes for this by returning failure from
__ufshcd_uic_hibern8_enter() if recovery succeeds as link is still not in
hibern8, upon receiving the error ufshcd_hibern8_enter() would initiate
retry to put the link state back into hibern8.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c9ef2dd..1201578 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3891,15 +3891,24 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 	if (ret) {
+		int err;
+
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
 
 		/*
-		 * If link recovery fails then return error so that caller
-		 * don't retry the hibern8 enter again.
+		 * If link recovery fails then return error code (-ENOLINK)
+		 * returned ufshcd_link_recovery().
+		 * If link recovery succeeds then return -EAGAIN to attempt
+		 * hibern8 enter retry again.
 		 */
-		if (ufshcd_link_recovery(hba))
-			ret = -ENOLINK;
+		err = ufshcd_link_recovery(hba);
+		if (err) {
+			dev_err(hba->dev, "%s: link recovery failed", __func__);
+			ret = err;
+		} else {
+			ret = -EAGAIN;
+		}
 	} else
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
 								POST_CHANGE);
@@ -3913,7 +3922,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 
 	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
 		ret = __ufshcd_uic_hibern8_enter(hba);
-		if (!ret || ret == -ENOLINK)
+		if (!ret)
 			goto out;
 	}
 out:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

