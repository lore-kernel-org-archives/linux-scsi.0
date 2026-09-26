Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB872DCBE3
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446630; cv=none; b=lTsPhYItRU3Qjt4dcDSwWiGBPIUQ/gk4wdotlFACaLAI3nFj1YEgBRrycg6EFX7pm8zTmTvDV+8B/w2JIYNzThX8ns7CONHtK1Ilz+OmCFVveQDZhhBXjRc1mImzhGdCp8Vc/ME+IzeZwS+c2cpbznNXE7yRemJB/qt/nbghnQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446630; c=relaxed/simple;
	bh=x4yBjruf298l/dt759XMqJm7e6xyvBc/kDFB1kZODhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kPKwUd3590fYe+goqyEoB7758un5nNx+zQuhvJrgqoeCMXXKRybDTKBoHNrQbR9eV88UQqVO08x3ewwmJXNIO5N11Zp/0lN5s5kBbL73DMJNutBsGJyuYLZCLekHS3al//ZiteZtYE4e4FjodphEtgC0YI+O0SHfGFTSIp6MAqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgjZlQiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgjZlQiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4F61F000FF;
	Sat, 26 Sep 2026 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446629;
	bh=93QoXoqW51DqzOF2sWPW5fM44P1tSggXxpWaMK3ZFog=;
	h=From:To:Cc:Subject:Date;
	b=QgjZlQiWuOlvLWb1N2LZ/AS+YaA7R+ODi13NrJTjuxMtg/BMHQqMQE7Q3iCBc+869
	 jZ4WmrDBGtXEqCjP3wAjhCXjnttWlV3IdALqn9EeBe5dp2KlDSkgBBoQPYptYhfy9S
	 6pwkILaVQoLnXadNl6VMOzrGpu4pXt5/CyHdPjKxtfcBwC5WkhhR8dtOGrcPvQn6Qy
	 mbo4Bwo1OkmxT7v2fiRrPDu2CnmDlWcHjDZq3Ab2lneSFmN9cDufxLw4EwsPQH1deO
	 qcQJEM3xIGiQSaH8M7qtdnub3n+bzjZYNnch4bUDoPDHA6ajNvPA5UhQh+GftWOK6j
	 br+NttOxU5PzQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v8 00/11] scsi: scsi_debug: fix zoned write validation
Date: Sat, 26 Sep 2026 20:17:03 +0200
Message-ID: <20260926181702.508975-13-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2419; i=cassel@kernel.org; h=from:subject; bh=x4yBjruf298l/dt759XMqJm7e6xyvBc/kDFB1kZODhw=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ28MitXHeuva5NzEZk5/srS17+S5jyN9RxkUZSoJdkQ 3dD2NWdHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjIZwmGf5rJJ5raH/Zc3OOY uk7kff6ReY1bV9n/+irMdal5yS+J7fKMDL0HzlluzRQ7KPY9ctlHaVMOmyj1103W05Y2sdqv+Lc mjQkA
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

Changes since v7:
- Patch 10 adds a comment above map_region() explaining why its callers
  may map more than was written, as John suggested. Picked up his
  Reviewed-by.

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

 drivers/scsi/scsi_debug.c | 121 +++++++++++++++++++++++++++++++-------
 1 file changed, 100 insertions(+), 21 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.55.0

