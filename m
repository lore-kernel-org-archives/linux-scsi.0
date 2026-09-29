Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29593CBE8F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670366; cv=none; b=o4JjFyVoxHlVf9qWvVp6KEHmUAkeB3YX/E6QYF1OIzPHmP35fZGIeQhAYMbDeSf5CShPaJPfa/zXhKi49X9ZXP1tEOc1Lw1TvNvAlxmdukZ27TiiybyxHUwon45TBUjyXLvNIA+kbFBoBd0eltFNAVJtSFe8+fe0T/753ENZR6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670366; c=relaxed/simple;
	bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9bq9QeLDcVqZXwxPtoLb0KNd3XhijBYE7oehTKfK/SEbOb84Qu2W7f/2sD91aDKcuc9gl8R4pYpXqU3YADjzZpUDY9lKNhMQUyp/5NMi8rskfhjBOdlaaWvbxfjsNBYRvxGUcpsvEp+uSYK2DsBX6VDU20683ftOhxqq498yx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLANi5L3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLANi5L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420101F00893;
	Tue, 29 Sep 2026 08:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670364;
	bh=sDMQrqsKoHkEj5RoyZniz6L4Gsq6cY8ESlhyMYlUWpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLANi5L3uURF8ERg9wC+/GF6mT0dRYa5WGcKWFB4UvIBk32Cp8HKfmkrIXXFI9bp/
	 BeLMURx8kytb8ZSeSHAVThaLs8Ipyslelyv7oBeYvtGwHuY6hfhneIOc+ZaTRNxrh0
	 DmE2EK9cQB63kaictf+ctcM8H/B9k5Phx90Zf1Qjyn/QhZfsGd+h9JLTQJWUzVna6D
	 YpWnChc0f3jWNigxQtGamiucr2floQKzls65WEUOpRQflo+IDlNBMhLfOYkRPQMNYr
	 3CE1Q4kn9m8Iiv2IPJn69ie3ZoeQoyY6LhvkvomGtegI3TlL62YeFwWucpfOgVpPiZ
	 1rBWClWUGjJ4A==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 02/13] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Tue, 29 Sep 2026 10:24:59 +0200
Message-ID: <20260929082456.857423-17-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1696; i=cassel@kernel.org; h=from:subject; bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l76Zvvzs16rVivPFDt3ddP6YW/v8TdnXax4Z1vA0L bC5oWsS2lHKwiDGxSArpsji+8Nlf3G3+5TjindsYOawMoEMYeDiFICJFG9lZJjd9UxUnqtJNbDf 0ldWPdhVZRLjzUOPrnw+p7+/93d65G5Ghi1r7X+Fts/+tF/h5x9Roxe9TxMb5+mwzwrifvfBoTy 3igEA
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

