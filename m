Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593955111B8;
	Tue,  8 Sep 2026 09:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858255; cv=none; b=j0NtaV0B4rYfX6RuHWkrrXzX8mSosdxo2GdnrbxCoyPRCqIUW5zaeqp4fjGDRfhpnMjXOXyUKLGiH2aKEk9SYmuG9hurGVQD/pzwr+Ljl3aOMmKzKFfQXhmJ+Qs4NQEIBgcJg5apgVK78ENCQ6XQq5k+PuSCZ8YaYTsJkdYiPck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858255; c=relaxed/simple;
	bh=FPulVaMX3QUcCYAvfmjdObtj7Afm3M+mCwNLqgtaDVY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUwIcs/S8kUThc0GPmGrMY2RHQChxW+3yvCFCgGnlm84fLycd5DvSZcGH9aFEZbDF7F+LaL3fiN2LZPq3q5QEYKOTm6xxrUFizyQxuMfagVf3akb4aUma+Ag6eFBqGg+7aX4KleNANfhJEb+cZcvJ5bJ2O+UzlnFPct8xFMdxSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+TOJOJW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+TOJOJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27CE1F00A3D;
	Tue,  8 Sep 2026 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858251;
	bh=wz2DLK17WXDlKQj00vKnJpXyO7Ea30faVvXnPP8tIfU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=K+TOJOJWPyt+C/A2SMlxIA5ZIQiyh4Z6cah6LJa1q4umpxzk/5yx7W8OYL8Lg+7jX
	 F2dpErct0It+cGpUHgdWzMoanankgJIc/wJUuW9HX5IY0TNJD3JtGgym9sE5mHChf/
	 K4fh1Ace1ucwkqPvV7htrWR84uHt2o6sNTH8zvMy42eJSfpOhWRpaURK4G+6bH16VD
	 xn/MwpNpXq9DNhXnza5+A4NNMK1Xty7fWEL4EjpdDts5wdWBJ4DMaSLuXX5epylQ4Y
	 duDeU7QUigFDRfMIBARFFxxrQH5VopfQBk/+KwU/XwHMik1uyEduemSpaFOK2kgO+G
	 7Yu6yFTWu/imQ==
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
Subject: [PATCH v6 29/40] scsi: libiscsi: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:57 +0900
Message-ID: <20260908090308.1085097-30-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor libiscsi to use scsi_set_sense() and replace all hard-coded
additional sense codes and additional sense code qualifiers with the enum
values defined in include/scsi/scsi_sense.h. This helps with code clarity
as the sense codes being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/libiscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5cbc51899de0..7637aacd6037 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -892,7 +892,8 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		ascq = session->tt->check_protection(task, &sector);
 		if (ascq) {
-			scsi_build_sense(sc, 1, ILLEGAL_REQUEST, 0x10, ascq);
+			scsi_set_sense(sc, 1, ILLEGAL_REQUEST,
+				scsi_sense_code(ASC_ID_CRC_OR_ECC_ERROR, ascq));
 			scsi_set_sense_information(sc->sense_buffer,
 						   SCSI_SENSE_BUFFERSIZE,
 						   sector);
-- 
2.55.0

