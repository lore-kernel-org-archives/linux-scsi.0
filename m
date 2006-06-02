From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH] Optionally disable QAS in MPT Fusion spi driver
Date: Fri, 02 Jun 2006 15:14:25 -0600
Message-ID: <1149282865.5237.56.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel7.hp.com ([156.153.255.213]:64438 "EHLO atlrel7.hp.com")
	by vger.kernel.org with ESMTP id S1030279AbWFBVO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2006 17:14:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>

Certain drives report that they support QAS, but it some cases can have
trouble with it causing bus resets.  This patch optionally disables QAS
for the MPT Fusion spi driver.  QAS is disabled using the mpt_qas module
parameter.

Andrew

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>

-- 
Andrew Patterson
Hewlett-Packard

Index: scsi-misc-2.6/drivers/message/fusion/mptscsih.h
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptscsih.h	2006-06-02 12:29:31.000000000 -0600
+++ scsi-misc-2.6/drivers/message/fusion/mptscsih.h	2006-06-02 14:32:07.000000000 -0600
@@ -66,6 +66,7 @@
 #define MPTSCSIH_DOMAIN_VALIDATION      1
 #define MPTSCSIH_MAX_WIDTH              1
 #define MPTSCSIH_MIN_SYNC               0x08
+#define MPTSCSIH_QAS                    1
 #define MPTSCSIH_SAF_TE                 0
 #define MPTSCSIH_PT_CLEAR               0
 
Index: scsi-misc-2.6/drivers/message/fusion/mptspi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptspi.c	2006-06-02 12:29:31.000000000 -0600
+++ scsi-misc-2.6/drivers/message/fusion/mptspi.c	2006-06-02 14:32:07.000000000 -0600
@@ -87,6 +87,10 @@ static int mpt_pq_filter = 0;
 module_param(mpt_pq_filter, int, 0);
 MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
 
+static int mpt_qas = MPTSCSIH_QAS;
+module_param(mpt_qas, int, 1);
+MODULE_PARM_DESC(mpt_qas, " Quick Arbitration and Selection (QAS) enabled=1, disabled=0 (default=MPTSCSIH_QAS=1)");
+
 static void mptspi_write_offset(struct scsi_target *, int);
 static void mptspi_write_width(struct scsi_target *, int);
 static int mptspi_write_spi_device_pg1(struct scsi_target *,
@@ -607,7 +611,8 @@ static void mptspi_write_qas(struct scsi
 	VirtTarget *vtarget = starget->hostdata;
 	u32 nego;
 
-	if ((vtarget->negoFlags & MPT_TARGET_NO_NEGO_QAS) ||
+	if (!mpt_qas ||
+	    (vtarget->negoFlags & MPT_TARGET_NO_NEGO_QAS) ||
 	    hd->ioc->spi_data.noQas)
 		spi_qas(starget) = 0;
 	else
@@ -989,7 +994,7 @@ mptspi_probe(struct pci_dev *pdev, const
 		ioc->name,
 		mpt_saf_te,
 		mpt_pq_filter));
-	ioc->spi_data.noQas = 0;
+	ioc->spi_data.noQas = mpt_qas ? 0 : MPT_TARGET_NO_NEGO_QAS;
 
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;


