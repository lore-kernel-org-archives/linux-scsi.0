Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A12236F0;
	Wed, 30 Jul 2025 21:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753911897; cv=none; b=i9njLUFF5MSGDq74jvXf6X1kdUOQUguDtmQRMgosm1czipntndfVJx7dV7WuCXTuJnyaohGcdi3P7+CeTUKL2RR/qLhuWKnIshX5hC1grtW7Lg3AoNoyCEbudHkqtflxGDFQj3s1oRYLi+zSmqjTrmTPH/paA9AWApwZDkjJVAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753911897; c=relaxed/simple;
	bh=GlmndYCz9OyCYW5JbaleveHUqDauIJOc0d/1wwx1fMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=udnCK1DSNo6fQT0c853DdwCdKq2rZvst+F0YEKunlUUI0MJgYC6Q70XPfBxpgetXeQaMZ5C5O2RZndN6zu6GLWrNC4khtmZxQpldIJRwSqL6iMBITzuJDiPKUCGkWVVxOoGxbcvTyDT1RJvRaTPDiDbe9yG5hGqy89uhbwKbEzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KN0n0ppe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KN0n0ppe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D812C4CEE3;
	Wed, 30 Jul 2025 21:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753911896;
	bh=GlmndYCz9OyCYW5JbaleveHUqDauIJOc0d/1wwx1fMQ=;
	h=From:To:Cc:Subject:Date:From;
	b=KN0n0ppeanPg1mdWw4CO6Kash20JcYhsWavZUA/uldCxVIF7CarLSQ70ehpcsM6TS
	 chlzCNqrlsvw/IpLZPLzIVLcgvC3N/lPscQKnRXwx0aR9nbc9lZ1JEYDabbXSRwdKi
	 jltIryOfaP8BH13htFaCIcukSK65iLRP4YQqSmItm5WS8qZsrOzCVxLj6rRYrI0SJ7
	 V+X22YmEW9DNk1TDhnGUgn+ECKzl1T5RzrsaKb58zeeswg9/9h5g2Lo8v8PYLp3qLD
	 h5TR+Amu67R/Wm3Cc4dbT1L/+7mnFGaJLDwFwOFupQBvry1vxET+SfP97sa2s0brgo
	 go+TJjxdC+DQQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Geoff Levand <geoff@infradead.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: buslogic: mark blogic_pci_tbl as __maybe_unused
Date: Wed, 30 Jul 2025 23:44:47 +0200
Message-Id: <20250730214451.441025-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

A previous patch removed an #ifdef check around the array definition, but
this is not actually used when the driver is built-in, and now causes
a warning when -Wunused-const-variable is set:

drivers/scsi/BusLogic.c:3727:35: error: 'blogic_pci_tbl' defined but not used [-Werror=unused-const-variable=]

Mark it as __maybe_unused for this configuration.

Ideally this should be fixed instead by using the array as part of
a pci_driver definition, instead of the linux-2.4 style manual bus
scan.

Fixes: 204689f0ea20 ("scsi: Always define blogic_pci_tbl structure")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
There are only a handful of unused const variables left in the kernel,
and I would like to turn that warning on by default when they are
all gone.
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 08e12a3d6703..82597bd96525 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3724,7 +3724,7 @@ __setup("BusLogic=", blogic_setup);
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };*/
-static const struct pci_device_id blogic_pci_tbl[] = {
+static const struct pci_device_id blogic_pci_tbl[] __maybe_unused = {
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT)},
-- 
2.39.5

