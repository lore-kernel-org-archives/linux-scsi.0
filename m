Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3021DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320670; cv=none; b=mtwYOupQZVqnhEi8o8/njgyPUidNcgzGD/pxGGSTOOchuLfyh1KnO2hU74XHz8ZNL6NhMaaz52QOFPXt11KkmAfE5NMpqjptTZR12SvLhh7BimJmaC2rxaMuZFQ1Sb9KSZbmvXSbq5hgXzuXoOI/gnMpLkhW1uCuaex+cmFq+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320670; c=relaxed/simple;
	bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXGWJlsE4NOmKuo4uKaMkKlProod8ZDG5oHKHNgiu6rmBDefDFIAkBa0SvpaWq7MPaFZpWFSJ0ORSKTfCNT8b6rzTwjvrno8JUQyqaSZO+DE/bU1GTvc1BECuLmeNyJ8mNGrAYs+J35qyqGvPXb4hCx9OkHlDl4oYWhzhRj9qV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Js/jfVU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Js/jfVU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87881F000FF;
	Fri, 25 Sep 2026 07:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320669;
	bh=sDMQrqsKoHkEj5RoyZniz6L4Gsq6cY8ESlhyMYlUWpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Js/jfVU1VsTsaTJ2fLajqyucEUV/E6T6i2c+B27e1+nu6qA+YeIDIJW+7cq/2UbSU
	 a5B4NJYKGVOWOPFXsSGznUBmoMRCg7V/aGAlwUai3fys76FfBxHwf/uKfW5k9D1IHc
	 Np4JFe3DrXbHHanMfbxM69uofo5Q72HQmnELmpHzTnCGs6uHjez+eB2suZNiNwVMjo
	 h9FY3ZfmXryTPNhzrx6rsVruSSAIoVYqRkelnuPvgnsyrUqrDrULM19A0Ch5J5BUhD
	 kzQbwgTUlcOnD95mlCgwQVFgiFuEsfiJ7yaoVlxcRwS4OZs0kCLu/h6RJU4lN5y0f7
	 OwGV+bgz2PWOQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 02/11] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Fri, 25 Sep 2026 09:17:29 +0200
Message-ID: <20260925071726.140915-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1696; i=cassel@kernel.org; h=from:subject; bh=2uL53PN8nRBmDFz9Ye4q9pqAvQphs6Vq/vcCDB+LCSg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQhNX372a9Vqxflih+5uOn/MrX3+puzrNY8Ma3iaF tjc0DUJ7ShlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEOlMZ/gqwRbxcteDH0bUx XS8SygyVC9mit/qXfVIuqZp3bu38+t8M/11e5xyv/1xnufPs5hj1WYUqH9N5N52pFbg48Yjp/He dwTwA
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

