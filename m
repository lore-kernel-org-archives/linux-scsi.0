Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73C82638BA;
	Tue, 25 Feb 2025 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740477427; cv=none; b=uiLnfWse+c+tp5V9VfuPH4yrY1dWju2R/xCmTGF4ADnCaFfkjhJy/y/triYp+hsFYYVLV0ib7ecEY8l5P2XpIaQQUQQFbV30EqvS9uU5sHSWz4OddfEvL1vCcukGAVxhkejJ7/BVHtnQpXiEXbGYo3N3JopLTGb69hdlvxHtde0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740477427; c=relaxed/simple;
	bh=ETZhEhnbeSdJGTgAwaRPTSSwfDGElp9EbPkWUvGZzhA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XE59TiRuykuXWoXaOjGoHscuN4eImtIhAWXyPr/5QDygXwNElUE0c1UxvojV7ccR1pTVP4I+tJ6VPzpCY9RZFZzwNHS5YWke7B6NEnYPvEDg+zDGVdG5nFrwd8veSUf6yoRJ7kyofYDwa/Egz27Yqa/bvDO25IZtmfXwXM4Na78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldLzRZS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldLzRZS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0C6C4CEDD;
	Tue, 25 Feb 2025 09:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740477426;
	bh=ETZhEhnbeSdJGTgAwaRPTSSwfDGElp9EbPkWUvGZzhA=;
	h=From:To:Cc:Subject:Date:From;
	b=ldLzRZS7CP6bY5JS8iAjwoXVXU9fi40uwevB5fibDnmwqXvypvfWg5J7g37ZG7MPs
	 kQysUEl9KRxkVt9kRNjuWGHgkzY3d31g1SJUlDLcjaiQdj/OJ14mFgjjLBz9K2JW3q
	 H6E6Gu5cJg91llckx9zyeGbM+I1ZoZIlUKfQ+y8rDpnqz238yAGFJFdzk6DzAh+Dgy
	 4TLIVD5aNOR3BGgfnpn7j21blmWik2B48tQuJ58i8nzjxi/n3NQno8hEbpN0fjEtai
	 aWkxcD9c8feDrSZ4bG19U5jQ+j+EngqnhrzGopWj9nws/mDA7ZpJkpGb3nDQ0uW9Sy
	 bcMmRGj/ByDzA==
From: Arnd Bergmann <arnd@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] scsi: scsi_debug: fix uninitialized variable use
Date: Tue, 25 Feb 2025 10:56:47 +0100
Message-Id: <20250225095651.2636811-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

It appears that a typo has made it into the newly added code

drivers/scsi/scsi_debug.c:3035:3: error: variable 'len' is uninitialized when used here [-Werror,-Wuninitialized]
 3035 |                 len += resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
      |                 ^~~

Replace the '+=' with the intended '=' here.

Fixes: 568354b24c7d ("scsi: scsi_debug: Add compression mode page for tapes")
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: use the correct 'Fixes' tag
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

