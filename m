Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75085C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 06:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4725120663
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 06:30:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pcsHBEMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgGIGaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 02:30:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55716 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgGIGa3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 02:30:29 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200709063026epoutp042a0b3645fe2cfef6bac61b1da889149a~gAcfuaShc3066530665epoutp04W
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 06:30:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200709063026epoutp042a0b3645fe2cfef6bac61b1da889149a~gAcfuaShc3066530665epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594276226;
        bh=v2r5RN+frqPS0oGGMaeiQL+3uWPipQob8tryDk24ThQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=pcsHBEMBwZTMxnubDtBjhTsFyHwLpShUNvTZyy8ZjXs43p0eGeiAkCHHrZQkzMQbp
         WsU2XTFjkwhKr8N9m6eEHwJWmjU/mMj3lRLkrI4L6FYpbDdcy0yHhwll5uRg+ixStM
         MsX6KZaB+DDKlreAwAP3VtuhclX9kn9oDhkEBeEw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200709063025epcas2p1e932eeb082b9d8a226d62d666b0596ff~gAce_H-MC0854808548epcas2p1E;
        Thu,  9 Jul 2020 06:30:25 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B2RB64PWjzMqYkw; Thu,  9 Jul
        2020 06:30:22 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.4E.18874.E79B60F5; Thu,  9 Jul 2020 15:30:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200709063022epcas2p449c161e2de6f355d62b24b4acf78656c~gAcb1qWus2187921879epcas2p4F;
        Thu,  9 Jul 2020 06:30:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200709063022epsmtrp29f27496757621811968e20d933f57959~gAcb0vQaU0181901819epsmtrp2V;
        Thu,  9 Jul 2020 06:30:22 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-73-5f06b97eac86
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.0D.08303.D79B60F5; Thu,  9 Jul 2020 15:30:22 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200709063021epsmtip16c9816d41395d7029823987edc1fde9c~gAcboiya00947209472epsmtip1z;
        Thu,  9 Jul 2020 06:30:21 +0000 (GMT)
From:   Lee Sang Hyun <sh425.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        kwmad.kim@samsung.com
Cc:     Lee Sang Hyun <sh425.lee@samsung.com>
Subject: [RFC PATCH v1] scsi: ufs: add retries for SSU
Date:   Thu,  9 Jul 2020 15:22:29 +0900
Message-Id: <1594275749-20357-1-git-send-email-sh425.lee@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTTLduJ1u8wdptchYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIxXZ3uZCm7IVRzZ8Z+5gbFDoouRk0NCwETizPqnTF2MXBxCAjsYJc6fPsgC4XxilGjoXcYG
        4XxmlDgw/yQTTMuaNfOgErsYJR7M/sIO4fxglDjVuZsFpIpNQFvi7rVZYAkRgc1MEmvmLGUF
        STALaEpM+XWAGcQWFjCT+NbzGcxmEVCV6FzxHayZV8BVomPZIXaIdXISN891MoMMkhD4yS7x
        bPNmNoiEi8TWZZcZIWxhiVfHt0A1SEl8frcXqqZcYnffVTaI5hZGifdrNzFDJIwlZj1rB2rm
        ALto/S59EFNCQFniyC0WiDv5JDoO/2WHCPNKdLQJQTQqS5x5txZqk6TEw9ZN0FDxkFiy/RRY
        q5BArMTcEz+ZJzDKzkKYv4CRcRWjWGpBcW56arFRgRFyNG1iBKdGLbcdjFPeftA7xMjEwXiI
        UYKDWUmE10CRNV6INyWxsiq1KD++qDQntfgQoykwvCYyS4km5wOTc15JvKGpkZmZgaWphamZ
        kYWSOG+94oU4IYH0xJLU7NTUgtQimD4mDk6pBqbLVzqM5dZGz2oMsqhtW3nU2HP7+2WVont2
        OylPOHBxWvTN1lqdwF2GVZzTL/d6bTmi1n1xF0tolzbbRQ+Fn7ver8mO0un46xt/r9CLx8Jq
        qf78ursnDfqU93xprr1w6l+4mFTq18nNunv+cb4yqNtxKPXF+kuup/x80jp+qF+TKJjArKwR
        vplffIVbO9u8mkchEYEsLTe0bqxIk28S/c1yecGlrl/zhKzXqtW0NbU3xR56qmh1p3XK/RqX
        BT6T+ZkeHrYu1M44s8QuytqpT19o7/KVBzfPlo7QC9fZU67vuYeHT23l7q9b4lSmC/TsiPEy
        XCXEl+f6fvLTWDPZnQdmP118ebHlanlfS5lbmkosxRmJhlrMRcWJAFQd/JcWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnG7dTrZ4g8nTGC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MV2d7mQpuyFUc2fGfuYGxQ6KLkZNDQsBEYs2aeWxdjFwcQgI7GCXu
        rF7KCJGQlJh4qQnKFpa433KEFcQWEvjGKPHqnA+IzSagLXH32ix2kGYRgcNMEou77rCDJJgF
        NCWm/DrADGILC5hJfOv5DGazCKhKdK74zgJi8wq4SnQsO8QOsUBO4ua5TuYJjDwLGBlWMUqm
        FhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEB6qW1g7GPas+6B1iZOJgPMQowcGsJMJroMga
        L8SbklhZlVqUH19UmpNafIhRmoNFSZz366yFcUIC6YklqdmpqQWpRTBZJg5OqQamILMFPplz
        6tOObmKeOq8nQ6P1hKjo3Zt9d3b6FTf9vZAz4R2zlT2vmOpN1p2N28+v+9jvd3KG+artimXv
        nl/yY/p9ZkJeRofrA15hR3Vd3Zn+T1hF1py5/jByzybJ/Tc6+LvumkzVLCp97L399/qQ4jXr
        suwl316RX7s3YPKkdOOcyuLGsKn2DA5V81yjXRyn9a1OEqoQ1E03Tt7pcZPx1Uz7HbtdcxY9
        WK8tu6VyjuA1TqUVhZYNTl18F7Z1XvS/WXdGcN9OVaHe+PfWFyS9HJeb72Na/yZuUcUlxaxl
        Yv9Xl2yU/7f5ym1Wlw32b6pKT7VdeDFHo3wlK5tC+52noYbs8WKdVcfDOVO7/eYosRRnJBpq
        MRcVJwIABtA/f8MCAAA=
X-CMS-MailID: 20200709063022epcas2p449c161e2de6f355d62b24b4acf78656c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200709063022epcas2p449c161e2de6f355d62b24b4acf78656c
References: <CGME20200709063022epcas2p449c161e2de6f355d62b24b4acf78656c@epcas2p4.samsung.com>
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

