Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A38C30F925;
	Sat, 25 Oct 2025 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409217; cv=none; b=AsiOUUCh1tHzdjDyLQuy10cL+zuV7FPhSqsobdw1nGhwGE+PDRQXwQ31kUqmLb4mvV0kyESXS9O5GdZvkK8Burm8HMXum4gZIJ6aukP5iD34uhCwmYRCKpCVWHVJO9Ao3fqwU8vQD7NDRK9A/NspnMcugZ0mORUe2m2sjtPboHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409217; c=relaxed/simple;
	bh=ANpXLZ4bPgXvS0qIQAcVZBHmnKkHZlT5fX0rP1o9R8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3lKK1Sbr989cJt+wgCChJmJFJnYiSj8c/rhPh5a0zFPcUS/HQhw14pugyukMgmu5f4HKF7ckur/z0S5zEsOdEeVgvAZ4+IJ6GT7w4Z+JpNxukm9BI25CGv63Q2OejXmWMADo53bh93y+7NtEPXDthzyWdThG00N7PtkdNwfEWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoR++aH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoR++aH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A727C4AF0C;
	Sat, 25 Oct 2025 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409217;
	bh=ANpXLZ4bPgXvS0qIQAcVZBHmnKkHZlT5fX0rP1o9R8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoR++aH5WVmyuXNOy9N+QG3rxupOXPRunXLHY11lR0+dY/oyzjYjO8ruwgz47spxD
	 kI4t30xIPXsh6pOhd51BeiLuVDkyG4DyPlzyqARF5zUvS8wRRrMPGp6XTWA1GNqbAw
	 KwRq8rFkPcHJd3n3gv74CwTR/dlriGzwxDJo33XIY5cjJbyVCVTFVAtIiWxcXhR/Xy
	 ai3+Etw8Adnazme9qX8mbVgjsZ0w/ptpo4SI2jYEyZgbD4yQheznSz0uhABO6WCOGn
	 +8Spoee7T9EmEhFT0rq6Tx4auO+UXYBMxyiKJ4+G2EM1P1kkSF8uftXNZ2QAUeSedP
	 8SS85es09ChwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	hare@suse.de,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.15] scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()
Date: Sat, 25 Oct 2025 11:57:57 -0400
Message-ID: <20251025160905.3857885-246-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 072fdd4b0be9b9051bdf75f36d0227aa705074ba ]

The fc_ct_ms_fill() helper currently formats the OS name and version
into entry->value using "%s v%s". Since init_utsname()->sysname and
->release are unbounded strings, snprintf() may attempt to write more
than FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN bytes, triggering a
-Wformat-truncation warning with W=1.

In file included from drivers/scsi/libfc/fc_elsct.c:18:
drivers/scsi/libfc/fc_encode.h: In function ‘fc_ct_ms_fill.constprop’:
drivers/scsi/libfc/fc_encode.h:359:30: error: ‘%s’ directive output may
be truncated writing up to 64 bytes into a region of size between 62
and 126 [-Werror=format-truncation=]
  359 |                         "%s v%s",
      |                              ^~
  360 |                         init_utsname()->sysname,
  361 |                         init_utsname()->release);
      |                         ~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/libfc/fc_encode.h:357:17: note: ‘snprintf’ output between
3 and 131 bytes into a destination of size 128
  357 |                 snprintf((char *)&entry->value,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  358 |                         FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN,
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  359 |                         "%s v%s",
      |                         ~~~~~~~~~
  360 |                         init_utsname()->sysname,
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~
  361 |                         init_utsname()->release);
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by using "%.62s v%.62s", which ensures sysname and release are
truncated to fit within the 128-byte field defined by
FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN.

[mkp: clarified commit description]

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The updated format string in `drivers/scsi/libfc/fc_encode.h:356` caps
  both `init_utsname()->sysname` and `init_utsname()->release` at 62
  characters, keeping the composed `"OS vversion"` entry within the
  128-byte field defined for `FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN` at
  `include/scsi/fc/fc_ms.h:92`. This directly prevents the -Wformat-
  truncation build failure reported when compiling with `make W=1`, so
  it resolves a real build bug without changing any control flow.
- Runtime impact is limited to at most two characters of each component
  being truncated, which is already acceptable for this management
  payload and smaller than the silent truncation that happened
  previously when both strings were long.
- The patch is tiny, self-contained in libfc’s FDMI attribute formatting
  helper, and introduces no dependency or architectural change, so
  regression risk is negligible while restoring clean W=1 builds for
  stable users who enable those checks.

 drivers/scsi/libfc/fc_encode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
index 02e31db31d68e..e046091a549ae 100644
--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -356,7 +356,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(len, &entry->len);
 		snprintf((char *)&entry->value,
 			FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN,
-			"%s v%s",
+			"%.62s v%.62s",
 			init_utsname()->sysname,
 			init_utsname()->release);
 
-- 
2.51.0

