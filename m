Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B23806C0;
	Thu,  3 Sep 2026 03:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406985; cv=none; b=GaZvepFdqHOnixIeyZyWDPAdYhVFTi/ScRBzDZHi3iZqiqysAb538TFKxd0Zbk8AKSKCkO1k1mRm2yLo+SO3J9UBCvWmA9Zh0MzOv3SBjfykDagZtNPG40f54WNiWRS5/KWUC+RnURXAZJ7Fh8IPE2vrBNX6BotaZt27CdZk5JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406985; c=relaxed/simple;
	bh=jVUvAU/jipcW7xL3UyK6BLg5G3rAjjS4URRj2j+qCmE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzMiujZ2j8WiOk7BUPBoSKDHvZwLPo+/yOk1o89o2KfKWUFn86CqAkAyXk7jxzZf/V36yK4Fs2gzNoP3GGUowbogF2dC8bmA5PwhcnTp5y9rNkL/GT0Mp+3iu2yV+mRcwbhKpaSE1fwFuVC/siFe1PEDQ/ePlY2AJK91KeBJ87A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akQVrOCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akQVrOCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE031F00A3E;
	Thu,  3 Sep 2026 03:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406979;
	bh=7du7Ly4+lxohLAzkVpO8BgMX1xcb851UPT7FENfEx7Q=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=akQVrOCCfEvbnBjwmIgAx+pXf851GuLrzCPCschcS0vWUCGH/96p2fN9bMBEBfFYV
	 rSV1UHsY5mQ8P7qEEQKhUE/rtzPTZ4y+CvpmKld1Hh9reJX20SJDqlNkKA08i+YaOL
	 ROnXaqE1P7i562EXbaZL3otxwRUMlz5mXXKU3Prs88U8CjovXCHidUtOR3N/9Wlnx6
	 /ijF4CvVw69Yth1F7eFnBe+s+XG/DOCtJdLZ5fcNLnW+rRP3Lortwva4skVQIhjTzV
	 MJUhvrtsKvNL5Tt/5+T2vBoAhDLwLssLkTfDzQYVrkDRIpZXPLgG+CX9IQE/dkO8Cb
	 a5FxQroQC4fcw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:45 +0900
Message-ID: <20260903034201.112211-25-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the qla2xxx driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 63b70d4abbf0..89c2af3fee4f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3263,21 +3263,24 @@ qla2x00_handle_dif_error(srb_t *sp, void *pkt)
 
 	/* check guard */
 	if (e_guard != a_guard) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_GUARD_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		return 1;
 	}
 
 	/* check ref tag */
 	if (e_ref_tag != a_ref_tag) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		return 1;
 	}
 
 	/* check appl tag */
 	if (e_app_tag != a_app_tag) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		return 1;
 	}
-- 
2.55.0

