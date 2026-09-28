Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3901433A02B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580082; cv=none; b=Bqf8bl4P+wHtrKMt/HGWe3MjuT3cR2Jidn/sfhxGG0YAp/hakUFeruJ/F09QPzDk1vUnEUj8ENqhDsMIQfwylXkJ1LP3aMSuuJN3F5LgNYmkAIbRDx/QhfXqXLB4aZPo1FxHiKu5ZoJTwr+CAMRVTWBnFVJlDHCgtKyLeloCYUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580082; c=relaxed/simple;
	bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOnOkog4EuJ0nBy/9ypWdAdylPCIHi62LUL+qowwakP0kQwb7kuo0FG8EtLCjvi1B5VTqPgTAzywlJ6BEz/+qQpv/jHZDi3978EC4om/2OBfN7Q1N4uP3OznS210FlRq1UCuMb7up13IYmhsF77T68Zmgu2JOjg9hhHD6aummcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLtiJawG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLtiJawG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73E91F000FF;
	Mon, 28 Sep 2026 07:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580081;
	bh=sDMQrqsKoHkEj5RoyZniz6L4Gsq6cY8ESlhyMYlUWpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLtiJawGfb0yVphA7fjL5G6y6mSKvrnT9VHOaoqVycKYnuAZ9z8NdzaK0gcDNCJzc
	 qSQyBjx0t0evbKELXV4/RMefDkIxFJm6hrQI6BU1w9W3fbQj0NsFfhcqh9JOttRj+W
	 2qRZZbIGTBN5STYnbGwHtD91f1DvFVTWSiBXHHtF9qcuqVaJEUNXDxMHaXtqI0A5Dj
	 PMPgIkoV/znRbo6XAV4B7e/T2iXJzLeNNZqvc0pQsU72DE9ErMYIh7VmpeUpisO3iG
	 BaPRrcJ8Wt+FywHnpPUhYUZpC0kwG3nnuWMu+KKUlVl8SY/6wPsjeJNFdF3NSJUNUd
	 2i5RBy9JZF11w==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 02/12] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Mon, 28 Sep 2026 09:21:05 +0200
Message-ID: <20260928072102.725566-16-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1696; i=cassel@kernel.org; h=from:subject; bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iaZNX372a9Vqxflih+5uOn/MrX3+puzrNY8Ma3iaF tjc0DUJ7ShlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBErrYx/GJaoSu4UyDi6J+C y5PztPXCOlkuvzeVqkhU3m9Vl6rL5MPwP5WtrH/RYvZmljZ91ut3gr7Im5X9+RNxXXyV/gv3hWc aOQE=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

There are no SMR drives that support atomic writes, so emulating a
device with both emulates something a user cannot encounter, and means
maintaining the zone handling of a command that no zoned device
implements.

Nothing in the standards forbids the combination, and for a host managed
drive whose logical block size equals its physical block size there is
no problem in it either: the vendor only has to give atomic writes an
alignment that makes sense with regards to ZBC. This is a choice not to
complicate scsi_debug.

Refuse the combination at initialisation. It can be changed back if such
drives ever appear.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with each combination:

  zbc=managed atomic_wr=1    refused, -EINVAL
  zbc=aware   atomic_wr=1    refused, -EINVAL
  zbc=managed                loads
  atomic_wr=1                loads
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c664966e95cb..8e45a57ae406 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8739,6 +8739,11 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (sdeb_zbc_in_use && sdebug_atomic_wr) {
+		pr_err("atomic_wr is not supported by a zoned device\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
-- 
2.55.0

