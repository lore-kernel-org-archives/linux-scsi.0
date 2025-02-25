Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE1F175D5D;
	Tue, 25 Feb 2025 16:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740501402; cv=none; b=X4hGI+TtMZrQ8vofxnBQlh6edbxCLoApSSkud6jKHJ9B3gkpy660VRs6YqDKEClltyNUsuyOXdXCEK+HwC1A7IG6hfdQHEOZShQfIQgQO7YmwBxabdgbb9yRXbWXHQ3RQCyXpk5JDcWuOCFJ+fANKXgayHktQWRScnl7N5ZU7D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740501402; c=relaxed/simple;
	bh=CDe7JbnlugO1bzQW+Xtm0wMRorwKjf487Z/g8QdakFc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cQ8OBMBOLS4SKqBIB30KJ/j+jpZSRoEsX3MqOw/UWHFdLUyxyoKKw3V22yGukpHmLkGGoR/99Kz4CYRWi9wFrJPX1r6d7W+hf954mhFmfl7lwgFV1JQkvijTY27+tWj9d7i3+HRNqWI4fVrd9GOl0ohqLNHY7cR/RZekyzCWc5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szV/O/Zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szV/O/Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5998C4CEDD;
	Tue, 25 Feb 2025 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740501402;
	bh=CDe7JbnlugO1bzQW+Xtm0wMRorwKjf487Z/g8QdakFc=;
	h=From:To:Cc:Subject:Date:From;
	b=szV/O/Zx/iKdYqpV/A94Tuo4+IwE39EKL/BII5M3YU0reotOKon71pu6oLFXc/VXA
	 4zWOgEtUbeaR1KnOa4y3W9Qp1vi45ioN87AYwcyA2ntqGaEkFzcKP5Aiko7pEUARAI
	 uPJJqVzmQXiJvQL2sTEwxwqyUmhFj0tN/Mzrz/oWNoGunzRjEi1VdHPd9hY2WKLTA7
	 n3ZSw9lUntHnzbQXdwABwNf6FksCTVZfgOlmqoUTk2/P+YavDnQs5Tp9lk/dRTMDUj
	 nrXisFn1WzoF7Q/cI6ZktnNGJcmI/e0VNCOSMgAAcmc3kI1dUO4bZ2rwCmsquth3RL
	 Hk2RQ1RG6i9sA==
From: Arnd Bergmann <arnd@kernel.org>
To: Yihang Li <liyihang9@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jason Yan <yanaijie@huawei.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
Date: Tue, 25 Feb 2025 17:36:27 +0100
Message-Id: <20250225163637.4169300-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Building with W=1 shows a warning about sas_v2_acpi_match being unused when
CONFIG_OF is disabled:

    drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:3635:36: error: unused variable 'sas_v2_acpi_match' [-Werror,-Wunused-const-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index bb78e53c66e2..6621d633b2cc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1806,7 +1806,7 @@ static struct platform_driver hisi_sas_v1_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v1_of_match,
-		.acpi_match_table = ACPI_PTR(sas_v1_acpi_match),
+		.acpi_match_table = sas_v1_acpi_match,
 	},
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 71cd5b4450c2..3cc4cddcb655 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3653,7 +3653,7 @@ static struct platform_driver hisi_sas_v2_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v2_of_match,
-		.acpi_match_table = ACPI_PTR(sas_v2_acpi_match),
+		.acpi_match_table = sas_v2_acpi_match,
 	},
 };
 
-- 
2.39.5

