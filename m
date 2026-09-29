Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B053A6EE6
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670362; cv=none; b=IxqkTUIp1SOgzsy3CnRYCCbG9ufOBLK4YW/5GGvWEkV1/nhJi4dn7pZsJIzc3EXvn/eV9f0r+o94b3njhhiI/mFd6HHCBfJutEAGBCoS31Gj2ZEga+JGl/Moyah8O0M3iYXQdSuX26G1Io2+KekFmk0DSjVrYEI+BM20CChdMHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670362; c=relaxed/simple;
	bh=K49wfNbT6iHprL/xSeO29tbPdCbhwGi1dKnsuPKX5V4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WH30/z9JMIgPLWCYdgKhxsAVE1EthoqOiILml2fpxHz3pnHJDPqboYCZ1vfbX5ZmKHr9WTS1eex7UvyOpkF6hHc2yorE3GIbCsdIB471C6Dsj9e/qWGx94s4Tlf7vufBTGsiaXLdpK8p2yMguWOlJ5g5dritsIG5YgtfMKyrIn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYlq/n/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYlq/n/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A592B1F00893;
	Tue, 29 Sep 2026 08:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670361;
	bh=2e9j/iao5CPcczW4a8v5S2z9iM9GLw58DwKAYaQwRiI=;
	h=From:To:Cc:Subject:Date;
	b=jYlq/n/HKfJR2HYuKB/FHEr+cZ46EBYHwhBT21mtgTHvsQa+NoR12UKRgN25vudT+
	 kpeY491aasGxCMLtk+wfO8tFHTBo+5Vg63oxWUopl/q7C8n82jr/bf3HlAYPgLjsES
	 bTh7fes1Drh2d/XNne+xaRocrGZwFo3kunocJaYGsvgU2kEBJnuyRZssVDaBM9tfbf
	 6LHSf7CySbNuzUSZzH63hUXmGhjAq3G1OjYOpk8F6Bn1ViHc1MDCptmRXtQh+t53yN
	 8JoPHa7HUHKAwGtWzvOhqAa5Us/KjZy0rTm2NYtYbY4PzaPpHdb95kwqxEFy39RuxD
	 FxxzoSOTlethA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 00/13] scsi: scsi_debug: fix zoned write validation
Date: Tue, 29 Sep 2026 10:24:57 +0200
Message-ID: <20260929082456.857423-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2879; i=cassel@kernel.org; h=from:subject; bh=K49wfNbT6iHprL/xSeO29tbPdCbhwGi1dKnsuPKX5V4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l97I/3rirsfzB1HBnrM+rHoSXv7vhm9C/EzRlKRDT y9GBh+d2VHKwiDGxSArpsji+8Nlf3G3+5TjindsYOawMoEMYeDiFICJfDNgZNgWVbEgL/jz6VN1 ldG/5vqvbPjNGVjGsms+6/PSlTsSze8w/OHxP84WKpD3uMVicex9TX+xe3f4vkY432mTyKjbbX3 9JjMA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

This series fixes scsi_debug with regards to writes to a ZBC drive, and
to WRITE ATOMIC (16). Each patch describes the problem that it fixes.

Two configurations are refused rather than emulated, and those two
patches come first, as the rest of the series relies on what they
exclude: a zoned device whose lowest aligned LBA is not zero, which no
host writing in units of the reported zone write granularity could ever
write, and atomic writes on a zoned device, which no drive supports.

Little of this is reachable in a default configuration. Most of it needs
physblk_exp, atomic_wr or logical block provisioning to be set, or an
initiator that does not provide a data buffer matching the transfer
length of the command.

The series is based on 7.4/scsi-staging rather than 7.3/scsi-fixes (as
Damien suggested on v1) to avoid a build failure that would have
happened if this series was simply merged with linux-next:

  error: too many arguments to function 'mk_sense_buffer'

Tested on a zoned scsi_debug device with 512 byte logical blocks and a
4096 byte physical block, and on a device that is not zoned for the
WRITE ATOMIC (16) patches. The notes below each patch describe what was
observed before and after it.

Changes since v10:
- Patch 3 is new. A negative physblk_exp was accepted, and the driver
  shifts by it. Sashiko pointed this out.
- Patch 6 caps the offset at the length of the buffer rather than at
  U32_MAX, which is -1 as an off_t on 32-bit architectures, as Sashiko
  pointed out.
- Patch 7 only sets the residual when it is non-zero, as Damien
  suggested. Picked up his Reviewed-by.
- Patch 11 cites SBC-6 4.28.2 in the comment above the new check, as
  John suggested. Picked up his Reviewed-by.

Niklas Cassel (13):
  scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned
    LBA
  scsi: scsi_debug: Make atomic writes and ZBC emulation mutually
    exclusive
  scsi: scsi_debug: Refuse a negative physblk_exp
  scsi: scsi_debug: Take the zone metadata lock before the data lock
  scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
  scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
  scsi: scsi_debug: Report the residual of a write
  scsi: scsi_debug: Enforce physical block alignment of zoned writes
  scsi: scsi_debug: Do not write a partial physical block to a zoned
    device
  scsi: scsi_debug: Advance the write pointer over the data written
  scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
  scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
  scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 143 ++++++++++++++++++++++++++++++--------
 1 file changed, 115 insertions(+), 28 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.55.0

