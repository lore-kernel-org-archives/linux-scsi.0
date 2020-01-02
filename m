Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3345C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9F322072C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgABPE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 10:04:58 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:60419 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbgABPE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 10:04:58 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfYgC-1jOap53wS0-00fykl; Thu, 02 Jan 2020 16:03:36 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        John Garry <john.garry@huawei.com>,
        Brian King <brking@us.ibm.com>,
        Intel SCU Linux support <intel-linux-scu@intel.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        zhengbin <zhengbin13@huawei.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <bgrove@attotech.com>,
        Ming Lei <ming.lei@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Richard Fontana <rfontana@redhat.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        peter chang <dpf@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Saurav Girepunje <saurav.girepunje@gmail.com>,
        Vikram Auradkar <auradkar@google.com>,
        Denis Efremov <efremov@linux.com>, Jiri Slaby <jslaby@suse.cz>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v3 17/22] compat_ioctl: scsi: handle HDIO commands from drivers
Date:   Thu,  2 Jan 2020 15:55:35 +0100
Message-Id: <20200102145552.1853992-18-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20200102145552.1853992-1-arnd@arndb.de>
References: <20200102145552.1853992-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:em1wWyRE/wRIZrTiJ9/rnuBjFpeAztfbhyJDPp+3XtIg+XgBc+3
 APBCDum0e0xHmDyO6SOJG8c/m8HxTWbZHz79sdQp9UtoN1QisJLvNXVD4KsNiZSbcU4y8ww
 NNZYlaPFj7atoo1KHIrT0yMRBv4OySaB3AddPM3m3nu6lXBIR2KlbZjEdUwN4buiMn35dow
 /+G7Cbrkeaj1wa2kZz2DA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:iY6OqM8KHtc=:qnZ0ggQTqr83IgrTxCpzQs
 lm+D91PC0Nv6VGxw1LN4N1iVTBKqBRTL0S7MRvNtXKDjdzbJvV9o01Uq7cySxK86N99p6BQrp
 9PShqiD4iSub6MiJDRFLbpMMwJz5K2x+ReWM4O2dDe/nao1pG8IcYxmJt73uSo039PJ9EUtiA
 dJipMBc2x320mGDkdEFjc3pdIj79CkS5ULPCjvbyXumFoYau9G8MvpQHQzwem/COhHB5arWWz
 gKaHtQJGKePJphRNoqdUSITRutzSiqAacmOnRuytgwBaNwFwydNu0PFh8uP3QpTgt2JKWNJan
 nxmFMxCRe12PUm+FHKMgoBMM/Hu6R+dCIRKGO1SuC6rEBw5hw1YxWjgDrLqHqXvghyKKIqcNM
 chLW/0Qp+MCWmhsY1+KSiuEadORkGxUXcsgAbz2ttY15QEtJcvc06hu2EZKcL1vj855Lf5KaU
 XE3SPNlWocl8SV61BSe/yuMcqCzwFJuHCa8hMGYms9RKvqkGtzPhc6UIC1yZICDLWzHwXGr58
 ZV4mKZOza8RhO8iLIxGg4VO8dDitCCrgw+yB3dZmShSNVmXNx4RG+KboK7C1dMYppcitsFAOz
 pBqRalYDYXwUTVYdnLUiSKyxpUwYDV2CLh26b+IhoscimG/10pUqhMZFT+5Qeb0s7K/18VZ5m
 1vvIYo61kUZdiFfmCpAORPSO348xJjEuSE7x6datFh1gUFIgYOUW/0jZk1/kuNmY36CbFqK54
 vZBFMHehcpuqaGILsyCzJ5PwLbuYrzz4UnIGFK0MufvfBjFx1GPM1qVZsUN6MWxI3QjJnOhjL
 u+B4dPaRCyvqmFMEQlPNtvC9iUGd1nS1SNRmxX21y6ApKBZteeBT7yKEFJrkF6Pi8hnopWSXR
 K/SA20cxfj0T+yNrUIBA==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ata_sas_scsi_ioctl() function implements a number of HDIO_* commands
for SCSI devices, it is used by all libata drivers as well as a few
drivers that support SAS attached SATA drives.

