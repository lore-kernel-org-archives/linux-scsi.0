Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C8CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 03:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7460722D3E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 03:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbhALDAa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:00:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36621 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730986AbhALDA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 22:00:29 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210112025945epoutp01540ee406a2f2570200bc11a8d87fa8c3~ZXM7rWG8y2805528055epoutp01Q
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:59:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210112025945epoutp01540ee406a2f2570200bc11a8d87fa8c3~ZXM7rWG8y2805528055epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610420385;
        bh=oAZkt8d/EzEdD6gm9i+kuwRAAhZpY0ps41OxDiNtdgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=WwS1qfV3Ppo6LNw0M1i3NdpOe0WVmGPRInH91mzyplHYdX6xAKerjh6gNdI3BmSAA
         sDJvL0lsIQyZJCtXO/IB9HKfKjK9erCi+yupQTlnNHXGC+XiFGhqP7U2kVoKD/K9BV
         nwj9OSkzfz98bncEWx/uO8OJYdipqHHdQDUsT1gE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210112025944epcas2p2d2fe8d40e181856dcf3682644a5f33b4~ZXM7HklTc1401914019epcas2p2R;
        Tue, 12 Jan 2021 02:59:44 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DFFfl0XCyz4x9Px; Tue, 12 Jan
        2021 02:59:43 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.30.10621.E901DFF5; Tue, 12 Jan 2021 11:59:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210112025942epcas2p4017cceea0f853461a9feec556cc53d2d~ZXM4nvgKN3061530615epcas2p44;
        Tue, 12 Jan 2021 02:59:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210112025942epsmtrp22a357bcdda9e4a09a5c6fc93c784080c~ZXM4mKmk62420624206epsmtrp27;
        Tue, 12 Jan 2021 02:59:42 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-f0-5ffd109eb435
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.32.08745.E901DFF5; Tue, 12 Jan 2021 11:59:42 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210112025941epsmtip1053b87469450ad5249bf183545e16ed7~ZXM4Xh8Sm1462214622epsmtip1Y;
        Tue, 12 Jan 2021 02:59:41 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v3 2/2] ufs: ufs-exynos: apply vendor specifics for
 three timeouts
Date:   Tue, 12 Jan 2021 11:48:27 +0900
Message-Id: <3a223a4a449f87ff33eebd0a81d9206fbd7770ac.1610419672.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610419672.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1610419672.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmhe48gb/xBj2NthYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZNy+8IG14CZXxbTuRywNjB84uhg5OSQETCR6H8xh7mLk4hAS2MEo0fOtlR3C+cQo
        8fboVkYI5zOjxMTTp1hgWs53vIKq2sUosenhKaiqH4wSN1+8YwWpYhPQlHh6cyoTSEJE4AyT
        xLXWs2AJZgF1iV0TTjCB2MIC0RLXLzxkA7FZBFQlJv84AmbzAsVP3ZoJtU5O4ua5TmYQm1PA
        UuLzql4WVDYXUM1cDomup+/YIRpcJL5P38MGYQtLvDq+BSouJfH53V6oeL3EvqkNrBDNPYwS
        T/f9Y4RIGEvMetYOZHMAXaopsX6XPogpIaAsceQWC8T9fBIdh/+yQ4R5JTrahCAalSV+TZoM
        NURSYubNO1BbPSR+X3vNCgkgoE3PFp1km8AoPwthwQJGxlWMYqkFxbnpqcVGBYbI8beJEZxW
        tVx3ME5++0HvECMTB+MhRgkOZiURXq8Nf+KFeFMSK6tSi/Lji0pzUosPMZoCA3Iis5Rocj4w
        seeVxBuaGpmZGViaWpiaGVkoifMWGzyIFxJITyxJzU5NLUgtgulj4uCUamA6+eFbkkWGWX7Q
        q57/D3UNz1/7JiGhM2NysPPtLZfrDkTePc+4cnmsEuseu08XLpa9X/tj25civ6mT7RcUTRRq
        N9oy99om1bqcKzOYnp0ynZmzS8JQOv/X6/jz3ktzVHdbJVe79NTlG+1qYt6zdO1N+wzHZxpf
        d2ZbLItU75/u+vaqfmCQtvgppu9zyioM5Tn9Vz4S1w69ZvXS+mBel+3eZRWVXS2LhA7pV0w/
        3L0n7ez7qd7XTx/cfLne8nXXvPlFEdohZlmu/GcEC6srrjyaunqPRWRvnM2BozFcxleOPTis
        ImLL9pGx/H+iTwz3JNdIho/c7tnWEQs/XlLt0y9zdW26/3Yz/3Xb2lY/Mz0lluKMREMt5qLi
        RABiexxlNAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnO48gb/xBu8PsVs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4Mq4feEDa8FNropp3Y9YGhg/cHQxcnJICJhInO94xd7FyMUh
        JLCDUWLhsm0sEAlJiRM7nzNC2MIS91uOsEIUfWOUeHvgNytIgk1AU+LpzalMIAkRgXtMEpcm
        zGUGSTALqEvsmnCCCcQWFoiUuNnwH2wSi4CqxOQfR9hAbF6BaIlTt2ZCbZOTuHmuE6yXU8BS
        4vOqXrC4kICFxLLm/Yy4xCcwCixgZFjFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc
        FVpaOxj3rPqgd4iRiYPxEKMEB7OSCK/Xhj/xQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2M
        FxJITyxJzU5NLUgtgskycXBKNTC5+M/Rk1z93d2+bNedxKiZjCs2J19tF5Y4tsw6eu//C8zT
        j1gkqRrJyEV9uL1hXbaXsR934Tkxi+7ps/6k+cz4Z+l8KKqpYDGn7BqPXhP+hANP7vJySe8s
        YNwQ0LtAsDai/sS3xr8HKwrOGFfyTJ+78h2XroSAwMTJ3Wl/dp4udfGV/f1Z5sOuPYreh08/
        SHh44MnkDU7xfnknBZSmnsp5vkRTTJBXPY53r9MlpgPed1z33TE85nVKKHOP8VyrzJtCk9wW
        PZ5T1n+vwXtDyu9rv9fuU30soSd2Mi1e+ttvh7rHcp05zTetq1/WfNeoW3gyz+DRutU7CjpX
        1HsYLth11eikk3mKQEVQz6f5EWeVWIozEg21mIuKEwGE4mj5+QIAAA==
X-CMS-MailID: 20210112025942epcas2p4017cceea0f853461a9feec556cc53d2d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210112025942epcas2p4017cceea0f853461a9feec556cc53d2d
References: <cover.1610419672.git.kwmad.kim@samsung.com>
        <CGME20210112025942epcas2p4017cceea0f853461a9feec556cc53d2d@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set optimized values for those timeouts
- FC0_PROTECTION_TIMER
- TC0_REPLAY_TIMER
- AFC0_REQUEST_TIMER

Exynos doesn't yet use traffic class #1.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..5ca21d1 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -640,6 +640,11 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 		}
 	}
 
+	/* setting for three timeout values for traffic class #0 */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+
 	return 0;
 out:
 	return ret;
@@ -1236,7 +1241,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
-				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.7.4

