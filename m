Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABF354707C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486829; cv=none; b=pjgDQCXpYXNmjEXHb25wa+nnfWM7waB45dshYXs6inHwoks9PoRDLD71F+0pxzZpmCJb07ai8M87PxGt1xH4cc0uYEfzzoGYaOfm2LREMY7sNXiPzz7JW48dCxkPOOqZtJHQrkTu67PO6Klx/SVjMtolUSYmHpgjlrf1aOBV4+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486829; c=relaxed/simple;
	bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIXrdppHdFbgF8vPOxnyttNS1vJsoIOrzhlje4JfUuLZ9OU/3JPF5DsnRig6hStpRs9FzfMV+VrI73Cl2dQjXJ0mWXZa8QMvtLkPnqHN958xxU/RLQvVb0xzeLu0v7Pi3WJa2sjSahre8gRnRu+HSLHt1/3My5JCOrStXS5G4b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kj3+8RaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kj3+8RaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9081F000FF;
	Sun, 27 Sep 2026 05:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486827;
	bh=sDMQrqsKoHkEj5RoyZniz6L4Gsq6cY8ESlhyMYlUWpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kj3+8RaMpU1WPtzMp7O0A3YddHfmQUDavfDW46KBSoBxbMdkHsF+oPvBsgTEUZ1KV
	 0OP9hHkZ3E9tzOvTh/5rZdf/RyIvJ6fO5w5kS4sRwC9k2qMPqOqB9YnHDsi30nOtSZ
	 R1ck4U39feASyjKgFeDkRzd/1ca8bvxOoCbnWGxYSnO+0ZkdbTAPfp2uiJzbVWR9Do
	 TNsTptTKG5bGnWDiRBmH0TQfOVsLO+73MZdhNkXZVG+MyDrLFi+tSq8yqEPDkGS2aG
	 xirgI1dyEwYFqyWnsAigqb225D5i57L3ljgduDATRD3s36XUrIwijVGK7ecr/cfBxw
	 JVkpII3WRnyKA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 02/11] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Sun, 27 Sep 2026 07:26:53 +0200
Message-ID: <20260927052650.567035-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1696; i=cassel@kernel.org; h=from:subject; bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rJSfvvzs16rVivPFDt3ddP6YW/v8TdnXax4Z1vA0L bC5oWsS2lHKwiDGxSArpsji+8Nlf3G3+5TjindsYOawMoEMYeDiFICJdAQz/LN72feKP2/Zk6mh Dg0/9in/Ol6q7DmD867QvWrft+sMLRoZ/udvv/mgjjPAMHF3zE/G7BUv/wb4TWZeaPnexehwROa mRbwA
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

