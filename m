Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E754D9F84
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649758; cv=none; b=syC+Pnt9rzTJ52KsoG3N1SFI1iklIG/RSODlLbaDebJQrvMKR5U/o0nZT+Tjb/5X0Z4XrX0zdH1YKwLAPvo+IQJwux/LDXQdQgEPRyq2jnNRSp2mebG+8+DGWGsrTucsCDy9o/YbkWmzVbuqinJE12JwqMTyxP8COjfGxa+3IZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649758; c=relaxed/simple;
	bh=N3jNfeFLA3bL8cgAzEHop5xLOM2pHxmPoXC+SVJSp7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6mUVY1qMoiI+iS6M+R9U3galkO20SgZplytWw0bENf8mrCvZqVXxbXURp+eRBdSza6CY55Y4OQRbbml8kn520xmgll54DAiJt6N9wN9V0nMZF48TQK7RSnoSWF9uO5tBb7WQ8ETc0i0Zi80xsWv8at5lyegMcnzazsu7Ay/czk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTlrQ4K3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTlrQ4K3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF041F00899;
	Thu, 17 Sep 2026 12:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649752;
	bh=d7xiY2xPld2yTeOAK5ThlvT7yt5caArc9ZEQwyLJqC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTlrQ4K3PWi9bR96FiSJAdO4Pf6iGP7VTW0OFA7FphZyOfLeXVL7b9y9yiUFO28j4
	 whPXud1/Z9iO1bb5E6nwu4SDKXaz23FPbgZ79zDU2gOkl8MMdI4TcVoUBp/a4wMP1s
	 TpzBeg2WvpMwg6kbfz8a9VdTu9JbfRGgmKAKO/QvUBWIFDwSgU1rQZP5cBXxh8na06
	 mC6cmvgJZbSmW6oS4X9LHRKVgqd21ac6SaOjI9CW4kKBrj4aufx1Rc5KEqeFQli2jG
	 TE2v72gFHG/UWss6ktdTa8RsT7pYUQfPCP3M3Ga1r1ZH2zYCNa30uSCPJ4WjZ6jrpb
	 0rbKxoLzmQF6w==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 5/6] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Thu, 17 Sep 2026 14:54:51 +0200
Message-ID: <20260917125445.1376493-13-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917125445.1376493-8-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2140; i=cassel@kernel.org; h=from:subject; bh=N3jNfeFLA3bL8cgAzEHop5xLOM2pHxmPoXC+SVJSp7c=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWP5aarVrSo1rOorl4p5phY4B7AL9YmuUzP0GBsxzP7 /ru5czsKGVhEONikBVTZPH94bK/uNt9ynHFOzYwc1iZQIYwcHEKwER27GJkeH/g3LGLfFMccqdf qZax2nPHcOm8GW2xG/U7GPX9lt//18LIsOTqr702MuIH/3BEXt+V8/xe13f34MWq2zltuZ582HP hPC8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

When logical block provisioning is enabled, a command that writes user
data marks the region that it wrote in the provisioning map, so that
GET LBA STATUS reports the region as mapped. resp_write_dt0(),
resp_write_scat() and resp_write_same() all call map_region() for that.

resp_atomic_write() does not, so a WRITE ATOMIC (16) leaves the
provisioning map untouched, and GET LBA STATUS keeps reporting the
region as deallocated after it has been written. map_state(), which
GET LBA STATUS uses, is the only reader of the map, so that is the whole
of the effect.

Call map_region() the way resp_write_dt0() does, and take the zone
metadata write lock across the access as it does when logical block
provisioning is enabled. That lock is what serialises the provisioning
map against resp_unmap(), which holds it while unmap_region() clears map
bits and zeroes the data that they cover. resp_unmap() does nothing
unless logical block provisioning is enabled, so the lock is only needed
in that case.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/scsi_debug.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 64f32d97455d..33f2df26e5af 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6184,6 +6184,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool meta_data_locked = false;
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6228,7 +6229,18 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	if (scsi_debug_lbp()) {
+		sdeb_meta_write_lock(sip);
+		meta_data_locked = true;
+	}
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (unlikely(scsi_debug_lbp()))
+		map_region(sip, lba, len);
+
+	if (meta_data_locked)
+		sdeb_meta_write_unlock(sip);
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0

