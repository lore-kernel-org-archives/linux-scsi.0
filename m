Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE8638DC68
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248915; cv=none; b=U/42STDG0L6PjZfuBQeEuh9ZoeZaLpf+xCyfGuALvrHj0VQOq183/FSZ82ECVC/+J99qUAyP+lXCx1Sm47PCGNSHVdPLubJEvPe5gsVzj3kximqn2TuqK+lSLE8kC1WpJLMtWa0WQ8GdQXqPgR0c3RE9wgvE6T78pTKHAogzxRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248915; c=relaxed/simple;
	bh=ouRUATUYEUnt+TQSUSaIqUbHbgdUGDBxkSKhit0g0Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnmvljLGpN2whaPHPVj3L6qOdAMYmBtlJAThTOeurn0HxwTQ4ZIVTscOCwWu9YeldMdoNtYcNjswmnsqeoxRpD2AtmAoWpcxPQGsZDtibQWlnPFSyWhlJ1/CuXNuUiC6Hcds6wRfR0EEe4dbr+lU9j9/p+3ZmlynMl7fFAxXmk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiEdxitP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiEdxitP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11471F00898;
	Thu, 24 Sep 2026 11:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248911;
	bh=gR1B62YOJ3wXY9WSg5vNIhgei51gyO8vTLcgzsTYWw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiEdxitP4lSujjrgp3/sOBb3GryjfrwxCuWkwTOzy2K06sOP4j40UiMQ4xqFV61Mx
	 rZaBSi7blGJk22jndQxPZD4wProAQ9tp/De66KnQDrR4lp1MItNlSuh4xGeHNJosij
	 Pe7N2dxk8vVtnVL6t5KawF2BBadj/NLYQJMDNKhRLY4ggaVuDOwMNHunDv58NTZbho
	 GsKRx4zP0kggzlblFEdoPchmytw54F76shx83WpjG5ofrvL05pYTIhgkilrIuYEPKj
	 A9pIlAYs3B4zMc5yxfg/kkzXDAhq+hkfS3ECKHKWg2nvm2kx/dzF3fpc7Og3TeebAq
	 N3iLUyVTFYvpA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 06/11] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Thu, 24 Sep 2026 13:21:34 +0200
Message-ID: <20260924112127.3815255-19-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3020; i=cassel@kernel.org; h=from:subject; bh=ouRUATUYEUnt+TQSUSaIqUbHbgdUGDBxkSKhit0g0Nk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su+eUOYodOfvruXX4xLO6f1OStw8Y6+3+xW9Qh6vJ wZPshIXdZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAia6MYGX4KVh2WWNgj+8d0 46lLSxI+ltYbXEp/nK8362Xh20Lhp2cZ/jsVhSy6anJg5vUlU1fOik1I2BxeVRn3KWpXzvNkJcE aEz4A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, requires a write to a
sequential write required zone to be terminated with ILLEGAL REQUEST /
UNALIGNED WRITE COMMAND both when it does not start at the write pointer
and when it does not end on a physical block boundary. That is why
sd_zbc_read_zones() sets the zone_write_granularity queue limit to the
physical block size of a host-managed device.

check_zbc_access_params() implements the first condition but not the
second. So with zbc=managed sector_size=512 physblk_exp=3, a write of a
single logical block at the write pointer is accepted and advances the
write pointer by one logical block, leaving it off the granularity that
was advertised: nothing can write at it any more, and the zone can only
be used again after being reset.

Check the ending LBA as well, with the same sense data, as the standard
gives both conditions the same. An entire medium write same command,
which the standard excludes, needs no special case: the preceding check
already terminates it with WRITE BOUNDARY VIOLATION. Sequential write
preferred zones are left alone, as writes to them need not be
sequential, and with the default physblk_exp=0 the check is a no-op.

Assisted-by: LLM
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

Before this patch, a one logical block WRITE(16) at the write pointer of
an empty sequential write required zone completes with GOOD status and
leaves the write pointer at LBA 0x18001, which is not a multiple of the
4096 byte zone_write_granularity reported for the device. After it, the
same command is terminated with ILLEGAL REQUEST / UNALIGNED WRITE
COMMAND and the zone is left EMPTY, while an aligned eight block write
is still accepted.

Compared to the version reviewed in v1, the only change is that the new
mk_sense_buffer() call uses the combined UNALIGNED_WRITE_COMMAND sense
code, as this is based on 7.4/scsi-staging.
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index fd80f66a86ac..f434fa033745 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3980,6 +3980,16 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 					UNALIGNED_WRITE_COMMAND);
 			return check_condition_result;
 		}
+		/*
+		 * Writes must end on a physical block boundary, that is, the
+		 * transfer length must be a multiple of the physical block
+		 * size.
+		 */
+		if (!IS_ALIGNED(lba + num, 1U << sdebug_physblk_exp)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					UNALIGNED_WRITE_COMMAND);
+			return check_condition_result;
+		}
 	}
 
 	/* Handle implicit open of closed and empty zones */
-- 
2.55.0

