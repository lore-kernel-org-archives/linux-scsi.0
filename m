Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BCFFBFC
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 01:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717723509; cv=none; b=VsJFs5M95kvZs8kws7bJmG7/EkMganX44h/U/SHP7awE0RYT3vC5V+/daO8mpW+JmNuQ9ynn6uIMtgHVftv4ES3La20qfX9PMyzBfBjy763mttsbCE//rd14fJvNSsVIj78/IAnEZjspOJEexv72TdklgUcl6PO295A6rAtGlvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717723509; c=relaxed/simple;
	bh=WnlMZvu4tvfloZu4m0PmMWwR+D0VvJIB67n/jVhtxJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qtdSqMyhfibCxydX7unFHOGP9CSvq1qpURSI0AW4bIaeuDrIIGbiToSdzUl5ZiRLElAE6Q+G9zfy/tNaJb73KvNr21SYcUiDG4teUTki2yEDSACJoY2Oy1/0Pf9+DACjP9NR9x+y5436reZdoYW+76wqghuuzS7OyB9J55LNSeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZuJ7q2g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZuJ7q2g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F4BC2BD10;
	Fri,  7 Jun 2024 01:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717723508;
	bh=WnlMZvu4tvfloZu4m0PmMWwR+D0VvJIB67n/jVhtxJM=;
	h=From:To:Cc:Subject:Date:From;
	b=ZuJ7q2g4CtT0YjqWf8PQ/Z9wk/Jno4KAPKJE+V/nsgbrQKkXjF4HsvKVFSp/XYjdA
	 KMf/WDCjUfdnpdZcJb6ZkpVAeD9vQiZhLYFyshkyljZNRfQv07H/hwoYht6jfRg46z
	 9RUQY6r56nni3jC5CySP7SqVHFEuu0qUGEzEFp/ygoi7Az+DSAzLcqhpmn6lHEc2Yb
	 LnVID5KwVG9iKjuw+03ApnZd4oN6Mt4Do5NuZmNAvfsgHgT6Cb0ZXPGfNDGb48DKnT
	 D0pA9L4yvSXx/WLf6pWNBMEslYCol4iybZj+jT7tqgctYdGspATROwgyD0qAjn4qQz
	 ivhL7v6cQy9Hw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH v2] scsi: core: Disable CDL by default
Date: Fri,  7 Jun 2024 10:25:07 +0900
Message-ID: <20240607012507.111488-1-dlemoal@kernel.org>
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
set the scsi device cdl_enable field to the user provided bool value.
For SCSI devices supporting CDL, the feature set is always enabled and
scsi_cdl_enable() is reduced to setting the cdl_enable field.

However, for ATA devices, a drive may spin-up with the CDL feature
enabled by default. But the scsi device cdl_enable field is always
initialized to false (CDL disabled), regardless of the actual device
CDL feature state. For ATA devices managed by libata (or libsas),
libata-core always disables the CDL feature set when the device is
attached, thus syncing the state of the CDL feature on the device and of
the scsi device cdl_enable field. However, for ATA devices connected to
a SAS HBA, the CDL feature is not disabled on scan for ATA devices that
have this feature enabled by default, leading to an inconsistent state
of the feature on the device with the scsi device cdl_enable field.

Avoid this inconsistency by adding a call to scsi_cdl_enable() in
scsi_cdl_check() to make sure that the device-side state of the CDL
feature set always matches the scsi device cdl_enable field state.
This implies that CDL will always be disabled for ATA devices connected
to SAS HBAs, which is consistent with libata/libsas initialization of
the device.

Reported-by: Scott McCoy <scott.mccoy@wdc.com>
Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---

Changes from v1:
 - Fixed typo in the commit title and improved the commit message

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

