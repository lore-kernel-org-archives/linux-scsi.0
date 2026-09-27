Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D20254707C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486825; cv=none; b=gS9muyg2/C1le6K0shvES+JoslWSU0sWVpzRewduxVqJ0X3fFHyFhQbFUR0Blq213WxIuSuVC1RKAE0EY0pxAavL8bAosTSiS8V0gMexWY/yRJCRAs2BSQFUu1Aha08u3rjsR6q/ETNq/LOTiIXKfO7mKeu23Tb01me1UfGTnTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486825; c=relaxed/simple;
	bh=TwZeIcFtbcoZvU23tSkWcx7idLes57je0hM5uRzT7f0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AqzmCmGinrI5gq+M+BnQZ1ixKldgprSU+gzSAAuE2B8riKspjVN96iXisKy1arcgMadGvubv9vuQuDmW6gpbzETTM3nsS9QQqklZM+e7b//IVTWdXUrJd/YadELKa4xacAL2qvsekXf3e00D+yvJmLbZnzQkWBQiG1q9WcbkGsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+fctmEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+fctmEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682EE1F000FF;
	Sun, 27 Sep 2026 05:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486823;
	bh=1nmBLVP5c+q0ILMAhu3QlCxxVJ8qsHGJIyrSn2scAaA=;
	h=From:To:Cc:Subject:Date;
	b=P+fctmEEUEUj+s5GquXj5VuYO5BOzWAyeYhCrM7u/RcMbjoa4cyXuT7ItOOdZm2dj
	 FdjeO6Pks3u99uY91sg1yvxZvtOs3ebwulLPuxjp0qv8sUYeMzo6/CCRmc0czcedGN
	 YLzswv0vClZbPr+6A7VTlwJbBZudQKXGxgbchkOFN2dMOp2M+ShITjvTekQu2U8rzl
	 jYnPta9RDUwNsZvnKyttW5Spb5EnWFQLXe7vwgndRB6mmebyvKL4RXK2+/qmEFD2g4
	 h3TevhV2s6S76hYNiWsiJt884vidMQEM7cwI7PQ7E/OtoStEy6941Lm4oMQxoH5p+Z
	 UYw5X1RYtDFiw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 00/11] scsi: scsi_debug: fix zoned write validation
Date: Sun, 27 Sep 2026 07:26:51 +0200
Message-ID: <20260927052650.567035-13-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2517; i=cassel@kernel.org; h=from:subject; bh=TwZeIcFtbcoZvU23tSkWcx7idLes57je0hM5uRzT7f0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rJQS7SopUtotaKTL7Cq2YEdySTV30/RDjFxvQvPCL MOe/M/rKGVhEONikBVTZPH94bK/uNt9ynHFOzYwc1iZQIYwcHEKwETkzzL8lSpKrll9b9qhw78X daYoVL1fI7z/w/OMe6tMbN4ttpEwfM3IsOQ5xz7n1m9r1l3PP6g7w3zZRatN7VpXvS9z1OlNnWc hxgUA
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

Changes since v8:
- Patch 5 reports the residual of WRITE SCATTERED (16) on every exit once
  the parameter list has been fetched, including an error on a later
  range, as Sashiko pointed out. Dropped Damien's Reviewed-by, as the
  patch has changed since he gave it.

Niklas Cassel (11):
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
  scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
  scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
  scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 120 +++++++++++++++++++++++++++++++-------
 1 file changed, 99 insertions(+), 21 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.55.0