The only command that is not safe for compat ioctls here is
HDIO_GET_32BIT. Change the implementation to check for in_compat_syscall()
in order to do both cases correctly, and change all callers to use it
as both native and compat callback pointers, including the indirect
callers through sas_ioctl and ata_scsi_ioctl.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ata/libata-scsi.c              | 9 +++++++++
 drivers/scsi/aic94xx/aic94xx_init.c    | 3 +++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 3 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 3 +++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +++
 drivers/scsi/ipr.c                     | 3 +++
 drivers/scsi/isci/init.c               | 3 +++
 drivers/scsi/mvsas/mv_init.c           | 3 +++
 drivers/scsi/pm8001/pm8001_init.c      | 3 +++
 include/linux/libata.h                 | 6 ++++++
 10 files changed, 39 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 58e09ffe8b9c..eb2eb599e602 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -17,6 +17,7 @@
  *  - http://www.t13.org/
  */
 
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
@@ -761,6 +762,10 @@ static int ata_ioc32(struct ata_port *ap)
 	return 0;
 }
 
+/*
+ * This handles both native and compat commands, so anything added
+ * here must have a compatible argument, or check in_compat_syscall()
+ */
 int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
 		     unsigned int cmd, void __user *arg)
 {
@@ -773,6 +778,10 @@ int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
 		spin_lock_irqsave(ap->lock, flags);
 		val = ata_ioc32(ap);
 		spin_unlock_irqrestore(ap->lock, flags);
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			return put_user(val, (compat_ulong_t __user *)arg);
+#endif
 		return put_user(val, (unsigned long __user *)arg);
 
 	case HDIO_SET_32BIT:
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index f5781e31f57c..d022407e5645 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -54,6 +54,9 @@ static struct scsi_host_template aic94xx_sht = {
 	.eh_target_reset_handler	= sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sas_ioctl,
+#endif
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3af53cc42bd6..fa25766502a2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1772,6 +1772,9 @@ static struct scsi_host_template sht_v1_hw = {
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sas_ioctl,
+#endif
 	.shost_attrs		= host_attrs_v1_hw,
 	.host_reset             = hisi_sas_host_reset,
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 61b1e2693b08..545eaff5f3ee 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3551,6 +3551,9 @@ static struct scsi_host_template sht_v2_hw = {
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sas_ioctl,
+#endif
 	.shost_attrs		= host_attrs_v2_hw,
 	.host_reset		= hisi_sas_host_reset,
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bf5d5f138437..fa05e612d85a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3075,6 +3075,9 @@ static struct scsi_host_template sht_v3_hw = {
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sas_ioctl,
+#endif
 	.shost_attrs		= host_attrs_v3_hw,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 	.host_reset             = hisi_sas_host_reset,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 079c04bc448a..ae45cbe98ae2 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6727,6 +6727,9 @@ static struct scsi_host_template driver_template = {
 	.name = "IPR",
 	.info = ipr_ioa_info,
 	.ioctl = ipr_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ipr_ioctl,
+#endif
 	.queuecommand = ipr_queuecommand,
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 1727d0c71b12..b48aac8dfcb8 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -168,6 +168,9 @@ static struct scsi_host_template isci_sht = {
 	.eh_target_reset_handler        = sas_eh_target_reset_handler,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl			= sas_ioctl,
+#endif
 	.shost_attrs			= isci_host_attrs,
 	.track_queue_depth		= 1,
 };
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index da719b0694dc..7af9173c4925 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -47,6 +47,9 @@ static struct scsi_host_template mvs_sht = {
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sas_ioctl,
+#endif
 	.shost_attrs		= mvst_host_attrs,
 	.track_queue_depth	= 1,
 };
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index ff618ad80ebd..3c6076e4c6d2 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -101,6 +101,9 @@ static struct scsi_host_template pm8001_sht = {
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sas_ioctl,
+#endif
 	.shost_attrs		= pm8001_host_attrs,
 	.track_queue_depth	= 1,
 };
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2dbde119721d..a36bdcb8d9e9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1109,6 +1109,11 @@ extern void ata_host_init(struct ata_host *, struct device *, struct ata_port_op
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 			  void __user *arg);
+#ifdef CONFIG_COMPAT
+#define ATA_SCSI_COMPAT_IOCTL .compat_ioctl = ata_scsi_ioctl,
+#else
+#define ATA_SCSI_COMPAT_IOCTL /* empty */
+#endif
 extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
 			    unsigned int cmd, void __user *arg);
@@ -1341,6 +1346,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.module			= THIS_MODULE,			\
 	.name			= drv_name,			\
 	.ioctl			= ata_scsi_ioctl,		\
+	ATA_SCSI_COMPAT_IOCTL					\
 	.queuecommand		= ata_scsi_queuecmd,		\
 	.can_queue		= ATA_DEF_QUEUE,		\
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,		\
-- 
2.20.0

