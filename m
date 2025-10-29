Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376CE1A8F84
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761734815; cv=none; b=meTUDVvGfAyNe6Vwf9PSC9Ie3xwyyXdhGElNzjSNzajjlviDWSFL2SGltbu6556s1Key0uz/crnbd9LhZcC1b2qzflTCfd3h5XOcHK0ROBtytZ5iYAFdciy2X1sPh/SQcMDqoBhWpHVOYuQAW/mjLwylFKVCFMYCB0AfYAtyTAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761734815; c=relaxed/simple;
	bh=dS9czUgA9SvycMX9W6Z/W2BEZqX27qPbQIIH/QhkwYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NF/7hJiB+fq0XsgdZHDYYSAz4FWwJsizr8ivByEBTtXjTntNkGD154p6fw9GERHorGPa2P10CCswEAvkP5Uwt0O1Ayek0xsqAvmyBlup4oOxnCmnvdpuQQ5IJeqeX2Qz3j/K/MoX8psMcDIgLMIdJVShcuJqOAWFbh4gto8KVTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qze8zTwq; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qze8zTwq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761734814; x=1793270814;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dS9czUgA9SvycMX9W6Z/W2BEZqX27qPbQIIH/QhkwYk=;
  b=Qze8zTwq8bPkbMkTethbV89KAZrAclOhpOWwW0Uh8uYUJ7kQOuuX75fs
   0+Y3EVyd6QZdjH3EuDyUmp6mAJUMwgS6qvh3h+VTHTCEZ+pmtBrFNxZmZ
   wdvh+fK7XV/VBMnDjJrDg+4szBaA4kmqEeuICTUT2BP7L7xvyv95qiGrQ
   nS//ZuTBXdgmcwPcRiDYAQbGRhij/fwZemySgXA7VfGhBxhvRwtmShn7Z
   0WWbfCHk8Tp8tJRQ+8eTXSs1TkNRr2EZqXzKgz4Vc2NBsZ0WiENUHOxfT
   pMk3S9chZFZv9J16CatBd6vBKM09CYH8DGqSCM8H7esmtplw3OEQx5Dml
   g==;
X-CSE-ConnectionGUID: fbo58vZFQamX9nl67wcJqQ==
X-CSE-MsgGUID: T4jzZMlFTLaJ8k2awfL0Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11596"; a="63553333"
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="63553333"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 03:46:52 -0700
X-CSE-ConnectionGUID: bT4T1XngTCi8KQd14JWTwg==
X-CSE-MsgGUID: 6nraw8NWSA2ncQkC0yKngg==
X-ExtLoop1: 1
Received: from fdefranc-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.245.245.4])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 03:46:51 -0700
Received: from punajuuri.localdomain (unknown [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id 5851C11FA76;
	Wed, 29 Oct 2025 12:46:48 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.98.2)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1vE3hY-00000003KyA-1BO1;
	Wed, 29 Oct 2025 12:46:48 +0200
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/1] scsi: block: pm: Remove redundant pm_runtime_mark_last_busy() calls
Date: Wed, 29 Oct 2025 12:46:48 +0200
Message-ID: <20251029104648.795582-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
pm_runtime_mark_last_busy().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/scsi/scsi_pm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d581613d87c7..2652fecbfe47 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -205,7 +205,6 @@ static int scsi_runtime_idle(struct device *dev)
 	/* Insert hooks here for targets, hosts, and transport classes */
 
 	if (scsi_is_sdev_device(dev)) {
-		pm_runtime_mark_last_busy(dev);
 		pm_runtime_autosuspend(dev);
 		return -EBUSY;
 	}
-- 
2.47.3

