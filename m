Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2532C12FF94;
	Tue,  9 Apr 2024 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673524; cv=none; b=mUOBZU91dVeVM68OEsDyU9ffXx7d/nODFgzBAwzr6cgYwlSFeOBcwNQQTnn0ZzAqMbjqWM2aOTWECiAEyGSMCSy7GAYkq4jZxkh9yui/O2/Gqvwxj7l3h2akZwWM/41W5yEJjrN2whhNN+rgVPpOnw4X973Dc0zajIrnKKftNnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673524; c=relaxed/simple;
	bh=kQagpPPOUq0SfSCwGLXK2TImVAsPbb2O6j8bOAzpRvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CQtHQpV4lLaTSdH9cPlsM+J5SNEX5Hs1YSx9MDMMK/YKgVny8PG/tITGRgnheJooJoKfr6Y5E/Djm9rsQ7L7rRMbIvC+Y5tm2u9sXJ6zhY1TtWKWFGERDy6lGoKieeQu3CuCyHNq3GBjWEqo8VDrTzN9ZRWksZp+ZtjPW765Bwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XRv/eawl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XRv/eawl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SZyzmpnjk4FheRLYyA90eDeg4CmfzjMaU8l+KnZbwcY=; b=XRv/eawlHdk4nU7ebxCA3OB0qm
	aGPAuAkDikOI2tkWhvWrnH4qXeP0fzNcjYFh0p5SpVuzqKn85Yxn5bMAbhJ8Nw3U4X3EIUB3Myd3z
	IC8Ft4sTQpzbN0QHYBtgc8Cai2Buc+SxUSoTQlATjgQBA5M44YiUORHDOrMIrg2rqMa6Q/h/1SZEZ
	rl+kcdOVe/8Q12UktxGEkyG3wV2qwbDZ0y6h+unSx9SR5JbxrJEsNXvXTKuRiU8AJTxtfto/qQgLM
	ON8Z+bmZntfJX7Cq4HAgms9OICk0aye38MlJGWyd/dGrdAu+J7hs9GTMXmW+PBxzs1B7dpniJICl+
	9BpmuQyA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCcM-00000002SAb-0yff;
	Tue, 09 Apr 2024 14:38:34 +0000
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
Subject: [PATCH 16/23] pmcraid: switch to using ->device_configure
Date: Tue,  9 Apr 2024 16:37:41 +0200
Message-Id: <20240409143748.980206-17-hch@lst.de>
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

Switch to the ->device_configure method instead of ->slave_configure
and update the block limits on the passed in queue_limits instead
of using the per-limit accessors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pmcraid.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 0614b7e366b776..0efe2fc8b30826 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -197,8 +197,9 @@ static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
 }
 
 /**
- * pmcraid_slave_configure - Configures a SCSI device
+ * pmcraid_device_configure - Configures a SCSI device
  * @scsi_dev: scsi device struct
+ * @lim: queue limits
  *
  * This function is executed by SCSI mid layer just after a device is first
  * scanned (i.e. it has responded to an INQUIRY). For VSET resources, the
@@ -209,7 +210,8 @@ static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
  * Return value:
  *	  0 on success
  */
-static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
+static int pmcraid_device_configure(struct scsi_device *scsi_dev,
+		struct queue_limits *lim)
 {
 	struct pmcraid_resource_entry *res = scsi_dev->hostdata;
 
@@ -233,8 +235,7 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
 		scsi_dev->allow_restart = 1;
 		blk_queue_rq_timeout(scsi_dev->request_queue,
 				     PMCRAID_VSET_IO_TIMEOUT);
-		blk_queue_max_hw_sectors(scsi_dev->request_queue,
-				      PMCRAID_VSET_MAX_SECTORS);
+		lim->max_hw_sectors = PMCRAID_VSET_MAX_SECTORS;
 	}
 
 	/*
@@ -3668,7 +3669,7 @@ static const struct scsi_host_template pmcraid_host_template = {
 	.eh_host_reset_handler = pmcraid_eh_host_reset_handler,
 
 	.slave_alloc = pmcraid_slave_alloc,
-	.slave_configure = pmcraid_slave_configure,
+	.device_configure = pmcraid_device_configure,
 	.slave_destroy = pmcraid_slave_destroy,
 	.change_queue_depth = pmcraid_change_queue_depth,
 	.can_queue = PMCRAID_MAX_IO_CMD,
-- 
2.39.2

