Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E062882A9;
	Fri,  4 Jul 2025 07:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751615712; cv=none; b=X+NnQlG+ox+TqfjESJK0i+NZZv+d7jfzTi7NrqeO0+A8sb76VW7/dmoxK8b/uVmQzuHQx1XXSmGzoMNrxdwvvkj+TcCGtYXTSQTvVfwrKPFkuws/+ql/hz6AjCfA0sSfPmjU+TqqB1XcJ6Yp1ljOOLChipcUVwT/NP9WnApCZwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751615712; c=relaxed/simple;
	bh=HatJQt+/Adv64NfU4l9yYslyXa8ctxMBuP4/uoYp+2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tf/hX+AE6vXQKeXFvoDnMLxd0wK8hIGZ3zyErLn358u1FojtyBVWBXG9xgR2gIJzBLAfoWBSQ4lv9nfDUcn9O5xG1JStgiAT3/9BUnixRwhWOY9EcWig1qCB6zBJOD1ayF1xLmuf0gHpGfPzQAHYABg7mOH93RUO1PxiejIcP8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQ7Hb34u; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQ7Hb34u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751615710; x=1783151710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HatJQt+/Adv64NfU4l9yYslyXa8ctxMBuP4/uoYp+2s=;
  b=eQ7Hb34uCUvO5XR3/8vL+iAvgrjPz50bs0W8beNRjuQyVYrhEMYXLfFx
   HFsPcb666mfaaULkHe5j6RtyeUG4oxkvGbypkTHRWtoX5VwiGNfGo5zHo
   1pLN8aL8aFphZTI0Omwakd/A/JwAGp8FnHvXNt2SmH7rkEk5RT185Z0Kj
   V1R6hmUkt+TKonpA5KE6slMqoKBxq/p1hQH9uFtlkYy4mQvvsOcKn2MQx
   MPnT1nbZfzaYnA4lTb+E9/pcQ0Ep4GRu4Ab8unCixzoKmMj9YfctqQobY
   vyvxIA05C6pCgg53RHz94LeL4q2zF47qlrzYQ8vSxvtplIonYiN6adpTg
   A==;
X-CSE-ConnectionGUID: H2i2/9KxTL6RhBhwc+4v2A==
X-CSE-MsgGUID: EN/KXynSQF+6iDOfJcJCTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53080630"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53080630"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 00:55:07 -0700
X-CSE-ConnectionGUID: 3ZLeYn5ZSAuolWKw3UI1DA==
X-CSE-MsgGUID: If5O9QjwR6KhmWAMeK3pcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154223141"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO svinhufvud.fi.intel.com) ([10.245.244.244])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 00:55:06 -0700
Received: from svinhufvud.lan (localhost [IPv6:::1])
	by svinhufvud.fi.intel.com (Postfix) with ESMTP id 1464F447EB;
	Fri,  4 Jul 2025 10:55:04 +0300 (EEST)
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 80/80] scsi: block: pm: Remove redundant pm_runtime_mark_last_busy() calls
Date: Fri,  4 Jul 2025 10:55:03 +0300
Message-Id: <20250704075503.3223228-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250704075225.3212486-1-sakari.ailus@linux.intel.com>
References: <20250704075225.3212486-1-sakari.ailus@linux.intel.com>
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
The cover letter of the set can be found here
<URL:https://lore.kernel.org/linux-pm/20250704075225.3212486-1-sakari.ailus@linux.intel.com>.

In brief, this patch depends on PM runtime patches adding marking the last
busy timestamp in autosuspend related functions. The patches are here, on
rc2:

        git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
                pm-runtime-6.17-rc1

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
2.39.5

