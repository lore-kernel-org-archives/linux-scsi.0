Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FC3C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C16AF20771
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="elFHcF2s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGCFih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:38:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19425 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCFig (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:38:36 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200703053831epoutp0491d11ea52427c822e8c0f40a68a8d0ac~eJ3dqEgZ_0762307623epoutp04U
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 05:38:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200703053831epoutp0491d11ea52427c822e8c0f40a68a8d0ac~eJ3dqEgZ_0762307623epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593754712;
        bh=XisvrFgN1+3/X4xOrCaQ1Jg+px/uRajlRLqI9yvuNFA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=elFHcF2sYKBTdP+36XXFLRsdvE0OW8jJ8rtd4VXY5bAf/g+3lpvHathKzcHFR3t6i
         OIHF+X9O1HoRxICp6vn+uXcjBWu6kbIomh0r/yNr1cjSYE5L1o05J8rdzaHCUfRJLu
         uZwzFo59WeWdMUukjj+wIrETv+H9vURNgugascpQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200703053831epcas2p343864cfa758ee4d7d8ae666190036894~eJ3c4-2J83218332183epcas2p3P;
        Fri,  3 Jul 2020 05:38:31 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49ykK05zhKzMqYkg; Fri,  3 Jul
        2020 05:38:28 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.DC.27441.454CEFE5; Fri,  3 Jul 2020 14:38:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200703053828epcas2p38d1d2236ae9c56df1f9233e4be141a03~eJ3aThJJQ3265432654epcas2p3N;
        Fri,  3 Jul 2020 05:38:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200703053828epsmtrp1c966795778ff3772dc71baa40ff00717~eJ3aSx6970380503805epsmtrp1c;
        Fri,  3 Jul 2020 05:38:28 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-dc-5efec454d449
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.9A.08382.454CEFE5; Fri,  3 Jul 2020 14:38:28 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200703053828epsmtip23b626dee08c38bffd7b9a9665f33c672~eJ3aB8Fo32308823088epsmtip2Z;
        Fri,  3 Jul 2020 05:38:28 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v2] ufs: introduce async ufs interface initialization
