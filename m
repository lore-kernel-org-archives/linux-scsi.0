Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626232A356A;
	Sun, 24 Mar 2024 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711324552; cv=none; b=COptuWWWGFl/OnSvP44DP5a37QY5i/TBfv1TDvujpHjhgfN9BEG+1pAzlDfamr8qkib6Jq4+hdv7fDQotbXInXPSa0iA2pfuk9xB3A6wXbC1SzSjH8HmX1pH/6ziyhbEpIfES11DTgfT+IO1Kok1hVPNTl7cZqUIExh0o7eCGTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711324552; c=relaxed/simple;
	bh=/miLi9ayeFDj/1m5b/DXrakCXRsVkLDPvQUTFUx9GtY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LkeVhuRLnEuNFTIYDkpN5roTX4UoOfXkpWAJrW7AWIrVzQbjaJUcOjo8/ohliMYlV/a+fIc2sU8oDj/n+ILdWPSlP/H65qwcLKIRv/FFvWrIhCyb4oz9mcTrvgQ+N71K0TZINzWk2E72QG9KTBGPx3H+eAlVLqKLvGLYMG4Wi0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BfOP82s5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BfOP82s5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=n/G3RdcsG/UHdocEiANoLj+Yss9HtHvu5C4t+MOMe/A=; b=BfOP82s54xwTY8QgOAJgTaoC7O
	LmkOjwxOuRJMRjFtFHU4TinNu0wxPxF4U/M57S1gQrDkfztuwqAZ2E87LK1BgjcT0wzpa4Ytz0QTv
	KfbVSC0cY8bAgzMUEXaJOPZN9G/ei1vehGdbaOIjwc52zsuDvxMuQlarYoAfvbS1pgLrK8MfrsHjm
	FaLJCfafmiPwd9CDbGz8KHlJ4Y0ibqlhSLimylnaryMhzyf+OBe0zaqmmUj5cCLax+BdBEiIDLDtK
	yvUTK2i66nI+OM7fNtVCK2ChU2mqgDWy07NfGTCQCmXR0C458RFI8xdt54wLnN1o/FuW9rlyd9+Gq
	JxHrZvow==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roXgi-0000000Dzai-1gDh;
	Sun, 24 Mar 2024 23:55:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 10/23] scsi: add a device_configure method to the host template
Date: Mon, 25 Mar 2024 07:54:35 +0800
Message-Id: <20240324235448.2039074-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240324235448.2039074-1-hch@lst.de>
References: <20240324235448.2039074-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is a version of ->slave_configure that also takes a queue_limits
structure that the caller applies, and thus allows drivers to reconfigure
the queue using the atomic queue limits API.

In the long run it should also replace ->slave_configure entirely as
there is no need to have two different methods here, and the slave
name in addition to being politically charged also has no basis in
the SCSI standards or the kernel code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 33 +++++++++++++++++++--------------
 include/scsi/scsi_host.h |  4 ++++
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 699356d7d17545..8e05780f802523 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -227,7 +227,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 
 	/*
 	 * realloc if new shift is calculated, which is caused by setting
-	 * up one new default queue depth after calling ->slave_configure
+	 * up one new default queue depth after calling ->device_configure
 	 */
 	if (!need_alloc && new_shift != sdev->budget_map.shift)
 		need_alloc = need_free = true;
@@ -874,8 +874,9 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		blist_flags_t *bflags, int async)
 {
+	const struct scsi_host_template *hostt = sdev->host->hostt;
 	struct queue_limits lim;
-	int ret;
+	int ret, ret2;
 
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
@@ -1073,22 +1074,26 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		lim.max_hw_sectors = 512;
 	else if (*bflags & BLIST_MAX_1024)
 		lim.max_hw_sectors = 1024;
-	ret = queue_limits_commit_update(sdev->request_queue, &lim);
+
+	if (hostt->device_configure)
+		ret = hostt->device_configure(sdev, &lim);
+	else if (hostt->slave_configure)
+		ret = hostt->slave_configure(sdev);
+
+	ret2 = queue_limits_commit_update(sdev->request_queue, &lim);
+	if (ret2 && !ret)
+		ret = ret2;
 	if (ret)
 		goto fail;
 
-	if (sdev->host->hostt->slave_configure) {
-		ret = sdev->host->hostt->slave_configure(sdev);
-		if (ret)
-			goto fail;
-
-		/*
-		 * The queue_depth is often changed in ->slave_configure.
-		 * Set up budget map again since memory consumption of
-		 * the map depends on actual queue depth.
-		 */
+	/*
+	 * The queue_depth is often changed in ->device_configure.
+	 *
+	 * Set up budget map again since memory consumption of the map depends
+	 * on actual queue depth.
+	 */
+	if (hostt->device_configure || hostt->slave_configure)
 		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
-	}
 
 	if (sdev->scsi_level >= SCSI_3)
 		scsi_attach_vpd(sdev);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b0948ab69e0fa6..1959193d47e7f5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -211,7 +211,11 @@ struct scsi_host_template {
 	 *     up after yourself before returning non-0
 	 *
 	 * Status: OPTIONAL
+	 *
+	 * Note: slave_configure is the legacy version, use device_configure for
+	 * all new code.
 	 */
+	int (* device_configure)(struct scsi_device *, struct queue_limits *lim);
 	int (* slave_configure)(struct scsi_device *);
 
 	/*
-- 
2.39.2

