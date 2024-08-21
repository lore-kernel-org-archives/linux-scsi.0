Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377A8166305;
	Wed, 21 Aug 2024 05:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724219763; cv=none; b=Jxf+ZLtvNORCE5+ixSaSOWtbEjxqxCeCDutYZW6o9tY29Ol7IWjD9+2h2MsuFPdPop6tg1SzcX/vp5w9nBI0ODa0TCW5njzw3X7O7WkQ9a7ktpX6wdaeLNuVivCxiqb7ceg+aMNesS7hrd/onnUZMMlseKNwL+hLxjcF0nWBPjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724219763; c=relaxed/simple;
	bh=019hknAFV3sGdIKFsRWq5MUfZidJB9BDlRe+Lih9n3k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iAO93ysoydb72IfLdOAVT7O8WF4yaLa/ISazhyYUM8+7AR7dQH2/uJv00vgnELD3KghFnE4oqvDA3DB5VGbytaDUACKQSyNsCEbEYaNBu8lBr1N4fxcr6fBXSkz9GaS2Ijjz1z/u1DziKouijlvZu93FdHnc10YzE8qkOwmtZJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YGjfdr0P; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YGjfdr0P"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724219762; x=1755755762;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=019hknAFV3sGdIKFsRWq5MUfZidJB9BDlRe+Lih9n3k=;
  b=YGjfdr0P5POQwkGRq7pVXQwZfnBsQpAlsPS0/1Lgx01s+93FpFtO5RrA
   ieGEbH1ZSvaEp/HmUoSsBsG4vc+5mmdN4o9GEyGzzslHU8YiR9Qd2T4zE
   VfhnTKJFyVoH4+dM3YbhyoGPnQES++HpDYDWx3pE2orniU0lSBjA12PEu
   ZPDq7zU2ireCtngoyu3h7vrZ99O3bY+e5BSB+gm82ZxYg4llpb5kw3CxF
   egfKGyxe0vWJ/S8vACoqvnptVYlcNaX37SIH6iG6wB4CK+lHn/Cr9DvcB
   Ooq6/1bM2HivzrEheEmaXpoqimjlPioAlNv8HZC8LT4DP3poesSOBlx8+
   A==;
X-CSE-ConnectionGUID: mGiH7xoHQlisoKwyhwioTQ==
X-CSE-MsgGUID: f4v5E3DGSpaITh2k0VrHNw==
X-IronPort-AV: E=Sophos;i="6.10,164,1719849600"; 
   d="scan'208";a="24777503"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2024 13:55:54 +0800
IronPort-SDR: 66c5735e_LqAIJ74mxLJcy5kbfxt7QOH2WnFEg11GRcItA9xF+v7l1xo
 Ysod9nRzLm+jcf6P3a0+AYKt6nr31qKvqUZz07w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Aug 2024 21:55:58 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Aug 2024 22:55:52 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2] scsi: ufs: Move UFS trace events to private header
Date: Wed, 21 Aug 2024 08:54:11 +0300
Message-Id: <20240821055411.3128159-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufs trace events are called exclusively from the ufs core drivers.  Make
those events private to the core driver.

The MAINTAINERS file does not need updating as the maintainership
remains the same and the relevant directory is already covered.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---

Changes in v2:
 - Fix a spelling mistake
---
 include/trace/events/ufs.h => drivers/ufs/core/ufs_trace.h | 6 ++++++
 drivers/ufs/core/ufshcd.c                                  | 2 +-
 include/ufs/ufs.h                                          | 4 ++--
 3 files changed, 9 insertions(+), 3 deletions(-)
 rename include/trace/events/ufs.h => drivers/ufs/core/ufs_trace.h (98%)

diff --git a/include/trace/events/ufs.h b/drivers/ufs/core/ufs_trace.h
similarity index 98%
rename from include/trace/events/ufs.h
rename to drivers/ufs/core/ufs_trace.h
index c4e209fbdfbb..84deca2b841d 100644
--- a/include/trace/events/ufs.h
+++ b/drivers/ufs/core/ufs_trace.h
@@ -9,6 +9,7 @@
 #if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_UFS_H
 
+#include <ufs/ufs.h>
 #include <linux/tracepoint.h>
 
 #define str_opcode(opcode)						\
@@ -395,5 +396,10 @@ TRACE_EVENT(ufshcd_exception_event,
 
 #endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
 
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../drivers/ufs/core
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE ufs_trace
+
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0dd26059f5d7..db30d0c4d91e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -39,7 +39,7 @@
 #include <asm/unaligned.h>
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/ufs.h>
+#include "ufs_trace.h"
 
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
 				 UTP_TASK_REQ_COMPL |\
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 853e95957c31..e594abe5d05f 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -597,7 +597,7 @@ struct ufs_dev_info {
 };
 
 /*
- * This enum is used in string mapping in include/trace/events/ufs.h.
+ * This enum is used in string mapping in ufs_trace.h.
  */
 enum ufs_trace_str_t {
 	UFS_CMD_SEND, UFS_CMD_COMP, UFS_DEV_COMP,
@@ -607,7 +607,7 @@ enum ufs_trace_str_t {
 
 /*
  * Transaction Specific Fields (TSF) type in the UPIU package, this enum is
- * used in include/trace/events/ufs.h for UFS command trace.
+ * used in ufs_trace.h for UFS command trace.
  */
 enum ufs_trace_tsf_t {
 	UFS_TSF_CDB, UFS_TSF_OSF, UFS_TSF_TM_INPUT, UFS_TSF_TM_OUTPUT
-- 
2.25.1

