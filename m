Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D7A4B0CA0
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643037; cv=none; b=m+TVeQNViZYGAJQ8Afpm8n9qMW3eFfwGSP0TPrYVdZhqp/NDBm3AkCLPa26vp0ECKZsds5C5+nniNhv+XzC7j1Xf1tRLj4tFJ9WuuPaBlBrOIzPnU8CBfVfd3r0Bv6gtajLgobjhjHuhN1pAGBZZuNp1AzuiDVROg1WhpJ5MPRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643037; c=relaxed/simple;
	bh=/i3SN9k9EAFpIJLnx0eH3NVITXMQk6noIQp6I2JPbd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8eUzse7XfffxedZTSD2QSNnCN9O4aeHUwWLSyySDzZ7bAtTgObCoWDhYWDNLJnXsYB0RdhqePEXDEYgU14+f/icBSYUFvflTDcjAbR7NYIHdOROl5uzOJmZPIc03hfaTvqXHMht7HcXpwv9MdSyZY1HYqWlSGTwlo59giFu+dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAVLV4c7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAVLV4c7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67821F0089A;
	Thu, 17 Sep 2026 11:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789643028;
	bh=/ogbWS4UwZ5oWQNnOMm96xpCKJtk4ARQdDXWXNXPGx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAVLV4c7prOXbelXYwMqdAsv5PusTShZJ3O8TFmbuiJjA0nIb53gEA14c+1anXWDz
	 ZovkQ53BEu43cFu8PC1kQLQsJK3BaMip072R6ufYGDKUdeOjmYwTOncCuWgRpHTh04
	 V03EplLJ5pvO2cH/gfWCLEFwoP594W+jd35he9vXCk52It3FewElnE+G+XcXJdBZNS
	 UsCdGp6ELprfxFPMjxPhPhVesWCS/LH5Uk3SMccDT3mDgdxfrYaTclmDITiGwyLGwE
	 QdgV+EyS3PTteXFvyRUy2XGBa3TG3qV0Fjit5rUP+y8Jg5X1vTD19AZbrucVyGjhjH
	 jCCiffWNcABWg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v2 4/4] scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)
Date: Thu, 17 Sep 2026 13:03:21 +0200
Message-ID: <20260917110316.1104863-10-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917110316.1104863-6-cassel@kernel.org>
References: <20260917110316.1104863-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3695; i=cassel@kernel.org; h=from:subject; bh=/i3SN9k9EAFpIJLnx0eH3NVITXMQk6noIQp6I2JPbd0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWn/jJyPI4L/P3TcHde+bKWKaL71r1+E7k3Ed2wQeMf 8iduRG2sqOUhUGMi0FWTJHF94fL/uJu9ynHFe/YwMxhZQIZwsDFKQATUXFj+O8wpbZaKPPwsdth nRZhUoz/+a/tePP5RaR5w8GKaYuOG+9iZOhI3cFfc/SMfTm/0jt2c5vLTxZfS9qZuPB+AHdkjOQ jExYA
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
respect to other commands, and advancing it only when all of the data
was written.

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
physical block, is now rejected by the physical block alignment check
added earlier in this series. An atomic write to a conventional zone is
unaffected.

A WRITE ATOMIC (16) of eight blocks with a data-out buffer of one leaves
the write pointer where it was, as an atomic write that does not
complete has no effect.
---
 drivers/scsi/scsi_debug.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5a08f02130ef..546a21fb342d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6212,10 +6212,27 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, len);
 
+	/* If ZBC zone then bump its write pointer, if all data was written */
+	if (sdebug_dev_is_zoned(devip)) {
+		if (ret == len * sdebug_sector_size)
+			zbc_inc_wp(devip, lba, len);
+		sdeb_meta_write_unlock(sip);
+	}
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0

