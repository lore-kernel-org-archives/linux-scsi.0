Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE839D3DA;
	Thu, 16 Jul 2026 08:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191141; cv=none; b=iMKNjRyFqtnyH6nZsBOF0LJ7xkzav8cf4gWrBzQtQuPfsBvSC6tMts3y7tUglfGxrXGqkW14tbiiO97Zl8e1AeEYzXgeGp1jgxmSdUo0UvuyFlZgPf3Lsj5EjuUpFAHzb+v02pHfooM8OXOwMBbyGvU0Xqn/RLpbPx8JzwmK7Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191141; c=relaxed/simple;
	bh=N+rhb8cnbPRFkuJL6G78qJnUIRQPojtYdCFL74K+luc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AlMWtAS4gnDxqltZimKikeA0jmz4K5FTIb6MyYvTDFOsBK0JJnq3+kkfXArwZXIMDY1WiDVTkq30uZQDhPoghbj2jKv96TXcIZj78C88/aJsP37xucx3PpgJ586z8AEbIWsNNcD/NUGpurzU9V8BBMZthzodIlouZIjsVSHxQMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1ZbRWy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1ZbRWy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140591F000E9;
	Thu, 16 Jul 2026 08:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784191139;
	bh=MtJFdkp1ZtpjPJ8xkF5U7P+NBmGz1xvh/ILGWd7BpC0=;
	h=From:To:Cc:Subject:Date;
	b=C1ZbRWy7dJlEtMDgmeEo5BdKwo60fwutCcV0g60mBJ4aSQ2TSKMY1J5HK0+pKZZ4t
	 o/fDQihN/TAzFmcxdwDk6RgtlsqxVUztlk8ldU+2Fj7mD2iMCLrVgweuJMUw3W3F4N
	 b/0x06pL1bjd1ew8uvwHkPGzua4PfY9kJ8Ljr/YhJH/keBdNnbmyu3UnmeH7C/OyXB
	 fJO9KUjo8blTbHSqfEkmiBIhg8iPIimLzNP6+iEmruB8U4Sk2J0f1hMl6vSkowL++3
	 vbn/67pctDhFEM59tim66w2MVnobyLOIj+LeN8D2bxEjaJ2X+Pex4m06VfzrZ6ZPfA
	 TygvQjHefK0rA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 0/2] fixup handling of timeouts with deferred QCs
Date: Thu, 16 Jul 2026 17:38:45 +0900
Message-ID: <20260716083847.926102-1-dlemoal@kernel.org>
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

 drivers/ata/libata-eh.c             | 38 ++++++++++++++++----
 drivers/ata/libata-scsi.c           | 56 +++++++++++++++++------------
 drivers/ata/libata.h                |  2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 15 ++++++++
 include/linux/libata.h              |  3 ++
 include/scsi/libsas.h               |  2 ++
 6 files changed, 86 insertions(+), 30 deletions(-)

-- 
2.55.0

