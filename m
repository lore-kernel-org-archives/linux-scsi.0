Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD632D6E62;
	Sat, 20 Dec 2025 03:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766201867; cv=none; b=Vs5udk3Z9DxGkYcssn7nTlJrwvgn2pxiw5Pxgejqx/B504eZgqLUDIHPa3UkSJZRX7UmTwT09St1L32/QUsas3RzyCzlp5hmL3wkozmVMvMPJdt42klsp8WQcGLnnRSV3L9nEEJuKsCbUfxfD04DKWehunPdfwN+6oE5D/EQWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766201867; c=relaxed/simple;
	bh=/il7K0lofULDy2OZDM3FF6uYpttd7tn+0u7tUhx20m8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=RPNjVw3sG+a1pTFTdnR8J851zonogv6zkwbwiWdgsUwDiYeLmFnrF6dXJ6oeOJuwzNP/Rnd/v3dX6wjhBWsmPFNDL9RkRKiC82ZtNcXIogkbvvajTVbGKhWdHdi96VqOY1qZIjYva4gvYfhPIveP+KMiVXq4A5GUWXlKMXuaOd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PgbIjVGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgbIjVGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB51BC4CEF5;
	Sat, 20 Dec 2025 03:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766201866;
	bh=/il7K0lofULDy2OZDM3FF6uYpttd7tn+0u7tUhx20m8=;
	h=From:Subject:Date:To:Cc:From;
	b=PgbIjVGCMcpKzzobahf7bFQUDmsKA46Noa21et4K7XppNwPUbKB8W80vYFqRE9Ci1
	 Qvo+DLISHlwT8XXuCs6cvAMW/zH8K+y716gNRv0HYtX8OHZ8Y3Z0h/oqsW0NxB5wcA
	 9f5zLc/t82851QR/HCrfTmd3wK5UORYpqgjrPQ9Kv7vYf2b30PhoqbGIwjTp1leWEA
	 D/BPZHC/0RFOzaHPK+2mWK+Ef1GkeH4XMvEGeyhu6dHfyfAHGVqSkfoczc9Ih7zxNl
	 9Lbr26v8UnaJJFMLE1S6p1EyQvOvLJn6D7c9dOkuyDLYukQ1ksGVu6ppaxHHXdgZC/
	 y2DTP39KzOtig==
From: Daniel Gomez <da.gomez@kernel.org>
Subject: [PATCH 0/2] scsi: target+fcoe: replace -EEXIST with -EBUSY in
 module_init() paths
Date: Sat, 20 Dec 2025 04:37:31 +0100
Message-Id: <20251220-dev-module-init-eexists-linux-scsi-v1-0-5379db749d54@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPsZRmkC/x2N0QqCQBBFf0XmuQFnyax+JXow51oDtsaOyoL47
 y0+Hg6cs5EjGZzu1UYJq7lNsYCcKuo/XXyDTQtTqEMjQa6sWPk76TIWE21mIJvPzqPFJbP3bnz
 GTTq5DO1LlUrolzBYPiaP577/AQQb0O10AAAA
X-Change-ID: 20251218-dev-module-init-eexists-linux-scsi-4e91a16f7bdd
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Hannes Reinecke <hare@suse.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, Lucas De Marchi <demarchi@kernel.org>, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daniel Gomez <da.gomez@samsung.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1492; i=da.gomez@samsung.com;
 h=from:subject:message-id; bh=/il7K0lofULDy2OZDM3FF6uYpttd7tn+0u7tUhx20m8=;
 b=owEBbQKS/ZANAwAIAUCeo8QfGVH7AcsmYgBpRhn/GVBkmi7vo+LhiK/E+rpx5MtzHTQ8TWr9f
 iX9yJl6DyeJAjMEAAEIAB0WIQTvdRrhHw9z4bnGPFNAnqPEHxlR+wUCaUYZ/wAKCRBAnqPEHxlR
 +9A6D/4sgZgr08LFw0XsLFk+sosvAgOxv0EBiwWYs6N9Cf1Co737yaG7o0R6Wb3y6jGsJFo4+yh
 Mg3347XDe+NXLL/tWO9nVrgqBPvDMpMx9LxQq2qsACq+g+4sO2bVISeVoz82yjgPQY2TXgtVVVb
 Vb0BRDROSK+WojKsjVTUXbmUfFpsxUnqr8thNaP3bWkhkh6x0YTOCTkYbaRA6TAPNUTzHkAyxhK
 KUrVCh+BjInbyzB/WEp2gnbK4+GNpUXNw4v0wiU3tgCqCt0lnenLI+V0HYZ7ipnrK5EkY6zT0oE
 GbP0VnKA6XTCs2eGOjTGmtak0YnHP8KXWFarOi9JDOClxldzhCJIyLSXqdIE8/inbrc7DcDG02e
 tuPjGER236oZRNcvV6cpQNWJMDJMn9M/HwMjynv4JmkIlDYoZCeDIk2D2aSfXXko429fnGl+p01
 R4wfXMhwAs2r/dR3Pf4gNlokF85C4Tp6RBE5zxo3f0G5lq4PMoPVteiodaJMQYmLvDzUkK86ngj
 Mmi6TRffNG/oiOOypdRmNyooJ4X2QuMgvLYPzIw+hk58JzjqnKaLyUqXQB8Wrx9ao9dJEiqlQTW
 9saaaOSc5ioLd26GqTH9AJdBlYuQ96WH7Zgbet4wyfkWb8pk1Qw49gohCLUI+PQFYAz8Hh5ksKW
 fujNrbcw0CBmJ+w==
X-Developer-Key: i=da.gomez@samsung.com; a=openpgp;
 fpr=B2A7A9CFDD03B540FF58B27185F56EA4E9E8138F

The error code -EEXIST is reserved by the kernel module loader to
indicate that a module with the same name is already loaded. When a
module's init function returns -EEXIST, kmod interprets this as "module
already loaded" and reports success instead of failure [1].

The kernel module loader will include a safety net that provides -EEXIST
to -EBUSY with a warning [2], and a documentation patch has been sent to
prevent future occurrences [3].

These affected code paths were identified using a static analysis tool
[4] that traces -EEXIST returns to module_init(). The tool was developed
with AI assistance and all findings were manually validated.

Link: https://lore.kernel.org/all/aKEVQhJpRdiZSliu@orbyte.nwl.cc/ [1]
Link: https://lore.kernel.org/all/20251013-module-warn-ret-v1-0-ab65b41af01f@intel.com/ [2]
Link: https://lore.kernel.org/all/20251218-dev-module-init-eexists-modules-docs-v1-0-361569aa782a@samsung.com/ [3]
Link: https://gitlab.com/-/snippets/4913469 [4]

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
Daniel Gomez (2):
      target: replace -EEXIST with -EBUSY
      scsi: fcoe: replace -EEXIST with -EBUSY

 drivers/scsi/fcoe/fcoe_transport.c | 2 +-
 drivers/target/target_core_hba.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251218-dev-module-init-eexists-linux-scsi-4e91a16f7bdd

Best regards,
--  
Daniel Gomez <da.gomez@samsung.com>

