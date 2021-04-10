Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEACC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADD66113A
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhDJGsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16884 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbhDJGsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:09 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ40w9zkhnw;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:45 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 7/8] scsi: megaraid: clean up for trailing statements
Date:   Sat, 10 Apr 2021 14:48:06 +0800
Message-ID: <1618037287-460-8-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
References: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Following error is reported by checkpatch.pl:
ERROR: trailing statements should be on next line
+               if (iterator++ == adapno) break;

So fix them.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 30 ++++++++++++++++++++----------
 drivers/scsi/megaraid/megaraid_mm.c   | 24 ++++++++++++++++--------
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d3fcaca..486c01d 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -709,7 +709,8 @@ megaraid_init_mbox(adapter_t *adapter)
 	 * controllers
 	 */
 	raid_dev = kzalloc(sizeof(mraid_device_t), GFP_KERNEL);
-	if (raid_dev == NULL) return -1;
+	if (!raid_dev)
+		return -1;
 
 
 	/*
@@ -2051,7 +2052,8 @@ megaraid_ack_sequence(adapter_t *adapter)
 		 * interrupt line low.
 		 */
 		dword = RDOUTDOOR(raid_dev);
-		if (dword != 0x10001234) break;
+		if (dword != 0x10001234)
+			break;
 
 		handled = 1;
 
@@ -2074,7 +2076,8 @@ megaraid_ack_sequence(adapter_t *adapter)
 
 			// wait for valid command index to post
 			for (j = 0; j < 0xFFFFF; j++) {
-				if (mbox->completed[i] != 0xFF) break;
+				if (mbox->completed[i] != 0xFF)
+					break;
 				rmb();
 			}
 			completed[i]		= mbox->completed[i];
@@ -2182,7 +2185,8 @@ megaraid_mbox_dpc(unsigned long devp)
 	uioc_t			*kioc;
 
 
-	if (!adapter) return;
+	if (!adapter)
+		return;
 
 	raid_dev = ADAP2RAIDDEV(adapter);
 
@@ -2796,7 +2800,8 @@ mbox_post_sync_cmd_fast(adapter_t *adapter, uint8_t raw_mbox[])
 	mbox	= raid_dev->mbox;
 
 	// return immediately if the mailbox is busy
-	if (mbox->busy) return -1;
+	if (mbox->busy)
+		return -1;
 
 	// Copy mailbox data into host structure
 	memcpy((caddr_t)mbox, (caddr_t)raw_mbox, 14);
@@ -2811,7 +2816,8 @@ mbox_post_sync_cmd_fast(adapter_t *adapter, uint8_t raw_mbox[])
 	WRINDOOR(raid_dev, raid_dev->mbox_dma | 0x1);
 
 	for (i = 0; i < MBOX_SYNC_WAIT_CNT; i++) {
-		if (mbox->numstatus != 0xFF) break;
+		if (mbox->numstatus != 0xFF)
+			break;
 		rmb();
 		udelay(MBOX_SYNC_DELAY_200);
 	}
@@ -2848,8 +2854,10 @@ megaraid_busywait_mbox(mraid_device_t *raid_dev)
 			msleep(1);
 	}
 
-	if (i < 1000) return 0;
-	else return -1;
+	if (i < 1000)
+		return 0;
+	else
+		return -1;
 }
 
 
@@ -3137,7 +3145,8 @@ megaraid_mbox_get_max_sg(adapter_t *adapter)
 		nsg =  MBOX_DEFAULT_SG_SIZE;
 	}
 
-	if (nsg > MBOX_MAX_SG_SIZE) nsg = MBOX_MAX_SG_SIZE;
+	if (nsg > MBOX_MAX_SG_SIZE)
+		nsg = MBOX_MAX_SG_SIZE;
 
 	return nsg;
 }
@@ -3317,7 +3326,8 @@ megaraid_mbox_display_scb(adapter_t *adapter, scb_t *scb)
 		mbox->numsectors, mbox->lba, mbox->xferaddr, mbox->logdrv,
 		mbox->numsge));
 
-	if (!scp) return;
+	if (!scp)
+		return;
 
 	con_log(level, (KERN_NOTICE "scsi cmnd: "));
 
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 1d6244e..5e889cb 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -88,7 +88,8 @@ mraid_mm_open(struct inode *inode, struct file *filep)
 	/*
 	 * Only allow superuser to access private ioctl interface
 	 */
-	if (!capable(CAP_SYS_ADMIN)) return (-EACCES);
+	if (!capable(CAP_SYS_ADMIN))
+		return (-EACCES);
 
 	return 0;
 }
@@ -256,7 +257,8 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 	iterator = 0;
 
 	list_for_each_entry(adapter, &adapters_list_g, list) {
-		if (iterator++ == adapno) break;
+		if (iterator++ == adapno)
+			break;
 	}
 
 	if (!adapter) {
@@ -408,8 +410,10 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 		if (mraid_mm_attach_buf(adp, kioc, kioc->xferlen))
 			return (-ENOMEM);
 
-		if (mimd.outlen) kioc->data_dir  = UIOC_RD;
-		if (mimd.inlen) kioc->data_dir |= UIOC_WR;
+		if (mimd.outlen)
+			kioc->data_dir  = UIOC_RD;
+		if (mimd.inlen)
+			kioc->data_dir |= UIOC_WR;
 
 		break;
 
@@ -424,8 +428,10 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 		if (mraid_mm_attach_buf(adp, kioc, kioc->xferlen))
 			return (-ENOMEM);
 
-		if (mimd.outlen) kioc->data_dir  = UIOC_RD;
-		if (mimd.inlen) kioc->data_dir |= UIOC_WR;
+		if (mimd.outlen)
+			kioc->data_dir  = UIOC_RD;
+		if (mimd.inlen)
+			kioc->data_dir |= UIOC_WR;
 
 		break;
 
@@ -677,7 +683,8 @@ lld_ioctl(mraid_mmadp_t *adp, uioc_t *kioc)
 	kioc->status	= -ENODATA;
 	rval		= adp->issue_uioc(adp->drvr_data, kioc, IOCTL_ISSUE);
 
-	if (rval) return rval;
+	if (rval)
+		return rval;
 
 	/*
 	 * Start the timer
@@ -750,7 +757,8 @@ ioctl_done(uioc_t *kioc)
 					"ioctl that was timedout before\n"));
 
 		list_for_each_entry(adapter, &adapters_list_g, list) {
-			if (iterator++ == adapno) break;
+			if (iterator++ == adapno)
+				break;
 		}
 
 		kioc->timedout = 0;
-- 
2.7.4

