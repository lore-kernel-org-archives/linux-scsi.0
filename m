Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [195.130.132.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5FC1E8825
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 18:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831806; cv=none; b=QoZNJIL1s67xRFTz19b6o4vcqwJkoNXCXAdQLcWuBAPlwTC3Y7APV7+URsCbTGR/EQcU3e5cHOoI0eGdpSQyIeOBVjle0fmkOmk8I/jmbBsc1qX12CHgyvGvl4NQOlk4SKwifB5vKnU5944/CM3R1QUqDtRX9HP8OqEMyb37TDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831806; c=relaxed/simple;
	bh=SNGgsZjvncAALUZ3SwuYQPe6vIKIexPik4mF1WjbGtk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kMH8OFcV4pU/Fsr+ToDRUrlS/ZO7F5fKpYJbbqZ93XkPeFz2oc5RmnJimJHA2dUT75NUZEM8P9uRC/wEP36PqlUxWo7js8qlC+zuqwqYOzYYgj9Mo6ULkfe0DjW9c8mO2MYukDVbNChn25rn+xEa+ybVJh80v5fssKC/KwXZLKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:aed7:437f:20a9:d72d])
	by xavier.telenet-ops.be with cmsmtp
	id Z6cb2D00f3NwldE016cbVi; Tue, 05 Nov 2024 19:36:36 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1t8OPX-006Jro-Ui;
	Tue, 05 Nov 2024 19:36:35 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1t8OPr-005bEX-Km;
	Tue, 05 Nov 2024 19:36:35 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sam Creasey <sammy@sammy.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-m68k@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi: sun3: Mark driver struct with __refdata to prevent section mismatch
Date: Tue,  5 Nov 2024 19:36:31 +0100
Message-Id: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As described in the added code comment, a reference to .exit.text is ok
for drivers registered via module_platform_driver_probe().  Make this
explicit to prevent the following section mismatch warnings

    WARNING: modpost: drivers/scsi/sun3_scsi: section mismatch in reference: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .exit.text)
    WARNING: modpost: drivers/scsi/sun3_scsi_vme: section mismatch in reference: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .exit.text)

that trigger on a Sun 3 allmodconfig build.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/sun3_scsi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index fffc0fa525940cee..1bd1c3f87ff7dd42 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -656,7 +656,13 @@ static void __exit sun3_scsi_remove(struct platform_device *pdev)
 	iounmap(ioaddr);
 }
 
-static struct platform_driver sun3_scsi_driver = {
+/*
+ * sun3_scsi_remove() lives in .exit.text. For drivers registered via
+ * module_platform_driver_probe() this is ok because they cannot get unbound at
+ * runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
+ */
+static struct platform_driver sun3_scsi_driver __refdata = {
 	.remove_new = __exit_p(sun3_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
-- 
2.34.1

