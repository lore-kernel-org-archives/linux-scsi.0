Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE9D492E2C
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 08:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789634780; cv=none; b=sm6NM/tXvKDZXYLwFIYpZ5dcAg6oypLB9//x6Y52IN/0mbkQAGqPIR/AF44d4T27MGNPg6Jf1h9U4C5qhQaUtV8wL/L6mGibO63mLv2MxXTcD/dolMKftOklCnkp8tBKJ3JjIpWTEC3J9A+s8Ietv+V36FfM+qIAFnGmTM2aWwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789634780; c=relaxed/simple;
	bh=MoXvIgLODbjdiQn6PQQJLbqaSW7KoszTJ5Uedi6dtiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOzBW+hE3+aexFTtuuQDxrC0oPvHPugH1Qp1cm+O+mJaY9JbUNChUtiN7zPAc8qa/MPVYdZFkjJAqkx51aKLFp/+WUN08PkzUhPlVRzV7O6AMduKpIS+Jw2q1DWcowT3Jf6rlEfuafcu9yvgo+SnBSS+1p7Bl6eeQuLTX3Hee+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcXPizkf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcXPizkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5624D1F00893;
	Thu, 17 Sep 2026 08:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789634763;
	bh=xLShsW+8Y1Jyw3GxI6GxWzFff1RByqfIC0Uf4v45czs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcXPizkfSv31cB4wnDfV8Yz2kzaIcsVXKQ4xybw5ttkDD+uC+EcuiG9LvcbnBfWyQ
	 SH1H16QsuJJJqOcC9AH6AkuVXF6HRMtqhjhZMnIHgVG9VWQ9lbwLnXuZZMx1m1iLmT
	 yq7wpw4b2uEOHVPmxUs2KVb1LaGAkZwEGN8zrs45iASgFrwtXLHywQKkMKJ0HAgAxU
	 seUR35lt5gcU1MIUME3lQIbT/9/6cXRU3LzJXTgKdFsk4qUcMaapL312loVXiCJqP/
	 Tqxn6rWntXyqDpK2mEe/iL0Trqu+T+/9Rv10wVxVFkeFplx9BU+olHgprPUZmqRd+j
	 AnMbEatiSAfEA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)
Date: Thu, 17 Sep 2026 10:45:56 +0200
Message-ID: <20260917084553.559765-6-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917084553.559765-4-cassel@kernel.org>
References: <20260917084553.559765-4-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3217; i=cassel@kernel.org; h=from:subject; bh=MoXvIgLODbjdiQn6PQQJLbqaSW7KoszTJ5Uedi6dtiI=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWrzj4RYjp4EQpjQWLF3y4X+zxbsXPiPurtNysshOlU y+k2sUc6ChlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEZCwZGSYwbBY0ON/MUN3e 1FOsWdhztikxc5KSdvn12V4Zd99NXsHI0DV7oudRp4LiQHnbC4JhjVaGD7n3d+rrzqyvmrvcwUG bGQA=
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
resp_write_dt0() does, holding the zone metadata write lock across both,
since the write pointer has to be read and updated atomically with
respect to other commands.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2 atomic_wr=1

issuing WRITE ATOMIC (16) with sg_raw. Before this patch, an eight block
atomic write at the write pointer of an empty sequential write required
zone completes with GOOD status and leaves the write pointer unchanged,
and one issued past the write pointer is accepted as well. After it, the
former advances the write pointer by eight blocks and the latter is
terminated with ILLEGAL REQUEST / UNALIGNED WRITE COMMAND.

A two block atomic write at the write pointer, which satisfies
atomic_wr_gran and atomic_wr_align but is smaller than the 4096 byte
physical block, is now rejected by the check added in the previous
patch. An atomic write to a conventional zone is unaffected.
---
 drivers/scsi/scsi_debug.c | 13 +++++++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6043,7 +6043,24 @@
 		}
 	}
 
+	if (sdebug_dev_is_zoned(devip))
+		sdeb_meta_write_lock(sip);
+
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret) {
+		if (sdebug_dev_is_zoned(devip))
+			sdeb_meta_write_unlock(sip);
+		return ret;
+	}
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+
+	/* If ZBC zone then bump its write pointer */
+	if (sdebug_dev_is_zoned(devip)) {
+		zbc_inc_wp(devip, lba, len);
+		sdeb_meta_write_unlock(sip);
+	}
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0

