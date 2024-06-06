Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CE72564
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652768; cv=none; b=diGqUe91faSHxBQKAdu7ZPQwlVSA+2Z/PV/tuxOZQ5Te1oDEL3cgvkUUc3TRDUIS+OdoHIweitzjPBSNVCmW/bdkHYK2YZVj+235Co8p0CwHJYlDp34DZRcwMNa7tlmiFqxCDWF1eqAwQE0C0+vBuRdxUqftHYVQfUws5iDf7lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652768; c=relaxed/simple;
	bh=dbJ5Kemq+yk+PL0taTY7MUYr3LnV+Zw5A9CWUAnIh6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fPRwNahFYrj+SYuv982e+UdpdM8HUsFgOUsqI+H3k8VOdvp1BPBPdaCayAgHzRN4SChXXHg+/xqPs1Ux+U3uP/CjUz3fZ9TUp5bA1jF6Jd6Qnd1E1JSoEHFaI7ipZTqlgVbjFzccdXgCJLB1wsYFPRnYv17xnOxXwZ1UsWDp55c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVGwKKeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVGwKKeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04FCC4AF07;
	Thu,  6 Jun 2024 05:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717652768;
	bh=dbJ5Kemq+yk+PL0taTY7MUYr3LnV+Zw5A9CWUAnIh6o=;
	h=From:To:Cc:Subject:Date:From;
	b=PVGwKKeIbTfaIK+/+q89Tlm/nVEvOiau2Hq73BKQ6Dsj4RmKfiPKMzYLy7/E8V0Gg
	 b6W+BoPNt5oJWq67A2wvjm0KZ+I8oMUxkIWZ4nSZLmALabhLDl/pnMKNGodITqa0At
	 5+1dZL0eQm4XigwUKzPGtood9+qxZZ1y0E867y5VUQu9Xksz7afBmo/03i5VbJtBp7
	 OAa9/L48qYC2niYpMEqTkacieI3OQw6MGXHHWRFudsYKQzMCik3VyU1WlbCgcYlt0J
	 X0EM8Eg8mzP8zAaBQcWdwKi+6Uzy0I3RkWW23abEgDiXyqkxV0QsDQNp+4Mx5Kms13
	 jd4ddy8iRnCVA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>
Subject: [PATCH] scsi: core: Disabe CDL by default
Date: Thu,  6 Jun 2024 14:46:06 +0900
Message-ID: <20240606054606.55624-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For scsi devices supporting the Command Duration Limits feature set, the
user can enable/disable this feature use through the sysfs device
attribute cdl_enable. This attribute modification triggers a call to
scsi_cdl_enable() to enable and disable the feature for ATA devices and
set the scsi device cdl_enable to the user provided bool value.

However, for ATA devices, a drive may spin-up with the CDL feature
either enabled or disabled by default, depending on the drive. But the
scsi device cdl_enable field is always initialized to false (CDL
disabled), regardless of the actual device CDL feature state.

Add a call to scsi_cdl_enable() in scsi_cdl_check() to make sure that
the device-side state of the CDL feature always matches the scsi device
cdl_enable field state, thus avoiding inconsistencies for devices that
have CDL enabled when first scanned. This implies that CDL will always
be disabled, as it should be, when the system first scans the devices.

Reported-by: Scott McCoy <scott.mccoy@wdc.com>
Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3e0c0381277a..9e9576066e8d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -666,6 +666,13 @@ void scsi_cdl_check(struct scsi_device *sdev)
 		sdev->use_10_for_rw = 0;
 
 		sdev->cdl_supported = 1;
+
+		/*
+		 * If the device supports CDL, make sure that the current drive
+		 * feature status is consistent with the user controlled
+		 * cdl_enable state.
+		 */
+		scsi_cdl_enable(sdev, sdev->cdl_enable);
 	} else {
 		sdev->cdl_supported = 0;
 	}
-- 
2.45.2

