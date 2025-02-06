Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ED31F4174;
	Thu,  6 Feb 2025 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738857509; cv=none; b=QMAep6XV3jPqdK/W9vvQHt7pLaHCHU3zSI08ELqoGjUtp491yc/ByYt3SUjvPKRKjs7R0mvg4AXtUsyZW8WNw7x8jNkidDUS8oHmAKt9qfJMt1JrpEa50mQqwpXbpFoGynYPALJ39nfRYas3qOZe2p155VuCEOHfgIEcO1nlKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738857509; c=relaxed/simple;
	bh=9CPQ4BItbToGb9+riTJJedrdZZnhQ++50987e9cUd4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G2k6NCG2s8MAjFgMtr/ZClwP0bjV+wqaIDFqXt7SPp+aEzDGh6QahH2E1YxmS3VCj7tpMkYoc1sv+CDbDPcHMiG4Q8rhSyuag3NTH0ii5O4NenY1tfIOAbDLFub2QtII5YtymWYBC0X+F8pZba5PeptNlEci3uDAZZ7BHC+3Mf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vzf7KWdn; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vzf7KWdn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738857508; x=1770393508;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9CPQ4BItbToGb9+riTJJedrdZZnhQ++50987e9cUd4w=;
  b=Vzf7KWdnHRlUv5vSpqKBwt/MLFwjShQaz4bStEoLmUn18LrGA/XhuW3s
   rbktpJkh64Mixz7abYhFJ8+lQlTdaHUZE6lo9bgDdrCD8lk7PVUWaYzFb
   lFeFvk4rZpdm/vrGYd2UU3+lXhxrN8Q5a7eTeoepfRBth6XG/zSAz+gJ0
   anK+5PcyK0PzZ+jDtLwHAkiDLHT02HG5wv3vcKWF1J9b7bNBhgug4lv9y
   2gINBaA3rQBhvCC3dinC3HjiLXB2vbjda6J5zKO+9BVFr/6QlhUtpH+Od
   T2OcU1bzlNx1VXM3MeMnYvjv+ry3F03fEN+S51J/yuhax+dro5P5QNbM/
   g==;
X-CSE-ConnectionGUID: cc2eMIcJRTyxbEp5zIu85A==
X-CSE-MsgGUID: zlkFBWhfQRGAHkvwonfRNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39621674"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="39621674"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 07:58:28 -0800
X-CSE-ConnectionGUID: LME2EmBtTzaZAEBIvucucA==
X-CSE-MsgGUID: q/7+1q/RSl2f2Q9mKfQUkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111093995"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa010.jf.intel.com with ESMTP; 06 Feb 2025 07:58:24 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 34677EE; Thu, 06 Feb 2025 17:58:23 +0200 (EET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi: lpfc: Switch to use %ptTs
Date: Thu,  6 Feb 2025 17:58:22 +0200
Message-ID: <20250206155822.1126056-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.43.0.rc1.1336.g36b5255a03ac
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use %ptTs instead of open-coded variant to print contents of time64_t type
in human readable form.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e360fc79b028..240e92143d73 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5643,24 +5643,11 @@ void
 lpfc_cgn_update_tstamp(struct lpfc_hba *phba, struct lpfc_cgn_ts *ts)
 {
 	struct timespec64 cur_time;
-	struct tm tm_val;
 
 	ktime_get_real_ts64(&cur_time);
-	time64_to_tm(cur_time.tv_sec, 0, &tm_val);
-
-	ts->month = tm_val.tm_mon + 1;
-	ts->day	= tm_val.tm_mday;
-	ts->year = tm_val.tm_year - 100;
-	ts->hour = tm_val.tm_hour;
-	ts->minute = tm_val.tm_min;
-	ts->second = tm_val.tm_sec;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
-			"2646 Updated CMF timestamp : "
-			"%u/%u/%u %u:%u:%u\n",
-			ts->day, ts->month,
-			ts->year, ts->hour,
-			ts->minute, ts->second);
+			"2646 Updated CMF timestamp : %ptTs\n", cur_time);
 }
 
 /**
-- 
2.43.0.rc1.1336.g36b5255a03ac

