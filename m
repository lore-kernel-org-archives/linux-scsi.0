Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFBB48D874
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712992; cv=none; b=lfBfuz3p2MqCy1uNLqKTE4b3d9k4wgztCbkAr0GVi8Rdb2IHhbKBtaKW2f89irAqE3PSE9XTnsSMxYo5fS7lK1mXTlznCteUmL1IUg8SjEg99RYwCQsI882MvNG0LOydsBBw64wm5EWzCbpvJHFlo4PWOJHjt+N5vfaq7Prs2HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712992; c=relaxed/simple;
	bh=bl4w0XYlHc2CWQEjRbkifACsC4Es1vNMFEWp9lbNecE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJF7IWq373edeFp53BDd8Gw+nx39sqWzyeRPqwNjhVufCn1jZDBrg79DwlcXecXG546tt0iOZatCOT/xLdALAgRgyHPrcDvIfCkvGeJjRnkflqaIG3x+wHxzpKYI9HxNYwKqHEbbRdeT/14Z9e+Dirp6ElpNAQfbnzaOdfrpOBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmP8zqu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmP8zqu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E158C1F00893;
	Fri, 18 Sep 2026 06:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712990;
	bh=HRWOeDU8Ef4dcvwmt5ghJn6z/9HXqQa3IvEit97qeHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmP8zqu5zv8e1HZOgdLRy73FIcKczOQddvTRnUUITkVUy2RDkAELHy57RQflwfAlT
	 nPyvxoNfm3dv50LohNyqa4XISCczv9kYz1cA7r4FxY7xwQEfS6zGPbZAsKx8DUbpyq
	 29HzUkRrg0QkwhIArIbHlyf/XS3/w6tbmMk9gZcJcHDaYOYDZdnylR9ofzrPr+Uw6r
	 iOg8R3yGhJzSIyZ1awVNhq5VRfEw6Obtgd/9mgsP80ZM6EVnnqwoL50sNievZZ7+dx
	 y+vDzrwEzW1/py8/BHuee+Y7nqyT0PFRKYb0mf6vqLDSeitMXZ/WEfL0qc8J8h7u6y
	 rfm/Z2rMBrUMQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v4 10/10] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Fri, 18 Sep 2026 08:29:21 +0200
Message-ID: <20260918062910.1709791-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918062910.1709791-12-cassel@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2337; i=cassel@kernel.org; h=from:subject; bh=bl4w0XYlHc2CWQEjRbkifACsC4Es1vNMFEWp9lbNecE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLLW3LJ3q1u7fcO/iJ/ZG+TOepQpBWoZ5Xk2SNX58gtXX iqXKAvoKGVhEONikBVTZPH94bK/uNt9ynHFOzYwc1iZQIYwcHEKwESU1zP8M1upax3zx/H4+lvh khmnHVU+1BoVqrIkbLQ9enNC8mTnT4wMzxkVW0qXbYqddN95jcn6xLT/Tiw+jbFBhe9/nWRY80a DAQA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_atomic_write() validates the fields that are specific to an atomic
write, the alignment and granularity of the transfer, the atomic
boundary and the maximum transfer length, but it never validates the
range that the command addresses. Every other command that writes user
data calls check_device_access_params() first, which rejects a transfer
that ends beyond the capacity of the device, one whose length exceeds
the size of the store, and any write to a write protected device.

As a consequence a WRITE ATOMIC (16) past the end of the device is not
terminated with LOGICAL BLOCK ADDRESS OUT OF RANGE. do_device_access()
reduces the LBA modulo the size of the store, so the command writes
somewhere else on the medium instead. A WRITE ATOMIC (16) also writes to
a device whose wp module parameter is set, which every other write
refuses with DATA PROTECT.

Call check_device_access_params(). The zone checks that it ends with are
unreachable, as atomic writes and ZBC emulation are mutually exclusive.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1

The device has a capacity of 262144 logical blocks. A WRITE ATOMIC (16)
of eight blocks at LBA 262140 is now terminated with ILLEGAL REQUEST /
LOGICAL BLOCK ADDRESS OUT OF RANGE; before this patch it completed with
GOOD status, having written eight blocks at LBA 0 instead.

With the wp module parameter set to 1, a WRITE ATOMIC (16) is now
terminated with DATA PROTECT / LOGICAL UNIT SOFTWARE WRITE PROTECTED,
which is what an ordinary WRITE(16) has always returned; before this
patch it completed with GOOD status and wrote the data.
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5243401701f9..5ae1241e4d8b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6246,6 +6246,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	if (lbp) {
 		sdeb_meta_write_lock(sip);
 		meta_data_locked = true;
-- 
2.55.0

