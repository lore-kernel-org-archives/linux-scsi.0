Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D094A307AE0
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296381; cv=none; b=JxJYVJyABZqBVJ+EpviVmbbvG3bxmeM5KT4ZEx6b+njLUwlqS8ryFfBHUAZBYS/NKlf6vpP20Swiu0rsux7lfUTkuJJIkqnKGvCx4EnNFmfmEtW7uSnfxg0Hsv2DCEeh2R63q80LO4ZudMXNH8gKb3IDHQH99QemOKkR0GGvIhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296381; c=relaxed/simple;
	bh=KljaHeRel9lFneiZy/VckZHka+lpYjQ8jEgcwYOY1Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beVKU246tkj1E26aHBjmHrupTB165aSl/ggXC/WaGtu2iDqTkaCfDcgxfS8hu50DsKl86uJjVN+nd5uQhGzy4COIpgtAj0dgwpXSfbGVp5jWQV7Fg5E6/LJ+YwXZVspoLibo61DZQTTLAiN2lLJ9IyzRf1S8wVNsW/6zdG21FeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MQ3tPAlT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MQ3tPAlT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761296380; x=1792832380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KljaHeRel9lFneiZy/VckZHka+lpYjQ8jEgcwYOY1Qg=;
  b=MQ3tPAlTd7lDIhwtUwVV25J9ombToYY5lf/A//1JF7x2n+Ge+nvMB1HZ
   s6Hd4K1Cnvs33HVYt2uxmtodDwMR4OHr/7ZdopA7+M4yifWIuPZKeG/8/
   O/eUkEDpg7N8cofZDNkkQjU6IMyk0lwwar7ItOFcuBs9OfiiYIyaZNPgL
   KB9Nn7cnRmVLB7FB7QguQ1Cu4sBZo8Lg+JO38VmSIhTIitgVAWhgF4QBY
   YfMgX23seH7vBgV5MPFaOSgCxRn+YlFHIoEHI4qjf8vQY5umbcBYytutN
   /Etb7o6HYep097eCJGqeghieOHPLQkRrEJWxLLws8OFlxuG0zptpwhKhk
   g==;
X-CSE-ConnectionGUID: xcwrrntRTvmFR9gcpwE9Lw==
X-CSE-MsgGUID: ic4sv+wtSD+a29st/9ASdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80910802"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="80910802"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:40 -0700
X-CSE-ConnectionGUID: rEKUDbsfSzuQN/S8PHJH2A==
X-CSE-MsgGUID: +JRuhzXSQFGmp8UDuGtYtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="221583384"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.43])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:38 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 3/4] scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL
Date: Fri, 24 Oct 2025 11:59:17 +0300
Message-ID: <20251024085918.31825-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251024085918.31825-1-adrian.hunter@intel.com>
References: <20251024085918.31825-1-adrian.hunter@intel.com>
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
UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress that from happening.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

      Rename from UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN
      to UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE


 drivers/ufs/host/ufshcd-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 89f88b693850..5f65dfad1a71 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -428,7 +428,8 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout = 200;
-	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8 |
+		       UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }
-- 
2.48.1

