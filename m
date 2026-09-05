Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321C037C936;
	Sat,  5 Sep 2026 03:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578610; cv=none; b=uhcdaa1prs1STPuFzqpvvDM4jDYD3CL8LA+FEv5xxJy2PjNtq/cVgx79Hl90hEwZnI5yGhTHHaJCEy9+QzKmuezNn1CbcyVdCKzoPG+UG+VXYfh4KWqzW/AN+8Q4OOm3t4Dl0u/lJaxiZ6rhPEJWNX+2lU8lJvpn+IhTYhwmlEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578610; c=relaxed/simple;
	bh=/mW41zqDDqdpOsgXHkPmsVI/0GS/DDbcEJiTrCb2nMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMLgwYLPL9w8v6ZAvuhaR9JTaNQdKKlpaCEDgbaIKlIdy8MCnQpZf6bQ6zqzMgUZ6na39Z9GGklwZG+YN1H9FvqOu83YwVyXIN1JI7SNW91Zfn8NEsrc3Kp9AyWWuy8/caSZcKb78Zhb+rIuHAXgGUHYfvZ3JGrdzL7RCExY3zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTRLWAzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTRLWAzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A832E1F00A3E;
	Sat,  5 Sep 2026 03:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578609;
	bh=ezZo3cIeZob5n0jUfDw8efAraNLL9XA404n3FNk6lwA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fTRLWAzYE/cQdm0vD0PFFxUYIbY9YHckyOsYpuRkE82Q/jqr6AFwJ3sdwgcxCxYsI
	 CbxzCLpWcOtqabGQIF9a0yHrAfmM3KNxOGwY6ZJQ4bCiq7xr07UUFow0cGe1OXaNnG
	 xA7ebxiG3YdsZBcf1NZumyK18/ENJqpKvBtlSi6IoKcZIcPY0Gs4ozIfR5BFMrzmJ8
	 0bplmbN9vFpA360vXDF0w6B5yxJad+5ste3khO9JGotiPL2kMBtgwThPfIVjuI2Ge2
	 FthWsisyqYAhSvp+KZ8X9FhBkRPRaDVVGrpOEjGgGzl2k5p6iZM9B85Ar1BUEqnTew
	 ddJDJ1eBiJXkg==
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
Subject: [PATCH v4 29/40] scsi: libiscsi: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:13 +0900
Message-ID: <20260905032224.509860-30-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905032224.509860-1-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
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

