Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A3B14D2A3
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473568; cv=none; b=j47QotLMjjYxzH2pTo57/gjjPwbbGiqJDVm1QJxFgEINtsP/R6q4poOblt3w5rHPfJcIYRYbGR19yQkgLoAnLE22o49ds7teSRSVkby15WniOd5BgHcSHv2xQP5wgmCpqCsZQq3AWD8nyo19CSTVdblwf18KF252s82iYdlFt9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473568; c=relaxed/simple;
	bh=jjx+GqcSDnE663D3PJ1XAhhSANs3UMkWrQiOwxGVVxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9UA+cwKe/DeyaAAQijSvWRMikP0l7WBs+P7tCLmtF8ddJ5hIRKa9gd8f14g+xIXW2JK3pA5xaFpmdbHG3Jc4/3E2iFKIvOlbnH2k9EGv9yKcAxdeA7QEIC1w5gUsU6Pvk0Dehq8D57EO4ATjglD1vum8whjxvS85RjRzowNb/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y8g8ctcX; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y8g8ctcX"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxp622cFz6CmM6L;
	Mon,  8 Jul 2024 21:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473552; x=1723065553; bh=/f13e
	zMkTqOft6w0SXyVP9yXp/obffaFESgQ7DPdowU=; b=Y8g8ctcXx5KFvJmQ8D0TC
	ZqexEkxMcKMDocVuYOVx69z39Y3t/ZFFcXBJQt+AJ1A0XU8jmOMDAgzWvvm2IhcC
	WCfGhrpk578CO28Xvu7dMCjzXUgM9SjNumfExKNJ0yXLht1M3wblmI8S6FpnedjL
	ATSkkMffFXUkMvTW5h0VaWrAuo5elWwbOO0akzU9x8wf5gEPtB3hlqFUvJOy6K3I
	ZIt4Ekgph/slV7mroS9haUlNakoyxzKX5IZoRf+Yn/zg88x5LIGL+nl/vRs/lBGr
	J+Mu7WwHeQ8DnWkUaa8VrAs4Iy6NxaKQhgKxfKR8Kos+c5LYxPaiftBP3k1iecPI
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qit4WRcD33xV; Mon,  8 Jul 2024 21:19:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxnl4rC0z6Cnk9V;
	Mon,  8 Jul 2024 21:19:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Naomi Chu <naomi.chu@mediatek.com>,
	Rohit Ner <rohitner@google.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v5 10/10] scsi: ufs: Make .get_hba_mac() optional
Date: Mon,  8 Jul 2024 14:16:05 -0700
Message-ID: <20240708211716.2827751-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
the maximum number of supported commands in the controller capabilities
register. Use that value if .get_hba_mac =3D=3D NULL.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 26 ++++++++++++++++++++------
 drivers/ufs/core/ufshcd-priv.h |  1 +
 drivers/ufs/core/ufshcd.c      |  3 ++-
 include/ufs/ufshcd.h           |  4 +++-
 include/ufs/ufshci.h           |  1 +
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index ef98c9797d07..70951829192f 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -138,18 +138,26 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
  *
  * MAC - Max. Active Command of the Host Controller (HC)
  * HC wouldn't send more than this commands to the device.
- * It is mandatory to implement get_hba_mac() to enable MCQ mode.
  * Calculates and adjusts the queue depth based on the depth
  * supported by the HC and ufs device.
  */
 int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
 {
-	int mac =3D -EOPNOTSUPP;
+	int mac;
=20
-	if (!hba->vops || !hba->vops->get_hba_mac)
-		goto err;
-
-	mac =3D hba->vops->get_hba_mac(hba);
+	if (!hba->vops || !hba->vops->get_hba_mac) {
+		/*
+		 * Extract the maximum number of active transfer tasks value
+		 * from the host controller capabilities register. This value is
+		 * 0-based.
+		 */
+		hba->capabilities =3D
+			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
+		mac =3D hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_MCQ;
+		mac++;
+	} else {
+		mac =3D hba->vops->get_hba_mac(hba);
+	}
 	if (mac < 0)
 		goto err;
=20
@@ -424,6 +432,12 @@ void ufshcd_mcq_enable(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_enable);
=20
+void ufshcd_mcq_disable(struct ufs_hba *hba)
+{
+	ufshcd_rmwl(hba, MCQ_MODE_SELECT, 0, REG_UFS_MEM_CFG);
+	hba->mcq_enabled =3D false;
+}
+
 void ufshcd_mcq_config_esi(struct ufs_hba *hba, struct msi_msg *msg)
 {
 	ufshcd_writel(hba, msg->address_lo, REG_UFS_ESILBA);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 88ce93748305..ce36154ce963 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -64,6 +64,7 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u3=
2 ahit);
 void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			  struct cq_entry *cqe);
 int ufshcd_mcq_init(struct ufs_hba *hba);
+void ufshcd_mcq_disable(struct ufs_hba *hba);
 int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4c2b60dec43f..1ba5668b0700 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8754,12 +8754,13 @@ static int ufshcd_device_init(struct ufs_hba *hba=
, bool init_dev_params)
 		if (ret)
 			return ret;
 		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
+			ufshcd_mcq_enable(hba);
 			ret =3D ufshcd_alloc_mcq(hba);
 			if (!ret) {
 				ufshcd_config_mcq(hba);
-				ufshcd_mcq_enable(hba);
 			} else {
 				/* Continue with SDB mode */
+				ufshcd_mcq_disable(hba);
 				use_mcq_mode =3D false;
 				dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
 					 ret);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 3eaa8bc7eaea..52b0b10cca50 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -325,7 +325,9 @@ struct ufs_pwr_mode_info {
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear swi=
tch
  * @mcq_config_resource: called to configure MCQ platform resources
- * @get_hba_mac: called to get vendor specific mac value, mandatory for =
mcq mode
+ * @get_hba_mac: reports maximum number of outstanding commands supporte=
d by
+ *	the controller. Should be implemented for UFSHCI 4.0 or later
+ *	controllers that are not compliant with the UFSHCI 4.0 specification.
  * @op_runtime_config: called to config Operation and runtime regs Point=
ers
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 8d0cc73537c6..38fe97971a65 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -68,6 +68,7 @@ enum {
 /* Controller capability masks */
 enum {
 	MASK_TRANSFER_REQUESTS_SLOTS_SDB	=3D 0x0000001F,
+	MASK_TRANSFER_REQUESTS_SLOTS_MCQ	=3D 0x000000FF,
 	MASK_NUMBER_OUTSTANDING_RTT		=3D 0x0000FF00,
 	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	=3D 0x00070000,
 	MASK_EHSLUTRD_SUPPORTED			=3D 0x00400000,
