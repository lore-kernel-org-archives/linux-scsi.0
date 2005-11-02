From: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: [PATCH] scsi - Fix Broken Qlogic ISP2x00 Device Driver
Date: Wed, 2 Nov 2005 12:43:22 +0530
Message-ID: <81083a450511012313v25e292duf7b64da0ebf07835@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.202]:52407 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932610AbVKBHN3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Nov 2005 02:13:29 -0500
Received: by zproxy.gmail.com with SMTP id j2so43836nzf
        for <linux-scsi@vger.kernel.org>; Tue, 01 Nov 2005 23:13:22 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, support@qlogic.com, akpm@osdl.org, stable@kernel.org

This patch fixes the fact that although the scsi_transport_fc.h header
file is not included in qla_def.h, we still reference the function
fc_remote_port_unlock in the qlogic  ISP2x00 device driver ,
qla2xxx/qla_rscn.c

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

--
diff -Naurp linux-2.6.14-git1/drivers/scsi/qla2xxx/qla_def.h
linux-2.6.14/drivers/scsi/qla2xxx/qla_def.h
--- linux-2.6.14-git1/drivers/scsi/qla2xxx/qla_def.h	2005-10-28
05:32:08.000000000 +0530
+++ linux-2.6.14/drivers/scsi/qla2xxx/qla_def.h	2005-11-01
11:54:25.000000000 +0530
@@ -40,6 +40,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport_fc.h>

 #if defined(CONFIG_SCSI_QLA21XX) || defined(CONFIG_SCSI_QLA21XX_MODULE)
 #define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
