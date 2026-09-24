Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598DA38DC68
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248906; cv=none; b=rbFueOThzSNA6Wkbgi7fTyLVjRKwncwbs7t3IL42fUTykHCC29k41MX/aE+zcLsw1JPHYccrumdV6L696mI3QL16MMMiiIgK1LD6xlgTuTpxrTZVah5IyoSyvqSeEvWOMmqk5SIB2LtR4AmO+b5GOqIlDxAx1L8eFUlltb6LXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248906; c=relaxed/simple;
	bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrWsDfVp1ndg9n8ZZjPfmMtZQ4uHgEl4suqrcGEI+C8WNAFBdUSoRbHxyPlhHUHEldybTV/RVNOi95ivEffY6fsrHRdcjUx17iN1/PaZeQmkVqPq0IzYLkJhYbO7OwMV8ZGV3q1UxALsZYIbtZJLXYjL9j5k4C0n9oOnq4UfbEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0e0LjJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0e0LjJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5600F1F000FF;
	Thu, 24 Sep 2026 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248903;
	bh=sDMQrqsKoHkEj5RoyZniz6L4Gsq6cY8ESlhyMYlUWpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0e0LjJy+t/nAYnhqm4F8EkBGcn8XnlpCuuSUJzNZjVa1+tVdbDktIlh60LAg7IBB
	 +XRDArjqNYISAUc2VO4zRAmqGVI9kbsKsi+S7uKOMKEJM+NUQDjkowj6GvOGwz/1aT
	 277BGlV0idrimylVNMmtlDF8BaMRwbtrLPwFFyY0cE4JBenmj3i/U8Ud6S+XlPQPa3
	 B6AdmnWghkdIXDK51KxhLjPRE8Fbmz6caaQ8S/yvawKOzvr/RdgY1vHSADTLN7XmTr
	 Knz2DZ0WtPigLiK3UjsL34rfgmPjz1gVQ4nYoltQPMEjcVZ13atGLmDrTP3kjdIQ3C
	 +lbzZv1EFR+Rw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 02/11] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Thu, 24 Sep 2026 13:21:30 +0200
Message-ID: <20260924112127.3815255-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1696; i=cassel@kernel.org; h=from:subject; bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su+evvzs16rVivPFDt3ddP6YW/v8TdnXax4Z1vA0L bC5oWsS2lHKwiDGxSArpsji+8Nlf3G3+5TjindsYOawMoEMYeDiFICJWDMwMiwSXZVd7fg5Texi bOmaZUJ+jYYa79W0W5/e0W19tT80ZAkjw86uo1aqdxpVs8UnO6htkNl9O8Ti62HRlZvMudI37Dg 1jx8A
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

