From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 1/2] lpfc: support for CPU phys_id and core_id on PowerPC64
Date: Wed,  1 Jun 2016 17:43:28 -0300
Message-ID: <201606012043.u51KflcX004680@mx0a-001b2d01.pphosted.com>
References: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50631 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbcFAUnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 16:43:41 -0400
Received: from pps.filterd (m0048827.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51KflcX004680
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 16:43:40 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23a468uxmy-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 01 Jun 2016 16:43:40 -0400
Received: from localhost
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 17:43:37 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 0738E1DC0054
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2016 16:43:29 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51KhZ6A8716732
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 17:43:35 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51KhZsJ031479
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 17:43:35 -0300
In-Reply-To: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dick.kennedy@avagotech.com, james.smart@avagotech.com

This commit uses the macros 'topology_physical_package_id' and
'topology_core_id' from <linux/topology.h>, which are defined in
arch/powerpc/include/asm/topology.h for CONFIG_PPC64 && CONFIG_SMP.

Also, change the initial value for min_phys_id from 0xff to INT_MAX
(the numbers may increment with large steps on some systems).

While in there, include the CPU number in the debug message, which
helps reading it on systems with many CPUs.

This depends on commit 'powerpc: export cpu_to_core_id()' (submitted
to the linuxppc-dev mailing list). Tested on next-20160601 w/ commit.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b43f7ac..03d1946 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -34,6 +34,8 @@
 #include <linux/firmware.h>
 #include <linux/miscdevice.h>
 #include <linux/percpu.h>
+#include <linux/kernel.h>
+#include <linux/topology.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -8718,7 +8720,7 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 		phba->sli4_hba.num_present_cpu));
 
 	max_phys_id = 0;
-	min_phys_id = 0xff;
+	min_phys_id = INT_MAX;
 	phys_id = 0;
 	num_io_channel = 0;
 	first_cpu = LPFC_VECTOR_MAP_EMPTY;
@@ -8730,6 +8732,9 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 		cpuinfo = &cpu_data(cpu);
 		cpup->phys_id = cpuinfo->phys_proc_id;
 		cpup->core_id = cpuinfo->cpu_core_id;
+#elif defined(CONFIG_PPC64) && defined(CONFIG_SMP)
+		cpup->phys_id = topology_physical_package_id(cpu);
+		cpup->core_id = topology_core_id(cpu);
 #else
 		/* No distinction between CPUs for other platforms */
 		cpup->phys_id = 0;
@@ -8737,8 +8742,8 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 #endif
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3328 CPU physid %d coreid %d\n",
-				cpup->phys_id, cpup->core_id);
+				"3328 CPU %d physid %d coreid %d\n",
+				cpu, cpup->phys_id, cpup->core_id);
 
 		if (cpup->phys_id > max_phys_id)
 			max_phys_id = cpup->phys_id;
-- 
1.8.3.1

