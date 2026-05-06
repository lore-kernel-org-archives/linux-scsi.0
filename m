Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6197048032D
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 14:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778076107; cv=none; b=ceqOASxs3TSMUEjxiZkCLrr7bGIL9+9mYTNqDVjmiVvyaVgy+GOhe339xZwuUO9LsPJd15ce+oTY7sOzvLKG7Eit3V4Basb0GH2kZ4cCHyhpKdCEmEEetSJbQ39ON9Z/OcgnSMymzDNA7oHFAXlJ3Ux6m8hBwdKLKwaIo+lS/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778076107; c=relaxed/simple;
	bh=oHhNXz/r/KzAQ2IVnHKM2M3mD7VMZuBMs6UzCCq150E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogNNZuB80N6SELYc+QM25QH428A88CgqhFH9JO5YYcYEf1r8GyNYRQvKUyx2m3D7LpPl5bJii5b52RwAJbxcCOIGATpsqUco+zI+1U8Jxh0uAkR3pSB+aHNn+mKFD9bw3Hl8/3FyusupHqDAI8zMijj+eNlIboM8qmV6VivNLqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=R+OQpwJ4; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="R+OQpwJ4"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 950DD241BB7
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 16:01:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1778076103; bh=ZtL8MBADXjrJv0Grrg6L/r4ralN6zP19+joyWk9P4J0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=R+OQpwJ43T95SawK40XE0hFSBD62PeU+VUGSZuPHnQbEttniu1OWJg20NXvHXVD/d
	 fIMeMJng8l0TNe7kQOEHW4Q8u+Wgp5EzyufASQJoFtPrzCjZQSFZoJEu/iRIXpqCSA
	 MmC22lreNJKvtHYZXeAdpIV9Vy5uSL65rqUBZ71JkB0ULWAUefscsFEkB4ro7TOnvD
	 I0FjB0D8Fw66sKG9C1TKXLQODqmzICwCsnXIHMJ8V39YAFGdWCipTRt9DSfagK0vZD
	 oh2FAkP+Y/W5ZGyJQ/wq3BYOgNcaCvOWwFk9s8e8dajHaqg2U9RaPLlQsQUZB49iFL
	 ZcTd2TEJlhT4Q==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4g9cWB4TkTz9rxG;
	Wed,  6 May 2026 16:01:42 +0200 (CEST)
From: Mateusz Nowicki <mateusz.nowicki@posteo.net>
To: don.brace@microchip.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mateusz Nowicki <mateusz.nowicki@microchip.com>
Subject: [PATCH 2/2] scsi: smartpqi: increase SIS ctrl ready resume timeout to 180s
Date: Wed, 06 May 2026 14:01:43 +0000
Message-ID: <ecabb7c8ab89554d362f2e15c4351e41814d073f.1778075755.git.mateusz.nowicki@posteo.net>
In-Reply-To: <cover.1778075755.git.mateusz.nowicki@posteo.net>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a PCIe hot reset, firmware boot can exceed the 90 second timeout
in sis_wait_for_ctrl_ready_resume().  On HPE SR932i-p Gen10+ boot takes
~125s, causing pqi_ctrl_init_resume() to fail with -ETIMEDOUT:

    smartpqi 0000:84:00.0: PCI reset prepare
    smartpqi 0000:84:00.0: PCI reset done - reinitializing
    smartpqi 0000:84:00.0: controller not ready after 90 seconds
    smartpqi 0000:84:00.0: reset recovery failed: -110

Match SIS_CTRL_READY_TIMEOUT_SECS (180s) used on the cold-boot path.

Signed-off-by: Mateusz Nowicki <mateusz.nowicki@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_sis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index ae5a264d062d..df06302cec38 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -58,7 +58,7 @@
 #define SIS_CTRL_KERNEL_UP			0x80
 #define SIS_CTRL_KERNEL_PANIC			0x100
 #define SIS_CTRL_READY_TIMEOUT_SECS		180
-#define SIS_CTRL_READY_RESUME_TIMEOUT_SECS	90
+#define SIS_CTRL_READY_RESUME_TIMEOUT_SECS	180
 #define SIS_CTRL_READY_POLL_INTERVAL_MSECS	10
 
 enum sis_fw_triage_status {
-- 
2.43.0

