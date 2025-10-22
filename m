Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B36D2EBB89
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156520; cv=none; b=iQiu8CN47FRJmcxes9f2my6yOZaCtKYRE0mnR2fOvqF6N/zx1sU8Th7rxPsSGRt7b93W/hjWJr5iGe87vdRDaivJsYGku34D+vWOXN31A74b1s6wT6iBavZ+EHZZTqeL5TxDpXnWyr6wGWdCFqv7ILJrRwn1NT2StpBO7wR704o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156520; c=relaxed/simple;
	bh=U6Gf3F2av8XDkdo8Mb76hYetkvT2/VY90vpU/rsY9g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtcweUUqId7Crwmnrfe/F6/wsBjCWxlNjopu+jgNCpyzneb10fGKxwOysj8VpS/BqbUJvyPiizIFBErY3WnFKWrQZZRt+aIfvbEeFGm5FxFTTLM/0K5cYn/eJiLA45xMcwaPvh61mG5W4iSWz8jcEy73YhllnUE/zSK/lClc+5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=USloD4qp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="USloD4qp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761156519; x=1792692519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6Gf3F2av8XDkdo8Mb76hYetkvT2/VY90vpU/rsY9g8=;
  b=USloD4qphvZMt+nRDl5EELb3kzBECU0e+x8njCt39yIVM5j1M03HCafz
   y6ciJBRQpQqMI3ROwz489NWWj3gQ/NgPngSXWZfbXLTNRu0r1YouPCKoZ
   EK/BzxsmhwqTxPoP0lMS8Hb/Il/a7RqN2MWPkZ1hy4pX2YdOU+fCgzWEe
   wOCEJ02sAqLk8oBSX4xioMTMzZHTtBs0McGNmvv2Ih65asA1okx3kWKt6
   e8XEJkv+wi3lVO1bZqdDwB+DzzMcP464YV1gMESA3867kG8pWVbOq4lju
   dXM7ZwyPp753qtSB1g3HOHmNIWQguwvqsU9zGhAZc0IIqmS02e47SW0EZ
   Q==;
X-CSE-ConnectionGUID: 37hDDxqPReu+KyOrOSdtZg==
X-CSE-MsgGUID: oqT0Pa86R2uweLNe/uzFmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80753240"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="80753240"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:38 -0700
X-CSE-ConnectionGUID: dLaVGIwbSVasxuukczdT6w==
X-CSE-MsgGUID: xRSt41TZTdSdQBoWWMGe6Q==
X-ExtLoop1: 1
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.4])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:37 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN for Intel ADL
Date: Wed, 22 Oct 2025 21:08:18 +0300
Message-ID: <20251022180819.86180-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022180819.86180-1-adrian.hunter@intel.com>
References: <20251022180819.86180-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Link startup becomes unreliable for Intel Alder Lake based host controllers
when a 2nd DME_LINKSTARTUP is issued unnecessarily.  Employ
UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN to suppress that from happening.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 89f88b693850..171a3cc58512 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -428,7 +428,8 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout = 200;
-	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8 |
+		       UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }
-- 
2.48.1

