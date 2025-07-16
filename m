Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEAB273807;
	Wed, 16 Jul 2025 02:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752631537; cv=none; b=jwaIcCoG37+yzID3x5MTNymg5kflWMkSrk3IoCeOZBUpP14tUt3ZJEaqPCswrGKaInWB0J3YhZpW9rDBVqJN2yxZd9l+brkHo0nimrIehblxF8xxDA4nU/w79A5yxPO/N0b7lJVzkstH0HV2Hn+z/llwouMdUC4vU4KF4RHhYEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752631537; c=relaxed/simple;
	bh=GQK6AiO3C46G7RFOzpBSeojor7lXjzqDAn+OIduLp6Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7xKv/iwssiNvqPKvYTvJt7H+vd5j0pyqU3qingHkaWcBUqUZWslEFLyBL/r1je6tgrCd4YDagt+gHAapbQfGLCeCFmFhSmzhFLirMYyHNHVOfwf2xi6tWwK8mREk58lXbeLQN8EI5rIByPKVWseNLVQdQKPerR75JVW9OjX3Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hc6uZway; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hc6uZway"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AC3C4CEF6;
	Wed, 16 Jul 2025 02:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752631537;
	bh=GQK6AiO3C46G7RFOzpBSeojor7lXjzqDAn+OIduLp6Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hc6uZwayHu40cU3XhUDZXOsz4QAlhYnUR4V8ldZ0DF2A64NwOvTYyrcDlrKE4s9qY
	 jPzKK8YzRuYaSpnJ0y3enf0hK7loIkXkXzbFbV2bhUrhQnig6G7uT//YVPqDYNnA48
	 yepY3S3sGDSYGktjBtmOu2NTg7CZYPRH38qw9iFCOsTUUHSczt8iAOeCYp7hBRfaYW
	 yi/ZNu1w/jMAtsYku05+zOmXd/NDQcJE9S22JBDb1mLGLHWW10djEvtepEgI+kMC4Y
	 g5ZEbhGR7H2wKPNsG646p7pFNy7NNZKAXqPqey6yElO4o7RlD/woPz7V1rJrWkCTO2
	 XcaOIr5aas4RQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 3/3] Documentation: driver-api: Update libata error handler information
Date: Wed, 16 Jul 2025 11:03:15 +0900
Message-ID: <20250716020315.235457-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250716020315.235457-1-dlemoal@kernel.org>
References: <20250716020315.235457-1-dlemoal@kernel.org>
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
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

