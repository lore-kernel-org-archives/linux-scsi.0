Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB564FB9C3
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649759; cv=none; b=inrbiBViBxiKc6o+tV0U7bDZbIrSNr1PTeO2VO3QfNLYPO25UzRiiw/9vWvy89vtne0eZVfNc8RLF3ZgOPw2mYMFxtNt2apGkmLgg2mzTrY7oL8lIbO8pfFcv1DcV+BvuZ9yxPC6wJhceZ+NK9rBoLy285pxbxK4A19jQU3qks4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649759; c=relaxed/simple;
	bh=Er+E1r4+t5ybv5W7h5OhDzjDoeRT47r9ADLCLhgwbrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoiY9f+0V+RealcFIvkE3xfu88WW6jA4N/j7uQMyriXXEeEmaUYBU1ImaEkw1sWmx2mlM1BZQoeoZFrJgyK2fHQeuc7nhJiymKkI+luxHI+cXq48dRxofjciRP1OmJN3bApa9StqXyvyKzoTwQM2GcqmK94uqS5WlFtjKRiTwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSJfpDsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSJfpDsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462B21F000FF;
	Thu, 17 Sep 2026 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649754;
	bh=p0hxiNLQRtxUgMzCVLaHdJXcZpPSGr55kXmiDNBJ9LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSJfpDsat0cnhXIzf9K6Tpoi1WnuLrqwDL0X+nu6lmo5IGyHQKXeKChOxPLJEBwms
	 aSDjBXdTQQ63fUOqKeut3IWJ8RpmlIy48RIIvhDnGfYIbP7RpoETUTbqxSaE0ct0Fv
	 vOyVvuOH9Xc3VMjGA3FxhPz+vzuisQWZrGRoldLQwvjgKgX8Hn/iZsTTA9M8S66OeU
	 NodlOR8rbGWc8uwF4+8CiwtESl0yU38UdzFbS0QVMCTB0o6DV2NERmYbuF/2CXqQoP
	 5AVIFYSPQLXklvc7jyTbLvdMrLfLU0dV7zVwtLn3VIXd4Cc8WkRE0Bn91v1M9uylIt
	 /zEPTQ0Hst35A==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 6/6] scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)
Date: Thu, 17 Sep 2026 14:54:52 +0200
Message-ID: <20260917125445.1376493-14-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917125445.1376493-8-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2900; i=cassel@kernel.org; h=from:subject; bh=Er+E1r4+t5ybv5W7h5OhDzjDoeRT47r9ADLCLhgwbrY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWP5Yy//LnisKMA5p/v+V2Pb2+umJX5e5452b9otYWf fHJZtzOHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjIpPuMDGuvORvZua9NyV40 cdlybQ4D/1c9SVUGq/zFNov5mFctucvwP40nennW1d8MMo+cLYwn3tujbH/NJM8872/gQfaXzgV n2QE=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

WRITE ATOMIC (16) is a write command, so on a zoned device it is subject
to the access requirements of the zone that it addresses, and it advances
the write pointer of a sequential write required zone. See ZBC-3 r06
(T10/BSR INCITS 579), 4.5.3.3.2 Write access pattern requirements for
sequential write required zones.

resp_atomic_write() calls do_device_access() directly, without calling
check_device_access_params() first and without advancing the write
pointer afterwards. It is the only command that writes user data which
does not; WRITE, WRITE SCATTERED and WRITE SAME all go through
check_device_access_params(), which validates zone access for a zoned
device.

As a consequence, with zbc=managed atomic_wr=1, a WRITE ATOMIC (16) can
write anywhere within a sequential write required zone regardless of its
write pointer and zone condition, into a gap zone, or across a zone
boundary, and none of it is reflected in the zone state. The write
pointer is left where it was, so a subsequent REPORT ZONES does not
describe the data on the medium, and the next write at that write
pointer overwrites data that was written without error.

Validate the access and advance the write pointer the way
resp_write_dt0() does. The zone metadata write lock is already taken
across the access for the provisioning map; take it for a zoned device
too, as the write pointer has to be read and updated atomically with
respect to other commands. Unlike an ordinary write, the write pointer
is advanced only when all of the data was written, as an atomic write
either completes or has no effect.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/scsi_debug.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 33f2df26e5af..b57d25d7214c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6229,15 +6229,29 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
-	if (scsi_debug_lbp()) {
+	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret) {
+		if (meta_data_locked)
+			sdeb_meta_write_unlock(sip);
+		return ret;
+	}
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, len);
 
+	/*
+	 * If ZBC zone then bump its write pointer, but only if all of the data
+	 * was written: an atomic write either completes or has no effect.
+	 */
+	if (sdebug_dev_is_zoned(devip) && ret == len * sdebug_sector_size)
+		zbc_inc_wp(devip, lba, len);
+
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
 
-- 
2.55.0

