Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F04D2ED8;
	Tue,  8 Sep 2026 09:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858268; cv=none; b=Xtzpxz/gdGodg4bELY+g7epdtq7zklw9KEhHOjRXqzU1KiJHQYk0YSBrmzZWkiX6o17tRrUNw4uZT/MTIthgtuNYcjfZRVFXjI40W/gSFGQNbfEWlv4yedCzVLqI9njOBQxLPpbtXMJwDoOmexkqDHh68Ycud7fIcksHTUC5ZnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858268; c=relaxed/simple;
	bh=L/Ml1oV+GqIJF9odH/6IDOcekz1HKMOD1YL/MkyPTTI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUcmLJDkJnStjsL2DQqjhR89uq5Y+VMl7cY6p8OBb3kPB8ixhPFuCRqekc3x88EswNevXwFlx/Ypr+MTisx6GAX7A6SjrKEWWhiwHwNYZw7y1C4wErTTfGS5nGPvcIUj8ickJYNDmwdO2+rXeEuA3KGefOpW2D8TPknUZZ5cfwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhbjYKyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhbjYKyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2E31F00A3F;
	Tue,  8 Sep 2026 09:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858263;
	bh=c5zrQMrFtgufpZK+nJD1xSiDCbtRxEQD4YkbxIuN2Rs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fhbjYKyRTI6BC/FQ9cKPzs+7yq8FihCFMPNf43+oUKlFLr+GbhuTB3ddu+04RBurQ
	 XmTicmRz+qUylsQ9qeaQA6MV+QXgkWQuOz3wM5m4MYAPHXrQadtsCu3OljzWMq/ShN
	 npDBRMjxkUPEqJtseX6PRiiDeyFKyC3YhrBqdpBkgcTiZxDd2UGue6eGPYvI6eO3Zg
	 +fiexZP1/WwU3Zn4XejzOHiM2h5I4Tkdegc6p25qYzViwRrhav0aeKgN6S6BJineYY
	 Yvc9vdHvdbW0aWsULpzEHbwL0CODr3TBGaoXcE+3bm4Ccv40RT67KBfUR223tJNwtt
	 8aNhwx11wma7g==
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
Subject: [PATCH v6 36/40] cdrom: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:03:04 +0900
Message-ID: <20260908090308.1085097-37-dlemoal@kernel.org>
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

Refactor the cdrom driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

