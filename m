Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D147224B07;
	Tue, 14 Jan 2025 09:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736847473; cv=none; b=ua2DNFASfGjN6LYZXdD/hoQ9ZqRa5MG2hLxD82I0ktr0trtQwtJA6m5a5WEV0cKtJgReOOw8ylHpAIchT0IfMUsTRiWxK2TPiVOPPpvEVtVKHiOd2O1QK1Eppy6AUGX/HbobTK82QaYhryrLaldgRS8otyn96KBHLO2CZqce0LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736847473; c=relaxed/simple;
	bh=9V0x75IlzcnF9Hh+iv+ZYyH2lAE0xsRChSedjz7jqso=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ol7WnYLsZrE3Q5LHoa1VtUpXjG/XsCK7D7BchJneYn7W9Jb1XIc8Y2bVy44we7XWG2gplJ+Z5lzJyMfPH1rniTqt0NyNdmDGUIuLsUpglo53+RmVFaCIxZTex5ldL6rhROaZt3x3MUQxTFdlbIGI0+XDfzTP5eNFIHcjLXC6J68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gYzHnd7k; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gYzHnd7k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736847471; x=1768383471;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9V0x75IlzcnF9Hh+iv+ZYyH2lAE0xsRChSedjz7jqso=;
  b=gYzHnd7kIOptBJ4eEbfW671bApzF4QyItCTFxvk+PUrZDUxM7i3MXNEF
   ofFhh3yH1drL5zMm66x+imPjKH09wH9NMJv7DJ1jnvpAW/aPShh4AFDpT
   41GHbXtpIP03FFdQqI4WH+J64XqDS4N09/gmIWYn7IxeyY4rhjhYOjYqW
   urEPL+g/Rb3SeViYATgsY4PdC6OzL5PrGxatkkLUxo0OSdm5LlnByUyCY
   81hrv2+d3ZfuKktPaZy+B/xfYD77hsEGCfx7BdM1oqD/9maYpLQo8R0lj
   vefGDoB0iKrGfpSR8lI5VpkHXMMjz0tjMREFNV9igTXAoMpZQvC+NsuZn
   g==;
X-CSE-ConnectionGUID: vc/13jrMSXa+XkPLIWDfsg==
X-CSE-MsgGUID: tJ+XSNucQkKY493A3S6TKA==
X-IronPort-AV: E=Sophos;i="6.12,313,1728921600"; 
   d="scan'208";a="36401067"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2025 17:37:50 +0800
IronPort-SDR: 67862197_kWM7ppIKVOGQhoeo9/Qxevra0RBODZp1wYQIJjw1SSuOY8k
 H3ERmoJ2tSWd/aEVU8Bi7NbHSGzInv8ZwYU3tyg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 00:34:32 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 01:37:49 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/2] scsi: ufs: Temperature notification fixes
Date: Tue, 14 Jan 2025 11:35:10 +0200
Message-Id: <20250114093512.151019-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin hi,

This series includes two changes to the UFS driver. The first patch
simplifies the temperature exception event handling, and the second
patch adds missing ABI documentation for the UFS hwmon driver.

Please consider this for the next merge window.

Thanks,
Avri

Avri Altman (2):
  scsi: ufs: hwmon: Add missing ABI documentation
  scsi: ufs: core: Simplify temperature exception event handling

 .../ABI/testing/sysfs-driver-ufs-hwmon        | 31 +++++++++++++++++++
 MAINTAINERS                                   |  2 ++
 drivers/ufs/core/ufshcd.c                     | 20 +-----------
 3 files changed, 34 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ufs-hwmon

-- 
2.25.1

