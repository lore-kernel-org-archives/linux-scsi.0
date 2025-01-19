Received: from smtp.smtpout.orange.fr (smtp-27.smtpout.orange.fr [80.12.242.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE77DA82;
	Sun, 19 Jan 2025 20:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737318673; cv=none; b=GSUOBuMDEy6DX4Xp9+lhfN2Z46wrIjvJghPzcE34ifzgnjVVeqzmgp7zg5sCf5p0Obeh8QI8jDr52hlagnyRb1WVuwT4tncI1S/0AWomRHyJuHq7vAnlx0FOY8hxKFEcTblDaPlNG+nJJueBw5+CJJXbUGeS5DYvVlQMxiD7gNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737318673; c=relaxed/simple;
	bh=K+JsJ9me16h3DvWGqU+L3uP22zaz2+ob8Ga0y6Yn6tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A3/jleG2WN5GN/KURNlnCMqCEFAmx2+WNqhtVqcJe6SOYxpasP8FkZRYmS0B8ZjVUdd5BeGs4BfxV5BxlKu9799Q/4gwdYLdEVIli4rD3tN8cXZ+oTf509SmKit+2qgocBaUTzDzTSJnI8KIDeCp7xMPIt2/f4cX6tx/Hr9sf5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=KE8uEEbL; arc=none smtp.client-ip=80.12.242.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="KE8uEEbL"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id ZbvZt5Bg9T9cbZbvctVvAQ; Sun, 19 Jan 2025 21:29:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1737318595;
	bh=qymbrdTFDBGYms3o1zqtHwQuOc1QBqjO7JslM1kAnY8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=KE8uEEbLMa30N/USd3TNIjxH5VlnJCYKEJBdhMOCYuJp5SGZr0ONXH9X+NwYwPWGn
	 iKT4KmSmngzXVyd+FzWNns4ZyRaBsH6zV6/QKoH83tdqTrgX6qjxfHDEH3TMuydu+v
	 X77LaqkMHXROZqhmRUhOWMc9FjHcfrevG3WnNrekHBR4cYZZew7kPHhMipkd/0W2dK
	 suMgvPqDvIvvfwcM6Ag3s0FwY2xkM31lp6/tiPjTCnPrVM9ldELdQcwIL8FL8w2Uzu
	 BvycUSyotO5W0BBGuATcg0in5sl62XAIqwUnR7Z7L+sy+FWIzatzfX0wks5gRwTbTU
	 5GL/o35ggGVgA==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 19 Jan 2025 21:29:55 +0100
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: Constify struct pci_error_handlers
Date: Sun, 19 Jan 2025 21:29:39 +0100
Message-ID: <efdec8425981e10fc398fa2ac599c9c45d930561.1737318548.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct pci_error_handlers' are not modified in these drivers.

Constifying these structures moves some data to a read-only section, so
increase overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  39049	   6429	    112	  45590	   b216	drivers/scsi/aacraid/linit.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  39113	   6365	    112	  45590	   b216	drivers/scsi/aacraid/linit.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only.
---
 drivers/scsi/aacraid/linit.c         | 2 +-
 drivers/scsi/be2iscsi/be_main.c      | 2 +-
 drivers/scsi/bfa/bfad.c              | 2 +-
 drivers/scsi/csiostor/csio_init.c    | 2 +-
 drivers/scsi/elx/efct/efct_driver.c  | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c      | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 drivers/scsi/qedi/qedi_main.c        | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 91170a67cc91..4b12e6dd8f07 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -2029,7 +2029,7 @@ static void aac_pci_resume(struct pci_dev *pdev)
 	dev_err(&pdev->dev, "aacraid: PCI error - resume\n");
 }
 
-static struct pci_error_handlers aac_pci_err_handler = {
+static const struct pci_error_handlers aac_pci_err_handler = {
 	.error_detected		= aac_pci_error_detected,
 	.mmio_enabled		= aac_pci_mmio_enabled,
 	.slot_reset		= aac_pci_slot_reset,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 76a1e373386e..a8b399ed98fc 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5776,7 +5776,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 }
 
 
-static struct pci_error_handlers beiscsi_eeh_handlers = {
+static const struct pci_error_handlers beiscsi_eeh_handlers = {
 	.error_detected = beiscsi_eeh_err_detected,
 	.slot_reset = beiscsi_eeh_reset,
 	.resume = beiscsi_eeh_resume,
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 6aa1d3a7e24b..f015c53de0d4 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1642,7 +1642,7 @@ MODULE_DEVICE_TABLE(pci, bfad_id_table);
 /*
  * PCI error recovery handlers.
  */
-static struct pci_error_handlers bfad_err_handler = {
+static const struct pci_error_handlers bfad_err_handler = {
 	.error_detected = bfad_pci_error_detected,
 	.slot_reset = bfad_pci_slot_reset,
 	.mmio_enabled = bfad_pci_mmio_enabled,
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 9a3f2ed050bd..79c8dafdd49e 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1162,7 +1162,7 @@ csio_pci_resume(struct pci_dev *pdev)
 	dev_err(&pdev->dev, "resume of device failed: %d\n", rv);
 }
 
-static struct pci_error_handlers csio_err_handler = {
+static const struct pci_error_handlers csio_err_handler = {
 	.error_detected = csio_pci_error_detected,
 	.slot_reset	= csio_pci_slot_reset,
 	.resume		= csio_pci_resume,
diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 8469c156ab33..59f277593785 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -735,7 +735,7 @@ efct_pci_io_resume(struct pci_dev *pdev)
 
 MODULE_DEVICE_TABLE(pci, efct_pci_table);
 
-static struct pci_error_handlers efct_pci_err_handler = {
+static const struct pci_error_handlers efct_pci_err_handler = {
 	.error_detected = efct_pci_io_error_detected,
 	.slot_reset = efct_pci_io_slot_reset,
 	.resume = efct_pci_io_resume,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index b9a51d3f2024..e3547ea42613 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5803,7 +5803,7 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, mpi3mr_pci_id_table);
 
-static struct pci_error_handlers mpi3mr_err_handler = {
+static const struct pci_error_handlers mpi3mr_err_handler = {
 	.error_detected = mpi3mr_pcierr_error_detected,
 	.mmio_enabled = mpi3mr_pcierr_mmio_enabled,
 	.slot_reset = mpi3mr_pcierr_slot_reset,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a456e5ec74d8..92572cde3485 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12710,7 +12710,7 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, mpt3sas_pci_table);
 
-static struct pci_error_handlers _mpt3sas_err_handler = {
+static const struct pci_error_handlers _mpt3sas_err_handler = {
 	.error_detected	= scsih_pci_error_detected,
 	.mmio_enabled	= scsih_pci_mmio_enabled,
 	.slot_reset	= scsih_pci_slot_reset,
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index c9539897048a..e87885cc701c 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2876,7 +2876,7 @@ MODULE_DEVICE_TABLE(pci, qedi_pci_tbl);
 
 static enum cpuhp_state qedi_cpuhp_state;
 
-static struct pci_error_handlers qedi_err_handler = {
+static const struct pci_error_handlers qedi_err_handler = {
 	.error_detected = qedi_io_error_detected,
 };
 
-- 
2.48.1

