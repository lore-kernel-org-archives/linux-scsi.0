Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D0A3B6C11;
	Mon, 20 Jul 2026 07:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531703; cv=none; b=mnWiasBkmv+q1ZkdhTCA9IOoHZeF/mHlLQkVT3fBXcvqv+F5XR2xVqd4ZI9KiK7mMPu+HNaKthrMXxXTx41k0+milfG4LaBhyHl7Rjf/S2GisFu7LobbuSsIc6AGggczaAxGkcNcVmvCsBDoIY3hlldt2dlv9ndfVvm5zzEYbnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531703; c=relaxed/simple;
	bh=NMcDQr4h4W2ZA3BgsmBachkhYQDMSCW4cuV+34wLohE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lZHpJ4EP+p0m5Mw0SP5Y37JiKTalH7AFGevD9ZEsdOvM27BG3L/ur3XqePR98KXBsEb9Nw0WK2b8zN/VaIJGeLqC3JPSXgoBF5RwNtob5zCC5hGHdeH6D0dPW03wRL+MouFs6JpZvhYNAkkeVuG7lqK6crG4oWMOnYW2+zBsUik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I93MVScE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I93MVScE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A851F00A3A;
	Mon, 20 Jul 2026 07:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784531702;
	bh=wCAFIAAF+wjQnhJY1XJgtZlwujhgHnnhlyotzR3W7nU=;
	h=From:To:Cc:Subject:Date;
	b=I93MVScEbdVH+PhKiB+KR8JeXhVk+RraVu52pFdCTZn3cRtKEE+fnQdm15oxe+uqy
	 8wfuBU4Ksz4+jrGCSjRSZdPr3PE8NpCxXI29xzUNwP1dGkD9WRvdCQnm83jhARV6IC
	 DFwyZ04qblG4vvrQg58rnYWcZqv3ubK/EhHRLsUJXhmQZ6hhQ0gm4jrIX2B6MQmW4m
	 c2o/RvLgvODjUsf/4wm++Yi6KVwVhyjqpLlTPIPIu+D7XzxDdy54vAnOm8Sil/Xd7d
	 Y0g+GIMvI7n/At1tooSz4+PFH6CZXuAZurFB8DReLpcIISdrB+RknA1hhOHA04uLL6
	 2/MOu/2Vm9JYg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v6 0/2] fixup handling of timeouts with deferred QCs
Date: Mon, 20 Jul 2026 16:14:48 +0900
Message-ID: <20260720071450.1877625-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series fixes libata and libsas to correctly handles deferred
queued commands in case of a timeout error, to avoid excessive delays in
waking up the scsi EH task.

Igor,

My apologies for the churn, but please retest!
Also, I added your Signed-off-by on patch 2 since half of it is yours.

Martin,

Once reviewed, I or you can take both patches ?

Changes from v5:
 - Reworked patch 1 to have deferred command retries all go through libata
   EH to ensure that we do not run into issues with the block layer
   immediately re-issuing retried deffered commands (which would create
   again the problem we are trying to solve). This change necessitate the
   introduction of a new QC flag and changes to the completion path for
   commands to ATAPI devices.

Changes from v4:
 - Simplified sas_eh_timed_out() code in patch 2

Changes from v3:
 - Reimplement ata_scsi_requeue_deferred_qc() in patch 1 as
   ata_eh_retry_deferred_qc() so that all requeue pathes use the same
   function.

Changes from v2:
 - Modified patch 1 to avoid the problem reported by Sashiko that requeued
   deferred QCs may be re-ssued immediately by the block layer, thus
   potentially keeping the device busy. The modification now relies on
   libata-EH to perform the requeue instead of immediately doing it from
   the eh_timed_out operation.
 - Modified patch 2 to use the new helper function defined in patch 1.

Changes from v1:
 - Modified patch 1 to ignore timed out deferred QCs in
   ata_scsi_requeue_deferred_qc() to let ata_scsi_cmd_error_handler()
   correctly handle this case.

Damien Le Moal (2):
  ata: libata-scsi: terminate deferred commands on time out
  scsi: libsas: terminate deferred commands on time out

 drivers/ata/libata-eh.c             | 48 +++++++++++----
 drivers/ata/libata-scsi.c           | 94 ++++++++++++++++++++++++++---
 drivers/ata/libata.h                |  2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 15 +++++
 include/linux/libata.h              |  4 ++
 include/scsi/libsas.h               |  2 +
 6 files changed, 142 insertions(+), 23 deletions(-)

-- 
2.55.0

