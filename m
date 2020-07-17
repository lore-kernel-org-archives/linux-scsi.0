Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641CAC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AD892071A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VLn9U9mK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgGQHrr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:47:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53721 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgGQHrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 03:47:47 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200717074744epoutp02017c2a6e79c7df318fb7f33f5855d12b~ieqRL7KZT3207032070epoutp02U
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2020 07:47:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200717074744epoutp02017c2a6e79c7df318fb7f33f5855d12b~ieqRL7KZT3207032070epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594972064;
        bh=v2r5RN+frqPS0oGGMaeiQL+3uWPipQob8tryDk24ThQ=;
        h=From:To:Subject:Date:References:From;
        b=VLn9U9mKTCYuGFietaHD0RlwYdRsyv3c4XEazGXuw0MAVP76hEiK+ur5guLm3lKLb
         DtkzW3UvVZUfzFI8BhJGOpPNdAFEh16mc7YqaEdxfWc1N7Z7hMzXMmZaMn2tinARh8
         FRu0rJb4CCerAwNZMo2t6sji72xtc8Kh0Pwwd/0k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200717074743epcas2p33365e85920ce6ce71bea6d68067dd9f5~ieqQaqVF_2627626276epcas2p3R;
        Fri, 17 Jul 2020 07:47:43 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B7NWc4NY6zMqYky; Fri, 17 Jul
        2020 07:47:40 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.19.27441.C97511F5; Fri, 17 Jul 2020 16:47:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200717074740epcas2p2b1c8e7bf7dc28f13c5a9999373f4601b~ieqNZNcRP2637826378epcas2p2U;
        Fri, 17 Jul 2020 07:47:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200717074740epsmtrp15003f99494e5f75301ddd196a51f9d98~ieqNYWKY40603306033epsmtrp1Z;
        Fri, 17 Jul 2020 07:47:40 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-d2-5f11579c7ecb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.AE.08303.B97511F5; Fri, 17 Jul 2020 16:47:39 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200717074739epsmtip2bab70465a3748e4ca9d00e5ccca44b18~ieqNMqOEu0895308953epsmtip2L;
        Fri, 17 Jul 2020 07:47:39 +0000 (GMT)
From:   Lee Sang Hyun <sh425.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, kwmad.kim@samsung.com
Subject: [RESEND RFC PATCH v1] scsi: ufs: add retries for SSU
Date:   Fri, 17 Jul 2020 16:39:36 +0900
Message-Id: <1594971576-40264-1-git-send-email-sh425.lee@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsWy7bCmqe6ccMF4g8ubJSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORmvzvYyFdyQqziy4z9zA2OHRBcjJ4eEgInEr1fr2LoYuTiEBHYwSrx79JURwvnEKPFlz0pW
        COczo0T7mxksMC1Xrl1lgUjsYpT48/wMM4Tzg1HiU8cTJpAqNgFtibvXZrGDJEQETjFJvHv5
        E2gwB4ewgK3EseMOIDUsAqoStx6tYAOxeQVcJW7/O8UKsUFO4ua5TrChEgJv2SVmtE6GWu0i
        cfD1HihbWOLV8S3sELaUxMv+Nii7XGJ331U2iOYWRon3azcxQySMJWY9awc7gllAU2L9Ln0Q
        U0JAWeLILbCRzAJ8Eh2H/7JDhHklOtqEIBqVJc68Wws1XVLiYesmJgjbQ2LzvU1AA9mBfo+V
        WCU/gVFmFsL0BYyMqxjFUguKc9NTi40KjJHjZRMjOPlpue9gnPH2g94hRiYOxkOMEhzMSiK8
        818KxAvxpiRWVqUW5ccXleakFh9iNAWG1kRmKdHkfGD6zSuJNzQ1MjMzsDS1MDUzslAS5y22
        uhAnJJCeWJKanZpakFoE08fEwSnVwDSHXaEm6GWO2Q+3dWa/y64cd+Gq2HOOpT/icnn8u8aH
        3NtU1V5+nMQ193v1nQDxkuw96zeqCgnfqLbhrbt1N7eOjfGFk+7y6Z21JdL/2WSWNnmYPWm6
        UJl/6MChOVWlTzbsmb/b9uvsh/El0lcSPVatWagezfPIYob3Zjn2fVuVcvgE/3K7N70+uT9D
        fTrD1P3TbNuMeQ62P1hy6nOdgKrrjMMZGvpPdxz0XWz92aBp5sww9auCvFevctwq1FO+8C8l
        bJ7zCukVb3K07jZcbkie+rzb5HJiwcGOY5WPffizOBuniUyLffquyFfCINH01LNXEyfMedte
        ViS/6k/hgUsZz/+fMnyk/z1+DkNgtJkSS3FGoqEWc1FxIgAZn45oBwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSvO7scMF4gzlPLS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MV2d7mQpuyFUc2fGfuYGxQ6KLkZNDQsBE4sq1qywgtpDADkaJXb/N
        IeKSEhMvNTFC2MIS91uOsHYxcgHVfGOUaPx6G6yBTUBb4u61WewgCRGBO0wSLzv7mbsYOTiE
        BWwljh13AKlhEVCVuPVoBRuIzSvgKnH73ylWiKFyEjfPdTJPYORewMiwilEytaA4Nz232LDA
        KC+1XK84Mbe4NC9dLzk/dxMjOBy1tHYw7ln1Qe8QIxMH4yFGCQ5mJRHe+S8F4oV4UxIrq1KL
        8uOLSnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXAxPBZP4Tv/Zor2UoyHTP+
        btxcmOH48u3u124iC4/MnOx851nYlI6jOb8YlDXsH1T66cRFPDENL1tk9st445zWTMFFN1yv
        9D0+0zfJmGGnbPLumFCXsP/vNDmXKe5+Z5V8uPHnmpCffot0POaIxUkpt+1SM7onWGhtbtOg
        6seUuHvPyx6XbhteFYYDm1QNtD7l7NKNkz23o7pyhfX96ffS/JkiDm134hbg15oRM8eO/yx/
        8b2aEpHcRvXjJ06qH/DnX8xsf+nN8gfCaf+7/01yK3Vcfsii9KTiS455u058iyoSE5kVfcXt
        29Y1fCd/ezQcSllwytrY9IPsjNzlm6r217as9eFxDpqrsWL7+shfSizFGYmGWsxFxYkA9ln2
        G7YCAAA=
