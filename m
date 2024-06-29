Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33552574B;
	Sat, 29 Jun 2024 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719664963; cv=none; b=YmrVjhshtDMBEwAPN29yvWJjc+flLHRStivM+vb5te5seFtaLEXXK1CWL3rGud+WtXgbyjB+7oevAuGNhWrK0GBRS4jskgqs2fRz9uBdjdmTUp3mBb0W0eMpaCoHaQWHDL8gAO+ppczUQNYOEUZ4O5MkH6/jadkhCpORxkLatxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719664963; c=relaxed/simple;
	bh=YE2wYJ2kCjz6uRVo49Ho3nZ45FD637M/W1oPclhVsow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbxRLc6cf21JAlvaQ3aSe0QXzsVXAZ75bLjBaexxVlBr7xzZ8FoVDKk5Sve8e+lurGxCp/YZ3yyzytAWbC3kDaaJJ22qqjUbRkHg0lML4ngcrs3kArW39gXDCfAd1jqQ0gr13MbOaZpqhPyN374iGMcZTu6Qr/3Q+pHIfDtGg44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8w3vZIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8w3vZIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8B8C4AF09;
	Sat, 29 Jun 2024 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719664962;
	bh=YE2wYJ2kCjz6uRVo49Ho3nZ45FD637M/W1oPclhVsow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8w3vZIhVu84/AEdu/0R2YPl32MebtlulpnoUTsf1nKLxns3JUWjUkxaHWs1uQobJ
	 N89mEY7Mm06y7NsJIxhA0RMikpI4/+CBAhLi9Xnl1AUZE6OFQrOIoJOiwtui3YTRCB
	 VhKyRC4JynbB2azhAJpslgYQixJPJ6PzTihhHzuWjLS+f2u33kMnW33bRYkeKij9oh
	 ZTjR01/kzWMK0Evr6oW8pK+t+d6/MTaGE3az/InsRB3LhI2UQTkZZHd1uePgitSGfV
	 Arijomt4jRcwujVnk/Y9r4hC/dgXXvLpmkK+FQiz/cm0KanxZCFTxD3hR79FFr5GbC
	 sSo1qDiuVUJdQ==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	stable@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ata: ahci: Clean up sysfs file on error
Date: Sat, 29 Jun 2024 14:42:14 +0200
Message-ID: <20240629124210.181537-10-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240629124210.181537-6-cassel@kernel.org>
References: <20240629124210.181537-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2648; i=cassel@kernel.org; h=from:subject; bh=YE2wYJ2kCjz6uRVo49Ho3nZ45FD637M/W1oPclhVsow=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNIaGDUiIxckPH6ezttj94BvWV/kp9Cdb48lvc5PlO+Lm v3vZLdxRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACbStJ/hn8UBW1l/0Yf3JnJ5 /lvLUDFxwbLTud/PamQfZrhdfddE9wUjwya772YeLnuaL8czB2w++sY5bXnJyg+3dn2717FHSOb gB14A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

.probe() (ahci_init_one()) calls sysfs_add_file_to_group(), however,
if probe() fails after this call, we currently never call
sysfs_remove_file_from_group().

(The sysfs_remove_file_from_group() call in .remove() (ahci_remove_one())
does not help, as .remove() is not called on .probe() error.)

Thus, if probe() fails after the sysfs_add_file_to_group() call, the next
time we insmod the module we will get:

sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:04.0/remapped_nvme'
CPU: 11 PID: 954 Comm: modprobe Not tainted 6.10.0-rc5 #43
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x5d/0x80
 sysfs_warn_dup.cold+0x17/0x23
 sysfs_add_file_mode_ns+0x11a/0x130
 sysfs_add_file_to_group+0x7e/0xc0
 ahci_init_one+0x31f/0xd40 [ahci]

Fixes: 894fba7f434a ("ata: ahci: Add sysfs attribute to show remapped NVMe device count")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/ahci.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5eb38fbbbecd..fc6fd583faf8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1975,8 +1975,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
-	if (!host)
-		return -ENOMEM;
+	if (!host) {
+		rc = -ENOMEM;
+		goto err_rm_sysfs_file;
+	}
 	host->private_data = hpriv;
 
 	if (ahci_init_msi(pdev, n_ports, hpriv) < 0) {
@@ -2031,11 +2033,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* initialize adapter */
 	rc = ahci_configure_dma_masks(pdev, hpriv);
 	if (rc)
-		return rc;
+		goto err_rm_sysfs_file;
 
 	rc = ahci_pci_reset_controller(host);
 	if (rc)
-		return rc;
+		goto err_rm_sysfs_file;
 
 	ahci_pci_init_controller(host);
 	ahci_pci_print_info(host);
@@ -2044,10 +2046,15 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = ahci_host_activate(host, &ahci_sht);
 	if (rc)
-		return rc;
+		goto err_rm_sysfs_file;
 
 	pm_runtime_put_noidle(&pdev->dev);
 	return 0;
+
+err_rm_sysfs_file:
+	sysfs_remove_file_from_group(&pdev->dev.kobj,
+				     &dev_attr_remapped_nvme.attr, NULL);
+	return rc;
 }
 
 static void ahci_shutdown_one(struct pci_dev *pdev)
-- 
2.45.2

