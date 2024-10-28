Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1A21C3F27
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 10:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730111085; cv=none; b=lZl579UmWKr45ds5ek4Q+L3RRwVZPzuwGFQOTF8UlBQ3CQ3EmtiWuF7fb6McuHKIX7y/NUJClym9cGL62fqE/mvMoUD1BeFsKnWzsspBdvLoB51lavDv6dN3V8a2vjs+gP4EDrtWMxw6yLSsRlB5HimMawpIBaIGB8vW+ClVWq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730111085; c=relaxed/simple;
	bh=PSXcW8y52t+sS2GK5KwCBNYCko4EWdoLOtCU9synXEE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OWgZeHh1Ll4iuTc37Cwy5rBCbrQzAm0gPrnjvvAKSOIoQYhgNEBsMJoi8LPwTfDGNHmeZIgjd+ZVIlq9zwdNq48s32I6/60Oqc6wLbiUmARheaRMbRMHApnanCs+pYhavCP2+ue7+gt5CA5CazgPHcelV555hk4cjvOGD0BKC1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=efad/ab9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="efad/ab9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730111082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xc/RGz11YWPABh0H4B1/0347FqzAk6dVpdVvZMq9SS8=;
	b=efad/ab9EsdaEMx6V3ShskSf/G+8Y1dO3DbEZpCMh54fJTp7hP9gXGoExuPP9FDEBoEH9H
	n5QHi92tZrzeiI83N1tpodV6NZhyKNTn6gyeej6EDMh4w9UDmlX+OWLsgXJoJU0+5SLy1J
	OO2vUsBgcF4PtqlSMD6wPcnE28yc1bI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-WWOOe-J8MXCW29GVLTjYWQ-1; Mon, 28 Oct 2024 06:24:41 -0400
X-MC-Unique: WWOOe-J8MXCW29GVLTjYWQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d4cf04be1so1994919f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 03:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730111080; x=1730715880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xc/RGz11YWPABh0H4B1/0347FqzAk6dVpdVvZMq9SS8=;
        b=TLBKX6MY4sjGy402WnEhw3QgUHMxXLXQMreLq/tc8RSvcZdqPpIupcMqJhKhTMMRd5
         PUqwI74/B/fpfbO84eifYskPHegBumGnlxTucUp6hh/O/X8cOK/dY87gzm9sVM1dFk/n
         WBEhCRrYVIlQRODP61/fIaHzqsuuuQfgJckojVRzb3OZTqF+bti/dVWLFnl5QY5jelan
         d6Krx41CypQTwYP9nCLiqmbrSjZh6ZJD02XNirdmKF1a4gDLinMJZV9pvAtlaj5SvRRT
         mAhPjoKFWq8h+b3l/1ACcqLjQrb3AOWNyHEgG5YZvzM8G5ZbdH8IWLl8B9ZemHZroNdU
         elig==
X-Gm-Message-State: AOJu0Yz4bLLdvA5xHTTL1NFSxScL6HZ0Tqjk19IQmNAJwJNfj0a3VwQr
	QyUixZU9W0waEepeRa21cnshJIb7tPOLAMfkwWjcesomZIPMD/lWVTZGB9moN7g0uw8Hi027jBT
	qwa8IkNBd6qIUDAN/B4GjMo5/voKo3P9vyKgSVad5BblUoHa4at7sldSETqc=
X-Received: by 2002:adf:f106:0:b0:37d:3dfd:cd92 with SMTP id ffacd0b85a97d-3806117dceamr5365155f8f.28.1730111080018;
        Mon, 28 Oct 2024 03:24:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGExDH7Nq1hm7ppK1jbeRo2k+cJOHRjlhoUA91SFSHg9aqnEaUekKi+z3ICfdmUg8xcIHYp+Q==
X-Received: by 2002:adf:f106:0:b0:37d:3dfd:cd92 with SMTP id ffacd0b85a97d-3806117dceamr5365142f8f.28.1730111079680;
        Mon, 28 Oct 2024 03:24:39 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43193595c51sm103279845e9.20.2024.10.28.03.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 03:24:39 -0700 (PDT)
From: Philipp Stanner <pstanner@redhat.com>
To: Pedro Sousa <pedrom.sousa@synopsys.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Minwoo Im <minwoo.im@samsung.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Philipp Stanner <pstanner@redhat.com>
Subject: [PATCH] scsi: ufs: Replace deprecated PCI functions
Date: Mon, 28 Oct 2024 11:24:29 +0100
Message-ID: <20241028102428.23118-2-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pcim_iomap_regions() and pcim_iomap_table() have been deprecated in
commit e354bb84a4c1 ("PCI: Deprecate pcim_iomap_table(),
pcim_iomap_regions_request_all()").

Replace these functions with pcim_iomap_region().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/ufs/host/tc-dwc-g210-pci.c | 8 +++-----
 drivers/ufs/host/ufshcd-pci.c      | 8 +++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/host/tc-dwc-g210-pci.c b/drivers/ufs/host/tc-dwc-g210-pci.c
index 876781fd6861..0167d8bef71a 100644
--- a/drivers/ufs/host/tc-dwc-g210-pci.c
+++ b/drivers/ufs/host/tc-dwc-g210-pci.c
@@ -80,14 +80,12 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(pdev);
 
-	err = pcim_iomap_regions(pdev, 1 << 0, UFSHCD);
-	if (err < 0) {
+	mmio_base = pcim_iomap_region(pdev, 0, UFSHCD);
+	if (IS_ERR(mmio_base)) {
 		dev_err(&pdev->dev, "request and iomap failed\n");
-		return err;
+		return PTR_ERR(mmio_base);
 	}
 
-	mmio_base = pcim_iomap_table(pdev)[0];
-
 	err = ufshcd_alloc_host(&pdev->dev, &hba);
 	if (err) {
 		dev_err(&pdev->dev, "Allocation failed\n");
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 54e0cc0653a2..ea39c5d5b8cf 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -588,14 +588,12 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(pdev);
 
-	err = pcim_iomap_regions(pdev, 1 << 0, UFSHCD);
-	if (err < 0) {
+	mmio_base = pcim_iomap_region(pdev, 0, UFSHCD);
+	if (IS_ERR(mmio_base)) {
 		dev_err(&pdev->dev, "request and iomap failed\n");
-		return err;
+		return PTR_ERR(mmio_base);
 	}
 
-	mmio_base = pcim_iomap_table(pdev)[0];
-
 	err = ufshcd_alloc_host(&pdev->dev, &hba);
 	if (err) {
 		dev_err(&pdev->dev, "Allocation failed\n");
-- 
2.47.0

