Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35A5153808;
	Mon,  9 Dec 2024 17:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733763831; cv=none; b=m28+i9jEhZ7B1n8JLSsAZ42MBxK2QVKJ3wzHQIMW5sWqnDLTrqlPPv59pHDJxsomjoXPb6xntVtD0ZHjDVK+ZaUXUBwOj/dY/LQxvfxirtQTmyBFLJdBLPkQR1YgaSwygZUujWNlP8/Pk+qAkvfOr2Pj7zvi/wzupyqRbYrUhro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733763831; c=relaxed/simple;
	bh=JhD/0VV5bz+GHGfjTQmm9tvzSk0rpxVIqEukVkwBKAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CI0Dtg8VscPOlWL9J8YEZQX30Ebzuf/rghE2Pyd1hMmQk+dFjN3peOhT1ZCTrpaib6QTQyKtJXSGMIu9e03YVQ1j6WbymQNY5u5I+rFNjQrUTtcegBULKYD9L7jvRZg3K0K+YlMLdyqD+StHMnUolLtC8kUg9IEs0Ubu2yfVUmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	by air.basealt.ru (Postfix) with ESMTPSA id 833A6233B9;
	Mon,  9 Dec 2024 20:03:47 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-scsi@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org,
	nickel@altlinux.org,
	gerben@altlinux.org,
	dutyrok@altlinux.org
Subject: [PATCH 5.10.y 2/3] scsi: core: Fix scsi_mode_select() buffer length handling
Date: Mon,  9 Dec 2024 20:03:29 +0300
Message-Id: <20241209170330.113179-3-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
In-Reply-To: <20241209170330.113179-1-kovalev@altlinux.org>
References: <20241209170330.113179-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@wdc.com>

commit a7d6840bed0c2b16ac3071b74b5fcf08fc488241 upstream.

The MODE SELECT(6) command allows handling mode page buffers that are up to
255 bytes, including the 4 byte header needed in front of the page
buffer. For requests larger than this limit, automatically use the MODE
SELECT(10) command.

In both cases, since scsi_mode_select() adds the mode select page header,
checks on the buffer length value must include this header size to avoid
overflows of the command CDB allocation length field.

While at it, use put_unaligned_be16() for setting the header block
descriptor length and CDB allocation length when using MODE SELECT(10).

[mkp: fix MODE SENSE vs. MODE SELECT confusion]

Link: https://lore.kernel.org/r/20210820070255.682775-3-damien.lemoal@wdc.com
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 drivers/scsi/scsi_lib.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0a9db3464fd48e..06838cf5300d00 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2019,8 +2019,15 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 	memset(cmd, 0, sizeof(cmd));
 	cmd[1] = (pf ? 0x10 : 0) | (sp ? 0x01 : 0);
 
-	if (sdev->use_10_for_ms) {
-		if (len > 65535)
+	/*
+	 * Use MODE SELECT(10) if the device asked for it or if the mode page
+	 * and the mode select header cannot fit within the maximumm 255 bytes
+	 * of the MODE SELECT(6) command.
+	 */
+	if (sdev->use_10_for_ms ||
+	    len + 4 > 255 ||
+	    data->block_descriptor_length > 255) {
+		if (len > 65535 - 8)
 			return -EINVAL;
 		real_buffer = kmalloc(8 + len, GFP_KERNEL);
 		if (!real_buffer)
@@ -2033,15 +2040,13 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		real_buffer[3] = data->device_specific;
 		real_buffer[4] = data->longlba ? 0x01 : 0;
 		real_buffer[5] = 0;
-		real_buffer[6] = data->block_descriptor_length >> 8;
-		real_buffer[7] = data->block_descriptor_length;
+		put_unaligned_be16(data->block_descriptor_length,
+				   &real_buffer[6]);
 
 		cmd[0] = MODE_SELECT_10;
-		cmd[7] = len >> 8;
-		cmd[8] = len;
+		put_unaligned_be16(len, &cmd[7]);
 	} else {
-		if (len > 255 || data->block_descriptor_length > 255 ||
-		    data->longlba)
+		if (data->longlba)
 			return -EINVAL;
 
 		real_buffer = kmalloc(4 + len, GFP_KERNEL);
-- 
2.33.8

