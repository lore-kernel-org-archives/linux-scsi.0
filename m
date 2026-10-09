Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A6936404E;
	Fri,  9 Oct 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563230; cv=none; b=LpCmHRjCeHmEnU/aSwKuxDn+8coP04VeV15bmM8gUVSjq9Dpnt57ghdbGaoV8SvxHW+UagEJ+nKBKII4b0DJSYUAmZ1mLrmQlXAsVwzKtWlqRCT9Q5D5MdG9VJ/WqiunARGy+as0fdMwLMj8XorkUt2edMV+oRnT7zqPl9lORvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563230; c=relaxed/simple;
	bh=9r+TMbKLM84NykY/tQPO43ydHWQ+ptnWPsGpcr5D7b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtWk0F7iMlYWFvudlmOw9ugpR+OStHTuCZqsBsREgit58H/mdiX9TUbCDHqz4xbtfnU7DZ8H89+HyswoMP5nkegJ16iyWGpQaKC6twpRE/n8C8qT1aG6glDlEl5DB+SU4IVOyzJLqblN9bhLaMcY4YKIz2V+O8iEqOZJmAjqC7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=ak1zTHpn; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="ak1zTHpn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=9r+TMbKLM84NykY/tQPO43ydHWQ+ptnWPsGpcr5D7b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak1zTHpnllqGfhKwiRnHDnSsmzRyxMTcBjBgM0zPbIPL3R99SoRs3c/0R6jHGXphZ
	 tLVQmAQpoauf3+8R6WG01XAw8lRETTVcMVS8reIuPvXly0O4gcmEOZiLsVEpAC01Dd
	 nKBXAQP0fFH5pn8CyT8hULmV4AEmQAZI2BTGZkQA=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 5B81BBE773;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 286905FB4D;
	Fri,  9 Oct 2026 17:26:55 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>,
	stable@vger.kernel.org
Subject: [PATCH v10 07/15] scsi: scsi_devinfo: preserve full-width quirk identifiers
Date: Fri,  9 Oct 2026 16:55:14 +0100
Message-ID: <20261009155522.593045-8-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strscpy_pad() reserves a byte for NUL termination, truncating quirk
identifiers that fill their fields. An eight-character vendor such as
MATSHITA loses its final character and fails to match. A sixteen-character
model loses its final character too; prefix matching then allows the
quirk to match other models with the same first fifteen characters.

Copy the full vendor and model fields. Pad shorter strings with NUL for
compatible entries and spaces for dynamic entries. Lookup uses bounded
strnlen() and memcmp(), so full-width identifiers need no terminator.
Shorter model names continue to match prefixes.

Fixes: 1b60c86dd992 ("scsi: devinfo: Replace strncpy() and manual pad")
Link: https://lore.kernel.org/linux-ide/20260611025249.D23191F00893@smtp.kernel.org/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_devinfo.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 88a911b35c94..5e37461e61e8 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -289,14 +289,9 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 
 	from_length = strlen(from);
 
-	/*
-	 * null pad and null terminate if compatible
-	 * otherwise space pad
-	 */
-	if (compatible)
-		strscpy_pad(to, from, to_length);
-	else
-		memcpy_and_pad(to, to_length, from, from_length, ' ');
+	/* Full-width identifiers need all bytes; shorter ones are padded. */
+	memcpy_and_pad(to, to_length, from, from_length,
+		       compatible ? '\0' : ' ');
 
 	if (from_length > to_length)
 		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
-- 
2.43.0

