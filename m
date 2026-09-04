Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D36305E3B;
	Fri,  4 Sep 2026 00:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481667; cv=none; b=lwodib+0zY3LDfHwDV9WOpggcdOwubru+OmETNoTlFHh0zfwUlt7HuH1XHRQKIRoWEUu+fKT4bAlNrab136CY41fZMKNqsujwGLefiyaizObDh3hm3txap9oscYCSGtRyGOP5czCrYGl7l/OapsL9i3NVdvensJfqM7FZ7wV5HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481667; c=relaxed/simple;
	bh=aniMHomtNRiybiTm9qmt1bbUmYk2bJon40xjoPETuaw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1xpI3sJJV32KBA1kUKF4PLeTNAm27nxnru5cx1FqGM1/SORXkCSDJwvdmoonlnxpiQ4xf8Fn6L4Ukwa9SWTEaQ8Q7NW2pGSE8FUhrh93EYdu1gqfoGLJz5OkN5m32UDxIaGf4H8WgH0NtDBOSbaAtBBeJx0znODOZK6R3D1MnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATHevNNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATHevNNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6171F00A3D;
	Fri,  4 Sep 2026 00:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481664;
	bh=GmKRJhMjMSX4APigNgrN8PgSWVi01i8DN3Nci0Few5w=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ATHevNNt6IZY2VHCLD9lkNWJk7mRG1bpOUo+p+OU+xEqY39hsRl2ySw89Any2s8bS
	 HaJlFamH9eaLqeouiaCGdXImXJng5icUeYTgbRNtDzONZQRQEG/yKM2AsS3EaUPxsi
	 QhiZbZAaXpgpteqw2mLJcvSOl0vui7iTzAlU+bqlzREbZqeNwgGJWsQgqFSaWhegNq
	 ujPskfXPqqzC9Sdl4Yy9uQ5mZrrlWsvg+Y2KFG43tbZS3BVR7JXBvxswVu0vXMpcBM
	 hYN+hzvTfEuZ9o+EMkw5o+pibgL5vtBYdNVvQEgRv1BhMm98TrckKmxoEssAQn3A20
	 2TA/DXl6/h7Kg==
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
Subject: [PATCH v3 27/40] scsi: stex: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:31 +0900
Message-ID: <20260904002644.157668-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the stex driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/stex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 6aeeb338633d..056ff0eb5455 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -401,8 +401,7 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 static void stex_invalid_field(struct scsi_cmnd *cmd,
 			       void (*done)(struct scsi_cmnd *))
 {
-	/* "Invalid field in cdb" */
-	scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0x24, 0x0);
+	scsi_set_sense(cmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	done(cmd);
 }
 
-- 
2.55.0

