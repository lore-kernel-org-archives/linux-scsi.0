Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91519C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 08:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9B020899
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 08:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P/Tm+Day"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgGBI2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:28:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25128 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgGBI2d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 04:28:33 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200702082830epoutp01db966c10f3455f4d1b19704b4cd1b2ee~d4ilEYshT1326113261epoutp017
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 08:28:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200702082830epoutp01db966c10f3455f4d1b19704b4cd1b2ee~d4ilEYshT1326113261epoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593678510;
        bh=WqulEDehZE6vjeGpPevvaebHgQc9p3DkIMNE7UEd9z0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=P/Tm+Dayf301duMJ/rz4ZyE7oRQ5JaiqCYDRijy8GdjDDjvqcprQDa2wonPcpIYBh
         2esKnjgv1B59GkmDaHoor9OXfFZnRbwe+7bWaZAKboPEV32yzRz492zD8Ow7EJ+OxW
         WP2MdOB+++6iEgR3zn47frxGbcv019lP7o3BaJG0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200702082829epcas2p4ae446cc5b966289512b116beb1adc433~d4ikcw7ZO2470624706epcas2p4b;
        Thu,  2 Jul 2020 08:28:29 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49yB7Z4kRszMqYkV; Thu,  2 Jul
        2020 08:28:26 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.B5.19322.AAA9DFE5; Thu,  2 Jul 2020 17:28:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8~d4ihZ6ZHc0742107421epcas2p2M;
        Thu,  2 Jul 2020 08:28:26 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200702082826epsmtrp1d7dda161333d1bd3dc6ea726e522ea54~d4ihZEXDc1343613436epsmtrp1s;
        Thu,  2 Jul 2020 08:28:26 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-4d-5efd9aaa96f5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.64.08303.9AA9DFE5; Thu,  2 Jul 2020 17:28:25 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200702082825epsmtip2f8b25a731eda5458b33224ad50d53051~d4ihJU6PU2809328093epsmtip2X;
        Thu,  2 Jul 2020 08:28:25 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1] ufs: introduce async ufs interface initialization
Date:   Thu,  2 Jul 2020 17:20:39 +0900
Message-Id: <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTQnfVrL9xBhtaVC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORmHGruZC2brVCz8tpu5gXG2ShcjJ4eEgInEvz3XWLoYuTiEBHYwSvR93c0M4XxilLhw6iwj
        hPOZUWLNz0OMMC0nVp9lhUjsYpQ4f+kuVP8PRonvv9+yg1SxCWhKPL05lQkkISKwmUni1YL7
        zCAJZgF1iV0TTjCB2MICnhLfd/wEi7MIqEp8Oz4HLM4r4CaxZO1hVoh1chI3z3WCHSUh8JVd
        4um332wQCReJmW/XM0HYwhKvjm9hh7ClJF72t0HZ9RL7pjawQjT3MEo83fcP6gljiVnP2oFs
        DqCLNCXW79IHMSUElCWO3GKBuJNPouPwX3aIMK9ER5sQRKOyxK9Jk6GGSErMvHkHapOHxPqb
        n8EuExKIlVh6r4V1AqPsLIT5CxgZVzGKpRYU56anFhsVGCJH0yZGcGrUct3BOPntB71DjEwc
        jIcYJTiYlUR4Txv8ihPiTUmsrEotyo8vKs1JLT7EaAoMr4nMUqLJ+cDknFcSb2hqZGZmYGlq
        YWpmZKEkzpureCFOSCA9sSQ1OzW1ILUIpo+Jg1OqgWldtdrdnLnCAp+Z0wuyG64eLrn7Wf/r
        Vzb2F0GXOYX96vbNzGTL2BYbMSPxaYFg2/ZIrcJy6/CIG9/OGZ/Zdqgrf6+0Vk7B4gMyh0+4
        bn603HvHxBzRmNjzHBcXsgQdkD29+1H1/P+WEYblfxasXRl6aslDd5aDNlrOt1e+fPrqqHPg
        rMfNQjLL+Tib1fOMa58/bVH0+KRfV2ZtNdGp4nHXg1bXfImSEL075z/IazkpWh7fP9fty4XT
        CzjF/a1lX/VcPhl1ZSfzomi9y+krTa7+8lLIueL3ePMKj70rV0QZcbK6+Vx+d8JuTva/+hNW
        XAU3N3164r6V/+YxLclLZySqf7ZPmjTv0RuRaq6nexWVWIozEg21mIuKEwGzICnMFgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSvO7KWX/jDP7etrR4MG8bm8XethPs
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtfj1dz27xerFD1gsFt3YxmRxc8tRFovu6zvYLJYf/8dk
        0XX3BqPF0n9vWRz4PC5f8fa43NfL5DFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQI4
        orhsUlJzMstSi/TtErgyDjV2MxfM1qlY+G03cwPjbJUuRk4OCQETiROrz7J2MXJxCAnsYJR4
        e+Q8C0RCUuLEzueMELawxP2WI1BF30CKpjGDJNgENCWe3pzKBJIQETjMJPF/63N2kASzgLrE
        rgknmEBsYQFPie87foI1sAioSnw7PgcszivgJrFk7WFWiA1yEjfPdTJPYORZwMiwilEytaA4
        Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOFS1tHYw7ln1Qe8QIxMH4yFGCQ5mJRHe0wa/4oR4
        UxIrq1KL8uOLSnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXAdP7kw+zsJzev
        lG00Vpr1RGeXcErGW58YX7+ih7MNGnqfrukKMrV6r/h9ceEGVtY0i18ddtfumK7/8ylucs22
        f2UWknxlbmuKBCpO3bxs/j/yxuVFi08mr9MPiMmf+yeZdfrmQ0Um5w72b1fdolneEPyG5YFa
        wle5P0+yVheu7/A+uP/gz/3z3r78fGLfHP2oD7Ivon1KeTK2vw122nCgKbSSfwFH7Fe1fUKh
        DtO7br21+STDlZ97pGfT7EvfjshxSDXypE75qjlp+SLjuGCxOTs/fnKrl7+xVtFBNvysyeu9
        Yh9PrT/QH55/f0/kTL9FfbFb/lgrr2WYWFqolcO91ijopxZLwEPtWQpMgTHSfUosxRmJhlrM
        RcWJALsR4p7EAgAA
X-CMS-MailID: 20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8
References: <CGME20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
index 8cd9026..723e7cb 100644
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
+	---help---
+	This selects the support of doing UFS interface initialization
+	asynchronously when you set link state to link off,
+	i.e. UIC_LINK_OFF_STATE, to reduce system wake-up time.
+	Select this if you have UFS Host Controller.
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..b65d38c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8319,6 +8319,80 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return ret;
 }
 
+static int ufshcd_post_resume(struct ufs_hba *hba)
+{
+	int ret;
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
@@ -8370,6 +8444,14 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
@@ -8377,38 +8459,12 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
 
@@ -8427,6 +8483,10 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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

