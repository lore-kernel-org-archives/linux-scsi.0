Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122E64C10F1
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005268; cv=none; b=YNPpKLANJXz2p+6C0qseY6IVV7pxZ/pl5SWnamURS3V49YFJz6UjjpRfSENM3IWCAheM4Sq/r9nYv9Ariyl1GBiQ4KDxXyeT5GYgdmnPwiaKl9k1eFqlXuSkf8BscZt6eWbwCjx4kx7EYU0APRjESl2s6dZq5cge8FuO1fUchFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005268; c=relaxed/simple;
	bh=HdAu3zZKBYoB3pge1Xapnk9rQaz+tYRWz5rxwbE8RsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=raFXc3wreA8V0ziAHehXp9cLIZ6eRZJTYOSTWBtiL4zj4vQJLJLNg4x+NNKVt0a8j+/z3aQ0vxCK6fCMPYX1hIq5Qq5GSiy7LqgqzlrVb1QTp8vDxVuRuK7g5xLTDN5VpoGHfbhpBBD7d7xwZI+7UG+EcmkxPpRA7uGdx8y16pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fElCsOJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fElCsOJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B564F1F00898;
	Mon, 21 Sep 2026 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005266;
	bh=3QKwVzn8EUHqQsn8beE9Oixb4ZxslVVspRmFsGaYyIE=;
	h=From:To:Cc:Subject:Date;
	b=fElCsOJ1EDLNZcASbX/fy/aJWOKIvPMPubSgRA/zOFhXIGv/7lMya7vuovQO0m57n
	 Xa0MyEL6NioxHfU37NQsIyPvqO1BjeGkJiDcLOHvt85OLWd7NLOnZ7wNmib/1JlrKe
	 usB28tKf+rRpQnFWmms3fHWQxLaIGCo4PHTiFDinV+pegK5pGK6ouejfUuLOW9nigb
	 e3i/DSibbAZPpGqd5aKAX26yxgKw5KBQpuFBLJ/jrUDRPvusKd8nMr3K20O9zLgwkN
	 hFvk9rkuD+55JhUhBw1+XhrKqNpKlROsD8HF1HNF1n1klrWLKrAQUp7tvg0pLzySjD
	 H7pOwXNMFudjg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 00/10] scsi: scsi_debug: fix zoned write validation
Date: Mon, 21 Sep 2026 17:40:16 +0200
Message-ID: <20260921154015.2971990-12-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2538; i=cassel@kernel.org; h=from:subject; bh=HdAu3zZKBYoB3pge1Xapnk9rQaz+tYRWz5rxwbE8RsQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+t9nimb0OLtuz9pvu269S33B0LHFq/WswtepLS0bV 8lH71j2sKOUhUGMi0FWTJHF94fL/uJu9ynHFe/YwMxhZQIZwsDFKQATUV/K8E/j66Fe8SXGVx7q J8/P+a+scIDTWG5PwdnwuY0/l194IDqXkaHZZ+WWL+cjr24qL15T2HHpd7W2BU+a6baLP54sOxX TGsQDAA==
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

Changes since v4:
- Patches 7 and 8 use a bit shift rather than a division, as Damien
  suggested. sector_size is always a power of two.
- Patch 9 drops the meta_data_locked variable, as John suggested.
- Patch 10 drops the paragraph describing the two sense codes that the
  missing check fails to generate.
- Picked up Reviewed-by tags from Damien and John.

Niklas Cassel (10):
  scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned
    LBA
  scsi: scsi_debug: Make atomic writes and ZBC emulation mutually
    exclusive
  scsi: scsi_debug: Take the zone metadata lock before the data lock
  scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
  scsi: scsi_debug: Report the residual of a write
  scsi: scsi_debug: Enforce physical block alignment of zoned writes
  scsi: scsi_debug: Do not write a partial physical block to a zoned
    device
  scsi: scsi_debug: Advance the write pointer over the data written
  scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
  scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 102 ++++++++++++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 16 deletions(-)


base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
-- 
2.55.0

