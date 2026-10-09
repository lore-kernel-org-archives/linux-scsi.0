Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B562F34B1AD;
	Fri,  9 Oct 2026 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563226; cv=none; b=AzmlqLRFJomoKJ/wj7Fq3CUfuafv9Le50YVhJle2fcUWnCfB2E0GheHiJKbi49JdlYfpep+xGllhxiQL/y3BPqSbGdEn6IQxEqoMJod51cTkderqwr2VG/+BuGNusJuCm9dxkc7bOU7Tgi861jO+I5++/dLmSxW4tymTO2OnSqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563226; c=relaxed/simple;
	bh=4xILLf+4WhvYqe/5MPsixN7rxxWhrd/B2vzvi6GmicE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ttMM0vGJeaCTiCUVhp5gbT9e+4Fa5kJ3DWdTAhpN2A6I6BRcDc6P4L6LEYDasjZ0Jqf17GJXzFDa6jjZsVX3AigQvSXb5p6iseHFB0fRFSsHyb9ecCMmaXdsHEUTFwwNykMwXV+aSyGJmV7lKRyDtpE06N9gTJkzqnVsGd9lzw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=LqGJjWHC; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="LqGJjWHC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563213;
	bh=4xILLf+4WhvYqe/5MPsixN7rxxWhrd/B2vzvi6GmicE=;
	h=From:To:Cc:Subject:Date:From;
	b=LqGJjWHCE67eYOef9TWtI+h84Rg0B6NYTrU+PirWHIOR8wkuWVUw5PmUFf/nsubPd
	 L0/Htk+xSG/wcELy8JU5ua+h+neMtG9zGn2DUcyo4rQXsPHrkYscaP3bRuk42B4pO/
	 eRy742VAxuPjk3Al2iEBLuERxnCDNd9XI5fdaopQ=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 16A8BBE56C;
	Fri,  9 Oct 2026 16:26:53 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id D81C25FADC;
	Fri,  9 Oct 2026 17:26:52 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v10 00/15] ata: add multi-LUN support for ATAPI devices
Date: Fri,  9 Oct 2026 16:55:07 +0100
Message-ID: <20261009155522.593045-1-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds multi-LUN ATAPI support for Panasonic/COMPAQ PD/CD
drives and fixes stale CD capacity after media changes.

Patches 1-5 fix pre-existing ACPI/SCSI lifetime, OF-node reference and
ZPODD notification bugs and can be merged independently. Patches 6-9
fix port detach, quirk matching and sr media handling; patches 10-15
add multi-LUN support.

Set libata.atapi_max_lun=8 to scan LUNs 0-7 on BLIST_FORCELUN devices.
The default remains LUN 0 only.

Changes since v9:
- Add ACPI uevent lifetime and SCSI OF-node release fixes (1-2).
- Fix ZPODD initialization and wake-attribution races (4-5).
- Update all sr block-size limits together and initialize/check sense
  data before classifying TEST UNIT READY failures (8-9).
- Track resume/rescan completion per LUN and request runtime resume
  asynchronously, balancing PM references across retries (11).
- Attribute ZPODD notifications once per physical wake (11).
- Publish accepted SCSI devices under the port lock, serialized with
  removal (11, 14).

Base unchanged from v9.
v9: https://lore.kernel.org/linux-ide/20261006234202.1139018-1-philpem@philpem.me.uk/

Phil Pemberton (15):
  ata: libata-acpi: pin the SCSI device while emitting a bay event
  scsi: core: release the device tree node at final device release
  ata: libata-zpodd: reference SCSI devices in PM callbacks
  ata: libata-zpodd: publish initialized state before registering
    notifications
  ata: libata-zpodd: serialize wake attribution with physical power-on
  ata: libata-core: pin SCSI devices during port detach
  scsi: scsi_devinfo: preserve full-width quirk identifiers
  scsi: sr: keep queue block sizes in sync with the medium
  scsi: sr: retry unfinished media revalidation on the next open
  ata: libata-scsi: add atapi_max_lun module parameter
  ata: libata-scsi: convert dev->sdev to per-LUN array
  ata: libata-scsi: route non-zero LUN commands for multi-LUN ATAPI
  scsi: add BLIST_NO_LUN_1F blacklist flag
  ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
  scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk

 drivers/ata/libata-acpi.c   |  16 +-
 drivers/ata/libata-core.c   |  26 ++-
 drivers/ata/libata-eh.c     |  21 +-
 drivers/ata/libata-scsi.c   | 411 +++++++++++++++++++++++++++---------
 drivers/ata/libata-zpodd.c  | 110 ++++++++--
 drivers/ata/libata.h        |   8 +-
 drivers/scsi/scsi_devinfo.c |  13 +-
 drivers/scsi/scsi_scan.c    |   3 +
 drivers/scsi/scsi_sysfs.c   |   2 +
 drivers/scsi/sr.c           |  44 +++-
 drivers/scsi/sr.h           |   2 +
 include/linux/libata.h      |  16 +-
 include/scsi/scsi_device.h  |   4 +-
 include/scsi/scsi_devinfo.h |   6 +-
 14 files changed, 529 insertions(+), 153 deletions(-)


base-commit: 22430ae5d90ab288b0ee2ad99ae941f4a666b694
-- 
2.43.0

