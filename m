Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6E7F9E8
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 05:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753249291; cv=none; b=teqZCWrewMOQ5+rjo7WV06angPMcYwTW/nNEcO2FaWbVqKa0oEZWOQWEyTHAiPSP/YXAxRmwBxoBlGVlf4DFuBPcMfNkvNivFN738Nh6RK7DjTg8466Gk2dTfwGKdd1G3iZJmocFQEcqKrzxIyBYJzkYh1q9WMGhm8Qq4YFEbZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753249291; c=relaxed/simple;
	bh=vGiVNJOoEIMYhMbAibGhZcrRJAVWg2B4N6s46wfWwlg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rBZ1gzYTjW566Pq4gppt8YKv21FNIFhceWFbMwpG838gZ0YmtdHrMFPcs9h/FcMafjZZ9a71mW1lHlJ4hzpVCJJA785NptkSnRhR58UFiXkkTUpgE40Dhh9+/7XEENNSfN6D0+2SqMMX9Hvl1+kK7EI1quSZInIvHpUMR7xlYJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKWw9+DV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKWw9+DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830DEC4CEE7;
	Wed, 23 Jul 2025 05:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753249290;
	bh=vGiVNJOoEIMYhMbAibGhZcrRJAVWg2B4N6s46wfWwlg=;
	h=From:To:Subject:Date:From;
	b=XKWw9+DVzGSj3TkGynBN5BRa81KTmhwLEoTunVUlVMvpIG8UUCGWexSoMiftI7zOn
	 UYl7m1RWwEqPrj3kwUTthrLYRRg5ihzEQ9kapqrDzkVc8vCqb+76YJZDhIbopiAt7a
	 K0vMgt0FPCeLZq5ej+ILKkSFoz84c6gnVYIQW3lZX1vrNs5Bt63MUy8SCJTRcMrsjC
	 KwQq5rd0jbWNHsAdyVyetyQWmFNA+ChHYcfLJuWRylKdwpjyeJvcJlFN4ZRJ0fjDgX
	 +3770Xvr+wrg9RXEVmGR8OlJtXW9VuVwqSBMSljr5SwMBzOvkIAR6fsmVbDyOWfMzA
	 1zuADRR6yIi3g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/4] libsas cleanups
Date: Wed, 23 Jul 2025 14:38:59 +0900
Message-ID: <20250723053903.49413-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin, John,

While debugging an issue with the pm8001 driver, I generated these
cleanup patches. No functional changes overall.

Damien Le Moal (4):
  scsi: libsas: Make sas_ata_wait_eh() inline
  scsi: libsas: Make sas_get_ata_info() static
  scsi: libsas: Move declarations of internal functions to sas_internal.h
  scsi: libsas: Use a bool for sas_deform_port() second argument

 drivers/scsi/libsas/sas_ata.c      | 13 +----
 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_internal.h | 84 +++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_phy.c      |  6 +--
 drivers/scsi/libsas/sas_port.c     | 13 +++--
 include/scsi/sas_ata.h             | 74 +-------------------------
 6 files changed, 94 insertions(+), 98 deletions(-)

-- 
2.50.1

