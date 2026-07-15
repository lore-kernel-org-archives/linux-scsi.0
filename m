Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DF83D8902;
	Wed, 15 Jul 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784105920; cv=none; b=thAMkHYlCXSkINL3ANr26MKcn093pU/pYcL8mtMir99rhe+ZKcZHW0NaxfuC8ptEImVdajiEh9vjkvXAdA7AQ0nPhV+/0ncfPy0stMreHRaWv/HuL+xzyrJ2KvcwuZTx217qTL5WzNZ9L2WVuLoZxK7aYV6FC68u7UWNabyAU5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784105920; c=relaxed/simple;
	bh=k1p2jnrm7ellBF7Wq2WQsTOdN7VOjfArABSZ3k6aavE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DB4r3VobvftqJXLl40XGZTjXYGP/76+KfKfgF8TkfI0xEP5smSQOp79BroD2Xx22B1ASsfJeHTp5Kyi2qlurHZGSplka35Z8xY+M4yzrJ/2gsu72so4s55Tn2BszRz96WAONeWf56S9PzMtpkV+QtM4O+6HWODRdeCysoQ1Rgkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2AVips7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2AVips7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D34D1F000E9;
	Wed, 15 Jul 2026 08:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784105916;
	bh=lwzEkkjWNNJy6DFjUqqyHIBbNZHWbg2vlMPqGBlLa+w=;
	h=From:To:Cc:Subject:Date;
	b=D2AVips7vEX/AhAAey0BUmNBTbkbmymelkDr93xZw8ZHhxn9CDyBmvElW/SPqvk1a
	 uC+IhI5LQeObBKCt9/9LP1AFcuI/1ryjfHuH/jkvVmzoJf1yTnTiw0MCs20bA53bzI
	 w+iQBJCD6rpG9CrdgwLdEegcj4MhZocbL8dPdNsSYVh7hvi1o2z3GiBj6XOVa2Q1+b
	 B6Oem6oZJQpMB5wQqKLzWDFtxyqQhGUVzWEu0eBX5WNGBNCyGifw3l7v/kzgyN9dVQ
	 hBGRJEuQndlxQZKIW0iqloCJO2UabdzWmYve+ykaUl3xYliBw2EVIP5Kw/6kMjRKcx
	 nJe0JhXxmk4Pg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 0/2] fixup handling of timeouts with deferred QCs
Date: Wed, 15 Jul 2026 17:58:22 +0900
Message-ID: <20260715085824.854200-1-dlemoal@kernel.org>
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
 drivers/scsi/libsas/sas_scsi_host.c | 17 +++++++++
 include/linux/libata.h              |  3 ++
 include/scsi/libsas.h               |  2 ++
 6 files changed, 88 insertions(+), 30 deletions(-)

-- 
2.55.0

