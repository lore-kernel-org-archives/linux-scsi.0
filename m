Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6157BC7618E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 01:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbjDYB3H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Apr 2023 21:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjDYB3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2023 21:29:06 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8174C5269
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2023 18:29:03 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230425012859epoutp0405e5f96958b67ef37dabaf2f9d11f289~ZCUejt2bX3217232172epoutp04e
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 01:28:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230425012859epoutp0405e5f96958b67ef37dabaf2f9d11f289~ZCUejt2bX3217232172epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682386139;
        bh=gh+P81jr88TFzRimUdVq9FOs0DkNKHgXBwKE3vKfBx8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=kYLFtqHvBja0PpkeBoDtJe1/b5elCDISgsqZu5SeB1detm17Okj0snbhl3P6+3FXp
         MMpN7tEwu83JoTHJ+N5rnawi7wyvG9LSCy0Sio/RLUtzcgNsvJoLaJD5PMHc4ySUB6
         CvQhJVrAO43fATPsSY8GZ1tPpCnkLd3RZHaE/2Bg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20230425012858epcas2p3fcfe96d036dc0917ef1d18bbf4b2543f~ZCUd79EPJ3083330833epcas2p3G;
        Tue, 25 Apr 2023 01:28:58 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Q54CY4JY9z4x9Q0; Tue, 25 Apr
        2023 01:28:57 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.BE.08199.9DC27446; Tue, 25 Apr 2023 10:28:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20230425012857epcas2p45eaa3f5f87de424bbf951b22653b3e70~ZCUcrpOfZ1121811218epcas2p4m;
        Tue, 25 Apr 2023 01:28:57 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230425012857epsmtrp166a6f975ba7e1148abb2d172972219ec~ZCUcqsY_J3060630606epsmtrp1t;
        Tue, 25 Apr 2023 01:28:57 +0000 (GMT)
X-AuditID: b6c32a47-c29ff70000002007-e7-64472cd9f106
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.CF.28392.8DC27446; Tue, 25 Apr 2023 10:28:56 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230425012856epsmtip27f210bae40ec50751fb5b2e653687929~ZCUca_1au2609826098epsmtip2C;
        Tue, 25 Apr 2023 01:28:56 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com,
        kwangwon.min@samsung.com, junwoo80.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2] ufs: poll pmc until another pa request is completed
