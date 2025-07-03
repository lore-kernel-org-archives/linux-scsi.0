Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4993282F5
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525025; cv=none; b=OGq2rRKNO9aqqeSpcvLFXUORYqNAbhihR1zBwoCqBuNQI9fJxT7dKwLrZ038vGTrE6ifxB//KBGukWTunkTLE7nZ36faj5Dkb8vGxUqJlNXAuafD3K9RHwcsvsWk3lDfdyCTNQSex7h3WZH2sgc4gxP4OBqzOfi/S3wf+u+8KKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525025; c=relaxed/simple;
	bh=NNVOfZeNnQIdKlKTPMgtWANDPt86wYBUniIqgapqm8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BpHFlEGTmhmjVtjrB/gnWq0RH8AAkRazVrERj5KuAbH4aa101OqIU5LLv66w4karaRSOMwPyb6ArNxNmPX3BEpijRWl9GgwPX7OIOFjF+y9kOvmRsMxdS2c6kiRuAAKi652EdvWADqhlh4saCjao+ZNAKACdzvJ3+QWxheHhK+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HEyL4iNb; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HEyL4iNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751525024; x=1783061024;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NNVOfZeNnQIdKlKTPMgtWANDPt86wYBUniIqgapqm8E=;
  b=HEyL4iNbzch0Gh+G9CF9sTaBi0+EfG0UVSc1hUlGCgM9QJyVGX4lzEIr
   LKR2W4ElOJoB2HsfWFMs6b5vb/1eSbLMRKuqBagqJw5UHBvUq5Qia8s+E
   xCwAfrXrDqBmI7adxV61dKHebi4pZ9e1AKNgnhY0ZJyxyyAqvy2oS3St7
   adpDRmIDNhtecs3hEGXVX2dR2qu76WJNqFyYspLM4JoA3iGd3OBmPPG9l
   tmJEaZ84lm8GmG0svgZkrj7rrJrpcwfmDjAyfnD/RjfRqmwMPtPkFdkET
   slPZUJLcl9K2+WfjuPoMfmwXbgvgK4wQ0x/lYB5sGBm/QlJvDopsofJZw
   Q==;
X-CSE-ConnectionGUID: hX+Smi3+RNePzThkkYuiBQ==
X-CSE-MsgGUID: xT+FnLiPTPeIinbCYw3j/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64533823"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64533823"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:43 -0700
X-CSE-ConnectionGUID: 52IhEvW8Q4mlLP1En+4t9Q==
X-CSE-MsgGUID: r4SCorM9QuaPzl2dwAuo5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158646040"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:41 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 0/3] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
Date: Thu,  3 Jul 2025 09:43:19 +0300
Message-ID: <20250703064322.46679-1-adrian.hunter@intel.com>
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

Here are a couple of fixes for Intel MTL-like UFS host controllers,
related to link hibernate state, and a minor tidy-up.


Adrian Hunter (2):
      scsi: ufs: ufs-pci: Fix default runtime and system PM levels
      scsi: ufs: ufs-pci: Remove UFS PCI driver's ->late_init() call back

Archana Patni (1):
      scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers

 drivers/ufs/host/ufshcd-pci.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 24 deletions(-)


Regards
Adrian
