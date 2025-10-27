Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D90930C626
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 17:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761585059; cv=none; b=McstRFp/62ui1PNtaB9RLRquf5ed0mSrngrMfrftLrgmSIzvmBgl2a5/xw3goL2UyUl7oE5ssPB2Z8ya356SfAooFf+rRAAk53UMgYEVIAlKa5m47LGqBmvl8SU8uvSa9SkExlYpVKtdpO8SnuHiOPFzE3S2hypiJDfFjcvicDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761585059; c=relaxed/simple;
	bh=qqjobYPV4gRulUS1O+o0IVZpD7Ke5kkc2GvpodDhM/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJm6RWA7v4ctkYgiE23bopT4gf6qtGTST/+Kh2UEhAupUnQB01HhiWfVaG2bf0vQnZY2S9+Wh+ioPA7GlZ6BwXFO5h0suWo34HYFZZkDOJFkfUJ31ga1BWEfD3cLriTNDKVe8F+3JhhwFWkcSWBHioJVXp1pGzbF1kjxt2VR9ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fJ3FHJhB; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fJ3FHJhB"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cwKlj2JTkzm0yVB;
	Mon, 27 Oct 2025 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761585053; x=1764177054; bh=SAOI1
	qEkAEbJcExWK4E/DlvLqHGMBfVtL0E+fnHxzCA=; b=fJ3FHJhBrvNjTwEC3FRMg
	/8rkmhBG3KhyQyHvjor/FRssFSdkvpm01ToZV2BixvtF8IulQ7GUZc0gPdJClUwj
	2haQfQGzjI30zDNZbjZAIp8AJlmx1yRAykyh4jjlSQpKDEMo0QAQoF2LFRVlOYMb
	CkwLougIDUbpoUFe3tj6xkqxhepRGtmN4pNg9YX9PqZNL/pARDzxBrRMHBBIcyhB
	r3SWoZmIbNV2Xi0cd/ZuAi/OaB8UDmep9Kd7cgVtHj+trU1VGI9RsM23NzORJLem
	xkVYYNLP2FMMw77kOkL1ncU7enST0CUgSVop8AqFV1hQ7w9RUISiVtQumwKVuDZ+
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q_-TTl97Ndeh; Mon, 27 Oct 2025 17:10:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cwKlL6x12zm0ySc;
	Mon, 27 Oct 2025 17:10:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Daniel Lee <chullee@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Huan Tang <tanghuan@vivo.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Gwendal Grignou <gwendal@chromium.org>,
	Liu Song <liu.song13@zte.com.cn>,
	Bean Huo <huobean@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Can Guo <quic_cang@quicinc.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 2/2] ufs: core: Really fix the code for updating the "hid" attribute group
Date: Mon, 27 Oct 2025 10:09:30 -0700
Message-ID: <20251027170950.2919594-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
In-Reply-To: <20251027170950.2919594-1-bvanassche@acm.org>
References: <20251027170950.2919594-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Recently a sysfs_update_group() call was added in ufs_get_device_desc().
ufs_get_device_desc() may be called from the error handler and the error
handler may be activated before ufs_sysfs_add_nodes() is called. This
causes creation of the "hid" directory before ufs_sysfs_add_nodes() is
called and hence causes this function to fail.

Fix this by tracking whether or not ufs_sysfs_add_nodes() has already
been called. This patch fixes the following kernel warning:

sysfs: cannot create duplicate filename '/devices/platform/3c2d0000.ufs/h=
id'
Workqueue: async async_run_entry_fn
Call trace:
 dump_backtrace+0xfc/0x17c
 show_stack+0x18/0x28
 dump_stack_lvl+0x40/0x104
 dump_stack+0x18/0x3c
 sysfs_warn_dup+0x6c/0xc8
 internal_create_group+0x1c8/0x504
 sysfs_create_groups+0x38/0x9c
 ufs_sysfs_add_nodes+0x20/0x58
 ufshcd_init+0x1114/0x134c
 ufshcd_pltfrm_init+0x728/0x7d8
 ufs_google_probe+0x30/0x84
 platform_probe+0xa0/0xe0
 really_probe+0x114/0x454
 __driver_probe_device+0xa4/0x160
 driver_probe_device+0x44/0x23c
 __device_attach_driver+0x15c/0x1f4
 bus_for_each_drv+0x10c/0x168
 __device_attach_async_helper+0x80/0xf8
 async_run_entry_fn+0x4c/0x17c
 process_one_work+0x26c/0x65c
 worker_thread+0x33c/0x498
 kthread+0x110/0x134
 ret_from_fork+0x10/0x20
ufshcd 3c2d0000.ufs: ufs_sysfs_add_nodes: sysfs groups creation failed (e=
rr =3D -17)

Cc: Daniel Lee <chullee@google.com>
Cc: Peter Wang <peter.wang@mediatek.com>
Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-sysfs.c | 7 ++++++-
 drivers/ufs/core/ufshcd.c    | 3 ++-
 include/ufs/ufshcd.h         | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 7150c15287d1..714c611b85b0 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -2095,13 +2095,18 @@ void ufs_sysfs_add_nodes(struct ufs_hba *hba)
 	int ret;
=20
 	ret =3D sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
-	if (ret)
+	if (ret) {
 		dev_err(dev,
 			"%s: sysfs groups creation failed (err =3D %d)\n",
 			__func__, ret);
+		return;
+	}
+
+	WRITE_ONCE(hba->sysfs_attrs_added, true);
 }
=20
 void ufs_sysfs_remove_nodes(struct ufs_hba *hba)
 {
+	WRITE_ONCE(hba->sysfs_attrs_added, false);
 	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
 }
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9521aa38211c..4a543a2a10a4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8499,7 +8499,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
=20
-	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
+	if (READ_ONCE(hba->sysfs_attrs_added))
+		sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
=20
 	model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..de7420ee127e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -869,6 +869,8 @@ enum ufshcd_mcq_opr {
  * @ee_ctrl_mutex: Used to serialize exception event information.
  * @is_powered: flag to check if HBA is powered
  * @shutting_down: flag to check if shutdown has been invoked
+ * @sysfs_attrs_added: Whether or not the sysfs attributes have been add=
ed to
+ *	hba->dev.
  * @host_sem: semaphore used to serialize concurrent contexts
  * @eh_wq: Workqueue that eh_work works on
  * @eh_work: Worker to handle UFS errors that require s/w attention
@@ -1021,6 +1023,7 @@ struct ufs_hba {
 	struct mutex ee_ctrl_mutex;
 	bool is_powered;
 	bool shutting_down;
+	bool sysfs_attrs_added;
 	struct semaphore host_sem;
=20
 	/* Work Queues */