Date:   Tue, 25 Apr 2023 10:20:35 +0900
Message-Id: <1682385635-43601-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmhe5NHfcUg85PChYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8XqxQ9YLBbd2MZksetvM5PF1hs7WSxubjnKYnF51xw2i+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkC
        2KOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
        KEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgX6BUn5haX5qXr5aWWWBkaGBiZAhUm
        ZGf0rLzPWHDZoKJn0kbGBsY36l2MnBwSAiYS0zZNZuli5OIQEtjBKDH//k5WCOcTo8S7/r9s
        EM5nRom+mXuYYFredP9nh0jsYpQ4+ucwlPODUWLtzp+MIFVsApoST29OZQJJiAjcZZJ4t+og
        C0iCWUBdYteEE2CjhAXcJZovHAHawcHBIqAqMeepC0iYV8BV4nH/MahtchI3z3Uyg8yREPjJ
        LnFm2RZWiISLxIxJn5ghbGGJV8e3sEPYUhIv+9vYQWZKCGRL7FkoBhGukFg87S0LhG0sMetZ
        OyNICTPQnet36UNUK0scuQV1JJ9Ex+G/UEN4JTrahCAalSV+TZrMCGFLSsy8eQeqxENi5Vsv
        EFNIIFai+bXCBEbZWQjTFzAyrmIUSy0ozk1PLTYqMIbHUHJ+7iZGcELUct/BOOPtB71DjEwc
        jIcYJTiYlUR4hbPcUoR4UxIrq1KL8uOLSnNSiw8xmgKDaiKzlGhyPjAl55XEG5pYGpiYmRma
        G5kamCuJ80rbnkwWEkhPLEnNTk0tSC2C6WPi4JRqYAoyYzA8INHoZ1v+Z4+8xpq+7J2n/+5W
        uNu0cyrLnFP60RyBCw1jM7/+6r156rZlqdqDldMWyW9ukDts53P26ON9QTMNXjb+elymdy3u
        5Jd7chOfnBS88deh/cjdw9cnsho+DNRddzqjc8PCgtK83ZO3MNXE/No7/YSy2Ke8dwxtF1uU
        H3Mcmv/SJuhZo5/UNLarAtkTGT8p6b9cHZp+ojvmNf/OSCsWIc7dPLwGW3bPOM0T0CVcMiug
        1OWoy6mIva+WNpV/EUqftLqohlFn3a19mUu+uXXv9PiXbmqpal1yaaOy9B72I9U3/7E7NGzY
        zeWUevSgqwvnQouMJ9Hz1pjKBMfY8S3lvSP30k72xyUlluKMREMt5qLiRADZf2wbEQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvO4NHfcUgz2vrC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVovVix+wWCy6sY3JYtffZiaLrTd2sljc3HKUxeLyrjlsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7LN7zksljwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMF
        sEdx2aSk5mSWpRbp2yVwZfSsvM9YcNmgomfSRsYGxjfqXYycHBICJhJvuv+zg9hCAjsYJSb+
        ZoeIS0qc2PmcEcIWlrjfcoQVouYbo8T5ZxogNpuApsTTm1OZuhi5OEQE3jNJzJq9HayZWUBd
        YteEE0wgtrCAu0TzhSNsXYwcHCwCqhJznrqAhHkFXCUe9x9jgpgvJ3HzXCfzBEaeBYwMqxgl
        UwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgsNUS2sH455VH/QOMTJxMB5ilOBgVhLhFc5y
        SxHiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qByXHzzOP9
        lTE9Mkb/lR5W9wgW2huvUf1qfnfCY96/1zvrchgj+2vPzePW0pupmSop97Rtrsu17/JvE7o9
        /n53fn1893vBh5/+7/u345lxgX2NoJPxqpTQPUu8Hndof5ZQ/bBTo/HL58vXPkmmSMzsTY67
        ZLx4a/TTA9a3r+pobpJzSz7WsbBCUdR8E7uibZX9uejYFK3svIf538RYxCULq89uVPA8o3By
        +SMpV01R9zrBjMmXhJh/X82+VunClSPV61cewHT7joLD0o/1EfLOfktW69ht/TuVJ7eTT71n
        3n22J3vElXXzjG8v5/U9ZPrZ+qNuyJ8tx9e6ucw6Gyz03LU8acHZoztC+ac8nNymxFKckWio
        xVxUnAgA8UylQ8ICAAA=
X-CMS-MailID: 20230425012857epcas2p45eaa3f5f87de424bbf951b22653b3e70
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230425012857epcas2p45eaa3f5f87de424bbf951b22653b3e70
References: <CGME20230425012857epcas2p45eaa3f5f87de424bbf951b22653b3e70@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2
1) remove clearing hba->active_uic_cmd at the end of __ufshcd_poll_uic_pwr
2) change commit message on the cited clause: 5.7.12.11 -> 5.7.12.1.1
3) add mdelay to avoid too many issueing
4) change the timeout for the polling to 100ms because I found it
sometimes takes much longer than expected.

Regarding 5.7.12.1.1 in Unipro v1.8, PA rejects sebsequent
requests following the first request from upper layer or remote.
In this situation, PA responds w/ BUSY in cases
when they come from upper layer and does nothing for
the requests. So HCI doesn't receive ind, a.k.a. indicator
for its requests and an interrupt, IS.UPMS isn't generated.

When LINERESET occurs, the error handler issues PMC which is
recognized as a request for PA. If a host's PA gets or raises
LINERESET, and a request for PMC, this could be a concurrent
situation mentioned above. And I found that situation w/ my
environment.

[  222.929539]I[0:DefaultDispatch:20410] exynos-ufs 13500000.ufs: ufshcd_update_uic_error: uecdl : 0x80000002
[  222.999009]I[0: arch_disk_io_1:20413] exynos-ufs 13500000.ufs: ufshcd_update_uic_error: uecpa : 0x80000010
[  222.999200] [6:  kworker/u16:2:  132] exynos-ufs 13500000.ufs: ufs_pwr_mode_restore_needed : mode = 0x15, pwr_rx = 1, pwr_tx = 1
[  223.002876]I[0: arch_disk_io_3:20422] exynos-ufs 13500000.ufs: ufshcd_update_uic_error: uecpa : 0x80000010
[  223.501050] [4:  kworker/u16:2:  132] exynos-ufs 13500000.ufs: pwr ctrl cmd 0x2 with mode 0x11 completion timeout
[  223.502305] [4:  kworker/u16:2:  132] exynos-ufs 13500000.ufs: ufshcd_change_power_mode: power mode change failed -110
[  223.502312] [4:  kworker/u16:2:  132] exynos-ufs 13500000.ufs: ufshcd_err_handler: Failed to restore power mode, err = -110
[  223.502392] [4:  kworker/u16:2:  132] exynos-ufs 13500000.ufs: ufshcd_is_pwr_mode_restore_needed : mode = 0x11, pwr_rx = 1, pwr_tx = 1

