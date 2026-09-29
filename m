Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8471339B94F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670376; cv=none; b=BG3jt5ekPTnmGEbRBbZ+k4junn+DNM59CNwlHXMuuQT8CfeyWE+kEzzMW63mNNiev46YdNKh6kR+xQ4g3ziCoxUKdbF3Np1v7ts/5orsvsPUb2TK/asnW+d7i5NQZVTXeHus12J1T0BpbzISnIzWbokv8DASRpsl+JkFZocBut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670376; c=relaxed/simple;
	bh=fMwHJKwKvkHt49zcLZrL25ULMeaF9xGLhNtK15HXiLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8wgpd4/unHTviN1/cDSqBPqh4kyft5YakqCZZc2ggVaq6VQbJkkV0R7SwLJHOXK01vUS0qFig4Sb7metlIYwEw4FhfwFOEe7AdnwptyMB4fuxHjD6TB3rJZwhk20yL6ubQ4DDBI/Nqb1l/eEq3qpuZrksRQMVMWLhJ50Y4QKpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpd9+Vi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpd9+Vi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D801F00893;
	Tue, 29 Sep 2026 08:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670375;
	bh=OZNvsulpAiFA651bWd0FcQ/BoyPWaMDXdohsz/RRxiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpd9+Vi7YQeNaSutifaX/M8aaOcNsmLvvTHzdGcUROWD7h5Ji7aCgVqz7d88wLpOG
	 PdWOZZDEB8EmEfJt1sLeZdYH+Q7qz/UdbhccJrp3ootIZGdznx/FT71kmbSCOzeWKY
	 Pv4DusNJ9VDOxezaH7F24w/o0nC1yXljx0GSmroCYLguNCxbCGpnqRzuGZPCIIr6Wy
	 AcCng2ymaXS21FeEnCgWWvSToQQNJOGVpFsgnBEs4rbTprxbba4bCQ/IVQVyvu0p/O
	 arwFN9NGJlriBfhh/XPJZ/wAfICZYoK/bRpDTU8/wZp+8z/tGSmbGMsoHuQtFNpnpM
	 9YrUrct1DfLEQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 08/13] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Tue, 29 Sep 2026 10:25:05 +0200
Message-ID: <20260929082456.857423-23-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2828; i=cassel@kernel.org; h=from:subject; bh=fMwHJKwKvkHt49zcLZrL25ULMeaF9xGLhNtK15HXiLY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l75dcnjzrpeMb5oDVvDKcMn/bmb1WP/spWmI1FwhO RmVkoqUjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEyEvZiR4fFd+4fV/Xu2qi2x f6159AEbz6v7TBy7LnNyyrycZ1Z7opvhF3MUb+qeVwFSnw4F+7x4rc/MrOWqu+//nav32kwPfyz 9wAoA
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
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2f828820cbea..501cf63671a0 100644
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

