Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5221F95C;
	Tue, 25 Feb 2025 08:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473809; cv=none; b=KrGAcrrl7N2P1Cq6LhEDSd0XPC6Fnw1Fl/e8/3HwmmBBP/TwnamENK5nOLtnMGT0+ujjBZzNYt4YuB5q7w+s62LUSGbZ/5WdBksf3WU99PNnbYaZj0SirBQ1iHbNxMngSpKSxZyTYZuM+Ju7v/+tGNpkkkZjvthLYVajKqCYqAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473809; c=relaxed/simple;
	bh=Pg6cPWVXZ9yBArlBveUYY9leBBr7mVzrxcIz8ti190k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Cy9HxrQK+BLNicZjO8yB9UkF/yAWUPos1PP+KXcBAEWx00od09Twz5/hFSxo/UlbMOMpKh5AxAcxn3Q3lv2aOgJwcCxwz7ovCZie9XNPD5lf8MA3o8rMC8UU83up5JJqkpWMVFCsi06y7anOstBu3umNohqMQ9xbHQRVUxPnuq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3yxmafT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3yxmafT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE02C4CEDD;
	Tue, 25 Feb 2025 08:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740473808;
	bh=Pg6cPWVXZ9yBArlBveUYY9leBBr7mVzrxcIz8ti190k=;
	h=From:To:Cc:Subject:Date:From;
	b=D3yxmafTn7Z6+nftxsxV6MjQX6aSXleIPiAupCp6UOInhpuSjupLoeBSIr9mt/RDk
	 xJkrkP2PbzFpxEQTMyfMgUoIsaN0DSGIMpX6UaAwuNX5ZlEiPNBIhkET5Wh+sZ7MAv
	 2mdSLUOFTWmjsPdpwnXhGdRfptr84Un/UpJMrSHs/61vwNHMXIvkWZCZwacnAIHnaO
	 XOm9/PhgXDH1ulEnNE2uTvTCFEVBuJHuTV18x/eaFkYlfOTGyYDhqf26cQwcAlfcL0
	 bDM/5XiQ45Fc57b0foORRa4bnYMQhujj17eg/VKTRoEgVD6nQvQb1+57kSAZ5TWRLI
	 YooziSQX/6q1g==
From: Arnd Bergmann <arnd@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: fix uninitialized variable use
Date: Tue, 25 Feb 2025 09:56:39 +0100
Message-Id: <20250225085644.456498-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

It appears that a typo has made it into the newly added code

drivers/scsi/scsi_debug.c:3035:3: error: variable 'len' is uninitialized when used here [-Werror,-Wuninitialized]
 3035 |                 len += resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
      |                 ^~~

Replace the '+=' with the intended '=' here.

Fixes: e7795366c41d ("scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 722ee8c067ae..f3e9a63bbf02 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3032,7 +3032,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	case 0xf:	/* Compression Mode Page (tape) */
 		if (!is_tape)
 			goto bad_pcode;
-		len += resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
+		len = resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
 		offset += len;
 		break;
 	case 0x11:	/* Partition Mode Page (tape) */
-- 
2.39.5

