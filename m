Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93E1C43462
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C946115A
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhDJGs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16890 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbhDJGsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ6Fl2zkhsT;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:44 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 2/8] scsi: megaraid_sas: use parentheses to enclose macros with complex values
Date:   Sat, 10 Apr 2021 14:48:01 +0800
Message-ID: <1618037287-460-3-git-send-email-luojiaxing@huawei.com>
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

checkpatch.pl report several error below:

ERROR: Macros with complex values should be enclosed in parentheses
+#define SCP2LUN(scp)                   (u32)(scp)->device->lun // to LUN

ERROR: Macros with complex values should be enclosed in parentheses
+#define SCP2ADAPTER(scp)       (adapter_t *)SCSIHOST2ADAP(SCP2HOST(scp))

So fix those by enclosed by parentheses.

Signed-off-by: Jianqin Xie <xiejianqin@hisilicon.com>
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/mbox_defs.h    |  2 +-
 drivers/scsi/megaraid/mega_common.h  | 16 ++++++++--------
 drivers/scsi/megaraid/megaraid_sas.h |  6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/megaraid/mbox_defs.h b/drivers/scsi/megaraid/mbox_defs.h
index 5001624..3efbfdb 100644
--- a/drivers/scsi/megaraid/mbox_defs.h
+++ b/drivers/scsi/megaraid/mbox_defs.h
@@ -124,7 +124,7 @@
 #define FC_MAX_PHYSICAL_DEVICES		256
 #define MAX_MBOX_CHANNELS		5
 #define MAX_MBOX_TARGET			15
-#define MBOX_MAX_PHYSICAL_DRIVES	MAX_MBOX_CHANNELS*MAX_MBOX_TARGET
+#define MBOX_MAX_PHYSICAL_DRIVES	(MAX_MBOX_CHANNELS * MAX_MBOX_TARGET)
 #define MAX_ROW_SIZE_40LD		32
 #define MAX_ROW_SIZE_8LD		8
 #define SPAN_DEPTH_8_SPANS		8
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 2ad0aa2..2a0981b 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -196,22 +196,22 @@ typedef struct {
 
 
 // conversion from scsi command
-#define SCP2HOST(scp)			(scp)->device->host	// to host
-#define SCP2HOSTDATA(scp)		SCP2HOST(scp)->hostdata	// to soft state
-#define SCP2CHANNEL(scp)		(scp)->device->channel	// to channel
-#define SCP2TARGET(scp)			(scp)->device->id	// to target
-#define SCP2LUN(scp)			(u32)(scp)->device->lun	// to LUN
+#define SCP2HOST(scp)			((scp)->device->host)	// to host
+#define SCP2HOSTDATA(scp)		(SCP2HOST(scp)->hostdata)	// to soft state
+#define SCP2CHANNEL(scp)		((scp)->device->channel)	// to channel
+#define SCP2TARGET(scp)			((scp)->device->id)	// to target
+#define SCP2LUN(scp)			((u32)(scp)->device->lun)	// to LUN
 
 // generic macro to convert scsi command and host to controller's soft state
 #define SCSIHOST2ADAP(host)	(((caddr_t *)(host->hostdata))[0])
-#define SCP2ADAPTER(scp)	(adapter_t *)SCSIHOST2ADAP(SCP2HOST(scp))
+#define SCP2ADAPTER(scp)	((adapter_t *)SCSIHOST2ADAP(SCP2HOST(scp)))
 
 
 #define MRAID_IS_LOGICAL(adp, scp)	\
-	(SCP2CHANNEL(scp) == (adp)->max_channel) ? 1 : 0
+	((SCP2CHANNEL(scp) == (adp)->max_channel) ? 1 : 0)
 
 #define MRAID_IS_LOGICAL_SDEV(adp, sdev)	\
-	(sdev->channel == (adp)->max_channel) ? 1 : 0
+	((sdev->channel == (adp)->max_channel) ? 1 : 0)
 
 /**
  * MRAID_GET_DEVICE_MAP - device ids
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index b5a765b..b652a84 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -154,9 +154,9 @@
 #define MFI_INIT_CLEAR_HANDSHAKE		0x00000008
 #define MFI_INIT_HOTPLUG			0x00000010
 #define MFI_STOP_ADP				0x00000020
-#define MFI_RESET_FLAGS				MFI_INIT_READY| \
-						MFI_INIT_MFIMODE| \
-						MFI_INIT_ABORT
+#define MFI_RESET_FLAGS				(MFI_INIT_READY | \
+						MFI_INIT_MFIMODE | \
+						MFI_INIT_ABORT)
 #define MFI_ADP_TRIGGER_SNAP_DUMP		0x00000100
 #define MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE    (0x01)
 
-- 
2.7.4

