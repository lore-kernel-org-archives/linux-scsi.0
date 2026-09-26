Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFFB2DCBE3
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446634; cv=none; b=YilLRvK/s3Wjgj4+o7EpbMpINNTLloj4Wgilv3IKo74Y9HRZTbs/+MGjoGPlUC69hdk4jfHCdON33iZWLW1e2+OjACd2m1zg7wBnNKnZpyYz2EHYC8gSv57TkXQi1Hfelfj/B9kp0mOyY0k9krhKwmhq1XtwFwJMug25mB8dmjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446634; c=relaxed/simple;
	bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqnT9XQVhGasabXByxrbglnjAbPFtdncFnuRQm524p3iIsDftDRv3zeTVEjZL1mWVxnSjSB5VtyNKZBLECZ25nTblPSqlZ2fF2hrYVuLpromgF2kHhBtRO7ycoKfy8/IjBvir+GI/7TG6sLhcWnGHK1d1FNHBPWqbwxD+41/VAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjdXddV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjdXddV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB8D1F000FF;
	Sat, 26 Sep 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446633;
	bh=sDMQrqsKoHkEj5RoyZniz6L4Gsq6cY8ESlhyMYlUWpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LjdXddV7PbAH8DDHwMKnpXaOgccx5WaQeW1581he1uuTirj3egLBpdYPSa+/qDqse
	 ZE16U+0py7jVwhwG45vpIWwwwvOfTo3HQlEbF9B4CWqC0Sc5hPPe2nuK2lcRwVnTHT
	 s8CTRwDnB/RSqRamfUZLLg/JIcTQO1lv/mN/8GZ16O1mjgMO9vbpssUcDmva1YrAC4
	 CLIQBdLRtZ9nzxGUA9Za367MA8Nb10r9KVaPV2sX6as4hwsTNjWTA/9lHj6QZlXaVl
	 oiR7KmmmHrzXNos7fBBei3zHGWDpWcH4uyy00juuYJNQ94syxdqjCuNB6taP0dATD/
	 zgJ+WxG5IAxKg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v8 02/11] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Sat, 26 Sep 2026 20:17:05 +0200
Message-ID: <20260926181702.508975-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926181702.508975-13-cassel@kernel.org>
References: <20260926181702.508975-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1696; i=cassel@kernel.org; h=from:subject; bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ28MhNX372a9Vqxflih+5uOn/MrX3+puzrNY8Ma3iaF tjc0DUJ7ShlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEXhoyMtyrfXXo/ZlJtw/f 0L642IlV1ae1otM0eaVkubmg2MEVrA8Z/pdt2GNqE7Chr+/c1LzETdkPtqRo/Gralq/+xOPcXQO XHfwA
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

