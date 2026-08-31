Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A200335A385;
	Mon, 31 Aug 2026 02:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141943; cv=none; b=TD/8AFIK2lPty/hD8069ti+E3ZB38eTb0pzwt5ApTaHNvVD7t7M1R/jyHrM/nvFUTqECh4R/0oNxAG4MnXMaueCY+uG6jtC9BzwCePpOoQj1gIq2W6oXh7G1DbBALDvcFAccfVJZv/lHBBr2iM+8WNIEx6ezZaRWI28bXeYNS1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141943; c=relaxed/simple;
	bh=jVUvAU/jipcW7xL3UyK6BLg5G3rAjjS4URRj2j+qCmE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErLlxJ1AszymNfed8QeCHKyMumst2I9hTmSxUkwO7b62zCciTqKupugpm7kWFwuHqVW6HBHvsvV3N0NjE02PZCg7eRtX79ZhIlgvydzNvKUnNMvvwEgnHRdYehK4W2QFoos8/tnqsLjJwh9BppgUUhBaaE4kTrKpDhLqFWWC2Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJCWscFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJCWscFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A59D1F00A3D;
	Mon, 31 Aug 2026 02:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141942;
	bh=7du7Ly4+lxohLAzkVpO8BgMX1xcb851UPT7FENfEx7Q=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=VJCWscFmfthbWKZIhz74X9LeHXtx17cypCQ149aCsX47Ar7U1f2ONl4uC025Opsvg
	 Y7LR+zAvO8TYIu4H6LTeI9nLS07KzDsTnUpW9aRxDurenMpOFm86Ie2lftJD8cryV6
	 DpuWsBO6tOtoDcOX4uTMbo6lZT0paslMkRUPVEve2KuahO+gJa4ZSncFefxr0+tb0+
	 NtOSL+sY8SP0pOhyfyD1WX74c6sQKiufqv60djHfneMJkAcUzwEWPiClCpndgCRfcF
	 g7yLZClW0tt5LH71blFBr31lvJ76zymQ74yN/jDFtD4QYvcFfWbd3ZqHExsmi6HOwX
	 tq3fu0fRNvsJw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 24/37] scsi: qla2xxx: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:38 +0900
Message-ID: <20260831020451.585944-25-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
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

