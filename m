From: Ke Wei <kewei.mv@gmail.com>
Subject: [PATCH] mvsas: Mainly add version info to run testing process.
Date: Wed, 27 Feb 2008 20:50:25 +0800
Message-ID: <20080227125025.GA7897@ubuntu.domain>
Reply-To: Ke Wei <kewei.mv@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:58753 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbYB0MtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 07:49:20 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3169186wah.23
        for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 04:49:19 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

1. Owing to device testing, we need the kernel can show mvsas current
version in the /proc system.
2. Set the correct SAS address to per port.


Signed-off-by: Ke Wei <kewei@marvell.com>

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
old mode 100644
new mode 100755
index d4a6ac3..3e56178
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"mvsas"
-#define DRV_VERSION	"0.5"
+#define DRV_VERSION	"0.5.1"
 #define _MV_DUMP 0
 #define MVS_DISABLE_NVRAM
 #define MVS_DISABLE_MSI
@@ -645,6 +645,8 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
 static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
 static void mvs_scan_start(struct Scsi_Host *);
 static int mvs_sas_slave_alloc(struct scsi_device *scsi_dev);
+static int mvs_linux_proc_info(struct Scsi_Host *shost, char *buffer,
+		char **start, off_t offset, int length, int inout);
 
 static struct scsi_transport_template *mvs_stt;
 
@@ -657,6 +659,8 @@ static const struct mvs_chip_info mvs_chips[] = {
 static struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
+	.proc_name		= DRV_NAME,
+	.proc_info		= mvs_linux_proc_info,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
@@ -799,6 +803,29 @@ static void mvs_hba_cq_dump(struct mvs_info *mvi)
 #endif
 }
 
+static int mvs_linux_proc_info(struct Scsi_Host *shost, char *buffer,
+			char **start, off_t offset, int length, int inout)
+{
+	char *p = buffer;
+	int pos;
+	struct mvs_info *mvi = SHOST_TO_SAS_HA(shost)->lldd_ha;
+
+	if (inout == 1)
+		return -EINVAL;
+
+	p += sprintf(p, "Marvell 88SE64XX Driver , Version %s\n", DRV_VERSION);
+	p += sprintf(p, "%u phys, SAS addr %llX\n",
+			   mvi->chip->n_phy, SAS_ADDR(mvi->sas_addr));
+
+	*start = buffer + offset;
+	pos = p - buffer - offset;
+	if (pos > length)
+		pos = length;
+
+	return pos;
+
+}
+
 static void mvs_hba_interrupt_enable(struct mvs_info *mvi)
 {
 	void __iomem *regs = mvi->regs;
@@ -1005,7 +1032,7 @@ err_out:
 	return rc;
 #else
 	/* FIXME , For SAS target mode */
-	memcpy(buf, "\x00\x00\xab\x11\x30\x04\x05\x50", 8);
+	memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
 	return 0;
 #endif
 }
@@ -1330,7 +1357,7 @@ static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 
 		mvs_hba_cq_dump(mvi);
 
-		if (unlikely(rx_desc & RXQ_DONE))
+		if (likely(rx_desc & RXQ_DONE))
 			mvs_slot_complete(mvi, rx_desc);
 		if (rx_desc & RXQ_ATTN) {
 			attn = true;
@@ -2720,9 +2747,8 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 	msleep(100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
-		/* FIXME: is this the correct dword order? */
-		u32 lo = *((u32 *)&mvi->sas_addr[0]);
-		u32 hi = *((u32 *)&mvi->sas_addr[4]);
+		u32 lo = swab32p((u32 *)&mvi->sas_addr[4]);
+		u32 hi = swab32p((u32 *)&mvi->sas_addr[0]);
 
 		mvs_detect_porttype(mvi, i);
 
