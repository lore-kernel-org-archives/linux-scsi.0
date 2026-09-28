Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE733A02B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580078; cv=none; b=irGi7T+E0YZpo41THhAciU/p5HgMtHQuRxKE4f/Y0DmzVuuKx4anXweZtdQDxau32xtRRC+cDZuXDIpqX28947NOWO8rw/I3Ju7o25ULDyCClu2+TYVk/TDdJ4Zcm/CZFxjCVA2Mpmd3XrlK8lgcjPj9tzVyv/TP0rFbi1/QnA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580078; c=relaxed/simple;
	bh=HqolfxAJQFTc0yg9psIzD8Lk9CSQ1ZM5b/OeogT1ghA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cc8KspFQqArhh5U+zY7oQMkm4wFY7DerFlEp1pHMkWazJD1id4vND7AZ8IUAQnBz4q6+d6yCh9R/zl899jrbrKWOvt7PiQ0BQAhoCsbMMdanmCZ2AJUz4qAGOHMWN/QW8LC1d0W1M3zws/Zk97pW7vfRDMXct5OZYnzwxMnxwks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNruIGTA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNruIGTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041201F000FF;
	Mon, 28 Sep 2026 07:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580077;
	bh=e6ka/DP1W6ZgqHXv6RrxDTxrd5iEj4OHeHmM3ah49BQ=;
	h=From:To:Cc:Subject:Date;
	b=bNruIGTAzkcZenXQll/n9hTVuE+vbJgJAX91kUCYWhk4dRpgADjlkLd5XBOEmSW/Z
	 RpmgRlQF6IXzN1QSsL48BA+x0p0iZxRrLjJ0N7ca4glDHog5b4UFfQ1/Rl+q6yRnKK
	 nDPDw2/4nI4786oJdXCKMFdVBVgDMOIoJ54qThuwonnKNvzQnLRQRNxWjpETrUFgZV
	 MdS4N9jwmp5GvmgtnUJ1D2R3OBiXETw5VXUZ1BzBD0CXkEpwBe7QREh9jUjQrLYBUl
	 zhot1YUU2Qd1NPuBOT1enL8xC+hN6VxEktsChmVJxi4z2M/6rQKXPLZsU9cwbtywoG
	 +BlT/gH68rfQA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 00/12] scsi: scsi_debug: fix zoned write validation
Date: Mon, 28 Sep 2026 09:21:03 +0200
Message-ID: <20260928072102.725566-14-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2684; i=cassel@kernel.org; h=from:subject; bh=HqolfxAJQFTc0yg9psIzD8Lk9CSQ1ZM5b/OeogT1ghA=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2icZ5zPEJ2XJyTeBsvht/t8VY5vD5c1om6nGcUJy/u E3UoOZURykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACaybBkjw5I36s3RQp8t5lRs 72uT3rB31o2WdBuuB60rYpdM2//0lDTDX4lf17gyz/SW1718LlyrMmkX16zvB3yOCR5Z//zEzdd h85kB
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

Changes since v9:
- Patch 5 is new. A WRITE SCATTERED (16) range of 4 GiB or more wrapped
  the 32-bit offset into the data-out buffer, so the ranges that followed
  were written from the wrong part of it. Sashiko pointed out that the
  wrap also gave a wrong residual.
- Patch 6 cites the definition of the residual in
  Documentation/scsi/scsi_mid_low_api.rst.

Niklas Cassel (12):
  scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned
    LBA
  scsi: scsi_debug: Make atomic writes and ZBC emulation mutually
    exclusive
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

 drivers/scsi/scsi_debug.c | 132 ++++++++++++++++++++++++++++++--------
 1 file changed, 106 insertions(+), 26 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.55.0

