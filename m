Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF781EB27;
	Sun,  2 Jun 2024 14:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337067; cv=none; b=V3Wot0hMPVskBYQfYF5ZKIAGGZEEnx1StHg+HMS5XLOBMlxJjkZd2u6ejKoLU3JD/NJd09LJn3ZtxK+UQxayf2zh4MxGqAq2J+1i9YCO0MC5KUvqGfzfUi4Pf2ifVtXRQqJN+I+EBhnkvfprC2PJNFkF9RmrRTBdgaCeLIvjU4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337067; c=relaxed/simple;
	bh=U4yjLreSOOGoCiVvZlQXfcer8ge1DPm9T8ADtuy70LM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ElAJYaSGuyx+cDgbPJD7IMpXXc+ptfXcGecunH7dPn7n9bh8KRiv5bCdpkMfQLw4q3TopmmdAB9YXHreRocUwQ1gmBk5/F+oIP5IBCyWpR1MmX+TZjTzpBNk5qAHDpZKtF8MK8ezHxqZPPmyC8/kYn5lxD8UDvZPSrjLTT0SDoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4GkLI47; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4GkLI47"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717337066; x=1748873066;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U4yjLreSOOGoCiVvZlQXfcer8ge1DPm9T8ADtuy70LM=;
  b=E4GkLI47Le5DDB9u5n3Y3vMHmydxxis+SMyxsGnMXxjPwc4UUn4Ui27Z
   g2xuD9KslS5KrQLmzYw6lrLhUWscswGh/a8OI7dP3jW1ze5puyP18kht/
   9Yf24fvuMI6jj7rxCCl5r0OWUqx90Bd/PgN5IsQTbP8J+4wtimVvWwTVE
   atg/YsdL3iPkl/EnUln8vEZoWCquw04M6fEGaJD6m2N5B+04h3XSyvwe1
   AyKhtdkSJUCo/k1xvAGbJOAu/z/mB6fBcda4mEWN7WuqLOaveiDu86wLo
   YFbcQzJjdI0vuN/occtJWfLnMlJ0JVnyLHY7DR4tGiwkKZ/6+++j7XgJ5
   A==;
X-CSE-ConnectionGUID: 3NR5D4i0R0ytBgwiUtaRHA==
X-CSE-MsgGUID: iY9Mp4zPStmQ1Pwsg+nEVg==
X-IronPort-AV: E=McAfee;i="6600,9927,11091"; a="17677455"
X-IronPort-AV: E=Sophos;i="6.08,209,1712646000"; 
   d="scan'208";a="17677455"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2024 07:04:25 -0700
X-CSE-ConnectionGUID: elZrqPxfReO6dXOVKzco2w==
X-CSE-MsgGUID: VQkGPSUHTSOYTGSZRKnmyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,209,1712646000"; 
   d="scan'208";a="36724235"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jun 2024 07:04:22 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id AF6261CB; Sun, 02 Jun 2024 17:04:21 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi: mpi3mr: Fix printf() specifier
Date: Sun,  2 Jun 2024 17:04:20 +0300
Message-ID: <20240602140420.3247493-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.43.0.rc1.1336.g36b5255a03ac
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Compiler is not happy about format string

  format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Werror=format=]
  note: in expansion of macro ‘ioc_warn’
  1367 |       ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",

Fix the specifier to make it possible to build.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 329cc6ec3b58..82aa4e418c5a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1364,7 +1364,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 			continue;
 
 		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
-			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
+			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
 		}
-- 
2.43.0.rc1.1336.g36b5255a03ac

