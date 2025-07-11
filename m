Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84536224225;
	Fri, 11 Jul 2025 08:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223083; cv=none; b=AkxlvSR06TjZCTdSwlC3b0lhcFQomySYLixOcodLo0cydpLdxFEjGyPC8TLocVVTP2ltAzLaKoZfK2cxxs1eB1fkki0eC3Vejh0OXKjM/iYhj+TJ/WkHupx/MLzI/JZi8jUVqD3jlRaZMBEGtGpbrfEi5qrDSvId+YluIYsE6vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223083; c=relaxed/simple;
	bh=w7nJAyKMJeNsji0yABYkpY6JqH3Uaae1SEeF2QVYZDE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw8AHdQyPNeeby/blOU9Lr0mTgPcIDiLhUzsF9re7TYJ/TCTqGqq9dByMoPyLgmA0LnsVoMVFSsGndk3cH/lYrLvDSA+bLO0e+vKg3wNTc/BH1F8WlIFyh+9GXX0y05kh7dwFQcT/TVzBUk5GAyFxjiyucPEn8PMR3UQU1not1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyafU+oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyafU+oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9644C4CEED;
	Fri, 11 Jul 2025 08:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752223083;
	bh=w7nJAyKMJeNsji0yABYkpY6JqH3Uaae1SEeF2QVYZDE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SyafU+ozG9vN0WrDwrJrWAGDjwS3OPWaCRHloAKg3LVqqUJh5S7h+M+6WUcy/5XCw
	 h5c5/x5zMakXGThqY8Xsjz/z8bNs2WQVZkebnd0Jy3ECMePPN2Fp41efRNuBG34diJ
	 wE4uXwlPG9kLq1AVrxI/yxKrtmupzUdVvq1t2K090/qUIPb7VGdYCMRY2jq0NVVZlc
	 gcnxDT20KjYaGg/9+FoQeHF5HZfO3SUzt7ahSb1UH4hkCbLqKmVgt0PCGs1qaiuM6z
	 Uc9hb+kmXOs9EbwQhBe4Zqd8TZPahvQzzsolrD5IpoBW6zgoAfVaP6tAt44buzPDHi
	 PRv1spAYcUyjA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 3/3] Documentation: driver-api: Update libata error handler information
Date: Fri, 11 Jul 2025 17:35:44 +0900
Message-ID: <20250711083544.231706-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250711083544.231706-1-dlemoal@kernel.org>
References: <20250711083544.231706-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update ``->error_handler()`` section of the libata documentation file
Documentation/driver-api/libata.rst to remove the reference to the
function ata_do_eh() as that function was removed. The reference to the
function ata_bmdma_drive_eh() is also removed as that function does not
exist at all. And while at it, cleanup the description of the various
reset operations using a bullet list.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 Documentation/driver-api/libata.rst | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/Documentation/driver-api/libata.rst b/Documentation/driver-api/libata.rst
index 5da27a749246..93d97fe78e3f 100644
--- a/Documentation/driver-api/libata.rst
+++ b/Documentation/driver-api/libata.rst
@@ -283,18 +283,25 @@ interrupts, start DMA engine, etc.
 
 ``->error_handler()`` is a driver's hook into probe, hotplug, and recovery
 and other exceptional conditions. The primary responsibility of an
-implementation is to call :c:func:`ata_do_eh` or :c:func:`ata_bmdma_drive_eh`
-with a set of EH hooks as arguments:
+implementation is to call :c:func:`ata_std_error_handler`.
 
-'prereset' hook (may be NULL) is called during an EH reset, before any
-other actions are taken.
+:c:func:`ata_std_error_handler` will perform a standard error handling sequence
+to resurect failed devices, detach lost devices and add new devices (if any).
+This function will call the various reset operations for a port, as needed.
+These operations are as follows.
 
-'postreset' hook (may be NULL) is called after the EH reset is
-performed. Based on existing conditions, severity of the problem, and
-hardware capabilities,
+* The 'prereset' operation (which may be NULL) is called during an EH reset,
+  before any other action is taken.
 
-Either 'softreset' (may be NULL) or 'hardreset' (may be NULL) will be
-called to perform the low-level EH reset.
+* The 'postreset' hook (which may be NULL) is called after the EH reset is
+  performed. Based on existing conditions, severity of the problem, and hardware
+  capabilities,
+
+* Either the 'softreset' operation or the 'hardreset' operation will be called
+  to perform the low-level EH reset. If both operations are defined,
+  'hardreset' is preferred and used. If both are not defined, no low-level reset
+  is performed and EH assumes that an ATA class device is connected through the
+  link.
 
 ::
 
-- 
2.50.1