This patch is to poll PMC's result w/o checking its ind until
the result is not busy, i.e. 09h, to avoid the rejection.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 89 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9434328..96ce6af 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -98,6 +98,9 @@
 /* Polling time to wait for fDeviceInit */
 #define FDEVICEINIT_COMPL_TIMEOUT 1500 /* millisecs */
 
+/* Polling time to wait until PA is ready */
+#define UIC_PA_RDY_TIMEOUT	100	/* millisecs */
+
 /* UFSHC 4.0 compliant HC support this mode, refer param_set_mcq_mode() */
 static bool use_mcq_mode = true;
 
@@ -4138,6 +4141,61 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+static int __ufshcd_poll_uic_pwr(struct ufs_hba *hba, struct uic_command *cmd,
+		struct completion *cnf)
+{
+	unsigned long flags;
+	int ret;
+	ktime_t timeout;
+	u32 mode = cmd->argument3;
+
+	timeout = ktime_add_ms(ktime_get(), UIC_PA_RDY_TIMEOUT);
+	do {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->active_uic_cmd = NULL;
+		if (ufshcd_is_link_broken(hba)) {
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			ret = -ENOLINK;
+			goto out;
+		}
+		hba->uic_async_done = cnf;
+		cmd->argument2 = 0;
+		cmd->argument3 = mode;
+		ret = __ufshcd_send_uic_cmd(hba, cmd, true);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		if (ret) {
+			dev_err(hba->dev,
+				"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
+				cmd->command, cmd->argument3, ret);
+			goto out;
+		}
+
+		/* This value is heuristic */
+		if (!wait_for_completion_timeout(&cmd->done,
+		    msecs_to_jiffies(5))) {
+			ret = -ETIMEDOUT;
+			dev_err(hba->dev,
+				"pwr ctrl cmd 0x%x with mode 0x%x timeout\n",
+				cmd->command, cmd->argument3);
+			if (cmd->cmd_active)
+				goto out;
+
+			dev_info(hba->dev, "%s: pwr ctrl cmd has already been completed\n", __func__);
+		}
+
+		/* retry for only busy cases */
+		ret = cmd->argument2 & MASK_UIC_COMMAND_RESULT;
+		if (ret != UIC_CMD_RESULT_BUSY)
+			break;
+
+		dev_info(hba->dev, "%s: PA is busy and can't handle a requeest, %d\n", __func__, ret);
+		mdelay(1);
+
+	} while (ktime_before(ktime_get(), timeout));
+out:
+	return ret;
+}
+
 /**
  * ufshcd_uic_pwr_ctrl - executes UIC commands (which affects the link power
  * state) and waits for it to take effect.
@@ -4160,33 +4218,16 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	unsigned long flags;
 	u8 status;
 	int ret;
-	bool reenable_intr = false;
 
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (ufshcd_is_link_broken(hba)) {
-		ret = -ENOLINK;
-		goto out_unlock;
-	}
-	hba->uic_async_done = &uic_async_done;
-	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
-		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
-		/*
-		 * Make sure UIC command completion interrupt is disabled before
-		 * issuing UIC command.
-		 */
-		wmb();
-		reenable_intr = true;
-	}
-	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ret = __ufshcd_poll_uic_pwr(hba, cmd, &uic_async_done);
 	if (ret) {
-		dev_err(hba->dev,
-			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
-			cmd->command, cmd->argument3, ret);
-		goto out;
+		if (ret == -ENOLINK)
+			goto out_unlock;
+		else
+			goto out;
 	}
 
 	if (!wait_for_completion_timeout(hba->uic_async_done,
@@ -4223,14 +4264,12 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
 	hba->uic_async_done = NULL;
-	if (reenable_intr)
-		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
 		ufshcd_set_link_broken(hba);
 		ufshcd_schedule_eh_work(hba);
 	}
-out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out_unlock:
 	mutex_unlock(&hba->uic_cmd_mutex);
 
 	return ret;
-- 
2.7.4

