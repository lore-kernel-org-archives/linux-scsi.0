Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39654171D2;
	Fri, 18 Apr 2025 07:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744962966; cv=none; b=gwB5zix/4Z9JXTIv0tonsZ3l7q20UXsYxgHuPRjJT1IxBgJZudm9MZ6pvlUvyJgY4VRWjWqlCBB7HSDJcBZ2eKYb7bla8R9OOQfVyo+aQLUwm5cojrHXKfEG2pxWcnzMLO0yjRY1HdEv3MKAyoSSBJ/GL/S13UTSojKNXF3L2Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744962966; c=relaxed/simple;
	bh=mxBQJPiOYYkFZQyRgPVxn/5O1vP2Y4JN73VvGLl38eo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=irxxD4seItRKxw6xpE/BaKRa/iHOELsze/TfVxLnpinbxm3iMHQqKeI9tEdxjxg8yi6Ho3BhCQ6Xssu1n9bdlKUoI6I2ScfbjjGi5RDLyQN34mq97rqvgUsjI91bYKdftw/VnJPEiK6NUBVgXsrHqxt2ObYzo7v14SF/mbwoiqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GY9nI6xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GY9nI6xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDAEC4CEE2;
	Fri, 18 Apr 2025 07:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744962965;
	bh=mxBQJPiOYYkFZQyRgPVxn/5O1vP2Y4JN73VvGLl38eo=;
	h=From:To:Subject:Date:From;
	b=GY9nI6xArtBljF9b0nCThkJNpn40qlaIhyumfAx4zvN4d/zXzytdl0xg4GjsaDKy8
	 VbkYlg/8P90QR2e+uja0APFnnqMp+B+U/edH6nX6yayt0rgVOKP+VuKygL3gHN2gU5
	 vTgyyaF5m7L79ZXQa9iyx0bdYDMJ8lZNiwWuvHH4Pl77H7HfKVtzdQZPtgfbFvHiBp
	 SsQPic+dJw0pK4nWEzuNBBjyiZBcviWfKRlGMv0JaohjipM5fYsIIdRkcOl+wM5MXf
	 kaMJRf3mhx8PDcMrnhtfA1GFYUmQgsSWWo6WoPeFiuMp7THoZTGn6LcF9bvnpG45WQ
	 VBVLEYUlyfnjQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 0/5] CDL Feature control improvements
Date: Fri, 18 Apr 2025 16:55:12 +0900
Message-ID: <20250418075517.369098-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Control of the enable/disable state of an ATA device Command Duration
Limits (CDL) features has issues:
1) Incorrect checks of the feature support for translating a MODE SELECT
   command
2) Incorrect feature state report translation in libata-scsi
3) The state reported when enabling the feature was being ignored, which
   caused needless SET FEATURES commands to be issued to the device,
   thus causing an unwanted reset of the CDL statistics log page (which
   is implied by any CDL activation action).

Patches 2 to 5 patches address these issues. In addition to these, patch
1 corrects an incorrect function return type.

Martin,

I can take the scsi patch if you are OK with it. Or the reverse, you can
take all patches through the scsi tree if you prefer. Please let me
know.

Changes from v1:
 - Added Patch 1 and 2
 - Added review tags to patches 3, 4 and 5

Damien Le Moal (5):
  ata: libata-scsi: Fix ata_mselect_control_ata_feature() return type
  ata: libata-scsi: Fail MODE SELECT for unsupported mode pages
  ata: libata-scsi: Fix ata_msense_control_ata_feature()
  ata: libata-scsi: Improve CDL control
  scsi: Improve CDL control

 drivers/ata/libata-scsi.c | 36 ++++++++++++++++++++++++++++--------
 drivers/scsi/scsi.c       | 36 ++++++++++++++++++++++++------------
 2 files changed, 52 insertions(+), 20 deletions(-)

-- 
2.49.0

