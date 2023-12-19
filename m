Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D36539AC4
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 19:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="F/AlW9Fe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1703014639; x=1734550639;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MxQyFtq0T1CUQIvZ4nakCRNMAORdiwBKAYt8TVZpsK0=;
  b=F/AlW9FeJVX8NQxdQKrfSmUvH1/HTu4+LWcLYjxjW8uwNBWacYqfQpKZ
   Z0GjvssV510hMiNybGVafPyQRt4/M4zG9f/Mw0li0EoLLaLlBpUV8fk5/
   gZnfqdcctpSwpoxD3LPt5cbXO51Qbj9c3/tvku0D3bCGs7b8Sprze8UV7
   fw6/XjFSk5XXcJ3p/Oeub74fy26GhWuNLm4C2NRbHt7vWPt0XA4B60wer
   lEMckD4lyLBRvEGpftCPvadq4nNgzlMNiniknDA4+DFnDqRGpNkW3Dk23
   bhZNj5HVlYppUiombBA2H9NRmdIc2ZOWe8EkQwGbd6mVHEenU0yhU7boo
   Q==;
X-CSE-ConnectionGUID: QfATRU5QQbSZ4OmFfcIKRQ==
X-CSE-MsgGUID: 7vvmf9BrSa+t6GE2vVK9yA==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,289,1695711600"; 
   d="scan'208";a="13591430"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2023 12:37:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Dec 2023 12:36:53 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 19 Dec 2023 12:36:53 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/3] smartpqi updates
Date: Tue, 19 Dec 2023 13:36:49 -0600
Message-ID: <20231219193653.277553-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.43.0.76.g1a87c842ec
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

These patches are based on Martin Petersen's 6.8/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.8/scsi-queue

The only functional change to smartpqi is correction of a race condition
during a scan/rescan operation. The device->rescan flag can be updated
by multiple threads causing issues.

The other two patches add PCI-IDs for new controllers and change the
driver version.

This set of changes consists of:
* smartpqi-Add-new-controller-PCI-IDs
  No functional changes. Just adding in more device support.
* smartpqi: fix logical volume rescan race condition
  The driver has several threads that can contend for accessing
  a controller instance wide 'rescan' flag. In some rare cases
  a race condition can occur that bypasses a call to rescan for
  device changes. Some of these changes are; device removal, logical
  volume changes, and device adds. We basically added a spin-lock
  to protect the 'rescan' flag.
* smartpqi-change-driver-version-to-2.1.26-030
  No functional changes.

---

David Strahan (1):
  smartpqi: Add new controller PCI IDs

Don Brace (1):
  smartpqi: bump driver version to 2.1.26-030

Mahesh Rajashekhara (1):
  smartpqi: fix logical volume rescan race condition

 drivers/scsi/smartpqi/smartpqi.h      |  1 -
 drivers/scsi/smartpqi/smartpqi_init.c | 89 ++++++++++++++++++++++++---
 2 files changed, 79 insertions(+), 11 deletions(-)

-- 
2.43.0.76.g1a87c842ec

