From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [RFC] Common header file for FC definitions
Date: Tue, 8 Jan 2008 09:09:36 +0100
Message-ID: <20080108080924.GA6993@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:58159 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYAHIJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 03:09:33 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id m0889WBl213916
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 08:09:32 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0889VnM2973832
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 09:09:31 +0100
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0889V95013899
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 09:09:31 +0100
Received: from localhost (ICON-9-164-184-245.megacenter.de.ibm.com [9.164.184.245])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m0889VZO013896
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 09:09:31 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

zfcp has a couple of definitions to describe the FC protocol. Grepping
through the complete source tree shows that e.g. the lpfc module makes
similar private definitions. It think that it would make sense to
introduce a global header file for FC related definitions that each FC
driver can use.

The attached patch contains some definitons that i found in zfcp and
could be reused by other drivers.

What do others think? Would this be useful?

Christof

---
 include/scsi/fc.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/scsi/fc.h	2008-01-08 08:56:32.000000000 +0100
@@ -0,0 +1,47 @@
+/*
+ * Public definitions that are used by Fibre Channel (FC)
+ * device drivers.
+ */
+
+/* FC-PH/FC-GS well-known address identifiers for generic services */
+#define FC_DID_KEY_DISTRIBUTION_SERVICE	0xFFFFF7
+#define FC_DID_ALIAS_SERVICE		0xFFFFF8
+#define FC_DID_MANAGEMENT_SERVICE	0xFFFFFA
+#define FC_DID_TIME_SERVICE		0xFFFFFB
+#define FC_DID_DIRECTORY_SERVICE	0xFFFFFC
+
+#define FC_DID_MASK		      0x00FFFFFF
+
+/* task attribute values in FCP-2 FCP_CMND IU */
+#define SIMPLE_Q	0
+#define HEAD_OF_Q	1
+#define ORDERED_Q	2
+#define ACA_Q		4
+#define UNTAGGED	5
+
+/* task management flags in FCP-2 FCP_CMND IU */
+#define FCP_ABORT_TASK_SET	0x02
+#define FCP_CLEAR_TASK_SET	0x04
+#define FCP_LOGICAL_UNIT_RESET	0x10
+#define FCP_TARGET_RESET	0x20
+#define FCP_CLEAR_ACA		0x40
+
+/* FC-LS */
+#define FC_LS_RLS		0x0f
+#define FC_LS_ADISC		0x52
+#define FC_LS_RPS		0x56
+#define FC_LS_RSCN		0x61
+#define FC_LS_RNID		0x78
+
+/*
+ * FC-GS-2
+ */
+#define FC_CT_REVISION			0x01
+#define FC_CT_DIRECTORY_SERVICE	0xFC
+#define FC_CT_NAME_SERVER		0x02
+#define FC_CT_SYNCHRONOUS		0x00
+#define FC_CT_GID_PN			0x0121
+#define FC_CT_MAX_SIZE			0x1020
+#define FC_CT_ACCEPT			0x8002
+#define FC_CT_REJECT			0x8001
+