X-CMS-MailID: 20200717074740epcas2p2b1c8e7bf7dc28f13c5a9999373f4601b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200717074740epcas2p2b1c8e7bf7dc28f13c5a9999373f4601b
References: <CGME20200717074740epcas2p2b1c8e7bf7dc28f13c5a9999373f4601b@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Retry of SSU is not working because of UNIT_ATTENTION if SSU is failed.
So, more retry is needed.
More than 3 times of SSU(START STOP UNIT) retries are needed
to prevent a platform watchdog which is because of IO stuck.
Host sends SSU to device during resume to wake-up UFS device.
And system(host) can not do IO operations if SSU is failed.

There are no responses from UFS device and
ufshcd_eh_reset_handler() is called in the below log.
We need to do 3 times of retries to clear UNIT ATTENTION
which is because of HW RESET at this situation.

<3>[  636.089575]  [0: kworker/u16:11: 3578] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: tag:0, cmd:0x1b, retries 2
<3>[  636.089898]  [0: kworker/u16:11: 3578] ufshcd-qcom 1d84000.ufshc: ufshcd_eh_host_reset_handler: reset in progress - 2
...
<4>[  638.271463]  [1:    kworker/1:1: 3552] scsi 0:0:0:49488: START_STOP failed for power mode: 1, result 30000
...
<6>[ 1056.481268]  [3:   msm_watchdog:   79]  current proc : 79 msm_watchdog
...
<4>[ 1056.576026]  [3:   msm_watchdog:   79] Call trace:
<4>[ 1056.576138]  [3:   msm_watchdog:   79]  __switch_to+0xb4/0xc0
<4>[ 1056.576267]  [3:   msm_watchdog:   79]  __schedule+0x8d8/0xc70
<4>[ 1056.576404]  [3:   msm_watchdog:   79]  io_schedule+0x8c/0xc0
<4>[ 1056.576530]  [3:   msm_watchdog:   79]  bit_wait_io+0x14/0x60
<4>[ 1056.576658]  [3:   msm_watchdog:   79]  out_of_line_wait_on_bit+0xd8/0x158
<4>[ 1056.576817]  [3:   msm_watchdog:   79]  __wait_on_buffer+0x24/0x30
<4>[ 1056.576962]  [3:   msm_watchdog:   79]  jbd2_journal_commit_transaction+0xf24/0x1970
<4>[ 1056.577134]  [3:   msm_watchdog:   79]  kjournald2+0x1e0/0x258
<4>[ 1056.577264]  [3:   msm_watchdog:   79]  kthread+0x110/0x120
<4>[ 1056.577389]  [3:   msm_watchdog:   79]  ret_from_fork+0x10/0x18
...
<0>[ 1056.784682]  [3:   msm_watchdog:   79] Kernel panic - not syncing: Platform Watchdog can't update sync_cnt
...

Change-Id: I933f774e04456226d760536200e9f079a5d5b987
Signed-off-by: Lee Sang Hyun <sh425.lee@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ad4fc82..30cee8c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -100,6 +100,9 @@
 /* Default value of wait time before gating device ref clock */
 #define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
 
+/* SSU retries */
+#define SSU_RETRIES 3
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -7977,6 +7980,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret;
+	int retries;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
@@ -8016,14 +8020,18 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
-	if (ret) {
-		sdev_printk(KERN_WARNING, sdp,
-			    "START_STOP failed for power mode: %d, result %x\n",
-			    pwr_mode, ret);
-		if (driver_byte(ret) == DRIVER_SENSE)
-			scsi_print_sense_hdr(sdp, NULL, &sshdr);
+	for (retries = 0; retries < SSU_RETRIES; retries++) {
+		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+		if (ret) {
+			sdev_printk(KERN_WARNING, sdp,
+				    "START_STOP failed for power mode: %d, result %x\n",
+				    pwr_mode, ret);
+			if (driver_byte(ret) == DRIVER_SENSE)
+				scsi_print_sense_hdr(sdp, NULL, &sshdr);
+		} else {
+			break;
+		}
 	}
 
 	if (!ret)
-- 
2.7.4

