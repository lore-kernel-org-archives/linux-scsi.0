Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE262C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 09:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243313AbjD0Joc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 05:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243281AbjD0Job (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 05:44:31 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09C24C22
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 02:44:24 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230427094421epoutp0321c4602b687e0b5a6fdb5853ae627b9f~ZwXkfqQDz1287012870epoutp03Z
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 09:44:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230427094421epoutp0321c4602b687e0b5a6fdb5853ae627b9f~ZwXkfqQDz1287012870epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682588661;
        bh=SZ9PcpiyR4kU5oxIFoQ0FGmeCh45hLAdNw7KJrcRuLA=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=fK0nnvosGAcF5Fsjv83K9twoFub+Z4gHYwKYUvMzudvkLPMmH9/O5SLm99iMtdwQF
         Jj3dVYLZdWdGhpY3o55qaJChkdrHXFeCgXMj9JYySzjuSiozZUZCp75vKM7rIkIHJb
         lZhuqtpGpWyaJ0a3hTZ6owPUlkkf3nEwpC3SP6ac=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230427094421epcas2p15d7f80bad5f97817c449acbf2d0ca8de~ZwXkBGz4A1604816048epcas2p1L;
        Thu, 27 Apr 2023 09:44:21 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.92]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Q6W6D2RZvz4x9Py; Thu, 27 Apr
        2023 09:44:20 +0000 (GMT)
X-AuditID: b6c32a48-475ff70000005998-2d-644a43f48d32
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.59.22936.4F34A446; Thu, 27 Apr 2023 18:44:20 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Change the module parameter macro of
 use_mcq_mode
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "mani@kernel.org" <mani@kernel.org>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230427094420epcms2p1043333a3e0c0cf58e66164e0b83b3b02@epcms2p1>
Date:   Thu, 27 Apr 2023 18:44:20 +0900
X-CMS-MailID: 20230427094420epcms2p1043333a3e0c0cf58e66164e0b83b3b02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJsWRmVeSWpSXmKPExsWy7bCmhe4XZ68Ug1Uf+SwezNvGZvHy51U2
        i4MPO1kspn34yWzx8pCmxaPbzxgtFt3YxmRxedccNovu6zvYLA58WMVosfz4PyaLhR1zWSyW
        br3J6MDrcfmKt8emVZ1sHhMWHWD0aDm5n8Xj+/oONo+PT2+xeEzcU+fRt2UVo8fnTXIe7Qe6
        mQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BO
        V1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBfoFSfmFpfmpevlpZZYGRoYGJkC
        FSZkZ/TsvsBWsJqn4vK+NpYGxiVcXYycHBICJhITZ25i6WLk4hAS2MEose/eNCCHg4NXQFDi
        7w5hkBphgVCJmTs2M4LYQgJKEl0LtzJDxA0k1k3fA2azCehJTPl9hxFkjojARhaJfzcOskIs
        4JWY0f6UBcKWlti+fCsjhK0h8WNZLzOELSpxc/Vbdhj7/bH5UDUiEq33zkLVCEo8+LkbKi4p
        0XpmKxuEXS/R+v4UO8hiCYEJjBKNx/5ADdKXuNaxEeoZX4kLrXogYRYBVYmli75B3eMisWvp
        EiYQm1lAXmL72znMIOXMApoS63fpg5gSAsoSR26xQFTwSXQc/ssO81XDxt9Y2TvmPWGCsNUk
        Hi3YAg0FGYmLc85BfeIh0d3UyzyBUXEWIqBnIblhFsINCxiZVzGKpRYU56anFhsVmMDjNjk/
        dxMjOBFreexgnP32g94hRiYOxkOMEhzMSiK8vJXuKUK8KYmVValF+fFFpTmpxYcYTYG+n8gs
        JZqcD8wFeSXxhiaWBiZmZobmRqYG5krivB87lFOEBNITS1KzU1MLUotg+pg4OKUamOSLjB+x
        FJ1eNT1Pcd9stQfH73ZGe507deWiRlXYfub10Q8db2dUP3S4dNbumFX/KYOjkluFN9XncHps
        OmpzNeX2m8CWdcnpwnktbhw/Dy1w3PTplITs8gvWe09+eFMW4v5yUuvdZJaSHa6Hi8SkTi8R
        TcpcNsOhXFz0ymdGjiABqYjH0RldOS15H/sWSFxwWljZd4CzpNyXr9xs3+SZafpbXT4ZmCjz
        rHNQXaB/bc+aU3c+M/3p1LJuqiz/zGcWt9x9YYTbUs2VffmGccuPrN8hpBbPWdkU7f3p9MNX
        Fr6ya7ecvb/05aTXk99bB9i9FBQTWuOparTiuLWyVZI3q2ifU8uqmDNPjz4S+eO5WomlOCPR
        UIu5qDgRAB8OTmNNBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230427094420epcms2p1043333a3e0c0cf58e66164e0b83b3b02
References: <CGME20230427094420epcms2p1043333a3e0c0cf58e66164e0b83b3b02@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mcq_mode_ops uses only param_{set,get}_bool(). Therefore, convert
module_param_cb() to module_param() and remove the mcq_mode_ops.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9434328ba323..4ae92e8883b3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -98,7 +98,7 @@
 /* Polling time to wait for fDeviceInit */
 #define FDEVICEINIT_COMPL_TIMEOUT 1500 /* millisecs */
 
-/* UFSHC 4.0 compliant HC support this mode, refer param_set_mcq_mode() */
+/* UFSHC 4.0 compliant HC support this mode. */
 static bool use_mcq_mode = true;
 
 static bool is_mcq_supported(struct ufs_hba *hba)
@@ -106,23 +106,7 @@ static bool is_mcq_supported(struct ufs_hba *hba)
 	return hba->mcq_sup && use_mcq_mode;
 }
 
-static int param_set_mcq_mode(const char *val, const struct kernel_param *kp)
-{
-	int ret;
-
-	ret = param_set_bool(val, kp);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static const struct kernel_param_ops mcq_mode_ops = {
-	.set = param_set_mcq_mode,
-	.get = param_get_bool,
-};
-
-module_param_cb(use_mcq_mode, &mcq_mode_ops, &use_mcq_mode, 0644);
+module_param(use_mcq_mode, bool, 0644);
 MODULE_PARM_DESC(use_mcq_mode, "Control MCQ mode for controllers starting from UFSHCI 4.0. 1 - enable MCQ, 0 - disable MCQ. MCQ is enabled by default");
 
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
-- 
2.17.1

