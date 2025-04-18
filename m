Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A04C1FFC62;
	Fri, 18 Apr 2025 23:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017632; cv=none; b=g77D/PqQybsFQGs9X9cNV4WVhE4odkHIKJPDJ3GqhvDn6Hw9rFVYEfbgwtFkxMtv5YVlMmWrENF/8BD7K/eXDoVAaYBFHBhUKcgvt593yXj0d57tuu8q935MHHNXwPopXulRUSRe56qk1Nn4fv0K8ufHK5jHGb4x5ydgjh2P4ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017632; c=relaxed/simple;
	bh=1Gp4ot/XTjOPevCzzt7O1tNdI+AWukDOLWkFWoGRCJ0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=R7Ht4KwghwREVuvflT6oBZT8Fd4LrGNoHkAHdTnnHZ5+DsjZzGlg56x5wJfqW7XObIAzWrCNRl889vC6uuZvvJtShYW9IhRgdRiSlWO2e/gEWGGXb2jmnSHb59KiwxVrFfpBnPyUqNyMuIT85002evHDkkZQmNPj8QlQAOsvJ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGEsByan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGEsByan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA800C4CEE2;
	Fri, 18 Apr 2025 23:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745017631;
	bh=1Gp4ot/XTjOPevCzzt7O1tNdI+AWukDOLWkFWoGRCJ0=;
	h=From:To:Subject:Date:From;
	b=nGEsByannoXwj40owZJQ5lRguHo+Vtf1ujYs6wW2ogxRSb98OZcsIWr9a0bSSqSk3
	 cZU82OkO38jSDDW+pouZnyqSlx4tpD4YeuIxPHjwRR69QTDKVxbPRgpq0Bn5e0BbYB
	 q3somjyTSLr56UBnjYFpND3N1Z2MMwjWQ6ssZFyLACnPZy9pmvl8qKjNZhIXYrGpG9
	 XMpw4l/SOb5hwQnF+roLZ/XLL1zwpvSzozQVqVw+Kg1kCqWyV0XhGBhy48Cu2IjrZ4
	 ISreQTDjKu7w9VyhYrIN+B6o4ZO//rnTS8TSixH+gFEFvU2/gIRPEzLukO6dVeZJkN
	 MUS4ZKy6nPHsA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 0/4] CDL Feature control improvements
Date: Sat, 19 Apr 2025 08:06:19 +0900
Message-ID: <20250418230623.375686-1-dlemoal@kernel.org>
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

Changes from v2:
 - Dropped the patch "ata: libata-scsi: Fail MODE SELECT for unsupported
   mode pages" (former patch 3) as it wasnot necessary
 - Added review tag to patch 1

Changes from v1:
 - Added Patch 1 and 2
 - Added review tags to patches 3, 4 and 5

Damien Le Moal (4):
  ata: libata-scsi: Fix ata_mselect_control_ata_feature() return type
  ata: libata-scsi: Fix ata_msense_control_ata_feature()
  ata: libata-scsi: Improve CDL control
  scsi: Improve CDL control

 drivers/ata/libata-scsi.c | 25 +++++++++++++++++--------
 drivers/scsi/scsi.c       | 36 ++++++++++++++++++++++++------------
 2 files changed, 41 insertions(+), 20 deletions(-)

-- 
2.49.0

