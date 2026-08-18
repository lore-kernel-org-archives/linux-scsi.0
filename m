Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BADB45FFB6;
	Tue, 18 Aug 2026 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052574; cv=none; b=P3+/iFSbXB2uCAb4opJWi9bh9S/pEWLmW9+o+LRQrNdDkIc71PJ8wufrFzxdVtARteBRR8GBGaHztE+7Hb+ZZz8P7ayWFcXOCyYWFpNYBHSsRlJLi3xRo/VskOto04RyBrjOUcD1jKfufvi6TAVGqjVyLf/NcGYQK36ftHuA0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052574; c=relaxed/simple;
	bh=h1pxTr3SWD0gTxjKyV2Stfykyqm02SS2xPWAUWboao4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lAdcLhqwW+2Gc4LIHcecp0jqsfKPz1BFaoo7kh/Uckvr+xbUvquy/so33tdLZ4Cawa3VJv+T9L5aFOlhvx+hPm7Fj5L8Hl2yAlieW6GFn5Hk/bcWejFXh+PJazvwO/JPX3KTtqR3TdB5b9FKcN6/172pa+PfrwOjikKWhJ2u+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lhImTWTV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lhImTWTV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787052573; x=1818588573;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h1pxTr3SWD0gTxjKyV2Stfykyqm02SS2xPWAUWboao4=;
  b=lhImTWTVFC5Iig0BYkuBHfrxC6edYvcdqWUtuP2rg4YNGNnuZbEmDCKh
   Bu/WYTf0YWTaVn3WpxaxG82salkg5HXAV2dyhPqgzWYfgck6IEheQ/rj4
   w3/U6X1i9Rr8z1ZqhquLCWakLU5CT/rxgjLgq9wl9Hr/cpuEJlJ2ic8qz
   T2JNlx1mvA+nfUNC5GDrDBx+O5vlAnJeL62yiu4IXjBa40v/thlCWO6mz
   h9M/fuO/fplcBmyb0YI/DgkkoRNkdHepOp5eP9VvDbuvko7FBJmEkM5TY
   rDAy9ue/DMbkNdgEVWN0wqYtQL77xY7PJWr2TL/Jr79kCZbIiglML7eUK
   A==;
X-CSE-ConnectionGUID: zy8669saTeiPb9vxIs1sBQ==
X-CSE-MsgGUID: AnKOGavUTfaffMd/bCC3vQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="105075321"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="105075321"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 04:29:32 -0700
X-CSE-ConnectionGUID: x7WWul2fSHad8ITVRii6Kw==
X-CSE-MsgGUID: nHXBWsqERBOU7T+tMEYkcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="269041498"
Received: from intel-fishhawkfalls.iind.intel.com ([10.99.116.69])
  by orviesa004.jf.intel.com with ESMTP; 18 Aug 2026 04:29:31 -0700
From: sangram kumar yerra <sangram.k.y@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: sangram kumar yerra <sangram.k.y@intel.com>,
	James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 0/2] scsi: ufs: ufs-pci: Intel UFS 4.0 HS-Gear5 and MCQ support
Date: Tue, 18 Aug 2026 16:58:28 +0530
Message-Id: <20260818112830.453402-1-sangram.k.y@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

096cd6b7adf2 ("scsi: ufs: ufs-pci: Add support for Intel Nova Lake")
added the PCI ID for Intel's UFS 4.0 controller (8086:D335), reusing
the existing Meteor Lake variant operations table. That table is
missing two things this controller needs to work correctly at UFS 4.0
capability: a PA_INITIAL_ADAPT sequence for reliable HS-Gear5 link
training, and the MCQ resource/runtime-config hooks required for
ufshcd_alloc_mcq() to succeed. Without either, the controller still
works, but silently falls back to Gear5 link instability or legacy
single-doorbell mode respectively.

Patch 1 adds a pwr_change_notify hook that configures
PA_INITIAL_ADAPT (resetting to the default PA_NO_ADAPT otherwise)
before Gear5 power mode changes.

Patch 2 adds the mcq_config_resource and op_runtime_config hooks,
with the OPR register offsets and stride this controller uses.

Both were validated on real NVL silicon: a 10-cycle reboot trial (5
minutes monitored each) with this exact configuration showed zero
UIC-layer errors throughout, and MCQ hardware queues were confirmed
carrying real doorbell traffic at the documented addresses.

sangram kumar yerra (2):
  scsi: ufs: ufs-pci: Add support for Intel UFS 4.0 HS-Gear5
  scsi: ufs: ufs-pci: Add MCQ support for Intel UFS 4.0 controllers

 drivers/ufs/host/ufshcd-pci.c | 59 +++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

-- 
2.34.1

