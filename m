Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396BA3655C4;
	Mon, 13 Jul 2026 04:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783915986; cv=none; b=mrY3OCAptOmlBr35aBoDm8DkxJuyggh1IU0F4qjc85JaduGcRWFPH43BtFQ2WZPfxqYSxVsNOgjFxe8Qv2r13a4RpxAkPCdsS19nQujNhtcn1JRcdEbd6Ez3pTxzVGGdFGf7xQwRl28j9EtU4M9yRzxJ18NFVIyYF9KDscQHwiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783915986; c=relaxed/simple;
	bh=XQnIHsAq1lfQsXXAkXOcd3hsqPZfVibdtGmc909bNbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mm1n7JBzarHBgHwmJNh8AutFVaZg/6bDb0BuJjMQvsMgsPZVkJLkZ7PJVwIzJElkdorc5GNQoAJo6krFC4mi9E9zUm8steFhykcJ07no01M0pL0urUpJPE3R7i2MPtG9Dd2FRpWhyIE9KSNu+fBE2y3NhPVHFiUD2g70Lp3xSC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HN9GkXvr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HN9GkXvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021F41F000E9;
	Mon, 13 Jul 2026 04:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783915984;
	bh=ikdhwQZU+pv/raEuEWAGFF59fM6qg8XunfK6LSs8Gbc=;
	h=From:To:Cc:Subject:Date;
	b=HN9GkXvr9+Ts8H11KyRTHmHtlYU83D6UGJh06wfJixoNa4gQEh8O/ZPLXbBeoHW4e
	 5ZvmUA7tlTu7wly6eEDhvmhzYMh+LNt2J8pMrJaZ4kNMbZyIOJXN6Cwm4zXIYZygiJ
	 m9YGPQ+WuHM15ErFzjt6U68vbu54RIICMzGFE9Clqz/GGsA6wxc50OQtnFC16Be/R8
	 PBear33S4MWG0kUauuCsCT2V8LTjXfsp3BIF/tXcN9ffWGo9FznR1PjzaW57mdXNCe
	 lS/t43JXD9CQfEwyyIqgP6zCiY0rGbf9ZkG159ShqZAdeWpdQjp9gVDLme1Z8DrpzJ
	 MK62faMzqC3lw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 0/2] fixup handling of timeouts with deferred QCs
Date: Mon, 13 Jul 2026 13:12:50 +0900
Message-ID: <20260713041252.463401-1-dlemoal@kernel.org>
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

My apologies for the churn, but please retest !
Also, I added your Signed-off-by on patch 2 since half of it is yours.

Martin,

Once reviewed, I or you can take both patches ?

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

 drivers/ata/libata-eh.c             | 36 ++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c           | 22 ++++++++++++++++++
 drivers/scsi/libsas/sas_scsi_host.c | 17 ++++++++++++++
 include/linux/libata.h              |  4 ++++
 include/scsi/libsas.h               |  2 ++
 5 files changed, 80 insertions(+), 1 deletion(-)

-- 
2.55.0

