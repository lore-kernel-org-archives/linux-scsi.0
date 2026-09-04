Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B646B32AAA3;
	Fri,  4 Sep 2026 00:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481681; cv=none; b=GcqoWWqXvlAMWzsyZF5wpXvDilACzrnAvmTcoCYzw7J0834DV1dp+bzon6cOX2dJhD1Zda56mxV8TLPQTO64IiyDuMR7HQUgs4JpLtKOYE+dqO2cJ27VwNbUpx3yHYfLswqle6uWkKlSOkDJp0522K3xR0McWC78mCSgYeOAFXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481681; c=relaxed/simple;
	bh=BtopPeysEnZQFu1RnVN1qVDwWHqKG070Zn1FxGHWKR8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1G4UIZUZAig/Jxi88A/SbcQB0wfV+rRGaiXSFWsBYs9bN8xNiCKak3N2Ws1qEYxQATsbOdC5+DTjzKC8wX10xkoIL3MhETOPmtyKRd9S2iNjzbXNCx/TnlFvLGF9f8VNMqbsuIaClVJC1wLnSTyYGdmAOwixgEB9vCdgUAwqrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkzpOxFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkzpOxFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1E91F00A3D;
	Fri,  4 Sep 2026 00:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481680;
	bh=zrT7q7ZH+fC23WTSGC63DAKdptXjh3DD8gyJYRjfY74=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=FkzpOxFnODI+GHYQUVRsCQS3ex+P7r5kbwtMtx0+jbxltExQBR+6BFAUV/Ks+BspJ
	 E/UhW6q8bvE8Q14UfiLicMDkVj9GlyPDfxOsNg4PwRRNJS6KokKFoHG4Lfe4JNPX1w
	 QBcXW60DmwrmG+0JIjxBxH1YRoKpN4Go0+d45ezfIpedPD5zTCPM1ySFe7RqoRgWKJ
	 5tGR2fhpkInWAECTHTR6lvZEv//YN9waNjB/w2dI5tlRatbdISYaTmqlcf7UiOqaIs
	 LOd9pMCpwM/t5ecPEr+zxyEsx7XNyXT4SykVnbhKQoSNjBp2v1aW7M3ommY4YKCax9
	 j3qLcyTupS5eQ==
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
Subject: [PATCH v3 36/40] cdrom: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:40 +0900
Message-ID: <20260904002644.157668-37-dlemoal@kernel.org>
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

Refactor the cdrom driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/cdrom/cdrom.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 4f1fd389260f..c717e35ea2af 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -345,9 +345,8 @@ int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 			       struct packet_command *cgc)
 {
 	if (cgc->sshdr) {
-		cgc->sshdr->sense_key = 0x05;
-		cgc->sshdr->asc = 0x20;
-		cgc->sshdr->ascq = 0x00;
+		cgc->sshdr->sense_key = ILLEGAL_REQUEST;
+		cgc->sshdr->sense_code = INVALID_COMMAND_OP_CODE;
 	}
 
 	cgc->stat = -EIO;
@@ -2979,9 +2978,8 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 	cgc->sshdr = &sshdr;
 	cgc->data_direction = CGC_DATA_READ;
 	ret = cdrom_read_block(cdi, cgc, lba, 1, format, blocksize);
-	if (ret && sshdr.sense_key == 0x05 &&
-	    sshdr.asc == 0x20 &&
-	    sshdr.ascq == 0x00) {
+	if (ret && sshdr.sense_key == ILLEGAL_REQUEST &&
+	    sshdr.sense_code == INVALID_COMMAND_OP_CODE) {
 		/*
 		 * SCSI-II devices are not required to support
 		 * READ_CD, so let's try switching block size
-- 
2.55.0

