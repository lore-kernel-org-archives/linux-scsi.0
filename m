Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581F214900B
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433161; cv=none; b=RlX/kskftzQk5LgebY6x0sq1OfGMKEui3JiNBZIzrBWZaTZY54NC2vOvRH3kAF3s86xsKIrbZuWgJGbuGWc+rsW77DhuD2vkGQbLRKrm/N41etgw/bWS5O8uByf81e45mAPOAJtZ524QRQZFn+dv0F6glyt/02t4Ddmi7n3/gaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433161; c=relaxed/simple;
	bh=8C24oquEqlFQCyJVkJrELveUXgWblfcGwF9vVLF97Eg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=um9VYiErBwcdc774wgczuZ1DJYrEykl4728acI0PjD1/93ZB2u3veRW7DT+B9RIODeGiZW//pKdqJVUr4CsCiQoNa0fmqrVeXlKHgdq1EpFaHQhvs8ZRdN9TClHoyAXJUirKbpdUHt+xcmmDHP3+ySPFjkmyv6i0WWAZr+Aa47o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=OdodJ8Cc; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="OdodJ8Cc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1745433161; x=1776969161;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8C24oquEqlFQCyJVkJrELveUXgWblfcGwF9vVLF97Eg=;
  b=OdodJ8CcCXK2bkY/tu6KgBer6h7o6FVJ/lCEpTCt9sk7oUSD0KQvi0sK
   3X1MUQNN5wpmbNLUV3G2BBqKpNDPBr5vGkYRnykU/ofH6Fm0pVfwJ1aZr
   TFe8yHzef03c0AEpkjq5K5BWhlkkV263AuiLiRH/Shr0LoalsK9EAhKzm
   tSsJJnPZbCXOZZumDiJdxerQizGYlDAVQ7Z32NrgNx666/1O90Zq7grft
   pd4jNi53UdvliZo9yQtJSlHpUgYk35KpvqkgskO0G71hXMQW0dwij7L34
   N1SFFzikWur/1sZSJbiek9h2P+uaCRFImTVD1kB2dX6ALkDQPl+lnobkP
   Q==;
X-CSE-ConnectionGUID: M53gAtjaT4+J1rEc0EEFpA==
X-CSE-MsgGUID: G8cCMhK1RGa0pcCXWz04ew==
X-IronPort-AV: E=Sophos;i="6.15,233,1739862000"; 
   d="scan'208";a="272181072"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2025 11:32:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 23 Apr 2025 11:32:30 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Wed, 23 Apr 2025 11:32:30 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <hch@infradead.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<joseph.szczypek@hpe.com>, <POSWALD@suse.com>, <cameron.cumberland@suse.com>,
	Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/5] smartpqi updates
Date: Wed, 23 Apr 2025 13:32:24 -0500
Message-ID: <20250423183229.538572-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.49.0.391.g4bbb303af6
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

These patches are based on Martin Petersen's 6.16/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.16/scsi-queue

There are two main functional changes in this patch series:
smartpqi-take-drives-offline-when-controller-is-offline
smartpqi-fix-smp_processor_id-call-trace-for-preemptible-kernels

The other two patches add PCI-IDs for new controllers and change the
driver version.

This set of changes consists of:
* smartpqi-take-drives-offline-when-controller-is-offline
     On rare occasions, the controller can lock up and the driver was
     removing the controller instance from OS but leaving the
     drives exposed and their state was still 'running'.

     This patch sets the drive state as 'offline' to avoid confusion.
* smartpqi-add-new-pci_ids
     Add support for more PCI devices.
* smartpqi-enhance_wwid-logging-logic
     Cosmetic change for logging WWIDs for NVMe devices and for drives
     that support the extended format.
* smartpqi-fix-smp_processor_id-call-trace-for-preemptible-kernels
     When preemption is enabled, there are call traces in the console
     logs which are annoying. The call trace mentions using
     smp_processor_id(). Since the driver is only using this function call
     when accessing a per_cpu variable, we changed the call to
     raw_smp_processor_id(). This patch was written by
     Yi Zhang <yi.zhang@redhat.com> and I am posting it on his behalf.
* smartpqi-update-driver-version-to-2.1.34-035
     No functional changes.

---

David Strahan (2):
  smartpqi: take drives offline when controller is offline
  smartpqi: add new pci ids

Don Brace (1):
  smartpqi: update driver version to 2.1.34-035

Venkatesh Emparala (1):
  Enhance WWID Logging Logic.

Yi Zhang (1):
  smartpqi: fix smp_processor_id() call trace for preemptible kernels

 drivers/scsi/smartpqi/smartpqi_init.c | 140 ++++++++++++++++++++++++--
 1 file changed, 130 insertions(+), 10 deletions(-)

-- 
2.49.0.391.g4bbb303af6

