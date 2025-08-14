Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF32D45948
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192757; cv=none; b=kAJaGrwXHC6i1TDF64UMet4UJTspkH+9GOTcYOYNkt1tXHLZCQsa2tr47awRd0xSoIAPT5+iLPr4RoA9SuqoNlm1KwYIPzeEzKLPDprD1CZtJviOYUCRQsSvmjFnBjePQFj+ERrTsgWdkyb375PX+tIQ0pmhJrZ87L3/CskpbmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192757; c=relaxed/simple;
	bh=5EC/sij7i9teegC1geV/39cvEWMkVynuDC7eGHkCHF0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HA2WAiYKAq/1xSBm9txkAJh/WCpI2q14214y3kEYvPZ+fUTlVntdf3FpB7yov3MAhhRzSPLZ9Xx2U8Rq57FXZ+4qPBJC9S0xcgIeQo1oW+WyB9jyz1AYr4qM3xyxKqW6CxvtW29UCCa+jzAHunPCukfJOfcTM9xLaCumfWZ6V/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MOI5cQRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MOI5cQRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76ABBC4CEED;
	Thu, 14 Aug 2025 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192756;
	bh=5EC/sij7i9teegC1geV/39cvEWMkVynuDC7eGHkCHF0=;
	h=From:To:Cc:Subject:Date:From;
	b=MOI5cQRnMKqQsc6qle87QcVib8AXSryNmKaD81DWWZm5jqMS4rD3BcirFBLNa9+/r
	 DcHvRTWQqDHQx484CVwe+iF5QoMizLwBqaRiyUv74jsblG7PrKWlb4uBdK0g4qUCWf
	 rBb4NMXBNuYEqK0AAzea5H3zgioo5SC1ocKrfNsN09darVozhI0DjXI2qx3+RkmN0A
	 L0rDit7epCDc2phBKEQZ+GV8Q45WzmFiZqy4pJyiFs7SeCr6qLu29rjVyeJ3bCpYXX
	 /AppQjyPTbbkSiwOnxlrcDtHaUz1WHw+KjwEsbDTK3SDmG/UJlOBHs1Q9e58B1l869
	 yMlHAUd/mxLdw==
From: Niklas Cassel <cassel@kernel.org>
To: Yihang Li <liyihang9@h-partners.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Terrence Adams <tadamsjr@google.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	Deepak Ukey <deepak.ukey@microsemi.com>,
	Viswas G <Viswas.G@microsemi.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	Jack Wang <jinpu.wang@profitbricks.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 00/10] scsi: pm80xx: Fix expander support
Date: Thu, 14 Aug 2025 19:32:15 +0200
Message-ID: <20250814173215.1765055-12-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1998; i=cassel@kernel.org; h=from:subject; bh=5EC/sij7i9teegC1geV/39cvEWMkVynuDC7eGHkCHF0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyc53WPVVdGmCG8MTjrea9a8EfLL+hdr8rq5W33PD2 WxjEse0jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEzEQ5Phn6n+J6/IUFfdouVr 9I+fuNlx4X/HeSm/Su+Ll/081mbE/GVkWMhYmvczqZdZeavO87QkTbsL0vZu24uX/1v83rbIZp0 tHwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Hello all,

Some recent patches broke expander support for the pm80xx driver.

The first two patches in this series make sure that expanders work with
the pm80xx driver again.

It also fixes a bug in pm8001_abort_task() that was found through code
review.

There is also some patches that make the pm80xx driver more robust, so it
is less likely that the expander support will break again in the future.

There is also some minor changes to some other libsas drivers to make use
of the new dev_parent_is_expander() helper.

Please test and review.


Kind regards,
Niklas


Changes since V1:
-Addressed Damien's review comments.
-Picked up tags from Igor. Did not pick up tags on patches that were
 changed.


Niklas Cassel (10):
  scsi: pm80xx: Restore support for expanders
  scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
  scsi: libsas: Add dev_parent_is_expander() helper
  scsi: hisi_sas: Use dev_parent_is_expander() helper
  scsi: isci: Use dev_parent_is_expander() helper
  scsi: mvsas: Use dev_parent_is_expander() helper
  scsi: pm80xx: Use dev_parent_is_expander() helper
  scsi: pm80xx: Add helper function to get the local phy id
  scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an
    expander
  scsi: pm80xx: Use pm80xx_get_local_phy_id() to access phy array

 drivers/scsi/hisi_sas/hisi_sas_main.c  |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  6 ++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  6 ++---
 drivers/scsi/isci/remote_device.c      |  2 +-
 drivers/scsi/libsas/sas_expander.c     |  5 +---
 drivers/scsi/mvsas/mv_sas.c            |  2 +-
 drivers/scsi/pm8001/pm8001_hwi.c       | 11 +++------
 drivers/scsi/pm8001/pm8001_sas.c       | 34 ++++++++++++++++++++------
 drivers/scsi/pm8001/pm8001_sas.h       |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c       | 10 +++-----
 include/scsi/libsas.h                  |  8 ++++++
 11 files changed, 50 insertions(+), 37 deletions(-)

-- 
2.50.1

