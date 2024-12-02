Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490B81DE3D5;
	Mon,  2 Dec 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733166042; cv=none; b=YP8rLRWm8ghGFFjTWNSi3FsUgBLkMQFGoMxVMIYKt6Bfchcp3uuK+vnEZZEShLZHWDqChUa9c9gCpTIPicT+04ujN56gUkSGGDEq3qiUp2lAZd8xMsJm1pog2DA8ZqiW1s/n8s1KCg+QGvxAAS1L+vAxGInK5TFWgfT4nV+8ewc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733166042; c=relaxed/simple;
	bh=TMBtf8tHW7HSo+J0IXx7Vgtjq1QjUtkf1n/uqfOEV94=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=uEu1HOtUHB/LoRPjvuM6KP8pPGGorrITvkvwqIlhUS7Zb2zViJpONw5DYegMVptNEUse9U5bTNSLUsQCgQ1pTn2tz8+hWNjMBWiozC07s96d0lltTcZB6y/GK8/rdDQxa/q1/30Yn483lBMUa4ARq31Du/lahPezHd/UXfi19BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=UCRrJsEI; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="UCRrJsEI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1733166037;
	bh=TMBtf8tHW7HSo+J0IXx7Vgtjq1QjUtkf1n/uqfOEV94=;
	h=From:Subject:Date:To:Cc:From;
	b=UCRrJsEIeshSRwM/Fmf8PF9CwtfNSvEPZYzfdwayKyZ0BljSsO1TS2Vx3olEuVi8c
	 liYIpma/oFebeGv3rzy9oPpxSQmya00+yua1JEZNRHhxeZrW1G3RwDsPIWrbI/YR6U
	 rS2PSdnZfRR0OFAwRz9dCLxv3drRVms6BrkgPHmU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 0/5] sysfs: introduce and use macro BIN_ATTR_ADMIN_WO()
Date: Mon, 02 Dec 2024 20:00:35 +0100
Message-Id: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIANMDTmcC/x3MTQqDMBBA4avIrB1oQrTYqxSRxEzqLJqUTPAH8
 e6G7t63eScIZSaBV3NCppWFU6xQbQPzYuOHkH016Ic2SukO5ZAgOKcoBR3HyZaS0fpvzS3h4E3
 fh/AkZzTUxy9T4P3/f4/XdQO9DLWpbwAAAA==
X-Change-ID: 20241125-sysfs-const-bin_attr-admin_wo-9d466ff7eb42
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Tzung-Bi Shih <tzungbi@kernel.org>, Brian Norris <briannorris@chromium.org>, 
 Julius Werner <jwerner@chromium.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733166036; l=1317;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=TMBtf8tHW7HSo+J0IXx7Vgtjq1QjUtkf1n/uqfOEV94=;
 b=qkbGdke2NYYCgu59TeLJS7A7eWNgWRdWBo+2G8qKIHkdDBXG//myctF8vmaEN7qBuRPkewQeU
 8qsJmBMqoyKBRHgFsXoN/t3Iemm8g1hIGmKXIQBKBNYcCX9Goj8tC6r
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

For the bin_attribute constification effort it is useful to have
BIN_ATTR_ADMIN_WO() macro.
Introduce it and switch over all places in the tree which can make use
of it.

While at it also constify the bin_attribute callback parameters.

This series is meant to be applied through the driver core tree.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
Thomas Weißschuh (5):
      sysfs: add macro BIN_ATTR_ADMIN_WO()
      s390/sclp_config: use BIN_ATTR_ADMIN_WO() for bin_attribute definition
      powerpc/powernv/flash: Use BIN_ATTR_ADMIN_WO() for bin_attribute definition
      firmware: google: gsmi: Use BIN_ATTR_ADMIN_WO() for bin_attribute definition
      scsi: arcmsr: Use BIN_ATTR_ADMIN_WO() for bin_attribute definitions

 arch/powerpc/platforms/powernv/opal-flash.c | 14 ++----
 drivers/firmware/google/gsmi.c              | 17 +++----
 drivers/s390/char/sclp_config.c             | 16 ++-----
 drivers/scsi/arcmsr/arcmsr_attr.c           | 73 ++++++++++-------------------
 include/linux/sysfs.h                       |  6 +++
 5 files changed, 49 insertions(+), 77 deletions(-)
---
base-commit: e70140ba0d2b1a30467d4af6bcfe761327b9ec95
change-id: 20241125-sysfs-const-bin_attr-admin_wo-9d466ff7eb42

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

