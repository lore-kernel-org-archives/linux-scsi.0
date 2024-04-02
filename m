Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E160084A21;
	Tue,  2 Apr 2024 13:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063259; cv=none; b=N7C0RtRGP3aEBQqz7dc5zSruocoWQ9gUAQkBpxCNgvRAu2LMoQ3ORvyNIIOK8A/yV1+3iXZgt7O7hyR91LPSMdxqnzXD9iPh4zUuuHzhXL8FcxXfh5Sxat/0a5GTzzBK0QrXFFJjbKYW0ywbbaVYMkjig/xiwq3+zrt9yTOsFps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063259; c=relaxed/simple;
	bh=I+Xt4+tlHP3Xsz5SwFKjZk+ypJPOwmD8sB/WfACezuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLHSB/uaLbKYQd0wsqRB2c9K/2A7TOL9Tt18Cx3MCV91tCPYfePucq61+iX+IZEKc7aLUqD1GKx7docl8McqjwcQrnYkEeSnS4+Mk5mqPgMMEhzaFfc1PXlHZXsTZl4A+30I2p5VCQjfJfjzHDc+gImsUWgngBbFOEk9/d8Nn4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PRJqPC/O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PRJqPC/O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AL2Go3EcIMZ+lqY5zaNhfFoymHIdjgdXZZzKZ1Sij60=; b=PRJqPC/OKqBnboYbgMCGJBVGsK
	4Eg1lo8H90cn2I1Ki/zwdf3Kpn+0ohhbe/FVyApLSnTmRHNA2iqhhNKwuCPecLvAkn2j1LW1Hiv1U
	P1f+mG0CT0wKJpeGaKIpTSQX99xV3xOaLd2/Y4emf3oxHaUe2uJ5pGw9JZ5U0Te4IsZA4EDJCzWbw
	ySRAxOihbGLllTRMfQ0FdgiqKZtpzUC4/bwbBRxsK9QMZYU+Dgak8Q3HZOaD0Rv7fLjX4iOnltiA2
	h1s69uWp1APYNmSEqkIYCAl/JBqtJV6cxP6VO3jhlgcRkmQU0rokgrKSCNINOWKCscFWjBCQA7y8s
	Cp3SyEZw==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdrL-0000000BFah-1jSc;
	Tue, 02 Apr 2024 13:07:27 +0000
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
Subject: [PATCH 14/23] hptiop: switch to using ->device_configure
Date: Tue,  2 Apr 2024 15:06:36 +0200
Message-Id: <20240402130645.653507-15-hch@lst.de>
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
 drivers/scsi/hptiop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index f5334ccbf2cac3..e889f268601b4f 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1151,11 +1151,11 @@ static struct attribute *hptiop_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(hptiop_host);
 
-static int hptiop_slave_config(struct scsi_device *sdev)
+static int hptiop_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	if (sdev->type == TYPE_TAPE)
-		blk_queue_max_hw_sectors(sdev->request_queue, 8192);
-
+		lim->max_hw_sectors = 8192;
 	return 0;
 }
 
@@ -1168,7 +1168,7 @@ static const struct scsi_host_template driver_template = {
 	.emulated                   = 0,
 	.proc_name                  = driver_name,
 	.shost_groups		    = hptiop_host_groups,
-	.slave_configure            = hptiop_slave_config,
+	.device_configure	    = hptiop_device_configure,
 	.this_id                    = -1,
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
 	.cmd_size		    = sizeof(struct hpt_cmd_priv),
-- 
2.39.2

