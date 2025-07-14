Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502F51891A9;
	Mon, 14 Jul 2025 00:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752454637; cv=none; b=ciqGVlKOdk2tRGWsPGIy6EGv2tE9RouOAp6JJklhomabPmC+toSuchF0tgbDaGljuY9RQLpNFBoaw1wSMUyVMt//pHs20dgUN3X/Aw9JzlKmCcVA5YoLPpG0hLhtVVjhHh7ApC8jDNj0FVIQg46q84hEiFHhKAT/VdKF0kQ1ZYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752454637; c=relaxed/simple;
	bh=eW/jivSov9F+lXX38FsF0bfO1OEUUoclNzzAU9OL58E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV3oUlXv0JfM5mb5fma832FNq55mp6Cp+Ywc1M4IdjF+4vR+XtxK4GxWxt30uHasBB9jE5XNFXwfSjiio+NffrSMT6i/MFUnxtEBX+kM6na8t4dCT2riPPoLEF4bQObIkIEXTzJUgJylUXskhrsEx93u4OwN5OSIMggolepxJgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FT2TIk5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FT2TIk5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EFBC4CEF4;
	Mon, 14 Jul 2025 00:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752454636;
	bh=eW/jivSov9F+lXX38FsF0bfO1OEUUoclNzzAU9OL58E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FT2TIk5fBN3Yle+dSFKfaJSpP99G3LzgQwGFo6yGxhOgYcU4YWFTVzC3iuONXqBDh
	 sRtLQaiWCu1TKP5kUXQuBu/3GH6ZvsFQWvFZWpO1WlAZ8XpVCv/W8odCAVKvqTqBJY
	 V9Ax1rDB3CC7DEOYt0n6QDbanuX2tN/64AkBBTUV1lFC8yFzWKxNvAZlRse7oVj5ls
	 RW1x+JsPtctNTnMN+1FfYlARbDSQKEfoVpBd8YKG4RWCPVDBP4ufrX/CgAVLByxQzN
	 kIImPXtvWb3hiL3ysIFlmfEtN9A3cW7rm1bo3pWpyVMtXjZKUSpAHfTDewdXIqIQ9I
	 TJSYlw47IQtOw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 3/3] Documentation: driver-api: Update libata error handler information
Date: Mon, 14 Jul 2025 09:54:54 +0900
Message-ID: <20250714005454.35802-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250714005454.35802-1-dlemoal@kernel.org>
References: <20250714005454.35802-1-dlemoal@kernel.org>
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
Reviewed-by: Niklas Cassel <cassel@kernel.org>
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

