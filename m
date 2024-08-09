Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5A2179BF
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 02:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723172177; cv=none; b=KEYUhOckRKtHLjKePDPlWbE/L1iPjglPVpmFetWT8xvL4F1n4P/f13g2xd2J0B3C9LUwf3hW6ovFxGf8wSdgAQtzax4pEz+g+NgIb3DuRE96oz0i0k4nLu8JO+WsqjeIYoPFU75XvAqLZQONiYHEBlE/gTx677QU/ropeEWi6j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723172177; c=relaxed/simple;
	bh=/qRRkUiqj1//hUa3ya9ituzSi3EsSA8P8ryhC+cHpFU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NPxzTMy6T7Nw4gDca+m9WOJ5Oh1XbQRG/g+JV/eDKGxdMcTnIWkGXN+dqvF3SIzLAUnf0B8fFXLiwF221lDpnXHYUjyU16LLlzZxAdhSVC2YabPRfK/NFLGnGKGlYZjfeON4ssxJHVCeJ9ThFvI/aoDvNLQ83kGsE40Jn3nc1/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jqYsE2uH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jqYsE2uH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723172176; x=1754708176;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/qRRkUiqj1//hUa3ya9ituzSi3EsSA8P8ryhC+cHpFU=;
  b=jqYsE2uHvwpwNmxyst5dgdgi9A6LsRNlhifzv4gVFE/egEHErt9I5Dqh
   lWcu6UkQ3cArZpQeY9+Lm9bf8JQ1kcJDJX1GPSYLmlxPAsrCTet7MqVYg
   bEP8SEs8V1cVinDRiUWHUXLYBkP3ZIL8beSgJWTtYk3G494FC4B5JNHzq
   bNZ1iJvhpkBuVavSpxdNoP61Kmy7XgTx2wP+bYEqir3pIImWFpnxbeMPx
   Ar9h8NzBa753Zo+NEb+i1LFCSmQIUP4f+MVz5+ERDwtIofHeBSSqw4u53
   XLcBJqQADq98gzNqOYRHxjRSJx5gh0rEMMgS0atFhhL5Jlb8SMitQgzL5
   Q==;
X-CSE-ConnectionGUID: roH2S93RQ4yRTLBbaAC3Cw==
X-CSE-MsgGUID: LXxv6GoETwmiX3vY+0qt1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="21505097"
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="21505097"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 19:56:15 -0700
X-CSE-ConnectionGUID: 7oe86GqCSsSngVK2rTv33Q==
X-CSE-MsgGUID: FBL2AvFtTPe0c2tcTliZEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="57990338"
Received: from sni1-test3.itwn.intel.com ([10.225.75.78])
  by orviesa007.jf.intel.com with ESMTP; 08 Aug 2024 19:56:13 -0700
From: Super Ni <super.ni@intel.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	manivannan.sadhasivam@linaro.org,
	beanhuo@micron.com,
	peter.wang@mediatek.com,
	avri.altman@wdc.com,
	cw9316.lee@samsung.com,
	super.ni@intel.com
Subject: [PATCH] scsi: ufs: add missing macro for the UFSHCI register map
Date: Fri,  9 Aug 2024 10:56:10 +0800
Message-Id: <20240809025610.1000310-1-super.ni@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add macro for register bit listed in JESD223C (v2.1).

For completeness all registers specified in the JEDEC doc should be
included here.

Signed-off-by: Super Ni <super.ni@intel.com>
---
 include/ufs/ufshci.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 38fe97971a65..534fbb8988e2 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -43,6 +43,7 @@ enum {
 	REG_UTP_TRANSFER_REQ_DOOR_BELL		= 0x58,
 	REG_UTP_TRANSFER_REQ_LIST_CLEAR		= 0x5C,
 	REG_UTP_TRANSFER_REQ_LIST_RUN_STOP	= 0x60,
+	REG_UTP_TRANSFER_REQ_LIST_COMPLETION	= 0x64,
 	REG_UTP_TASK_REQ_LIST_BASE_L		= 0x70,
 	REG_UTP_TASK_REQ_LIST_BASE_H		= 0x74,
 	REG_UTP_TASK_REQ_DOOR_BELL		= 0x78,
-- 
2.34.1

