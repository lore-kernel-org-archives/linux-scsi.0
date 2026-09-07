Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004893F329A;
	Mon,  7 Sep 2026 02:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749079; cv=none; b=iVOT73Bv667oohP+5fbMZ5YvansKkp5yzvcXrqdG4UoQrieZ8jqPDtb3nVOnxo/bTknRV/MnOkZkU4yfp2K04G6aRgnHAby1EBTIjqwWpSjKAEEUMoPGj/OgXwRVVK+6cVrulYo7AdXK6iqUmSINLdVINnlIpfOTgEZCIApCBaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749079; c=relaxed/simple;
	bh=h2CZRQ6Oo3g276R48xMfwzQxvWfrNs/330QG2PdMt64=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP4ArTvwGNOsfHWg2PlTHZ4rLXoiQUx9n4iPUi5WncNKRBP5VeA1o5sOXFNXR8urIs/Rs6ikr7+teaATcRdSh69+BcsoIHHXwsH74jb4aZi222hLxDcqQY4l//StjbCiYfycgtdwGe4nE8m8lEVtSivefFEH7kxLZdpeYHvBw0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHs+/mDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHs+/mDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8DE1F00A3E;
	Mon,  7 Sep 2026 02:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749077;
	bh=6eI25ncEW1bDWA/ZZsGmt5838PGE09d+oj3dEi8b7Tc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=IHs+/mDOQo6td8hUp2agTx+zJE7dcbZeBrM9vCzP+B6YG7DtXuxz/tp4jKXEMQUFK
	 NmyI4OIDPS3Yn3sygjWt71co6w0T375IO3keF1KxrLQLYHGU8YHdiUD5F5Q3opDMrM
	 ryPi74R7GJ05Bxy74ATwmDk4Dl3eMPMmYtNKtATK4/A1owb8KWFVlmC8FZdoDeDDpC
	 X3XIHNkuemL0UhpU7L1l/Z+1FXoQjMVicicWHzNtj4thXk9Y5Ir1ykzLwLRp15NSv1
	 jBjKyyRTpXY2D/1slcduRfT2xc/RzWNV+Z0xP10qSec7EQa2LgiGH4AnJDEmGAmXjc
	 WYOVstbRG+f8w==
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
Subject: [PATCH v5 27/40] scsi: stex: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:30 +0900
Message-ID: <20260907024343.1046387-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
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
index e69a3779a32a..d4899816f7dc 100644
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

