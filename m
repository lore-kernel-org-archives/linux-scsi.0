Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB12E573;
	Fri, 10 Jul 2026 00:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783642019; cv=none; b=YV19KzgTf2Eq5KjWr0Bx8Q+M3WBr5N91YjPCij+vf43ypoL+4psaZjrac26Ogy+koHBQj3GF23nS6JsXDrdQ26CBE4yq1KrwMuAmJwNNbjIxxJXEll8Y5ocBv7ojXT2Oqh3X8H5CH3TNcW3WvOct5UUMhZSC0Wr6JJhGTDSgJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783642019; c=relaxed/simple;
	bh=lTwaLinAHSqeLb259F8j1UrmYjmdHoA3SqD0uOsJr44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TGNj1WZz/wKrX+ZuhM+ONvk/SgB9RWh/CnzmCQUURMQ1y7NdQjmxA+AeIX1ZqEETNjWL97m9updik1NY0qngNADCV3Taft/e+jwp294Upf+NoQsEEGaoaq5CT1b0H1kOHGgeMhaKOdb0MZjrRPrtRgFYyMqk9DO9zzMD+rE8MJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kAcNaq4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAcNaq4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C751F00A3D;
	Fri, 10 Jul 2026 00:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783642018;
	bh=PrdV6GFdrZIUh+K4nr3JOjWt600LeloBZo5gNCn6/iI=;
	h=From:To:Cc:Subject:Date;
	b=kAcNaq4HZjjDiiLhBCM7hXVOINn2XPy+3LRwh5XaO+is90Sb7GkLbTB7Jx7K76jYE
	 yJG9nZR4NnX09OXbmOJWSwMb/B3jSnle9lbA4uKXoS0wbNi5B6n/Ox4WUYaYbuRr9Z
	 QVeD87INauXOnMMXZk9redYw7YykSHBSbi3fcPcwAkRCmOmlYT7RYY3qyjyDhAXGzt
	 sM/+tEs11mI+UYtpM1IYj+9U800dBPd1TMxpxu9IAf+4OLJ3jziUTQuBl9T3ryXFti
	 ldrfLpPP1VS+ryqgckPAk742Dufa7S9sXbaaFbESRs/DDrRDOGagL8HhfPWqydzh7j
	 i7Y+Ikjnnua+g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 0/2] fixup handling of timeouts with deferred QCs
Date: Fri, 10 Jul 2026 09:06:44 +0900
Message-ID: <20260710000646.1202200-1-dlemoal@kernel.org>
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

Changes from v1:
 - Modified patch 1 to ignore timed out deferred QCs in
   ata_scsi_requeue_deferred_qc() to let ata_scsi_cmd_error_handler()
   correctly handle this case.

Damien Le Moal (2):
  ata: libata-scsi: terminate deferred commands on time out
  scsi: libsas: terminate deferred commands on time out

 drivers/ata/libata-eh.c             |  2 +-
 drivers/ata/libata-scsi.c           | 52 ++++++++++++++++++++++++-----
 drivers/ata/libata.h                |  3 +-
 drivers/scsi/libsas/sas_scsi_host.c | 17 ++++++++++
 include/linux/libata.h              |  4 +++
 include/scsi/libsas.h               |  2 ++
 6 files changed, 70 insertions(+), 10 deletions(-)

-- 
2.55.0

