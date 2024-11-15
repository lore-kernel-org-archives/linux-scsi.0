Received: from smtp.smtpout.orange.fr (smtp-27.smtpout.orange.fr [80.12.242.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A788518BBB4;
	Fri, 15 Nov 2024 21:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705250; cv=none; b=fXiof+sFXaS6n2nTvkzqIL2Quv743AaprWu7BA/JywXAAVQejjNmCIL8tDv3PH+awm0UJfxLX8jk27CXdSsiEtkRVa/hHECd+VJVSKPCoR2bLK348yJding2CEialLoGv3G1Pqtl8NYEfIGk3kObh7ioO5QLldTQzTalMeTZwOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705250; c=relaxed/simple;
	bh=Rw9yHxAlJptiW00gXT9bNtO7PWmaKJaFHUJ65j/SbNo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tS7Rum3IPdRhuBbHkYbuOEIrrEv8yhZZcQkqD7heMqksB44EuycR6FSa9Ac/OO+CgfKIOWV/Qr8fZ87nPafD0JYT2+w3OrKyxSQ6CqUFcYOMKATm8WBSVAcnQE0CB9K/KHcWQ8MrlnOv2OFvHxZy6OGIP+9nJBHySCle1xw+9U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=SfSeRz+X; arc=none smtp.client-ip=80.12.242.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="SfSeRz+X"
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id C3cctn5C3YfukC3cctZqkz; Fri, 15 Nov 2024 22:12:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1731705175;
	bh=8pH2yKbzdMuGhO+oCMeL+R6PuBnOs1ipY2HJDAsvL5E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=SfSeRz+XjqDFc2X1t5jsY6yfT4abFdxDaV18To1NDGYoxv46SuB6UNCIKbcuv+BnC
	 HEHfCZ/XzBN0GESG5BohGsmSm0Ni1WFGUwtA783+RbE08fUiF9Ex70vULNiRsyz+zA
	 O0yvCmHYq8VdEV6RiC+mT2gbECFtG46ELe4r7OWPUl4lGhdxjkgkJz7FH+oiwt12fp
	 eEd36pWftoSGZzGPaEwnuHpkUwljSXe1a0SmXCXMcKUxffQY58sB1sZi0lx/ktPc15
	 O8Blif6qPeZW+W80T0W1NSGiloXGZDYLlycH1KzcXRt6Wn3dt1IM8o5CgpyYN1486s
	 X6biz1TcW7Yzw==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 15 Nov 2024 22:12:55 +0100
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: message: fusion: Constify struct pci_device_id
Date: Fri, 15 Nov 2024 22:12:42 +0100
Message-ID: <fe8f17a999b6def2649b2ef52ea5c9ee61e28bd0.1731705152.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct pci_device_id' is not modified in these drivers.

Constifying this structure moves some data to a read-only section, so
increase overall security.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  36999	   2451	     88	  39538	   9a72	drivers/message/fusion/mptfc.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  37415	   2043	     88	  39546	   9a7a	drivers/message/fusion/mptfc.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only.
---
 drivers/message/fusion/mptfc.c  | 2 +-
 drivers/message/fusion/mptsas.c | 2 +-
 drivers/message/fusion/mptspi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 91242f26defb..ee61b70aa677 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -137,7 +137,7 @@ static const struct scsi_host_template mptfc_driver_template = {
  * Supported hardware
  */
 
-static struct pci_device_id mptfc_pci_table[] = {
+static const struct pci_device_id mptfc_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a798e26c6402..d0549a4daf76 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5377,7 +5377,7 @@ static void mptsas_remove(struct pci_dev *pdev)
 	mptscsih_remove(pdev);
 }
 
-static struct pci_device_id mptsas_pci_table[] = {
+static const struct pci_device_id mptsas_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 574b882c9a85..4184d0c70ac3 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1238,7 +1238,7 @@ static struct spi_function_template mptspi_transport_functions = {
  * Supported hardware
  */
 
-static struct pci_device_id mptspi_pci_table[] = {
+static const struct pci_device_id mptspi_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_ATTO, MPI_MANUFACTPAGE_DEVID_53C1030,
-- 
2.47.0

