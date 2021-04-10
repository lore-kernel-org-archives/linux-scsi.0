Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534CAC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1741B610E5
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhDJGsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16883 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbhDJGsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:09 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ5KSGzkhsB;
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
Subject: [PATCH v1 5/8] scsi: megaraid: clean up for "foo * bar"
Date:   Sat, 10 Apr 2021 14:48:04 +0800
Message-ID: <1618037287-460-6-git-send-email-luojiaxing@huawei.com>
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

"foo * bar" should be "foo *bar"
+                     struct megasas_iocpacket __user * user_ioc,

The format of the pointer variable must be "foo *bar", so fix
them.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/megaraid_ioctl.h    | 4 ++--
 drivers/scsi/megaraid/megaraid_mbox.h     | 2 +-
 drivers/scsi/megaraid/megaraid_mm.c       | 4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_ioctl.h b/drivers/scsi/megaraid/megaraid_ioctl.h
index 87b880fe..9bc0250 100644
--- a/drivers/scsi/megaraid/megaraid_ioctl.h
+++ b/drivers/scsi/megaraid/megaraid_ioctl.h
@@ -126,7 +126,7 @@ typedef struct uioc {
 	uint8_t			reserved[128];
 
 /* Driver Data: */
-	void __user *		user_data;
+	void __user		*user_data;
 	uint32_t		user_data_len;
 
 	/* 64bit alignment */
@@ -138,7 +138,7 @@ typedef struct uioc {
 	dma_addr_t		pthru32_h;
 
 	struct list_head	list;
-	void			(*done)(struct uioc*);
+	void			(*done)(struct uioc *);
 
 	caddr_t			buf_vaddr;
 	dma_addr_t		buf_paddr;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.h b/drivers/scsi/megaraid/megaraid_mbox.h
index d2fe7f6..3c16d38 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.h
+++ b/drivers/scsi/megaraid/megaraid_mbox.h
@@ -189,7 +189,7 @@ typedef struct {
 	dma_addr_t			mbox_dma;
 	spinlock_t			mailbox_lock;
 	unsigned long			baseport;
-	void __iomem *			baseaddr;
+	void __iomem			*baseaddr;
 	struct mraid_pci_blk		mbox_pool[MBOX_MAX_SCSI_CMDS];
 	struct dma_pool			*mbox_pool_handle;
 	struct mraid_pci_blk		epthru_pool[MBOX_MAX_SCSI_CMDS];
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 864cbb6..234885c 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -582,7 +582,7 @@ static uioc_t *
 mraid_mm_alloc_kioc(mraid_mmadp_t *adp)
 {
 	uioc_t			*kioc;
-	struct list_head*	head;
+	struct list_head	*head;
 	unsigned long		flags;
 
 	down(&adp->kioc_semaphore);
@@ -722,7 +722,7 @@ ioctl_done(uioc_t *kioc)
 {
 	uint32_t	adapno;
 	int		iterator;
-	mraid_mmadp_t*	adapter;
+	mraid_mmadp_t	*adapter;
 
 	/*
 	 * When the kioc returns from driver, make sure it still doesn't
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 40c77bb..2b17529 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4402,7 +4402,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	 * Allocate the dynamic array first and then allocate individual
 	 * commands.
 	 */
-	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd*), GFP_KERNEL);
+	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd *), GFP_KERNEL);
 
 	if (!instance->cmd_list) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "out of memory\n");
@@ -8150,7 +8150,7 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
  */
 static int
 megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
-		      struct megasas_iocpacket __user * user_ioc,
+		      struct megasas_iocpacket __user *user_ioc,
 		      struct megasas_iocpacket *ioc)
 {
 	struct megasas_sge64 *kern_sge64 = NULL;
-- 
2.7.4

