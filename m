From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 2/3] ipr: Increase MSIX vectors number
Date: Tue, 12 Jul 2016 16:02:08 -0500
Message-ID: <1468357329-3790-2-git-send-email-wenxiong@linux.vnet.ibm.com>
References: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32996 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbcGLVHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2016 17:07:42 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6CL47F1105352
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:41 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
	by mx0a-001b2d01.pphosted.com with ESMTP id 2455jscy9q-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:41 -0400
Received: from localhost
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@us.ibm.com>;
	Tue, 12 Jul 2016 18:07:38 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id E53CC1DC0071
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:07:27 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6CL7Zpc5013738
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:07:35 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6CL7ZGS028714
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:07:35 -0300
In-Reply-To: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@Odin.com, martin.petersen@oracle.com, brking@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Increase MSIX vectors from 2 to 16 by default.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 01dc065..1f539c2 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -98,7 +98,7 @@ static unsigned int ipr_transop_timeout = 0;
 static unsigned int ipr_debug = 0;
 static unsigned int ipr_max_devs = IPR_DEFAULT_SIS64_DEVS;
 static unsigned int ipr_dual_ioa_raid = 1;
-static unsigned int ipr_number_of_msix = 2;
+static unsigned int ipr_number_of_msix = 16;
 static unsigned int ipr_fast_reboot;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
@@ -222,7 +222,7 @@ module_param_named(max_devs, ipr_max_devs, int, 0);
 MODULE_PARM_DESC(max_devs, "Specify the maximum number of physical devices. "
 		 "[Default=" __stringify(IPR_DEFAULT_SIS64_DEVS) "]");
 module_param_named(number_of_msix, ipr_number_of_msix, int, 0);
-MODULE_PARM_DESC(number_of_msix, "Specify the number of MSIX interrupts to use on capable adapters (1 - 16).  (default:2)");
+MODULE_PARM_DESC(number_of_msix, "Specify the number of MSIX interrupts to use on capable adapters (1 - 16).  (default:16)");
 module_param_named(fast_reboot, ipr_fast_reboot, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(fast_reboot, "Skip adapter shutdown during reboot. Set to 1 to enable. (default: 0)");
 MODULE_LICENSE("GPL");
-- 
1.7.1

