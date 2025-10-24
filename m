Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A5F2ECD3A
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 08:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296374; cv=none; b=ZGHh6EglJy15lT5VA8UwknIMbqBJkzUHl2r7LAD+3B97ttawSwGr7IOFmbfoj6FM9TH0hdkR71zEHRn54eOVhwOaoNryPZ2yMDnwN8Q5EmD62yXF0x44n2rRCeSYewHc4h387/dH1m8Tj4WGYq8wIjC93YPlS+RcqezQDIeIekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296374; c=relaxed/simple;
	bh=9cVy3MOSOEN5W1H5iM7b/Zgi2f6j6mkUygDvmOgUyDk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FJMl0ciHTKNF/MrrU+ko1ozG71yfyHvfnt1afLFnZ8bVIGFw/r44CqJ2LE/3C+YDUe5PEH5t6graROOrr5B4ZAGtwKh3gHlPlY2aOpCoyVXhD3UyDg8hryJ07fXj0BuORs2ei/9GAU8sjJdEo8SdZvmbhBhlW2AzFYQtsaI+S+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SFHehIXH; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SFHehIXH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761296374; x=1792832374;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9cVy3MOSOEN5W1H5iM7b/Zgi2f6j6mkUygDvmOgUyDk=;
  b=SFHehIXHlBB3QSsp/DcWPZp5R3aQgccAlym5HCnC0hlh+t5BafO5tpsi
   Ti0FJnk+WZgVHOD7Lhj5jUnE2hl6J6/lIcQs+cZJB1Zp7fbr6+CbNydJV
   4bjh+yjl55B7XEFYyhezb2DiqZ3FGa/zGBZOoic7aReoUtJrv6/dyJnd5
   qAVeeGTBlNI+gG/7lS3JnoLFf3J2jLTnWsqcsQz6fFdhD7MjrZAJPdKnV
   L9l5vw9ntQ3GYN+cuE6othUXU0Ly5Qi82x+mnYq4MMaoziDOijuJud5Us
   XsnKPuuV0lUVMBs3g0F5cQr8he4XwbT5CIIqcqh7YVc4msKVZy1w+ikdP
   Q==;
X-CSE-ConnectionGUID: Z4mI/bl/Q+ifQ2rrwFBIug==
X-CSE-MsgGUID: sT8BXrVJTwe6Id7442jiuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80910793"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="80910793"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:33 -0700
X-CSE-ConnectionGUID: 90sJ4i1YQ/WtkzaylZh+/Q==
X-CSE-MsgGUID: NThSLL2+RUKl0aCIleJDqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="221583342"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.43])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:30 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 0/4] scsi: ufs: PM fixes Intel host controllers
Date: Fri, 24 Oct 2025 11:59:14 +0300
Message-ID: <20251024085918.31825-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

Here are fixes related to power management on Intel host controllers,
primarily ones based on Intel Alder Lake.

Patches are based on 6.18/scsi-fixes


Changes in V2:

   scsi: ufs: core: Add a quirk to suppress link_startup_again
   scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL

      Rename from UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN
      to UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE


Adrian Hunter (4):
      scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
      scsi: ufs: core: Add a quirk to suppress link_startup_again
      scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL
      scsi: ufs: core: Fix invalid probe error return value

 drivers/ufs/core/ufshcd.c     |  7 +++--
 drivers/ufs/host/ufshcd-pci.c | 70 +++++++++++++++++++++++++++++++++++++++++--
 include/ufs/ufshcd.h          |  7 +++++
 3 files changed, 78 insertions(+), 6 deletions(-)

base-commit: c0e37ac6a5d4c4bc33b9c4408d22714fe370a1b0


Regards
Adrian
