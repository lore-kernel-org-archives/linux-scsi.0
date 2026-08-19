Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56AE3BE652;
	Wed, 19 Aug 2026 03:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787109814; cv=none; b=ZreT6bBacbym1GbbN/1gxnflOhnFO9ay74zGqnG7Wylx/rRW2D7mAz9WtoYMdKRBneFdHumj4eC6kuoTtbTVTglD7UGiwyYZbg14kQUJliQu0gA7xsScuCehRrgqgLaDVt0GNIJ+9+e3f+PFY5sFbH2ajKqWO4Oy5hZGESXZf30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787109814; c=relaxed/simple;
	bh=tF3vC/jSsAS2ZCsahL49g6i+80aiWSj9SUNFvf/LloQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=coCBYZ5Tkj343eUe8i3Hs+Ga/zxfzG3hPLu8VB3Isx9AOnCoY5oCAz/i0LUjKrqnVgsB4F1wX1XWkN8e7Tf6ZXi9mFBxyvO2WhTK5Lm6U0O5B0g/j0e02Kzte/cUQgAh5A05pVqfYHV0qmjLEgbxghguu1AZbqIxb0kHOdnfcGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs5l+SLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs5l+SLI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B26FC19425;
	Wed, 19 Aug 2026 03:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787109814;
	bh=tF3vC/jSsAS2ZCsahL49g6i+80aiWSj9SUNFvf/LloQ=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=Zs5l+SLI337kGGyQFrdwYTo7rgEOdnRaXGxjfVAGIlAB5QBqlqrLySeURUzIoxBO8
	 4UfWLxmucuorfQR7ZDqHPVFF5N2yjJQ1+EgK9dPb5j/pIwnrmxdKRUPuWsZ/PKBx9r
	 ribQCw+TnzvCvrqVPdH+braBLe6p2+oSTsk9qMbmlqLcyaIrZqCGtZnvjuwzuj3rFt
	 3rJb0cqNXi9Thn+KnTNuhjqbYgkesZW6ALFRAcqTqaiyv55vgeR4rjjnudGBB8IoLB
	 s5Eib0O5RrTGMSMtG/hTOe2cHLgpElrqLV9837WYsab/QKPoFZvibQMJyqxLnmI1PZ
	 nr4T7xGepmVZQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA01C5DF82;
	Wed, 19 Aug 2026 03:23:34 +0000 (UTC)
From: Mark Amirkan via B4 Relay <devnull+markdamirkan.gmail.com@kernel.org>
Date: Wed, 19 Aug 2026 03:23:26 +0000
Subject: [PATCH] scsi: target: bound VPD identifier formatting
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260819-pscsi-vpd-ident-bounds-v1-1-ba28dcb0af08@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMywqDMBCF4VeRWXfABG/tqxQXTTLR6SKGjEoh+
 O6muvw4nD+DUGISeFUZEu0svIQC9ajAzp8wEbIrBl3rrh7UgFGsMO7RlYHCimbZghM0rfdG6Wf
 fNg7KOSby/LvC7/G2bOZLdv3X4DhO3Eq2gnoAAAA=
X-Change-ID: 20260818-pscsi-vpd-ident-bounds-b5ffb129754d
To: martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787109813; l=2920;
 i=markdamirkan@gmail.com; s=pscsi-20260818; h=from:subject:message-id;
 bh=L8mPB4bIaFikTHrgHz6nuvvi6qLxDbVD6mrN0KpPLA4=;
 b=bObFYuDHrVvOgAblWgKkkU/381Mm3pmZ7jVJDJ9bBFZmkiuiofrvAeRmvxQqDdZq1Bikcjixd
 DXKSY7SDwPWA3WfsCqAmBHbhhr9k0dO0Vs3A9tPrHGJxHxo1QInwXgh
X-Developer-Key: i=markdamirkan@gmail.com; a=ed25519;
 pk=/wb49ibt4gZFDncmhFQBYtjPvzT1tfJtvK4Mqt1P2Wc=
X-Endpoint-Received: by B4 Relay for markdamirkan@gmail.com/pscsi-20260818
 with auth_id=961
X-Original-From: Mark Amirkan <markdamirkan@gmail.com>
Reply-To: markdamirkan@gmail.com

From: Mark Amirkan <markdamirkan@gmail.com>

transport_set_vpd_ident() formats device-provided VPD page 0x83
identifiers into the 254-byte t10_vpd::device_identifier array without
checking whether the result fits.

A binary identifier emits one type character followed by two hexadecimal
characters per input byte.  A 148-byte identifier therefore emits 297
characters, eventually writing beyond the 296-byte t10_vpd allocation.

Reject binary identifiers longer than 126 bytes and apply the equivalent
destination bound to ASCII and UTF-8 identifiers.  Explicitly terminate
accepted identifiers.  Rejecting instead of truncating avoids creating a
false device identity.

The write was reproduced with generic KASAN on arm64 Linux 7.2-rc7 using
a complete 168-byte VPD response.  With the same input, the fixed kernel
retains the valid NAA descriptor, skips the 148-byte vendor-specific
descriptor, enables the pSCSI backstore, and produces no KASAN report.
Seven boundary tests pass.

The demonstrated path requires a device-provided response and privileged
pSCSI configuration.  No claim is made about exploitability or
unprivileged reachability.

The tested source reproducer is available privately on request.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
---
 drivers/target/target_core_transport.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dcfe9459..26a0bb66 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1335,6 +1335,14 @@ transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
 	vpd->device_identifier_code_set = (page_83[0] & 0x0f);
 	switch (vpd->device_identifier_code_set) {
 	case 0x01: /* Binary */
+		/*
+		 * Reserve one character for the type and one for the NUL;
+		 * each binary byte expands to two hex characters.
+		 */
+		if (page_83[3] >
+		    (sizeof(vpd->device_identifier) - 2) / 2)
+			return -EINVAL;
+
 		vpd->device_identifier[j++] =
 				hex_str[vpd->device_identifier_type];
 		while (i < (4 + page_83[3])) {
@@ -1344,11 +1352,16 @@ transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
 				hex_str[page_83[i] & 0x0f];
 			i++;
 		}
+		vpd->device_identifier[j] = '\0';
 		break;
 	case 0x02: /* ASCII */
 	case 0x03: /* UTF-8 */
+		if (page_83[3] >= sizeof(vpd->device_identifier))
+			return -EINVAL;
+
 		while (i < (4 + page_83[3]))
 			vpd->device_identifier[j++] = page_83[i++];
+		vpd->device_identifier[j] = '\0';
 		break;
 	default:
 		break;

---
base-commit: 3a0dd7ba4f44cdc116d83712f61e7c1a95be3588
change-id: 20260818-pscsi-vpd-ident-bounds-b5ffb129754d

Best regards,
--  
Mark Amirkan <markdamirkan@gmail.com>


