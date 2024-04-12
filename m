Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA5814D2BD
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943756; cv=none; b=SJk3SSfGyhntzOQmGG/jwPnGZ0ouQG5uShyxc4QwH4A8Nrg06pA+LPDnsTUy6KWCkbWQxPLYO1ERC4nNj/tABl0kqRPw3pcBgsYhK+15ypfcC9hTXdrHHzbwaM1Pr08H0IDkmg8pQU7z1fDhAfgccs4Vf3QDoWzy9d9m6W5sT0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943756; c=relaxed/simple;
	bh=9kRWAWxKAtv7YJoqh08g6l7gnxzqzCfkHiPaplr+0SM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SNP4EMuxeIIAfoc2MmmH06mB5gkaV8nOQXtjJ6YT/iCFO7ODEasx6gnZ1D2UWwMz7m4TTF7If4090iPa2H7IYFPqozLqcqeTqk3LrOR/v856xlzeV9hRLJLhVs5iU6H7/sJBtYZqrS9hE33tvChoUVAe9MtrQBuJJLjMEWeJraw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V+eAHS2x; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V+eAHS2x"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VGP606LJHz6Cnk8m;
	Fri, 12 Apr 2024 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1712943731; x=1715535732; bh=mSg47p8ZSxYz4vzj5reXY/6U4CjMy7ldN2g
	cywLXWZE=; b=V+eAHS2x4gBieTHNakzU3PF4LfCuXG0QWBKzGrXQKgurmpPnNDA
	+fq5ROymKLfQd5pvus5xnFtUH5OX2hxqGP/8k/lba+JGAwnfa1BQS5PzJ8Qp3IK8
	jpQSx5Fh/IUL6vBEwsnbk1MaEeti3pRLVgR99V6burZz3nPoviya4UOX7HxQDzoq
	eYA0YHRXv83dOEOUXLGfqe3F6tKkaglGGRNexqpB6MLEY5UUgAq6Kn8ydAr5rs9w
	xZrxDglBnFuzU+27oLf7Cg08wzYPASyUih1LvHwSrqPOQozn5suQiqQW/pOm3V33
	BccLoUtK89flLITok+KtUFIjLkEy2DLhMdw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4Yc_2a9d5pLh; Fri, 12 Apr 2024 17:42:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VGP5V58Pgz6Cnk8t;
	Fri, 12 Apr 2024 17:42:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Keoseong Park <keosung.park@samsung.com>,
	zhanghui <zhanghui31@xiaomi.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Remove .get_hba_mac()
Date: Fri, 12 Apr 2024 10:41:29 -0700
Message-ID: <20240412174158.3050361-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Simplify the UFSHCI core and also the UFSHCI host drivers by removing
the .get_hba_mac() callback and by reading the NUTRS register field
instead.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c      | 14 +++++---------
 drivers/ufs/core/ufshcd-priv.h  |  8 --------
 drivers/ufs/host/ufs-mediatek.c | 13 -------------
 drivers/ufs/host/ufs-qcom.c     |  7 -------
 drivers/ufs/host/ufs-qcom.h     |  1 -
 include/ufs/ufshcd.h            |  2 --
 include/ufs/ufshci.h            |  2 +-
 7 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 768bf87cd80d..228975caf68e 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -125,20 +125,16 @@ struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct u=
fs_hba *hba,
  *
  * MAC - Max. Active Command of the Host Controller (HC)
  * HC wouldn't send more than this commands to the device.
- * It is mandatory to implement get_hba_mac() to enable MCQ mode.
  * Calculates and adjusts the queue depth based on the depth
  * supported by the HC and ufs device.
  */
 int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
 {
-	int mac;
+	int nutrs;
=20
-	/* Mandatory to implement get_hba_mac() */
-	mac =3D ufshcd_mcq_vops_get_hba_mac(hba);
-	if (mac < 0) {
-		dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
-		return mac;
-	}
+	WARN_ON_ONCE(!hba->mcq_enabled);
+	nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
+	WARN_ONCE(nutrs < 32, "nutrs: %d < 32\n", nutrs);
=20
 	WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
 	/*
@@ -146,7 +142,7 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba=
)
 	 * It is mandatory for UFS device to define bQueueDepth if
 	 * shared queuing architecture is enabled.
 	 */
-	return min_t(int, mac, hba->dev_info.bqueuedepth);
+	return min_t(int, nutrs, hba->dev_info.bqueuedepth);
 }
=20
 static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index f42d99ce5bf1..a1add22205db 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -255,14 +255,6 @@ static inline int ufshcd_vops_mcq_config_resource(st=
ruct ufs_hba *hba)
 	return -EOPNOTSUPP;
 }
