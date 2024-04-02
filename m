Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCF283CAE;
	Tue,  2 Apr 2024 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063247; cv=none; b=my/R0FEs2K/Jmu2Z/KnqBxC5338BtAM7D0XB/tHdaTDK4lAGilqlez+8koE5h/4QPY+qHu0OdvcTHuNtZb1yNQkbGQzh5V85M1SkvgcAjJ2l01SXKU1SViSQExWC5j9CrcM2sEFO3989xeCwAP1R0mKcLYdMNk/SEyzybdZjpLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063247; c=relaxed/simple;
	bh=jfKtSuV1daVD0KrCWNke8nNqaS5H59eUCNYE8j7KWeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MsAowL6B0K4MYdmgsNKk48sJqdUI2jECwlPNFZm/lwVnVLBL71vFdkIE4dwvWPawfR4dO4LiD/TUp0ucKTvNF8NN3J5V817be+AUVWiTJUBCf83KmaS0POPytm3v+h2k/CZiSdtlUInEFUNcwAdARTORndXIm/kXCXYJgVa9gh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hPmyLxmA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hPmyLxmA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0SB00OexNdrbfq3Jqh6wTlG+HIlhe3hmP01YptNK0fI=; b=hPmyLxmACR7c/fzzzYIPCxiLDs
	/IQSAjlvmH726JqbAMoyB+sg6mtNKJcfT9ZidjdbxXwC5dQ91bjN4d4CfKkO9tPzMHsh3+u/ThCll
	ZDaVfZ2bqgcmxNQGbhbLQog5iwIRVa2xThhuWEKTbS41ei8oQdxo5iN6a4A0TTMgFh5Rbb2YqRK05
	rMJZwY/kzcVeSMQRMzPl0ijw5snUM2z/fqoqt4fiTuzRv/l/fWMBHe6qjuSM+MpcJmptQwkFbm8FK
	EnwW5rdoEMc0oQ5YlCqMhnqBKMWgVZLJBmK36md0D7k6u9nLXq/BzCGbY9AKlGGF+z2m7NOg2UwOd
	OK+nsCGg==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdr9-0000000BFVe-2INf;
	Tue, 02 Apr 2024 13:07:15 +0000
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
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 10/23] scsi: add a device_configure method to the host template
Date: Tue,  2 Apr 2024 15:06:32 +0200
Message-Id: <20240402130645.653507-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240402130645.653507-1-hch@lst.de>
References: <20240402130645.653507-1-hch@lst.de>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 47 ++++++++++++++++++++++------------------
 include/scsi/scsi_host.h |  4 ++++
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d97e18ffaedbe1..8300fc28cb10a8 100644
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
index 09d769a371ca06..19a1c5c4893534 100644
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

