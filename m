Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7721A15C158
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289952; cv=none; b=b9kt49JARm7TC6iZqtB53s3JDvLSRbOyknDgOj7jOWtuvTBpdiVf8a+qwtIDoLaYLI0DzmUWCaOzwsbdNwXc5xMto0lFxvbl9CRjClCxWSS5O5vmmdhvgI+OHz/Bu3+WjaTDTQXvTmQk82pDxMOI0/A/YxjLtt4WeVjBaXRGTA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289952; c=relaxed/simple;
	bh=wj2w+6TTn/t2hoxSXBMZel0aYH9yJw0Jy/BCEBgQN9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hDYwd7NPXgSJX/w9AOA/JVfsxC8CcBX+Y5vkoL2DvimGyiEyACLS0SmtB99YbUK+P5/w+wjnoDYnW2VfOe05kLCXrcW6oOBqV/llnQIUkTv4wXQD7iDXaqhQufYpKVC+G15z8g51NM7biwTS0HL2cMUT4OYeWcUn+nxYfl1aGG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KzPn0Ya5; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KzPn0Ya5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289950; x=1784825950;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wj2w+6TTn/t2hoxSXBMZel0aYH9yJw0Jy/BCEBgQN9o=;
  b=KzPn0Ya53XwndRBBYSsH04joWKS5G3xQQz96jZAwSoz2g+TRaOXA2v6F
   cd4ksogFgMiYGVIopwp3AjdkgNcPzXgHrPE/31uJK9Oi9PMkTsXU4F6Sb
   oFSP35TbcR/u1JYx0VmdDf6Y70fB2du24RNRoN734/mks013IlkrS5CJW
   Qt/nUWMmhk34kcArEPjFEfLw0RTqgFSHFBtYqFGY3vVFCoNmCZ9pxvWE5
   U/7id8XzBkxWrxDHUoa8sqlBsfeYVo0KgLGZtTwBu7U8as1A/UIX7RLcf
   WsXRrkWab04QSbbpRTkqK4beVRweFdDhNjcKcMo+hE2C7QLKTa501Atd6
   w==;
X-CSE-ConnectionGUID: NLAWYvQrTla4v/Xvx7Czgw==
X-CSE-MsgGUID: 8J8AvIctRAOz/7TCEcjwDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55734978"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55734978"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:10 -0700
X-CSE-ConnectionGUID: RS4KWDZGTEOVz9Jm1UiWOw==
X-CSE-MsgGUID: y8BEGOz6QFuhHQDZU87NOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196732969"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:08 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 0/8] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
Date: Wed, 23 Jul 2025 19:58:48 +0300
Message-ID: <20250723165856.145750-1-adrian.hunter@intel.com>
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

Here is V2 of a couple of fixes for Intel MTL-like UFS host controllers,
related to link Hibernation state.

Following the fixes are some improvements for the enabling and disabling
of UIC Completion interrupts.


Changes in V2:
    scsi: ufs: ufs-pci: Fix default runtime and system PM levels
	Add comment about getting variant after it is set

    scsi: ufs: ufs-pci: Remove UFS PCI driver's ->late_init() call back
	Adjust for change in patch 2
	Add Bart's Rev'd-by

    scsi: ufs: core: Remove duplicated code in ufshcd_send_bsg_uic_cmd()
    scsi: ufs: core: Set and clear UIC Completion interrupt as needed
    scsi: ufs: core: Do not write interrupt enable register unnecessarily
    scsi: ufs: ufs-pci: Remove control of UIC Completion interrupt for Intel MTL
	New patches


Adrian Hunter (7):
      scsi: ufs: ufs-pci: Fix default runtime and system PM levels
      scsi: ufs: ufs-pci: Remove UFS PCI driver's ->late_init() call back
      scsi: ufs: core: Move ufshcd_enable_intr() and ufshcd_disable_intr()
      scsi: ufs: core: Remove duplicated code in ufshcd_send_bsg_uic_cmd()
      scsi: ufs: core: Set and clear UIC Completion interrupt as needed
      scsi: ufs: core: Do not write interrupt enable register unnecessarily
      scsi: ufs: ufs-pci: Remove control of UIC Completion interrupt for Intel MTL

Archana Patni (1):
      scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers

 drivers/ufs/core/ufshcd.c     | 95 ++++++++++++++++++-------------------------
 drivers/ufs/host/ufshcd-pci.c | 33 ++++-----------
 2 files changed, 49 insertions(+), 79 deletions(-)


Regards
Adrian
