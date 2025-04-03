Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549412E62D4
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715316; cv=none; b=Q9Gt21uE0E7BYSGqVdw79MUwpx098xwSD9yA1N4o1GX9lmq0lREB8R17u9jV8A0gtZoyOMm+l95pAl53fmZaoYFMfIhhfL9RhSFFH8euQ8lLChpO8uUHULQILIkxjAomFY6G/ViQiwsqJ8av7EsdbJj2/+h2NI1eqKDgJOTe7W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715316; c=relaxed/simple;
	bh=we5tJTolw5aBZ8H+WkMA9LMcMmH0F6faI3LDPAc9TzM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dn2quXFaIbHy9rkF4M8LDKKErSuvEcgNkcPX3ezLP2b093fXdVJ/AqSjgkNrqFtJSsSkXe95p7Le2Al/D6ZK35uPibsZX+WIPCCq0VRf/ZvLqErH80XTQLZGYLJoQWbPLzDjlTQa7j1yGyMyvtu2HK64L77a2AemG3cfeHkKCjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w59Q4/b0; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w59Q4/b0"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF4M3Ly5zm0pKK;
	Thu,  3 Apr 2025 21:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1743715186; x=1746307187; bh=ONkm/VcPo7SpCBbuTYUIASGA0ESRFY4DYvB
	n7C18rqY=; b=w59Q4/b0ca3SkACt6a2G+Wou8g/rRtli895nhbkkdNO5Uuis6o2
	p9goysk/jUd9+aSIllCrjYOBChj5BNjRVB7yhcGFUpLunoLz07+McSi5wOArx2pH
	3Fq4bN0Q8PSE3SVQG5wxK+chYDpFa10j4xToIizjRwlU+O3lIcoy5cGBK2qCz4fD
	gS5jKXcpFwBonKoHEJ/PbSlSFyFRF2dvcD6SK5dv4zKwnxxOy50dttIs9oUBfap1
	ZBjEKzEVFkNUFYlQ25jfkaHWzWtCvhC4cI/4v28LXve8Lw/De1BnG4F5XJ8Vt49w
	+BcjPKIw16A76OyDQ+dSTwE6vtTwXzQ4NqA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q3fW3nPv1ySC; Thu,  3 Apr 2025 21:19:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF4J6tcZzmWRtQ;
	Thu,  3 Apr 2025 21:19:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/24] Optimize the hot path in the UFS driver
Date: Thu,  3 Apr 2025 14:17:44 -0700
Message-ID: <20250403211937.2225615-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series increases IOPS by 1% and reduces CPU per I/O by 10% on =
my
UFS 4.0 test setup. Please consider this patch series for the next merge
window.

Thanks,

Bart.

Bart Van Assche (23):
  scsi: core: Make scsi_cmd_to_rq() accept const arguments
  scsi: core: Make scsi_cmd_priv() accept const arguments
  scsi: core: Use scsi_cmd_priv() instead of open-coding it
  scsi: core: Introduce scsi_host_update_can_queue()
  scsi: ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace()
    argument
  scsi: ufs: core: Only call ufshcd_add_command_trace() for SCSI
    commands
  scsi: ufs: core: Change the type of one ufshcd_add_command_trace()
    argument
  scsi: ufs: core: Change the type of one ufshcd_send_command() argument
  scsi: ufs: core: Only call ufshcd_should_inform_monitor() for SCSI
    commands
  scsi: ufs: core: Change the monitor function argument types
  scsi: ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
  scsi: ufs: core: Rework ufshcd_eh_device_reset_handler()
  scsi: ufs: core: Cache the DMA buffer sizes
  scsi: ufs: core: Add an argument to ufshcd_mcq_decide_queue_depth()
  scsi: ufs: core: Add an argument to ufshcd_alloc_mcq()
  scsi: ufs: core: Call ufshcd_mcq_init() once
  scsi: ufs: core: Allocate the SCSI host earlier
  scsi: ufs: core: Call ufshcd_init_lrb() later
  scsi: ufs: core: Use hba->reserved_slot
  scsi: ufs: core: Allocate the reserved slot as a reserved request
  scsi: ufs: core: Do not clear driver-private command data
  scsi: ufs: core: Optimize the hot path
  scsi: ufs: core: Remove the ufshcd_lrb task_tag member

Hannes Reinecke (1):
  scsi: core: Implement reserved command handling

 drivers/scsi/hosts.c             |   3 +
 drivers/scsi/scsi.c              |  26 ++
 drivers/scsi/scsi_lib.c          |   6 +-
 drivers/scsi/scsi_logging.c      |  10 +-
 drivers/ufs/core/ufs-mcq.c       |  31 +-
 drivers/ufs/core/ufshcd-crypto.h |  18 +-
 drivers/ufs/core/ufshcd-priv.h   |  27 +-
 drivers/ufs/core/ufshcd.c        | 660 +++++++++++++++++--------------
 include/scsi/scsi_cmnd.h         |  17 +-
 include/scsi/scsi_host.h         |  24 +-
 include/ufs/ufshcd.h             |  11 +-
 11 files changed, 487 insertions(+), 346 deletions(-)

