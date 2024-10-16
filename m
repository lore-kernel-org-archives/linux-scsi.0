Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539A21D2F4A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113172; cv=none; b=tAkH3sjcKPLIfxVrlPW7A+ixUqTiqS90nb75SkaAaIFf4QYXMjFwzCqxvRk52xfAPdnsY6ioI3k16IMZFa05rpYGjdn0d6vrhS7hAfa8KBqPDj0wERPWo1mUzZ/aIeemMTjjTT697G24jSF1mrNveb1zIAljVIS2mjjfIYvhYxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113172; c=relaxed/simple;
	bh=tJYnRyLs+vOe5ziZOOPwG7tJnXx04wDUxjO/0vkGijE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW/EXCJwag3X7a2To+NZohxSY+ekzFNWmVD8RzLUa1jgyT3b1PB2VjWVruP+ewAYpl+Er0Oyrw/Betp0Zkp8H3kFyl22+YoefH3tsZcbpIp757zp1DFJ+7feu1Y01pj9QD3yXDWwzWs2X6aL+naDDssQpRpzgwmHl280yHoexsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sf80NVQf; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sf80NVQf"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTNwL5v4PzlgMVt;
	Wed, 16 Oct 2024 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729113164; x=1731705165; bh=SLRf9
	FpgOFoV8I+ITsfNgy8cGdrL1Z7Tli9KFFH4nO4=; b=sf80NVQfpXQKZXf2j4p+9
	KNnvY2XbjbOwOuoYSqk3Cl7RJrcDxGBn1Wi3g4MEreOWGGl/G9Lqrt4luQ3MNd73
	VMiFSVgZ6Gnko2mcX1wkDh+3ay/jULEkLDZsc65jEU5SsEiobhtO89Vc50FxJK+l
	LKmczLT+ZU/35OBM0AkqYqiu6zxSFzVQU6rvMu+fFNaH0BqAwlHC8YFCBIA4cf2O
	MRrLTslpq94No6hvXW5GFReq1v6h4gIkD/qPycaF0oBnfm9MKsH0Uow59vxdl3a9
	oaVNHg2bTVhyPysTFhB+EGB3/EVyUpuQ47d/Qp7lvynrnt+MgirB5QVqZKuwC8Ef
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WZ09dTFVRmUk; Wed, 16 Oct 2024 21:12:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTNw968PVzlgTWP;
	Wed, 16 Oct 2024 21:12:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: [PATCH 5/7] scsi: ufs: core: Simplify ufshcd_err_handling_prepare()
Date: Wed, 16 Oct 2024 14:11:16 -0700
Message-ID: <20241016211154.2425403-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016211154.2425403-1-bvanassche@acm.org>
References: <20241016211154.2425403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use blk_mq_quiesce_tagset() instead of ufshcd_scsi_block_requests()
and blk_mq_wait_quiesce_done().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 19 +++----------------
 include/ufs/ufshcd.h      |  2 --
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ff1b0af74041..75e00e5b3f79 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -349,18 +349,6 @@ static void ufshcd_configure_wb(struct ufs_hba *hba)
 		ufshcd_wb_toggle_buf_flush(hba, true);
 }
=20
-static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
-{
-	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
-		scsi_unblock_requests(hba->host);
-}
-
-static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
-{
-	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) =3D=3D 1)
-		scsi_block_requests(hba->host);
-}
-
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
 				      enum ufs_trace_str_t str_t)
 {
@@ -6379,15 +6367,14 @@ static void ufshcd_err_handling_prepare(struct uf=
s_hba *hba)
 			ufshcd_suspend_clkscaling(hba);
 		ufshcd_clk_scaling_allow(hba, false);
 	}
-	ufshcd_scsi_block_requests(hba);
 	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
-	blk_mq_wait_quiesce_done(&hba->host->tag_set);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	cancel_work_sync(&hba->eeh_work);
 }
=20
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
-	ufshcd_scsi_unblock_requests(hba);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
@@ -10560,7 +10547,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
=20
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
-	atomic_set(&hba->scsi_block_reqs_cnt, 0);
+
 	/*
 	 * We are assuming that device wasn't put in sleep/power-down
 	 * state exclusively during the boot stage before kernel.
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a0b325a32aca..36bd91ff3593 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -928,7 +928,6 @@ enum ufshcd_mcq_opr {
  * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
  * @clk_scaling_lock: used to serialize device commands and clock scalin=
g
  * @desc_size: descriptor sizes reported by device
- * @scsi_block_reqs_cnt: reference counting for scsi block requests
  * @bsg_dev: struct device associated with the BSG queue
  * @bsg_queue: BSG queue associated with the UFS controller
  * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime power
@@ -1089,7 +1088,6 @@ struct ufs_hba {
=20
 	struct mutex wb_mutex;
 	struct rw_semaphore clk_scaling_lock;
-	atomic_t scsi_block_reqs_cnt;
=20
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