Date:   Fri,  3 Jul 2020 14:30:41 +0900
Message-Id: <1593754241-194331-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdljTQjfkyL84g8nfdC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORkPOh4zFuzSqTi35xNTA+M6lS5GDg4JAROJLTPLuhi5OIQEdjBKTJq8ghnC+cQoceHFXiYI
        5xujxNent9m6GDnBOqYd+cYKYgsJ7GWU2PzEBKLoB6PE46b7TCAJNgFNiac3p4J1iwhsZpJ4
        teA+M0iCWUBdYteEE2BFwgKeEluubAWLswioSiy8eo4RxOYVcJOY9GUz1DY5iZvnOsFukhD4
        yS7R/W8bK0TCReJq+0ZGCFtY4tXxLewQtpTEy/42KLteYt/UBlaI5h5Giaf7/kE1GEvMetbO
        CAoBZqBT1+/ShwSGssSRWywQd/JJdBz+yw4R5pXoaBOCaFSW+DVpMtQQSYmZN+9AbfKQeH/v
        OhMkUGIlpi6fwDyBUXYWwvwFjIyrGMVSC4pz01OLjQqMkSNpEyM4LWq572Cc8faD3iFGJg7G
        Q4wSHMxKIrwJqv/ihHhTEiurUovy44tKc1KLDzGaAsNrIrOUaHI+MDHnlcQbmhqZmRlYmlqY
        mhlZKInzFltdiBMSSE8sSc1OTS1ILYLpY+LglGpg0sgp2ft+9s2tadIJel/zzy+69drGf/dv
        2TV9zGmM6Rn7FgY1nDi6chbv1m5H1+uLAufMO6wxeW9wUEIvo88DDQHFlfY3Np+0f6jJuNNn
        xnzXrwYHBL0eyLaWHZoRushB/beM+asijvdXfr88vaVZ49mP5+l6T8sEdk55+mq9utLimMhD
        wql/75ZUf9jy6OuXLMeEnTLnTLpeLNPpn9G+lm/G+1Mx2Zl/9D5djvzXZKX3I1TuXoWsS77z
        zO2xD18L6ajtdO9MP5ysd2dezwRuvzjH2ZXtr11C+V+syXS6xbbPeGrZ9NqytVsmmF/1m1uY
        PTl4q+KcZK6S/QcS1Y1vFkzStrVZGH5CPvxHX9/nx0osxRmJhlrMRcWJAD9EqpkUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSvG7IkX9xBpN28lk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZDzoeMxbs0qk4t+cTUwPjOpUuRk4OCQETiWlHvrF2MXJxCAnsZpRY
        9XQ7C0RCUuLEzueMELawxP2WI1BF3xgldp3eyg6SYBPQlHh6cyoTSEJE4DCTxP+tz8ESzALq
        ErsmnGACsYUFPCW2XNnKDGKzCKhKLLx6Dmwqr4CbxKQvm9kgNshJ3DzXyTyBkWcBI8MqRsnU
        guLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgUNXS3MG4fdUHvUOMTByMhxglOJiVRHgTVP/F
        CfGmJFZWpRblxxeV5qQWH2KU5mBREue9UbgwTkggPbEkNTs1tSC1CCbLxMEp1cBkElUxd8r3
        7ytrVnU5/N/2+amdVPLublOxFQsiLaeWVrYsTjh6y0j9g8Cq/JUd8fZX9/vstZ+8gfW2wvLo
        TMkuF6/7S5p5swwuPs1Ntbp368PxBTetg+OPe+xsXXE9X64gqjuJvY37rWbMx8L8KVfXPPD/
        +ZCN49o8TcHsa1Lp0w4rzFT4Hrl+KlfUAiXp066ri6/dErtd4/mwff6KS/vrs94u2b9N60q6
        vUNmz4+7E/vS3y46+M87/5zYTYe/3DJNL72rjTXDflpOL/mQmli4b2XzhBBHvWZ5jlSDyh3f
        fB78Zu7y2tXy+cPN6U1Sj7uktiwwTYj77MYqXdXM7OukVqGlom1xdpUxY/4B12lKLMUZiYZa
        zEXFiQBJLc4NxAIAAA==
X-CMS-MailID: 20200703053828epcas2p38d1d2236ae9c56df1f9233e4be141a03
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053828epcas2p38d1d2236ae9c56df1f9233e4be141a03
References: <CGME20200703053828epcas2p38d1d2236ae9c56df1f9233e4be141a03@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2
fix warning message

When you set uic_link_state during sleep statae to
UIC_LINK_OFF_STATE, UFS driver does interface initialization
that is a series of some steps including fDeviceInit and thus,
You might feel that its latency is a little bit longer.

This patch is run it asynchronously to reduce system wake-up time.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/Kconfig  |  10 ++++
 drivers/scsi/ufs/ufshcd.c | 120 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 100 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8cd9026..9ef1727 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -172,3 +172,13 @@ config SCSI_UFS_EXYNOS
 
 	  Select this if you have UFS host controller on EXYNOS chipset.
 	  If unsure, say N.
+
+config SCSI_UFSHCD_ASYNC_INIT
+	bool "Asynchronous UFS interface initialization support"
+	depends on SCSI_UFSHCD
+	default n
+	help
+	This selects the support of doing UFS interface initialization
+	asynchronously when you set link state to link off,
+	i.e. UIC_LINK_OFF_STATE, to reduce system wake-up time.
+	Select this if you have UFS Host Controller.
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6c08ed2..3d2cead 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8370,6 +8370,80 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return ret;
 }
 
