Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54723156CF;
	Tue, 20 Aug 2024 04:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724126475; cv=none; b=GTgTPJFOTYalHP4g93/sFZvjYNYpMw690pceKl8NExi1PvpBwLVBUh4hGoldlGJ6nP/ivMiGwovN6SknAKtvpCi3aKfji4m3u/VYYwoXPF0+eRF1dletHs/abiN/nLwNUQqhBmAw+8op2foHmg/9Y+peAaVvPYzgGxAYn4BqZIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724126475; c=relaxed/simple;
	bh=/fcTDhyfY/4OIdy7+1GXGjnZwj0jbSEXTVhs8GsELmI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r6keYaRlX38z1POOnmTnAcIl0AOJ90jeciAGixInloS13cQf6mJYoOl7mCGXjZf30+jJv4WYeCziB5Qx87iCVTWvDq5dgy1y04NcTiTXCh+Cc4N9wD9aL0ZJBps4bzCJxkZCqd8eh4gvi/UELHs/iLIb1Hza/Nr28jFzeKPtTZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fuMncEdT; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fuMncEdT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724126473; x=1755662473;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/fcTDhyfY/4OIdy7+1GXGjnZwj0jbSEXTVhs8GsELmI=;
  b=fuMncEdTfJSkhBWhH+YH206DWBYuVdSccoaOu2WPO5E/EhL1jRJ1KpKT
   INIAglOprBSiRM8WKlsYCVRgEybFbTy8+r4wnfPIcbzdVkEZy0poz1LsO
   InWxUuGOZ2iLgeA8v5Zc9tvA2SuLYiPBDNjZDY9g72O5c9dmV+t4WSWbV
   KunFWtpaXRBcnwDWvFHdJYKoMiaEss7+ooWcxNAR2efWEQs5iXZPOrimk
   VUhJzCVvwQAfSlExsXwroo8lz/YeSD2mT4JUfh41SpvsXje2lDTGgMCOv
   GnAOz+NJfCChAfF7gAzA2aCmb8+q+wNUWClE9UnlGj9uHSCwH3hmi+WQM
   A==;
X-CSE-ConnectionGUID: AiWK796YQEK4XMi2yPSDBw==
X-CSE-MsgGUID: b4QSQE2VQ16kInRX0kCbTQ==
X-IronPort-AV: E=Sophos;i="6.10,160,1719849600"; 
   d="scan'208";a="24663340"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2024 12:00:04 +0800
IronPort-SDR: 66c4080e_zwEAfga2bLbD5A5aWMfgQAAYvh9BqnEwRIiaCmh/WyYAxTy
 UOZDaVRJNkvpTAWrPo5ijO9r8YPaA47BC3tTtQw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2024 20:05:50 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2024 21:00:02 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Move UFS trace events to private header
Date: Tue, 20 Aug 2024 06:58:26 +0300
Message-Id: <20240820035826.3124001-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufs trace events are called exclusively from the ufs core drivers.  Make
those events privet to the core driver.

The MAINTAINERS file does not need updating as the maintainership
remains the same and the relevant directory is already covered.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
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

