Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF0D33A02B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580080; cv=none; b=nQxKnql0Jm/S7hKkKB/wPxYv9m4ZYwg+KPM9qLVRGVENk5gg/5hABkHhPn56Bq31DuNukHXs6lvIC4rIJyQZLnghECJwGipcYqWx7nfQNd6nt6RZ9OJt1oGY6mrkI05aVvLFg6SzwT3xNwI0bjAmLiQX1Mz1zpBVFzWagk05i0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580080; c=relaxed/simple;
	bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zi770rr/n7QvNNSNipeEq3rxAJ8k+0s1+zfvOkksZ6/m/oGq47xBv5Y/f8HqwUkWbSLeI9ebCbrunAQMlGuFKoaGVh5qPaOJmrIVHumd2rIiVNVFwnpfQKMRvU4rlH/NdA2yONKAHztGqarPStL5N2jQfzAvWEU5T/XF6nYF4Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWpRxauI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWpRxauI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01751F00893;
	Mon, 28 Sep 2026 07:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580079;
	bh=ey0gyz67TSo2myMlN7dPMXp4he7umj2+wNfXxNtkXX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWpRxauID9ouM5soGCKBhDd9/5ISznSYjDmSa2cp2G53IdiT6quCF9KE+zBdyP4sw
	 luv4gf8BGyb06z2gDwdEQ0s6XybUWvK5ZNi/ya3pQLTlm1bqXu8WclHXNBFWWf2vr8
	 2hSKhRx0WHgCC/s+YZxD6adCnMzdfSbJORIoW8X0dVIBLSV5puFIyHbLEHO7dUWFuz
	 GoA4RXbaCl4TrEEU7RubMv9TilXuw6iOiZ3f9gnaUbi+9+iPJnKZz6MjCHew3rW2l+
	 OhH941sWyePgwnFZG2jNhG2KoYPotv65DeBlEIDX5olRrW7voGSXdnYv5xX/ZObEa5
	 CSRh11Qxsk2Ng==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 01/12] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
Date: Mon, 28 Sep 2026 09:21:04 +0200
Message-ID: <20260928072102.725566-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1627; i=cassel@kernel.org; h=from:subject; bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iabZnT5taLC3spZB+vwd/vyTYkdlXdmV7sy8YqhTs +GekExbRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACaybQnDP+NrcfkPJsy5dTh1 ucOvT4szmSMXZaRU6XEm8fpNVc13UGX4p69v9EjUVqp4iWaCjorxk5Jva6Kkolse7ejm8T31XGQ SJwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

scsi_debug reports the lowest_aligned module parameter in the LOWEST
ALIGNED LOGICAL BLOCK ADDRESS field, see SBC-6 r02 (T10/BSR INCITS 587),
5.20.2, but nothing else in the driver acts on it.

On a zoned device a non-zero value puts the start of every zone in the
middle of a physical block. ZBC requires a write to a sequential write
required zone to end on a physical block boundary, so a host writing in
units of the reported zone write granularity could never write such a
zone at all.

Refuse the combination rather than emulate a device that cannot be used.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with each combination:

  zbc=managed lowest_aligned=8    refused, -EINVAL
  zbc=aware   lowest_aligned=8    refused, -EINVAL
  zbc=managed lowest_aligned=0    loads
  lowest_aligned=8                loads, as the device is not zoned
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..c664966e95cb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8734,6 +8734,11 @@ static int __init scsi_debug_init(void)
 			sdebug_dev_size_mb = DEF_ZBC_DEV_SIZE_MB;
 	}
 
+	if (sdeb_zbc_in_use && sdebug_lowest_aligned) {
+		pr_err("lowest_aligned is not supported by a zoned device\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
-- 
2.55.0

