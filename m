Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3391D5143
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 21:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739396353; cv=none; b=XSrQ2K/DXnPM7FVZy1ynCcAFriJyQmpbB7nz0Vg3C+EQwA55fjxoQzBQjJgnl7uvFxUgGadHIKxVSlcIjhOJ5MhnjZ7tOmi2GnzzSf1MnJB+76ielk5vJWIdNbgDAaTPxuZrxgq7SZaoaC/d4/B029WFH8WmOlX8yRATzCUio90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739396353; c=relaxed/simple;
	bh=Zo1PLJuZQiFe2VwCyJzHj8rMLILUyYwPkxIeX03YOlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mngreneCbCJFfvWDJj2jsv+YXsVj5q0AX4ZpIFubpRCLItsM7aRJyRDgLvYqrmOo0mKB1Dwij9EHwi7TUczfHArDmH7Gv8a4og5cAugB0RqUU+/8wQI8LUQeF8zKk9Nb1fUfq8BBh/SShBs+nml4HoO9HiRu4pwHHJfAzq9Fsvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BXkPq34I; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BXkPq34I"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YtWsn6gS8zlgTwg;
	Wed, 12 Feb 2025 21:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1739396327; x=1741988328; bh=PQqGDT1q2Bk/ezbvIh+SkX0aOLWkMfa/fkh
	22CmiEoY=; b=BXkPq34I73VgDeLJt4r4g93uV7CSH1gehFbsBW03i9bl4DAtYdr
	7G30Uu8veY9Cfy94zK7bY4D280wl0dJoKI9ybM4cR8NhgZxBIh4ChWbx+bqOU6CZ
	qEo/s34mscNY6Kj1xjYSvzl5NGFiioVEZ9srILt7FhdCX+n3xer8i+yZPBU5PPgQ
	gTXpX7KbPL0Vjs7QMAhH/nOAOYbUP0YjsCNyqOACWPqazxqN1Ub//XbzXMb+SSDK
	Kges2sMRgARcp1Cs4fvPTkCzzOzjfl4uBt1epqUeqqwAYa0aX6q/WxoEnfvJrAhl
	n3VSFOm8iwNoXJmuFxFtmdBBjv+mhslua2A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bEmgmJFzDMXn; Wed, 12 Feb 2025 21:38:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YtWsG5jqqzlgTwc;
	Wed, 12 Feb 2025 21:38:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Orson Zhai <orsonzhai@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH] scsi: ufs: Constify the third pwr_change_notify() argument
Date: Wed, 12 Feb 2025 13:38:02 -0800
Message-ID: <20250212213838.1044917-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The third pwr_change_notify() argument is an input parameter. Make this
explicit by declaring it 'const'.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h  |  6 +++---
 drivers/ufs/host/ufs-exynos.c   | 10 +++++-----
 drivers/ufs/host/ufs-exynos.h   |  2 +-
 drivers/ufs/host/ufs-hisi.c     |  6 +++---
 drivers/ufs/host/ufs-mediatek.c | 10 +++++-----
 drivers/ufs/host/ufs-qcom.c     |  2 +-
 drivers/ufs/host/ufs-sprd.c     |  6 +++---
 drivers/ufs/host/ufshcd-pci.c   |  2 +-
 include/ufs/ufshcd.h            |  8 ++++----
 9 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 786f20ef2238..2cf500e74440 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -159,9 +159,9 @@ static inline int ufshcd_vops_link_startup_notify(str=
uct ufs_hba *hba,
 }
=20
 static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
-				  enum ufs_notify_change_status status,
-				  struct ufs_pa_layer_attr *dev_max_params,
-				  struct ufs_pa_layer_attr *dev_req_params)
+				enum ufs_notify_change_status status,
+				const struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
 {
 	if (hba->vops && hba->vops->pwr_change_notify)
 		return hba->vops->pwr_change_notify(hba, status,
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.=
c
index 13dd5dfc03eb..cab40d0cf1d5 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -321,7 +321,7 @@ static int exynosauto_ufs_pre_pwr_change(struct exyno=
s_ufs *ufs,
 }
=20
 static int exynosauto_ufs_post_pwr_change(struct exynos_ufs *ufs,
-					  struct ufs_pa_layer_attr *pwr)
+					  const struct ufs_pa_layer_attr *pwr)
 {
 	struct ufs_hba *hba =3D ufs->hba;
 	u32 enabled_vh;
@@ -396,7 +396,7 @@ static int exynos7_ufs_pre_pwr_change(struct exynos_u=
fs *ufs,
 }
=20
 static int exynos7_ufs_post_pwr_change(struct exynos_ufs *ufs,
-						struct ufs_pa_layer_attr *pwr)
+				       const struct ufs_pa_layer_attr *pwr)
 {
 	struct ufs_hba *hba =3D ufs->hba;
 	int lanes =3D max_t(u32, pwr->lane_rx, pwr->lane_tx);
@@ -813,7 +813,7 @@ static u32 exynos_ufs_get_hs_gear(struct ufs_hba *hba=
)
 }
=20
 static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
-				struct ufs_pa_layer_attr *dev_max_params,
+				const struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
@@ -865,7 +865,7 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hb=
a,
=20
 #define PWR_MODE_STR_LEN	64
 static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
-				struct ufs_pa_layer_attr *pwr_req)
+				const struct ufs_pa_layer_attr *pwr_req)
 {
 	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
 	struct phy *generic_phy =3D ufs->phy;
@@ -1634,7 +1634,7 @@ static int exynos_ufs_link_startup_notify(struct uf=
s_hba *hba,
=20
 static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
 				enum ufs_notify_change_status status,
-				struct ufs_pa_layer_attr *dev_max_params,
+				const struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	int ret =3D 0;
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.=
h
index 9670dc138d1e..aac517276189 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -188,7 +188,7 @@ struct exynos_ufs_drv_data {
 	int (*pre_pwr_change)(struct exynos_ufs *ufs,
 				struct ufs_pa_layer_attr *pwr);
 	int (*post_pwr_change)(struct exynos_ufs *ufs,
-				struct ufs_pa_layer_attr *pwr);
+			       const struct ufs_pa_layer_attr *pwr);
 	int (*pre_hce_enable)(struct exynos_ufs *ufs);
 	int (*post_hce_enable)(struct exynos_ufs *ufs);
 };
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 6e6569de74d8..6f2e6bf31225 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -361,9 +361,9 @@ static void ufs_hisi_pwr_change_pre_change(struct ufs=
_hba *hba)
 }
