From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 0/2] lpfc: PowerPC64 topology information, and per-core scheduling
Date: Wed,  1 Jun 2016 17:43:27 -0300
Message-ID: <201606012043.u51KdPlB044752@mx0a-001b2d01.pphosted.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23171 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750854AbcFAUnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 16:43:40 -0400
Received: from pps.filterd (m0048817.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51KdPlB044752
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 16:43:39 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23a4fwkfam-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 01 Jun 2016 16:43:39 -0400
Received: from localhost
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 17:43:35 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id C16EB1DC0054
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2016 16:43:26 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51KhXdY28115214
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 17:43:33 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51KhWjv031373
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 17:43:33 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dick.kennedy@avagotech.com, james.smart@avagotech.com

This series enables the association of IO channels at the CPU-core level (i.e.,
with all CPUs/threads of core), which may increase performance depending on the
CPU affinity settings of the workload (e.g., benefit from the per-core caches);
and adds the required pieces to use it on PowerPC64 too (topology information),
which has server processors with many cores/threads and per-core caches.

Although the series include bits for PowerPC64, the per-core scheduling patch
is architecture independent.

Tested on next-20160601 (with an extra commit for patch 1/2, see commit msg).

Mauricio Faria de Oliveira (2):
  lpfc: support for CPU phys_id and core_id on PowerPC64
  lpfc: add option for lpfc_fcp_io_sched (LPFC_FCP_SCHED_BY_CPU_CORE)

 drivers/scsi/lpfc/lpfc_attr.c |  8 ++++--
 drivers/scsi/lpfc/lpfc_hw4.h  |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 65 ++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_scsi.c |  3 +-
 4 files changed, 70 insertions(+), 7 deletions(-)

-- 
1.8.3.1

