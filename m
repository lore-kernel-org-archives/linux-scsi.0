Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A449B19E7D0
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749796256; cv=none; b=N4pXjLi87L2/jGumU7qZy+qBohUcsHPhcLWxMG+N55iV/pVmIag7QZoUzeOx8BeY5ObjThnS94/W2NZ+na4P0RfEp3Ymxzx8PVNFJ8nOQwy5pYCRBO4wZhHJ+er24EhPRyuriZKlEFS1Sfcyu4uvXaP/ce/UxNB98oCG79Ru/yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749796256; c=relaxed/simple;
	bh=6LhAjF+UjdZz4tKDZuBXsGh7Lg4w5x7n6zZ3UnkvR/8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JcY3VKgmgjAd0zsELQBraSBH5madk7WCUpJa4+u648Qnf0zF2E1tGd6ELx0LFMqafz1RSket0B2PxuT3unsMUgZKyVCKHVpo6k2pV7BaCpozbn/4BL/3gjJIyOtYLjDXugisTbe/SZ1Nrx2yNSNBvKokOzVuP/P2Uc2+DXDs86s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrXSY87e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrXSY87e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00DC4CEE3;
	Fri, 13 Jun 2025 06:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749796256;
	bh=6LhAjF+UjdZz4tKDZuBXsGh7Lg4w5x7n6zZ3UnkvR/8=;
	h=From:To:Subject:Date:From;
	b=SrXSY87eKo9NB2yT6VCCxCFSFzI9YtbW/1y4GIft81PASck1rtMjdLe6llb8Qj4Xx
	 64P0iSu/6HNKpMWYPlMsYx5rhxP74lVHiN5HkE0QbpDvQ8vOC6JnGM5x7rJ5fbYEzv
	 ZDXSPjVafZjGdXdfUZx+3Kcl7EZX79PotGlIJXV8i9TXfDCaVdkX80Be1xMew1dD5s
	 8hcb90J42LQ5pI+0pnlPt6irbVilP+uKq+bGfQxDanbk2ALpvQWre0v9BgLL6e91Jh
	 50zD1H0W2Ic3bU03TeTNSxXMsA+qy3Dsv5YEpEdyeElYjHAaRjUi3lQCRov5RMgJeu
	 VbzhPuo3Az/Xw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 0/2] Improve optimal IO size initialization
Date: Fri, 13 Jun 2025 15:29:07 +0900
Message-ID: <20250613062909.2505759-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple of patches to improve setting the optimal I/O size limit of
scsi disks. A fallback default is added to make sure we always have a
non-zero optimal I/O size so that file systems operate with a
reasonnably sized default read_ahead_kb value, for improving buffered
read performance.

Changes from v1:
 - Changed message level from wrong WARNING level to INFO level
 - Added review tag

Changes from v2:
 - Added patch 1
 - Make sure we do not overflow variables and limits in patch 2

Changes from v3:
 - Change logical_to_bytes() to return a u64 in patch 1
 - Added review tag to patch 2

Damien Le Moal (2):
  scsi: sd: Prevent logical_to_bytes() from returning overflowed values
  scsi: sd: Set a default optimal IO size if one is not defined

 drivers/scsi/sd.c | 45 +++++++++++++++++++++++++++++++++++----------
 drivers/scsi/sd.h |  4 ++--
 2 files changed, 37 insertions(+), 12 deletions(-)

-- 
2.49.0

