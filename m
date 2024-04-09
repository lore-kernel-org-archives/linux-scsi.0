Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18285131E2C;
	Tue,  9 Apr 2024 14:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673509; cv=none; b=kTK154+nVmu64gORFIK8kKqHka7mVlPAy2x8rLbxFWUTFDhLA5fi7ArnqzEVuHIWjwAXL0/0FyyzNN52IzUBcZmjqSYn95e6No/RYNeBf00h5xgDE+0EC5rze9ZOlk72DuZVXDaXfg0qZhizLGAzZk5ppET8pWYY5PQKawNkt2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673509; c=relaxed/simple;
	bh=eKDAoDsvRsFxP99M1dfg05BFy0rkpHzGTUrqBh/fAQ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jh+t9iKzeVJhPP2V9g8duZqClE+bo9E6eW1dkP2j2RZ0KaNGckLuqjmNl/rYiulD4Gd7E5Tm71q+CsUF0pm9pUl/lxzzasxaIpuqnWIMfRpQpsXZb/up/GMrYytB37zx4OoMLfOo868QifPeRWpE7olkDLgcDa+bmYOX8NLG83A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bKOxGJQW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bKOxGJQW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UNIxgxuc9FtvbvzwSjpyY7cNQmLry7auIP83EtiGuVk=; b=bKOxGJQWLCW40YyQVcX3I6xk6j
	/twxDPqwPqDaUDRyWrbQiMz8284oJAAsVIc2fGNioLNc9ooxkdyViUNUlcD3a2pBaQ/d1eE7muNEy
	inO3HzZ+g9Vr5quUtV/IPGBpznxOzsJRoVDqrvzEWCwq5JxmBw5XJkPiQv8n93ouW9TQRyM6M6Krs
	MOu8lZSoP+zH5FhoN4kHIU0o4E3qlCr+RGxk7ddgzdpEMx7Vi/Se4XJm2AJ6aFD5UhnrjrcdM68fI
	ZD6iXqoVu3ESGrQtYmK1bQV67tjLjYHNLcrkPJKf4C9f45wVJY/ztCWZX70EQCkdWpzxqNz+Gf7+M
	W+mnYtxw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCc6-00000002S0U-09Yy;
	Tue, 09 Apr 2024 14:38:18 +0000
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
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/23] scsi: add a device_configure method to the host template
Date: Tue,  9 Apr 2024 16:37:35 +0200
Message-Id: <20240409143748.980206-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409143748.980206-1-hch@lst.de>
References: <20240409143748.980206-1-hch@lst.de>
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 47 ++++++++++++++++++++++------------------
 include/scsi/scsi_host.h |  4 ++++
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1ec4b309af726d..463ce6e23dc678 100644
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
@@ -874,6 +874,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		blist_flags_t *bflags, int async)
 {
+	const struct scsi_host_template *hostt = sdev->host->hostt;
 	struct queue_limits lim;
 	int ret;
 
@@ -1073,33 +1074,37 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		lim.max_hw_sectors = 512;
 	else if (*bflags & BLIST_MAX_1024)
 		lim.max_hw_sectors = 1024;
+
+	if (hostt->device_configure)
+		ret = hostt->device_configure(sdev, &lim);
+	else if (hostt->slave_configure)
+		ret = hostt->slave_configure(sdev);
+	if (ret) {
+		queue_limits_cancel_update(sdev->request_queue);
+		/*
+		 * If the LLDD reports device not present, don't clutter the
+		 * console with failure messages.
+		 */
+		if (ret != -ENXIO)
+			sdev_printk(KERN_ERR, sdev,
+				"failed to configure device\n");
+		return SCSI_SCAN_NO_RESPONSE;
+	}
+
 	ret = queue_limits_commit_update(sdev->request_queue, &lim);
 	if (ret) {
 		sdev_printk(KERN_ERR, sdev, "failed to apply queue limits.\n");
 		return SCSI_SCAN_NO_RESPONSE;
 	}
 
-	if (sdev->host->hostt->slave_configure) {
-		ret = sdev->host->hostt->slave_configure(sdev);
-		if (ret) {
-			/*
-			 * if LLDD reports slave not present, don't clutter
-			 * console with alloc failure messages
-			 */
-			if (ret != -ENXIO) {
-				sdev_printk(KERN_ERR, sdev,
-					"failed to configure device\n");
-			}
-			return SCSI_SCAN_NO_RESPONSE;
-		}
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
index b0948ab69e0fa6..92c8c3b08dfc90 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -211,7 +211,11 @@ struct scsi_host_template {
 	 *     up after yourself before returning non-0
 	 *
 	 * Status: OPTIONAL
+	 *
+	 * Note: slave_configure is the legacy version, use device_configure for
+	 * all new code.  A driver must never define both.
 	 */
+	int (* device_configure)(struct scsi_device *, struct queue_limits *lim);
 	int (* slave_configure)(struct scsi_device *);
 
 	/*
-- 
2.39.2

