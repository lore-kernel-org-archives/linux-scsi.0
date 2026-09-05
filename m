Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01AB390CB8;
	Sat,  5 Sep 2026 03:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578622; cv=none; b=dvS7A5icVoT3lvT7BjX02G5AReSytyievOJDy+3XF4IMNkUZFIZwyAqi3rmGDfGWYoqvLzuOXktiJOwiUWSIXGcIHDkDRos3/N3bBme/X8w48R0tgVrSTu/udLZU3Q5vdoQ5HqIo1LR0qXQygLE6Kh9cpOVxv/i/sHjk0oOoo98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578622; c=relaxed/simple;
	bh=BtopPeysEnZQFu1RnVN1qVDwWHqKG070Zn1FxGHWKR8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GA4DgrvhIqv3dX1uEjbO4OA4s6BQ01fLGsV0LpaDi7NkZ6V3Wcvctk3HhIXR27HYxC4cFnh75v6hLM0LNfnvV1ZNHUk1UFC13LJptwDzLyoONqUV+r3lJYltYf45OMo17br1TLoPLrX6GPT7PEt93iiRTFSsnxzv1p1f+2h9riQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPgSHrnY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPgSHrnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE601F00A3E;
	Sat,  5 Sep 2026 03:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578621;
	bh=zrT7q7ZH+fC23WTSGC63DAKdptXjh3DD8gyJYRjfY74=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=KPgSHrnYGAmC1a88EaYrEXPjc2+94zyDuNC4MgUBSRlHRCtuNWS/it+EG15ae98uO
	 aM5F9Lm9CKVaqGBMpZORs+HOUqvzxFQEeuokueJaqUrQtGva1r9xCKvvfLwi0M1yms
	 waHs2LqSCaGKdaTFSmMcupXdFZZEPBme6PnuDygCExVsnAd3kyT3/l1HcTJcO937mj
	 NphmQYy8A05sEKED7Y97mOBAM8jMRAvprUgY5G2t3MsnVQAF8bk2eufZf1iE03yIr2
	 gd7Aim+09s9c8LTM4ZcA+KVTf68EPlASIiXyNGy7YyyHdTio4nMF971E/b8CTiOojD
	 2pTQopmZCM3RQ==
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
Subject: [PATCH v4 36/40] cdrom: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:20 +0900
Message-ID: <20260905032224.509860-37-dlemoal@kernel.org>
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

