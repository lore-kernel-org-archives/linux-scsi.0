Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F6C82892;
	Tue,  2 Apr 2024 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063243; cv=none; b=TIiXrWzCaPHhrkduVRXFFWm5E6/Wdus0m5SpRzUyUV7vGFd4t6GSCpkgY75Hu7Tr1nz6NAWH05PmmBWSP05YA14wlKaqI9SeKEwJaBwAh/yjBxGsemxzoYEssZ+b1yws2bW1+0lhUojC25obBLYOwxfeqhXAtX7ifVmc7GCHMUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063243; c=relaxed/simple;
	bh=A5NANGV31KgAV7MOu9lJ7+q9/gsEPgkEXX2FFcrEWuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=srrOon4XkTatHcBQwTmvWzNjy30kSTt8f7bEoqLTZjtBOXrMadjVHzEUfmhtq85pY/prctHfgZqN4FKJUu+sTckBUcZKvZQemKg+YNXblDh7tNaDzv9qEa9XDbppGqxP1WR8swJxiJs5O6mn6Cr4JIHV4qWbi0OyZ+dW3MPPvfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ywTbeJLl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ywTbeJLl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kHfoIa0HAY/LCpSWKmY9EQ8Q5uoZBs99upeyG9argx4=; b=ywTbeJLlMrwaD30ftF6Vq7649E
	A6sxzyoBmDRibfS/866zKTu5Ai149s1r8zuilI1QMJ+grhs6s/gxIaVv0aEqbZBd5J1t5/sSW4t8Y
	9Q+Ph63SFql67IVRcOQetOYReBrM28oavRdNLoPbi/6N+uUtwylRUg845L1ANOGgSuRwwDAkxglX4
	Hr/zBGea0Xu9lDD2oaDN59ONGLclFSvqDZguPelv0r3npoUFQvdwCG68Biv7ohEBDG0aZeQ0mw6E1
	2CzT3g0+XI2xoypr+bFFsk049OIGzCcyHv1TSEnjtDNM0oLI2bV9PoVX4LekOIObQgnyqZKYeRTRu
	4laiQ66Q==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdr3-0000000BFSP-2VZc;
	Tue, 02 Apr 2024 13:07:10 +0000
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
Subject: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to the init method
Date: Tue,  2 Apr 2024 15:06:30 +0200
Message-Id: <20240402130645.653507-9-hch@lst.de>
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

Use the SCSI host's dma_alignment field and set it in ->init and remove
the now unused config_scsi_dev method.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ufs/core/ufshcd.c     | 3 ---
 drivers/ufs/host/ufs-exynos.c | 8 ++------
 include/ufs/ufshcd.h          | 1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e30fd125988d7a..7d593395aeff25 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5262,9 +5262,6 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	 */
 	sdev->silence_suspend = 1;
 
-	if (hba->vops && hba->vops->config_scsi_dev)
-		hba->vops->config_scsi_dev(sdev);
-
 	ufshcd_crypto_register(hba, q);
 
 	return 0;
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 734d40f99e31e6..7ffc28e2278420 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1187,6 +1187,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	exynos_ufs_config_smu(ufs);
+
+	hba->host->dma_alignment = SZ_4K - 1;
 	return 0;
 
 out:
@@ -1510,11 +1512,6 @@ static int fsd_ufs_pre_link(struct exynos_ufs *ufs)
 	return 0;
 }
 
-static void exynos_ufs_config_scsi_dev(struct scsi_device *sdev)
-{
-	blk_queue_update_dma_alignment(sdev->request_queue, SZ_4K - 1);
-}
-
 static int fsd_ufs_post_link(struct exynos_ufs *ufs)
 {
 	int i;
@@ -1583,7 +1580,6 @@ static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
-	.config_scsi_dev		= exynos_ufs_config_scsi_dev,
 };
 
 static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a35e12f8e68baa..93afb726213f0c 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -374,7 +374,6 @@ struct ufs_hba_variant_ops {
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
-	void	(*config_scsi_dev)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
-- 
2.39.2

