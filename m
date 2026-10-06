Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749D94E3229;
	Tue,  6 Oct 2026 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330129; cv=none; b=Q/ThnGJuwTbF/ZWNe8C0XfKhzWCNhBTBFgUjLixRlzKxcF3Oi2Wwvt/rRHvVGTwe37trwUyo/CYyaByUHmd615oPb0VSMTCFWhEFoNQXycm4n5WPRM5Nhyz1ReYBcPi8lGVWzMF8nt9Lo43Q/yOb/Qnv82MgV9wC1eCNzWh3tII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330129; c=relaxed/simple;
	bh=9r+TMbKLM84NykY/tQPO43ydHWQ+ptnWPsGpcr5D7b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdQie+umCHvecchX2yLB/wv3L9S5XIKyeaLZBFWewi8LrzqFtHmC1fW/oRquTIyJghQj+R5Lb45B29OjuZHxuXah5igErzhJItRtfvwViT8lv+jVBmcPugEis5VCkZuSAnST2xgjFg2tGMrdO0zf4cm/kpQmC5BVvgg0eBAu5aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=C4qU0hGl; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="C4qU0hGl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791330125;
	bh=9r+TMbKLM84NykY/tQPO43ydHWQ+ptnWPsGpcr5D7b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4qU0hGlKm8Aqe8Z46+e36yrVczHxhVr2MGNDKfI+uaKXBnQfwH72Gub7ZI5AcVPH
	 vFpoddWZMwbZ+e49q25zzhQREfmZ7CpokTmoJ2HiQpCiezR4fOzRNXKndc21a54VSQ
	 tMCuuuTWnX+VY6oVMrmHcmidQupQ6+qjCmo8bxcU=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 89429BD748;
	Tue,  6 Oct 2026 23:42:05 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 2AA605FC4F;
	Wed,  7 Oct 2026 00:42:05 +0100 (BST)
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
Subject: [PATCH v9 03/11] scsi: scsi_devinfo: preserve full-width quirk identifiers
Date: Wed,  7 Oct 2026 00:41:53 +0100
Message-ID: <20261006234202.1139018-4-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006234202.1139018-1-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
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

