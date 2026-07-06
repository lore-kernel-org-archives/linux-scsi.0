Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85019481648;
	Mon,  6 Jul 2026 06:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320988; cv=none; b=FiWSrQL89Chin/kXyMl4l/2/hsU5t2k3Pw3W7gxruSlG0mI7BodsM+2TI0w+t72UvfYpUjfTWyyQyFamQ7uky6gtO5uAWIYcOfehx9y78/uwD1rRnS4Tlb4R/YelJS22u1tWWRiIxIZHMnERGcFux8qNX1bfhozDr45L5JYHHFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320988; c=relaxed/simple;
	bh=r6PABZt7ILwhpo+ZIZ26JMI2EtSIjYao7FKvKAliuqM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QCKseZDsliVLkwKZ/mcWZXDXceRg6ffDVlnZGuUX60+va6wjswhKDAuFixemcav79r6VRQPqiAx1DP25vNvEk/Z7G/edyRGY5PhgrsKL8MeRJoE4GPPuNmywQNpoGrQgpzdRYC1WU0uZAetD9VWsFg6kN0y43WfLT6BS2dy29d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rq2mKXsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rq2mKXsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A031F000E9;
	Mon,  6 Jul 2026 06:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320981;
	bh=zTdCcxi6QeqNZVUmL/kMNNdgXQn+3026HQntWeXcHwA=;
	h=From:To:Subject:Date;
	b=Rq2mKXsdBYAt2c7MsuhLTKYv+LHnD1kJCgPEZwGmZyKJw0e2WUsLmdx4+I5LcBr9d
	 o6ReiWycs6F5ayv7bYkO+mFzDWQXcXbLRh5PnvhuDkZcRcDrwLsqmTjVicSf6nU8M4
	 yaWRsvqQRcrE573YyFe8gtvqE4lp40VvihSI1FFyTeoV7rBz3xJaKVo1OqMKBTioEF
	 diTUWHg7BSCm9AEArJWutw7DXxPDbs66iPgkarJ2+APrS7vRvI8IikCKLq6+o6L8/a
	 LN1BPlHCHdLvUJUCweE7fOctkreJhZIdsZmJ0X6aA04C2XZKB/qS3ItMCNM1jfvPJ/
	 mlWEUPiCZX4Fw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 0/9] ATA support for storage element management commands
Date: Mon,  6 Jul 2026 15:56:01 +0900
Message-ID: <20260706065610.3559692-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support to libata for translating all storage
element management commands:
 - GET PHYSICAL ELEMENT STATUS
 - REMOVE ELEMENT AND TRUNCATE
 - RESTORE ELEMENTS AND REBUILD
 - REMOVE ELEMENT AND MODIFY ZONES

The first 2 patches add definitions to scsi_proto.h related to the
depopulation feature. The remaining patches modify libata to detect
support for this feature and add command translation support.

Martin,

I have more patches for sd and scsi_debug (depop emulation) that depend on
patch 1 & 2. So I am not sure how we should handle this series. Maybe we
should create a "depop" topic branch in the scsi or libata tree ? I am
open to suggestions.

Damien Le Moal (9):
  scsi: scsi_debug: move ASC and ASCQ definitions to scsi_proto.h
  scsi: define depopulation capabilities related service actions
  ata: libata: improve the definition of device flags
  ata: libata-scsi: improve ata_get_xlat_func
  ata: libata-core: detect support for depopulation capabilities
  ata: libata-scsi: add support for the GET PHYSICAL ELEMENT STATUS
    command
  ata: libata-scsi: add support for the REMOVE ELEMENT AND TRUNCATE
    command
  ata: libata-scsi: add support for the RESTORE ELEMENTS AND REBUILD
    command
  ata: libata-scsi: add support for the REMOVE ELEMENT AND MODIFY ZONES
    command

 drivers/ata/libata-core.c |  73 +++++++++-
 drivers/ata/libata-scsi.c | 300 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_debug.c |  46 ------
 include/linux/ata.h       |   4 +
 include/linux/libata.h    |  90 +++++++-----
 include/scsi/scsi_proto.h |  74 ++++++++++
 6 files changed, 493 insertions(+), 94 deletions(-)

-- 
2.54.0

