Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED68A83CAE;
	Tue,  2 Apr 2024 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063251; cv=none; b=HQ6Jm/LmQEF88n3rAzbJ8eB6Ks2YH7mNHFkDjkBeoUbVFAxlBWdDFAodHI4TdI0An0xZTeYGEtFlNG80rdP5LgoOwu72SNfvVNzwpiWJnwLJyynvdOSQf/U15d8rNuAZzaIMRQSiVssh94HSa7m9pzNMc15uDSBhS1f2tdoqWBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063251; c=relaxed/simple;
	bh=8NpJjn1Ow2HMrJiGKTi3H1nS9ETcxM5OOXfJNOUQdSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TwYofewKy1zxGWlO6uUmmAaxb7g/Xtt8h/asvTDQEZmiWVZ5co/L0CDxx3ZaLa2ySYZhgLwwyvFo63xy/+sTCCLfKeR4NwNxFa0z8e2L3Zsf1Hd/d4LSMpi3AErjDw8AFja7sO4pBHo/8vHwNI0HWZOyY1gc/XvCccJ8pGj+iKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pi38csK7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pi38csK7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W/4MX6Ta0iS+DzFN/hZaJgRdefyKJITkCBys0ksCJ1Q=; b=Pi38csK7b6x5EVq705Uo1UCstW
	x3K/9EeHJLl0PnB/ppKNfUF51/t6vWwr7pFyDWRqDY3mQp9Y2j6fbp91zzvCE3kMSras+ipRT9mVe
	hAtwswqgrq84Xhez7YgkWBJNS+ImlgvwolIHvjYYA3PvBjfcfh34Eixu9ViAHVzErStQbNbbRaubW
	0ATYGJxsJXdW6ir0f1z0G63NkPGJ7gPrtiPYa2SLuBVv7hdoXkFZUMeKPGjnxB/xCM1AV+eoAA31Y
	yndmGQjm2dtpVHTFVPrs8thnsZsdyQ0sGHiW4jf5/DdqYgr1dGumiBcoOhpT1s/QpWHk3EPQd6jpv
	7+H0l2xw==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdrC-0000000BFWZ-18IE;
	Tue, 02 Apr 2024 13:07:18 +0000
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
Subject: [PATCH 11/23] megaraid_sas: switch to using ->device_configure
Date: Tue,  2 Apr 2024 15:06:33 +0200
Message-Id: <20240402130645.653507-12-hch@lst.de>
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

Switch to the ->device_configure method instead of ->slave_configure
and update the block limits on the passed in queue_limits instead
of using the per-limit accessors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 29 ++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 ++-
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 56624cbf7fa5e7..5680c6cdb22193 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2701,7 +2701,7 @@ int megasas_get_ctrl_info(struct megasas_instance *instance);
 int
 megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend);
 void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
-					   bool is_target_prop);
+		struct queue_limits *lim, bool is_target_prop);
 int megasas_get_target_prop(struct megasas_instance *instance,
 			    struct scsi_device *sdev);
 void megasas_get_snapdump_properties(struct megasas_instance *instance);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3d4f13da1ae873..def0d905b6d9e3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1888,7 +1888,7 @@ static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 * Returns void
 */
 void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
-					   bool is_target_prop)
+		struct queue_limits *lim, bool is_target_prop)
 {
 	u16 pd_index = 0, ld;
 	u32 device_id;
@@ -1915,8 +1915,10 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
 			return;
 		raid = MR_LdRaidGet(ld, local_map_ptr);
 
-		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
-			blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
+		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER) {
+			if (lim)
+				lim->dma_alignment = 0x7;
+		}
 
 		mr_device_priv_data->is_tm_capable =
 			raid->capability.tmCapable;
@@ -1967,7 +1969,8 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
  *
  */
 static inline void
-megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
+megasas_set_nvme_device_properties(struct scsi_device *sdev,
+		struct queue_limits *lim, u32 max_io_size)
 {
 	struct megasas_instance *instance;
 	u32 mr_nvme_pg_size;
@@ -1976,10 +1979,10 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
 	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
 				MR_DEFAULT_NVME_PAGE_SIZE);
 
-	blk_queue_max_hw_sectors(sdev->request_queue, (max_io_size / 512));
+	lim->max_hw_sectors = max_io_size / 512;
+	lim->virt_boundary_mask = mr_nvme_pg_size - 1;
 
 	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, sdev->request_queue);
-	blk_queue_virt_boundary(sdev->request_queue, mr_nvme_pg_size - 1);
 }
 
 /*
@@ -2041,7 +2044,7 @@ static void megasas_set_fw_assisted_qd(struct scsi_device *sdev,
  * @is_target_prop			true, if fw provided target properties.
  */
 static void megasas_set_static_target_properties(struct scsi_device *sdev,
-						 bool is_target_prop)
+		struct queue_limits *lim, bool is_target_prop)
 {
 	u32 max_io_size_kb = MR_DEFAULT_NVME_MDTS_KB;
 	struct megasas_instance *instance;
@@ -2060,13 +2063,15 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
 		max_io_size_kb = le32_to_cpu(instance->tgt_prop->max_io_size_kb);
 
 	if (instance->nvme_page_size && max_io_size_kb)
-		megasas_set_nvme_device_properties(sdev, (max_io_size_kb << 10));
+		megasas_set_nvme_device_properties(sdev, lim,
+				max_io_size_kb << 10);
 
 	megasas_set_fw_assisted_qd(sdev, is_target_prop);
 }
 
 
-static int megasas_slave_configure(struct scsi_device *sdev)
+static int megasas_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	u16 pd_index = 0;
 	struct megasas_instance *instance;
@@ -2096,10 +2101,10 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 		ret_target_prop = megasas_get_target_prop(instance, sdev);
 
 	is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
-	megasas_set_static_target_properties(sdev, is_target_prop);
+	megasas_set_static_target_properties(sdev, lim, is_target_prop);
 
 	/* This sdev property may change post OCR */
-	megasas_set_dynamic_target_properties(sdev, is_target_prop);
+	megasas_set_dynamic_target_properties(sdev, lim, is_target_prop);
 
 	mutex_unlock(&instance->reset_mutex);
 
@@ -3507,7 +3512,7 @@ static const struct scsi_host_template megasas_template = {
 	.module = THIS_MODULE,
 	.name = "Avago SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
-	.slave_configure = megasas_slave_configure,
+	.device_configure = megasas_device_configure,
 	.slave_alloc = megasas_slave_alloc,
 	.slave_destroy = megasas_slave_destroy,
 	.queuecommand = megasas_queue_command,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c60014e07b449e..6c1fb8149553a8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5119,7 +5119,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					ret_target_prop = megasas_get_target_prop(instance, sdev);
 
 				is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
-				megasas_set_dynamic_target_properties(sdev, is_target_prop);
+				megasas_set_dynamic_target_properties(sdev, NULL,
+						is_target_prop);
 			}
 
 			status_reg = instance->instancet->read_fw_status_reg
-- 
2.39.2

