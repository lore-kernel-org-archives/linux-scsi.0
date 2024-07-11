Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3E517C205
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 19:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727253; cv=none; b=TGPO/xniPMMRZF2gFot9WWB9pfQCuiJo03UBsij0P3tHgYWoEoH+xHZfmk9XgtW8sxefS3MYJXRAr9Cl3Wg6EkbFW4LMhMXGBCgFkficie7zesR+vki/al14OWmOmmHvczpQimU/YJA0bs/7cNxgCeCEiQOJYzeCDOH88x2eW6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727253; c=relaxed/simple;
	bh=+S28Ifuugta8uUF7/7/gvsxrq8Mmx4ttpwCCyPMnl80=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sFB8Z36OQGWLPKJbsfqqMq5IvoXIgy6aIfuWqTl6/4gGh0qgR21d5JD7BUelKSYBt1dXGhTDk+W9zrIsLWodiBiWs23mFeYqnY2NI+hyEK2PGZ9cDGn19AgUZ/RymzSEMer834FvG5S8IvM1SF+adwF5wWl4NS0u9hrV4EeyL7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=HOM7PqIC; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="HOM7PqIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1720727250; x=1752263250;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+S28Ifuugta8uUF7/7/gvsxrq8Mmx4ttpwCCyPMnl80=;
  b=HOM7PqICLke524IosCZJvqS/o4cUvAlKsiJEbGAd/h+C1b6sEAv34hha
   Cr3Zf2RONeYr0Wuw78G8eK8BDxO6WpCAWbM0auJ8Z7XB7Nv6lJgoE4//j
   PkVCuizbu3vTw7YBjgqysbhdemUvrvUciSw31lJo6dfrgvCWT7xAatRSR
   62wZAII3y3tTHIqbq0Ay0QvnRrdzcghgWOAkg8jI8wsffbSCUphiXOXk6
   0Zu3fjLpPwSKD8h0e1V+AAJhwRrCdIm0B3SN2OH0rf4ab7m85woVtjvNq
   qcAYdM3Uay/cU+fvXBcnZKcpAV1MB62xSBgXK3gRbdwEv1mt1WvIeqyjw
   w==;
X-CSE-ConnectionGUID: lpLBJxwkSjifens90ReNAw==
X-CSE-MsgGUID: P3bTpPsnRqSiRkmAA/+T9Q==
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="29106952"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2024 12:47:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jul 2024 12:47:05 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 11 Jul 2024 12:47:04 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>,
	Martin Petersen <martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/5] smartpqi updates
Date: Thu, 11 Jul 2024 14:46:59 -0500
Message-ID: <20240711194704.982400-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.45.2.827.g557ae147e6
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

These patches are based on Martin Petersen's 6.11/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.11/scsi-queue

The functional changes of note to smartpqi are for: multipath failover
and improving the accuracy of our RAID bypass counter.

For multipath we are:
    Reverting commit 94a68c814328 ("scsi: smartpqi: Quickly propagate path failures to SCSI midlayer")
    because under certain rare conditions involving encryption-enabled devices,
    a false path failure is reported to the SML causing multipath to failover
    to the other path.

    Improving errors returned from the driver back to the SML by checking for
    error codes returned from the firmware and returning the correct ASC/ASCQ codes
    to the SML. 

The other two patches add PCI-IDs for new controllers and change the
driver version.

This set of changes consists of:
* smartpqi-add-new-controller-PCI-IDs
  No functional changes. Just adding in more device support.
* smartpqi-improve-accuracy-of-RAID-bypass-counter
  We changed from using a integer variable to a __percpu variable. Using an integer
  was causing some race conditions when updating the "raid_bypass_cnt" value. This
  lead to unreliable results.
  Found by internal testing. No known externally reported bugs.
* smartpqi-revert-propagate-the-multipath-failure-to-SML-quickly
  We are reverting commit 94a68c814328
  ("scsi: smartpqi: Quickly propagate path failures to SCSI midlayer")
  because when encryption is enabled, a false path failure was being reported to the SML
  causing multipath to fail the path. This was because when encryption is enabled,
  the controller temporarily disables our Accelerated I/O path which caused the
  false path disabled detection. Disabling the accelerated I/O path can cause
  some performance degradation.
  Found by internal testing. No known externally reported bugs.
* smartpqi-improve-handling-of-multipath-failover
  We are better aligning error codes retuned by our controller firmware with what the OS
  is expecting. This improves multipath failover detection.
  Found by internal testing. No known externally reported bugs.
* smartpqi-update-version-to-2.1.28-025
  No functional changes.

---


David Strahan (1):
  smartpqi: add new controller PCI IDs

Don Brace (1):
  smartpqi: update driver version to 2.1.28-025

Gilbert Wu (1):
  smartpqi: revert propagate-the-multipath-failure-to-SML-quickly

Kevin Barnett (2):
  smartpqi: improve accuracy/performance of raid-bypass-counter.
  smartpqi: fix improve handling of multipath failover

 drivers/scsi/smartpqi/smartpqi.h      |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 176 ++++++++++++++++++++++----
 2 files changed, 151 insertions(+), 27 deletions(-)

-- 
2.45.2.827.g557ae147e6

