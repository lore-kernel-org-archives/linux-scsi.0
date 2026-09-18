Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E0248C8B9
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712976; cv=none; b=uFyVixUUF6UVyisfAYX2X3D7Eq9RCbbPt9p3qwg3aX5g1MErrw6PBEBu/CpH7t9z9UV0VyOokjQJQjKrcgJoYcTyLvrVQJHM5hFJh0h7rHmZW/FkG4d7mgyUJ9jlXuvAKVzU59Q1xUz/UYD9kyZotDQbtcllLkEiCECfMFzCo78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712976; c=relaxed/simple;
	bh=ctrol3wFQXXfKZuhbAO5sM6IFmiDBbc0RhbzCjHTM/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PI+9MriZGDkPH2ZcGqyJ9ielcoKmO0/+sv6cB92Pbp+/uirNIDN3/BwHnHhcOu7kKpUF0W7uhAS3o2lV9dfw9h/dQkoS3nTt8o6FcJdaQzxRPsj64wu7x7rNHqXA5GJyFuGmde4yLQnYcGK7Y/6bJdXGPgw6hKima9Zbe9o3lAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqZO2Dho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqZO2Dho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9D41F00893;
	Fri, 18 Sep 2026 06:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712974;
	bh=PUyqtPFTVrlS+jQyi30cB0iacHIEWNPOw7GWmuaFtLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqZO2DhoB0wVejVZV3nCSUBKL9H0QyiFjAFWgulfTD2w/LKutkh7Reu4C9EDQ6Ngf
	 wveBWQsxKSlTfmrj01ND/2/9XZoc1QjTxN2r/G4oo2ibol/3BB9Ex+xyOXwArPuodx
	 bP2K9SUhc513HSEQuKfZtQP6lLXUrzEvTeYjBNyPnNDznOJAiFQ7PKvOX89Er6FcCs
	 oKvHeS7AA7sPAWA6QH6xnu+DkMkCb2e6mp0Fb+h/hzmuaNU3xFweifIhXfe6R4e8lk
	 TWzUkXM1VV33taAiifoyQ6HwKfyYlPJGUuIJ5W6EXYydklKFpgTsFZcBLPxRAgGHBp
	 Kool6lShD1wfw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 02/10] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Fri, 18 Sep 2026 08:29:13 +0200
Message-ID: <20260918062910.1709791-14-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1873; i=cassel@kernel.org; h=from:subject; bh=ctrol3wFQXXfKZuhbAO5sM6IFmiDBbc0RhbzCjHTM/M=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LKzS5G3Mm7c/VL5hCmj1ynrS5K3ddYG7lPtO53md rxsH/+7jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEzkjxvD/0z3uKNKhu+nh9fN mbXLafbmzx6Cf6YcKxV0ZlVOUWRSN2D4H5h5s1ZjWll2kWrvjCvOfx6bZ7G5Ksbnu7amR5iv9WP lAQA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

There are no SMR drives that support atomic writes. Emulating a device
that supports both is emulating something that a user cannot encounter,
rather than the drives that exist, and it means maintaining the zone
handling of a command that no zoned device implements.

Nothing in the standards forbids the combination. For what would be by
far the most common case, a host managed SMR drive whose logical block
size equals its physical block size, there is no problem in the two
features being combined: the drive vendor only has to give atomic
writes an alignment that makes sense with regards to ZBC, for instance
equal to the physical block size. This is therefore a choice not to
complicate scsi_debug, rather than a restriction that the standards
impose.

Refuse the combination at initialisation. If SMR drives that support
atomic writes ever become a thing, this can be changed back.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: LLM
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

