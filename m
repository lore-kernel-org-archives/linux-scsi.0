Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839F9CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 531A92087F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RsS+XS5f";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aRmUB5PT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfJ3MiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 08:38:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37404 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfJ3MiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 08:38:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1ED5060B6E; Wed, 30 Oct 2019 12:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572439084;
        bh=0qAr1uNt0BYHMVVA7KLzkh+sq+gyZvFpwQDY6R6Df10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsS+XS5f5tV81leozAyTa1i4nLXQky/hdTp3CmCb0NtFgS8Sw0abewdNi7jSMoQa8
         OAELVXuL44arwpNWBTD1rnRXTq0PlT4yXYPW98B1lXqOYTt/uD76fNEOBOF5tWSinE
         w6cxppeQ4vMsr80q9qPzWuaG0hTkcca/yCKtLiYc=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D923E60B6E;
        Wed, 30 Oct 2019 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572439082;
        bh=0qAr1uNt0BYHMVVA7KLzkh+sq+gyZvFpwQDY6R6Df10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRmUB5PTobfl2QDb54NW/o29FJ30v/er86Jz2OKFnra6zWw5XQ/XomEoYaQLA/XBU
         K1xgrIlmP3E7O/SIvC2waxqCKbfezQpuAuQzdSxqrGvxvZcDi7twjsWWiqLHl4gzd8
         EnGzfXnOj61GhrgZc8O76C3+OxqNY3q0qerh9Ycc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D923E60B6E
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
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/2] scsi: ufs: Introduce bus voting vendor ops
Date:   Wed, 30 Oct 2019 05:37:42 -0700
Message-Id: <1572439064-28785-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572439064-28785-1-git-send-email-cang@codeaurora.org>
References: <1572439064-28785-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some vendors need to vote for bus bandwidth when bus clocks are changed,
hence introduce the bus voting vendor ops so that UFS driver can use it.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h |  9 +++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..ec13aaf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7289,6 +7289,13 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	if (list_empty(head))
 		goto out;
 
+	/* call vendor specific bus vote before enabling the clocks */
+	if (on) {
+		ret = ufshcd_vops_set_bus_vote(hba, on);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * vendor specific setup_clocks ops may depend on clocks managed by
 	 * this standard driver hence call the vendor specific setup_clocks
@@ -7330,11 +7337,21 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	if (on) {
 		ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
+	/*
+	 * call vendor specific bus vote to remove the vote after
+	 * disabling the clocks.
+	 */
+	if (!on)
+		ret = ufshcd_vops_set_bus_vote(hba, on);
+
 out:
 	if (ret) {
+		if (on)
+			/* Can't do much if this fails */
+			(void) ufshcd_vops_set_bus_vote(hba, false);
 		list_for_each_entry(clki, head, list) {
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..7eb4174 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -297,6 +297,7 @@ struct ufs_pwr_mode_info {
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
+ * @set_bus_vote: called to vote for the required bus bandwidth
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
  */
@@ -326,6 +327,7 @@ struct ufs_hba_variant_ops {
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
+	int	(*set_bus_vote)(struct ufs_hba *, bool);
 	int	(*phy_initialization)(struct ufs_hba *);
 	void	(*device_reset)(struct ufs_hba *hba);
 };
@@ -1082,6 +1084,13 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 		hba->vops->dbg_register_dump(hba);
 }
 
+static inline int ufshcd_vops_set_bus_vote(struct ufs_hba *hba, bool on)
+{
+	if (hba->vops && hba->vops->set_bus_vote)
+		return hba->vops->set_bus_vote(hba, on);
+	return 0;
+}
+
 static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->device_reset)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

