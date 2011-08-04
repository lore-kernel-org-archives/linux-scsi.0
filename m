From: <kashyap.desai@lsi.com>
Subject: [PATCH 01/05] mptfusion: Set max sector count module para
Date: Thu, 4 Aug 2011 16:41:55 +0530
Message-ID: <201108041050.p74AocIA005740@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33420 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403Ab1HDKvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 06:51:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, JBottomley@parallels.com

The max_sector setting is currently hard-coded in the driver to 8192 
sectors (4MB transfers). Using new module parameter, if max_sectors is 
specified at load time, the default of 8192 will be overridden.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7596aec..286faf0 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -92,6 +92,11 @@ static int max_lun = MPTSAS_MAX_LUN;
 module_param(max_lun, int, 0);
 MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
 
+static int mpt_loadtime_max_sectors = 8192;
+module_param(mpt_loadtime_max_sectors, int, 0);
+MODULE_PARM_DESC(mpt_loadtime_max_sectors,
+		" Maximum sector define for Host Bus Adaptor.Range 64 to 8192 default=8192");
+
 static u8	mptsasDoneCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptsasTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptsasInternalCtx = MPT_MAX_PROTOCOL_DRIVERS; /* Used only for internal commands */
@@ -5239,6 +5244,21 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		sh->sg_tablesize = numSGE;
 	}
 
+	if (mpt_loadtime_max_sectors) {
+		if (mpt_loadtime_max_sectors < 64 ||
+			mpt_loadtime_max_sectors > 8192) {
+			printk(MYIOC_s_INFO_FMT "Invalid value passed for"
+				"mpt_loadtime_max_sectors %d."
+				"Range from 64 to 8192\n", ioc->name,
+				mpt_loadtime_max_sectors);
+		}
+		mpt_loadtime_max_sectors &=  0xFFFFFFFE;
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"Resetting max sector to %d from %d\n",
+		  ioc->name, mpt_loadtime_max_sectors, sh->max_sectors));
+		sh->max_sectors = mpt_loadtime_max_sectors;
+	}
+
 	hd = shost_priv(sh);
 	hd->ioc = ioc;
 
