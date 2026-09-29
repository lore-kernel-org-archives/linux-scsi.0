Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBFF3E411F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670367; cv=none; b=SVsr8ZEypVR7QHmki63e8Cb64uun5BWtOzVr9SysSIjzfTnM+QJits6jd5if6H7pQQBu4Rw/oSpwq037CBhvwM6DxPs72Vlr6NJfiyMSBQ6q/7wvbHAyn8uKxapKu/0eXMqvei4IjAQqqluKXwR1rzF8h8nsappMfCjC6TVxcK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670367; c=relaxed/simple;
	bh=uHn+xouBm8aCyNWVuGQGtAQd/rFqOzhXHDEfGXUXlxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGrqk1UmZwXgf4Rjl2EBkaXoWSj2/v9DWqrgLD79Oml63StwBx3u+gFSKtLbhoFXrvgWpd7q+m4VLmWYl8mT3hpV4fMxBD0uWFlXiZHOQ0fqqDI5DdWLoshm5CS7tsobMoMoI+bhk2wAS0pujdlwo7ka7CQIdvzu11GJZi7ovqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4q2JuKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4q2JuKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C961F000FF;
	Tue, 29 Sep 2026 08:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670366;
	bh=jTn0ZPHrSDwA/2lchrQU8HyrubQYeHJXmaJU2xeuHbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4q2JuKB2t9t7b3F3Ow55tvrikaeVabRoq8XVIePnzUl37YoNA/iPgtX1nwT0I4EJ
	 Tub31si3rt8V5kOe/3G3CPklKWW4br2iJ7dJZ1sRO6I8R1JKj4uuUg3uIHf2zoMpQM
	 Q3I7+sD3LJh/nsVvk1hwoDMlMpU5IynhAb4hocYidik5iOG6FZWKUDiEUoU+fEGP8D
	 TlO4Fk5+L37dxhs1pOWlOSxSO1U5Wu2LYgia1fYd5Pv9osYHCUmZqoynkjf317Zsjx
	 gtSSi/M4w1NYodo/nVlpkOMMwJWH2PWnwjkws0ubPu4UXu8+ts4OnZetrDKqIua4oB
	 3UEcUV4IKjFaw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 03/13] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Tue, 29 Sep 2026 10:25:00 +0200
Message-ID: <20260929082456.857423-18-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1364; i=cassel@kernel.org; h=from:subject; bh=uHn+xouBm8aCyNWVuGQGtAQd/rFqOzhXHDEfGXUXlxE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l7551cfxeO7SJ7n7fb1/CzwtStvoMo9bZPoPm2i1z kk8ZpU5HSUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZgIiz/Dj+OsLS9N3SoueVxf xGZvuOfltGYZBg+NWSF7lx+W5NzKyPBXkkGsWefv7SN/vQMYPSOZC/TeP3OxlOx+FFnIu9v+yEE GAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

sdebug_init() refuses a physblk_exp above 15, but the parameter is a
signed int, so a negative value is accepted. The driver then shifts by
it when it builds the Block Limits VPD page, which is undefined
behaviour, and READ CAPACITY (16) reports an exponent of 15 for -1.

Refuse a negative value as well, and print it as a signed value.

Assisted-by: LLM
Fixes: ea61fca58c13 ("scsi_debug: Add support for physical block exponent and alignment")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with physblk_exp=-1. Before this patch it
loads, and READ CAPACITY (16) reports a logical blocks per physical
block exponent of 15. After it the module is refused with -EINVAL and
"invalid physblk_exp -1".
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8e45a57ae406..f7c71fcc53fd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8656,8 +8656,8 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (sdebug_physblk_exp > 15) {
-		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
+	if (sdebug_physblk_exp < 0 || sdebug_physblk_exp > 15) {
+		pr_err("invalid physblk_exp %d\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
 
-- 
2.55.0