=20
-static inline int ufshcd_mcq_vops_get_hba_mac(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->get_hba_mac)
-		return hba->vops->get_hba_mac(hba);
-
-	return -EOPNOTSUPP;
-}
-
 static inline int ufshcd_mcq_vops_op_runtime_config(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->op_runtime_config)
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
index c4f997196c57..0a52917e7fe6 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -34,7 +34,6 @@ static int  ufs_mtk_config_mcq(struct ufs_hba *hba, boo=
l irq);
 #include "ufs-mediatek-trace.h"
 #undef CREATE_TRACE_POINTS
=20
-#define MAX_SUPP_MAC 64
 #define MCQ_QUEUE_OFFSET(c) ((((c) >> 16) & 0xFF) * 0x200)
=20
 static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] =3D {
@@ -1656,17 +1655,6 @@ static int ufs_mtk_clk_scale_notify(struct ufs_hba=
 *hba, bool scale_up,
 	return 0;
 }
=20
-static int ufs_mtk_get_hba_mac(struct ufs_hba *hba)
-{
-	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
-
-	/* MCQ operation not permitted */
-	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
-		return -EPERM;
-
-	return MAX_SUPP_MAC;
-}
-
 static int ufs_mtk_op_runtime_config(struct ufs_hba *hba)
 {
 	struct ufshcd_mcq_opr_info_t *opr;
@@ -1801,7 +1789,6 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk=
_vops =3D {
 	.config_scaling_param =3D ufs_mtk_config_scaling_param,
 	.clk_scale_notify    =3D ufs_mtk_clk_scale_notify,
 	/* mcq vops */
-	.get_hba_mac         =3D ufs_mtk_get_hba_mac,
 	.op_runtime_config   =3D ufs_mtk_op_runtime_config,
 	.mcq_config_resource =3D ufs_mtk_mcq_config_resource,
 	.config_esi          =3D ufs_mtk_config_esi,
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 0b02e697ea5b..100f5f0b9da6 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1673,12 +1673,6 @@ static int ufs_qcom_op_runtime_config(struct ufs_h=
ba *hba)
 	return 0;
 }
=20
-static int ufs_qcom_get_hba_mac(struct ufs_hba *hba)
-{
-	/* Qualcomm HC supports up to 64 */
-	return MAX_SUPP_MAC;
-}
-
 static int ufs_qcom_get_outstanding_cqs(struct ufs_hba *hba,
 					unsigned long *ocqs)
 {
@@ -1798,7 +1792,6 @@ static const struct ufs_hba_variant_ops ufs_hba_qco=
m_vops =3D {
 	.program_key		=3D ufs_qcom_ice_program_key,
 	.reinit_notify		=3D ufs_qcom_reinit_notify,
 	.mcq_config_resource	=3D ufs_qcom_mcq_config_resource,
-	.get_hba_mac		=3D ufs_qcom_get_hba_mac,
 	.op_runtime_config	=3D ufs_qcom_op_runtime_config,
 	.get_outstanding_cqs	=3D ufs_qcom_get_outstanding_cqs,
 	.config_esi		=3D ufs_qcom_config_esi,
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index b9de170983c9..7951421b9921 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -14,7 +14,6 @@
 #define TX_FSM_HIBERN8          0x1
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
-#define MAX_SUPP_MAC		64
 #define MAX_ESI_VEC		32
=20
 #define UFS_HW_VER_MAJOR_MASK	GENMASK(31, 28)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bad88bd91995..3f50621b8564 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -324,7 +324,6 @@ struct ufs_pwr_mode_info {
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear swi=
tch
  * @mcq_config_resource: called to configure MCQ platform resources
- * @get_hba_mac: called to get vendor specific mac value, mandatory for =
mcq mode
  * @op_runtime_config: called to config Operation and runtime regs Point=
ers
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
@@ -369,7 +368,6 @@ struct ufs_hba_variant_ops {
 				enum ufs_event_type evt, void *data);
 	void	(*reinit_notify)(struct ufs_hba *);
 	int	(*mcq_config_resource)(struct ufs_hba *hba);
-	int	(*get_hba_mac)(struct ufs_hba *hba);
 	int	(*op_runtime_config)(struct ufs_hba *hba);
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 385e1c6b8d60..6c28177113e1 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -67,7 +67,7 @@ enum {
=20
 /* Controller capability masks */
 enum {
-	MASK_TRANSFER_REQUESTS_SLOTS		=3D 0x0000001F,
+	MASK_TRANSFER_REQUESTS_SLOTS		=3D 0x000000FF,
 	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	=3D 0x00070000,
 	MASK_EHSLUTRD_SUPPORTED			=3D 0x00400000,
 	MASK_AUTO_HIBERN8_SUPPORT		=3D 0x00800000,
