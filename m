Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1B547DD74
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 14:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778076106; cv=none; b=Uz5x8VK28hVk0FXupDCvw0mbjZhscpdgntKZm4iasWr8Knrjv86OgX96W4vmEh29rXjqCUifrtBv6qcFApDaj7J1W/ruByUnciELVxuJHO9zsuLAQdBH3cN0AgRpepZQVmIW1vSC07M6JYgrHiS208idAzWe5prl7PBfor1FGUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778076106; c=relaxed/simple;
	bh=lk1VBo0o+aLvY+j3qdBBdcxFXZJYH9OhUBaUSFwVy7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soEA4iRjilep+6DDh/6MiWfe76zRYfbWT3s1piByHt4OPg//UdvDo4F07Kn9bLP2zPL5jDk4Ni9axZnJ45ff858CVfE2ANDbg9pdeZ5omer+tWhrubVqc+p2TESSCLHtrj1vhxwRA8fQMvqTTHvLKMjrZiOIQxe/guxEwM7t/B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=Acc0cTN5; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="Acc0cTN5"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id ADB69242112
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 16:01:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1778076102; bh=oMp6DQwjZrRVZf84lVyKrhPYtfUehN8xUFWuSE93QNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=Acc0cTN5Xb1GSfVUmpYhhKeCiIiC63Kp019JIhxwhkn1C7KMwvjBp2j5ByKxM1oor
	 FoQTikzLsjiuljTnY78VgCE64ljiI7jPotVdejDPCRAe/qwAKN8ggUkDYWVjopqCHX
	 ZMrM6ZNutdQvajFsKxezVpYp+Fk450Jwl5syEiO9Agwcf/Vqnlu2TwONpMGQXGLzpC
	 lge2vS0OI4ejTY11tVXHivJRSM2n3s0KhvfeemQLx6HE+Whhh5oAAST7Tc49Gm+8qD
	 FuE6ztByxdn9EnoDW31NE8rIqjhfaWxvmYJt75z2mGxoc23HXIdXEOfCihrocHraRm
	 vnyF+w501F21g==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4g9cW83Dfpz9rxL;
	Wed,  6 May 2026 16:01:40 +0200 (CEST)
From: Mateusz Nowicki <mateusz.nowicki@posteo.net>
To: don.brace@microchip.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mateusz Nowicki <mateusz.nowicki@microchip.com>
Subject: [PATCH 1/2] scsi: smartpqi: add pci_error_handlers for bus reset recovery
Date: Wed, 06 May 2026 14:01:42 +0000
Message-ID: <af115a200993d9ca69ba91c47973e45d6c298de5.1778075755.git.mateusz.nowicki@posteo.net>
In-Reply-To: <cover.1778075755.git.mateusz.nowicki@posteo.net>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The smartpqi driver does not register pci_error_handlers.  When the PCI
subsystem performs a bus reset (e.g. "echo 1 > /sys/bus/pci/devices/
<bdf>/reset") on a controller without FLR support, the driver is not
notified.  Firmware reverts to SIS mode and drops admin and operational
queue mappings while the driver still believes PQI is active; SCSI I/O
hangs until reboot.

Add .reset_prepare and .reset_done callbacks reusing the existing
SIS -> PQI recovery helpers.

  reset_prepare:
    - pqi_wait_until_ofa_finished()
    - pqi_ofa_ctrl_quiesce()
    - clear controller_online and pqi_mode_enabled

  reset_done:
    - ssleep(PQI_POST_RESET_DELAY_SECS)
    - pqi_ofa_ctrl_unquiesce()
    - pqi_ctrl_init_resume() to drive SIS -> PQI, recreate queues,
      re-enable events and rescan
    - pqi_take_ctrl_offline() on failure

No new helpers or exports.  Tested on HPE SR932i-p Gen10+.

Signed-off-by: Mateusz Nowicki <mateusz.nowicki@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 47 +++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2026ac645d6a..c4003d3cda7e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10677,12 +10677,59 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, pqi_pci_id_table);
 
+static void pqi_reset_prepare(struct pci_dev *pci_dev)
+{
+	struct pqi_ctrl_info *ctrl_info = pci_get_drvdata(pci_dev);
+
+	if (!ctrl_info)
+		return;
+
+	dev_info(&pci_dev->dev, "PCI reset prepare\n");
+
+	pqi_wait_until_ofa_finished(ctrl_info);
+
+	pqi_ofa_ctrl_quiesce(ctrl_info);
+
+	ctrl_info->controller_online = false;
+	ctrl_info->pqi_mode_enabled = false;
+}
+
+static void pqi_reset_done(struct pci_dev *pci_dev)
+{
+	int rc;
+	struct pqi_ctrl_info *ctrl_info = pci_get_drvdata(pci_dev);
+
+	if (!ctrl_info)
+		return;
+
+	dev_info(&pci_dev->dev, "PCI reset done - reinitializing\n");
+
+	ssleep(PQI_POST_RESET_DELAY_SECS);
+
+	pqi_ofa_ctrl_unquiesce(ctrl_info);
+
+	rc = pqi_ctrl_init_resume(ctrl_info);
+	if (rc) {
+		dev_err(&pci_dev->dev, "reset recovery failed: %d\n", rc);
+		pqi_take_ctrl_offline(ctrl_info, PQI_FIRMWARE_KERNEL_NOT_UP);
+		return;
+	}
+
+	dev_info(&pci_dev->dev, "reset recovery complete\n");
+}
+
+static const struct pci_error_handlers pqi_pci_error_handlers = {
+	.reset_prepare	= pqi_reset_prepare,
+	.reset_done	= pqi_reset_done,
+};
+
 static struct pci_driver pqi_pci_driver = {
 	.name = DRIVER_NAME_SHORT,
 	.id_table = pqi_pci_id_table,
 	.probe = pqi_pci_probe,
 	.remove = pqi_pci_remove,
 	.shutdown = pqi_shutdown,
+	.err_handler = &pqi_pci_error_handlers,
 #if defined(CONFIG_PM)
 	.driver = {
 		.pm = &pqi_pm_ops
-- 
2.43.0

