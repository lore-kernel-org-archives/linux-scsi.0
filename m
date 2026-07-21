Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C05D3C4B93;
	Tue, 21 Jul 2026 06:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616040; cv=none; b=rVvVMHXmCxtqWayR79LeuAXJUwVvTHBWrsOv4Dxz3oqo6pQzMd4i4qCmZkxLRj4tL5nIQuspKuVEjcnDw70cfCg9qLP1wm2wp+PIh7Fuvq4C7GOV8EFer6vRakEqfhnhmy3qSpN4sO+uZrUi/yDgxNhqj0OqElg5L8Fskk0EDfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616040; c=relaxed/simple;
	bh=xT9g2GjO1dsYM3VIODV6tNLUevUl9qHJFp7R948v9IA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TzeL+3GARCbvJKiJHFiu7t5j/XyiQn21h0UB10N065vStRZmrNTHurJnlBAijUO3DSNOUM8EhDBmLafgcoemMTukfBH9fCWhLvOoCyEXu7kSRLmo3WntxUqCpfXlz/NMp8FXUswIMh6336BJgKCT3duoC8tE2C33QPNAExBX81k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kH3Ym0ms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH3Ym0ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5781D1F000E9;
	Tue, 21 Jul 2026 06:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784616039;
	bh=g3ePDX3M/XdmNKR4grkEL/SQkRgndCBGDDnz57Wh8a8=;
	h=From:To:Cc:Subject:Date;
	b=kH3Ym0msoVpKQEFoZIteMqpOl14uIwfrPXkVvVRsE1NNv+96SsWceidVl9eFe3md5
	 I1I0tpZleG9qjLw+DleZDtRDakEfbSsbvEB7WUn177uvkSMiw80xBf2nrK9xpLnniD
	 dgFTeh50ZRUCyiczI3x8/FuzOnr3eYWmjNEEC06bMMLFbFL+rn6VphvWFa+nZPMZqH
	 Kt5apsXjl1NnCsKRo+zZTR8Y7c3Al0uCKeDu/yLndMXmggArFRFZUuEft0SeqgjGwS
	 tw94kDnYnnPDXLVnpbA1/j+Ng5vIgA+el2jzNGoX2qTMz89AAq3DPgAxLNF9ivwYz0
	 MRLB4KDEVplEA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 0/2] fixup handling of timeouts with deferred QCs
Date: Tue, 21 Jul 2026 15:40:25 +0900
Message-ID: <20260721064027.2081195-1-dlemoal@kernel.org>
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

Changes from v6:
 - In patch 1, go back to using direct command completion for retrying
   deferred QCs, but adds libata EH trigger to avoid problems with the
   block layer immediately re-issuing the retried commands. This same
   method also allows directly handling timed out deferred QCs, which
   simplifies libata EH.

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

 drivers/ata/libata-eh.c             |  29 ++------
 drivers/ata/libata-scsi.c           | 109 +++++++++++++++++++++++++---
 drivers/ata/libata.h                |   3 +-
 drivers/scsi/libsas/sas_scsi_host.c |  15 ++++
 include/linux/libata.h              |   4 +
 include/scsi/libsas.h               |   2 +
 6 files changed, 127 insertions(+), 35 deletions(-)

-- 
2.55.0

