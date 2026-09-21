Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1E44C2253
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005270; cv=none; b=N+mZRj9Ep1ynVLbFW5h0y16+4fPW/2bIGZN3Cv4SK1goMn34TnmSrfNow4Cxjef3ZHabGy78O9ExDM77vzO1VqzZ1vn+z/+iTi307Nro5EgA6J5e/Ttr4gRFCOVSgIxN77+esXbHMpsoaKeSjp5tZa1sWFCi9/kvZlFhL/cXba0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005270; c=relaxed/simple;
	bh=EClXl3InvsXc/z3+6g4wc6ELOX3PafWx5ojFjilkiqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlwpvOjsqrOdcpqo+FBp421+csIJfVLGhGi+WYpJHK7P+gPxYvsXUaQxg0F/nw8VcR6c7N17PwItNnO3tlogbfkOKsF9hSSfTQ8SFRPZvc45Up8+cacWfc4HQfjW5jOLUAXmWqAULdE4F45Ib0rD8AoavsONyBiigpGzV5MMY0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sx6aMbvJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sx6aMbvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2A61F000FF;
	Mon, 21 Sep 2026 15:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005268;
	bh=+71ZFB69ekdEy1eg98Qm96XHJ5wecsPy4L/oRr1gJc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sx6aMbvJgCPRIwrMTOUWVI1AtunJb2ba9qrdSerImuI0DQV2gicaPmXPepvBepVpq
	 Nc9deiHsIKZonmQcxTk8x1/KjLT9+hJjBx53PSO+kNZK0E32MgqmKW6fVQxgFhzt6m
	 pxCvfp45zk4PvgD43exoFOGdHMtBUmJoRUsEfnAKtydL2bjBH39xWLVbuJK2ycRXAB
	 coOeNz0YwWgCXNGk6cbifitgoXuvYeou9uAfs51qo7kYPGY2HNYl0ARpEACne32UVH
	 1HMi2oWDzRYSVjQGuOjC4iwuH9FZHAxu6CKZAzbIKfdk5N/T8x2bCKYFIv4Fa1xj5H
	 xdQ9JGiF8/HBw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 01/10] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
Date: Mon, 21 Sep 2026 17:40:17 +0200
Message-ID: <20260921154015.2971990-13-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2124; i=cassel@kernel.org; h=from:subject; bh=EClXl3InvsXc/z3+6g4wc6ELOX3PafWx5ojFjilkiqI=; b=kA0DAAoWyWQxo5nGTXIByyZiAGqxT+bILm5BQp5XikWK6rprLaZxXGUi6de+yQHuNus90ZaZS Yh1BAAWCgAdFiEETfhEv3OLR5THIdw8yWQxo5nGTXIFAmqxT+YACgkQyWQxo5nGTXKRuwEAlnw7 ofD2B8kjcgLu8/AOvkU3mmhtVb7HWMTGwzwnAkYBAIG4B2Sf1uih6JweKDEk8s7FwR9PfuR7+cT SQFMhMkoB
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

The LOWEST ALIGNED LOGICAL BLOCK ADDRESS field indicates the LBA of the
first logical block that is located at the beginning of a physical
block, see SBC-6 r02 (T10/BSR INCITS 587), 5.20.2. scsi_debug reports
the lowest_aligned module parameter in that field of the READ CAPACITY
(16) parameter data, but nothing else in the driver acts on it: the data
it stores begins at LBA 0 and has no physical block structure behind it.

That does not matter for a device that is not zoned, where a write need
not end on a physical block boundary at all. It does matter for a zoned
device: ZBC requires a write to a sequential write required zone to end
on a physical block boundary, and a zone begins at a multiple of the
zone size, so a non-zero lowest aligned LBA puts the beginning of every
zone in the middle of a physical block. A host that writes in units of
the zone write granularity that it was given can then never satisfy the
requirement, and such a zone cannot be written at all.

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