+static int ufshcd_post_resume(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	if (!ufshcd_is_ufs_dev_active(hba)) {
+		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
+		if (ret)
+			goto out;
+	}
+
+	if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
+		ufshcd_enable_auto_bkops(hba);
+	else
+		/*
+		 * If BKOPs operations are urgently needed at this moment then
+		 * keep auto-bkops enabled or else disable it.
+		 */
+		ufshcd_urgent_bkops(hba);
+
+	hba->clk_gating.is_suspended = false;
+
+	if (hba->clk_scaling.is_allowed)
+		ufshcd_resume_clkscaling(hba);
+
+	/* Enable Auto-Hibernate if configured */
+	ufshcd_auto_hibern8_enable(hba);
+
+	if (hba->dev_info.b_rpm_dev_flush_capable) {
+		hba->dev_info.b_rpm_dev_flush_capable = false;
+		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
+	}
+
+	/* Schedule clock gating in case of no access to UFS device yet */
+	ufshcd_release(hba);
+out:
+	return ret;
+}
+
+#if defined(SCSI_UFSHCD_ASYNC_INIT)
+static void ufshcd_async_resume(void *data, async_cookie_t cookie)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)data;
+	unsigned long flags;
+	int ret = 0;
+	int retries = 2;
+
+	/* transition to block requests */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* initialize, instead of set_old_link_state ?? */
+	do {
+		ret = ufshcd_reset_and_restore(hba);
+		if (ret) {
+			dev_err(hba->dev, "%s: reset and restore failed\n",
+					__func__);
+			spin_lock_irqsave(hba->host->host_lock, flags);
+			hba->ufshcd_state = UFSHCD_STATE_ERROR;
+			hba->pm_op_in_progress = 0;
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			return;
+		}
+		ret = ufshcd_post_resume(hba);
+	} while (ret && --retries);
+	if (ret)
+		goto reset;
+
+	hba->pm_op_in_progress = 0;
+	if (ret)
+		ufshcd_update_reg_hist(&hba->ufs_stats.resume_err, (u32)ret);
+}
+#endif
+
 /**
  * ufshcd_resume - helper function for resume operations
  * @hba: per adapter instance
@@ -8421,6 +8495,14 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 * A full initialization of the host and the device is
 		 * required since the link was put to off during suspend.
 		 */
+#if defined(SCSI_UFSHCD_ASYNC_INIT)
+		/*
+		 * Assuems error free since ufshcd_probe_hba failure is
+		 * uncorrectable.
+		 */
+		ufshcd_async_schedule(ufshcd_async_resume, hba);
+		goto out_new;
+#else
 		ret = ufshcd_reset_and_restore(hba);
 		/*
 		 * ufshcd_reset_and_restore() should have already
@@ -8428,38 +8510,12 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 */
 		if (ret || !ufshcd_is_link_active(hba))
 			goto vendor_suspend;
+#endif
 	}
 
-	if (!ufshcd_is_ufs_dev_active(hba)) {
-		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
-		if (ret)
-			goto set_old_link_state;
-	}
-
-	if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
-		ufshcd_enable_auto_bkops(hba);
-	else
-		/*
-		 * If BKOPs operations are urgently needed at this moment then
-		 * keep auto-bkops enabled or else disable it.
-		 */
-		ufshcd_urgent_bkops(hba);
-
-	hba->clk_gating.is_suspended = false;
-
-	if (hba->clk_scaling.is_allowed)
-		ufshcd_resume_clkscaling(hba);
-
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
-
-	if (hba->dev_info.b_rpm_dev_flush_capable) {
-		hba->dev_info.b_rpm_dev_flush_capable = false;
-		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
-	}
-
-	/* Schedule clock gating in case of no access to UFS device yet */
-	ufshcd_release(hba);
+	ret = ufshcd_post_resume(hba);
+	if (ret)
+		goto set_old_link_state;
 
 	goto out;
 
@@ -8478,6 +8534,10 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->pm_op_in_progress = 0;
 	if (ret)
 		ufshcd_update_reg_hist(&hba->ufs_stats.resume_err, (u32)ret);
+	/* For async init, pm_op_in_progress still needs to be one */
+#if defined(SCSI_UFSHCD_ASYNC_INIT)
+out_new:
+#endif
 	return ret;
 }
 
-- 
2.7.4

