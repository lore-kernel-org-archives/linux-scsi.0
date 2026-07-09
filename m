Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667A83F44F9;
	Thu,  9 Jul 2026 08:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783586388; cv=none; b=Ny0a/OesfVc/YT5PiDLRO7CJRqtADlvEJd8ypR2xTLN9jTebZhYV8hXQa0Ca04ZkBBsmLoLSmv7EofTAhB1yfHTmxDFHk09qcUlAk4Lx9RTzU1gBgCGG7zqkhTeKKWzbT8zV5/AQIf0aEowGxE1rO0avKEfdELtJT5mz9plk4uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783586388; c=relaxed/simple;
	bh=od5POB1oq7Vb9QM9xXwPAFl+S0K1hqG6OU0GA6YOpLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qldgmcZljOmwpBusoI6tC0bcyEzMGMLnNmHm7bCXtxawOiAhp5LRUJvkEGo/5ViYaSz2+wfnVye1z4lA1ag71EaveBnBcFGDynsJvOAosJHDGeaTjKbjLW7ClwEob5UMKzysB9bsxwStx68DJwIt8LyPvI2b1k2wQQ87lXL2r6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsGSIjYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsGSIjYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B6B1F000E9;
	Thu,  9 Jul 2026 08:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783586386;
	bh=wvXmSseieV6A7ZJeML9swtXB0QPe9U12rLYvxr9FdbQ=;
	h=From:To:Cc:Subject:Date;
	b=VsGSIjYpFXqHkscjQAxqX2DDyGJVFxcYP8qdx8No3vnIXsvTax8Ki8tzoAFDNBxJl
	 Gz3ZRnIwBLqh6bdmfqtGRyz2s7v9DTvEGmfwcNlALUIr2uSXnFYAuZJpfIBr2BS3qu
	 2Tspn5rhmgFhV64lqPkIQJzH/gXkP0Wj2hMAR8ZEUtfZNZohLCKZIb0smeiJ5elfv2
	 VzIQzKk78S11EWMD4GQlMIHecqU6I8yXEzyojcsk0q8ODaVhOg6H/yumhf30Ec5eq/
	 VXEh82VNf0o2EiAuiK4B0Q/tuf4OwFiLmhkQyDW65EkWhKuVrEK09gIqKNtFb6dJQG
	 9l24q8AoimuOQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v1 0/2] fixup handling of timeouts with deferred QCs
Date: Thu,  9 Jul 2026 17:39:32 +0900
Message-ID: <20260709083934.1116862-1-dlemoal@kernel.org>
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

Please retest !

Martin,

Once reviewed, I or you can take both patches ?

Damien Le Moal (2):
  ata: libata-scsi: terminate deferred commands on time out
  scsi: libsas: terminate deferred commands on time out

 drivers/ata/libata-eh.c             |  2 +-
 drivers/ata/libata-scsi.c           | 54 +++++++++++++++++++++++++----
 drivers/ata/libata.h                |  3 +-
 drivers/scsi/libsas/sas_scsi_host.c | 17 +++++++++
 include/linux/libata.h              |  4 +++
 include/scsi/libsas.h               |  2 ++
 6 files changed, 73 insertions(+), 9 deletions(-)

-- 
2.55.0