=20
 static int ufs_hisi_pwr_change_notify(struct ufs_hba *hba,
-				       enum ufs_notify_change_status status,
-				       struct ufs_pa_layer_attr *dev_max_params,
-				       struct ufs_pa_layer_attr *dev_req_params)
+				enum ufs_notify_change_status status,
+				const struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
 {
 	struct ufs_host_params host_params;
 	int ret =3D 0;
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
index 135cd78109e2..927c0bcdb9a9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1081,8 +1081,8 @@ static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba=
 *hba,
 }
=20
 static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
-				  struct ufs_pa_layer_attr *dev_max_params,
-				  struct ufs_pa_layer_attr *dev_req_params)
+				const struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
 {
 	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
 	struct ufs_host_params host_params;
@@ -1134,9 +1134,9 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *h=
ba,
 }
=20
 static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
-				     enum ufs_notify_change_status stage,
-				     struct ufs_pa_layer_attr *dev_max_params,
-				     struct ufs_pa_layer_attr *dev_req_params)
+				enum ufs_notify_change_status stage,
+				const struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
 {
 	int ret =3D 0;
=20
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index e69b792523e6..45eabccdfa31 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -807,7 +807,7 @@ static int ufs_qcom_icc_update_bw(struct ufs_qcom_hos=
t *host)
=20
 static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 				enum ufs_notify_change_status status,
-				struct ufs_pa_layer_attr *dev_max_params,
+				const struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index b1d532363f9d..65bd8fb96b99 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -160,9 +160,9 @@ static int ufs_sprd_common_init(struct ufs_hba *hba)
 }
=20
 static int sprd_ufs_pwr_change_notify(struct ufs_hba *hba,
-				      enum ufs_notify_change_status status,
-				      struct ufs_pa_layer_attr *dev_max_params,
-				      struct ufs_pa_layer_attr *dev_req_params)
+				enum ufs_notify_change_status status,
+				const struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
 {
 	struct ufs_sprd_host *host =3D ufshcd_get_variant(hba);
=20
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.=
c
index ea39c5d5b8cf..2245397a9cc2 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -157,7 +157,7 @@ static int ufs_intel_set_lanes(struct ufs_hba *hba, u=
32 lanes)
=20
 static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
 				enum ufs_notify_change_status status,
-				struct ufs_pa_layer_attr *dev_max_params,
+				const struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	int err =3D 0;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1ddc1edf31b1..b9e8cc87c026 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -353,9 +353,9 @@ struct ufs_hba_variant_ops {
 	int	(*link_startup_notify)(struct ufs_hba *,
 				       enum ufs_notify_change_status);
 	int	(*pwr_change_notify)(struct ufs_hba *,
-				enum ufs_notify_change_status status,
-				struct ufs_pa_layer_attr *desired_pwr_mode,
-				struct ufs_pa_layer_attr *final_params);
+			enum ufs_notify_change_status status,
+			const struct ufs_pa_layer_attr *desired_pwr_mode,
+			struct ufs_pa_layer_attr *final_params);
 	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
 				  bool is_scsi_cmd);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
@@ -1422,7 +1422,7 @@ static inline int ufshcd_dme_peer_get(struct ufs_hb=
a *hba,
 	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
 }
=20
-static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
+static inline bool ufshcd_is_hs_mode(const struct ufs_pa_layer_attr *pwr=
_info)
 {
 	return (pwr_info->pwr_rx =3D=3D FAST_MODE ||
 		pwr_info->pwr_rx =3D=3D FASTAUTO_MODE) &&
