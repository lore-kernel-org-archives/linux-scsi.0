Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96246315D4F
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761585033; cv=none; b=jPjLd1auI7a2VUyaf+jwa+Xn1JdCI9vBLcYXOrP0KZ7p1UloTUxlj//xQIApFG873cIA1/rCvgyeK/coCgmwczOvR+W0yjqGifZ1mYDATBT743oPZlyYfnMz+xgfIlj3dfOc5xH5oRdyvUzMqh4ewnHJdUYcwZe8TAAY9bbWOww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761585033; c=relaxed/simple;
	bh=WEor/yXfjIbdqJ6mam7gJtRB4MoYR2zb07EbDmNU9IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gqw/WV5rVRCWEnJqzceBQjWACneUTmcfs8f1LecsczTJAW0FUGUE4I95TOU4mTDJJ9O9CgdoK3F6FrjZNLjrfTKWaDnM+mJHATJocltqGznHj70FUmzvkEY1plVSiLhc1utp5hDpLqnyX4cp+FTsFNbHtc0yz3iL1/guoIyS0no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cnVOlfVp; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cnVOlfVp"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cwKlB3P2Xzm0yVV;
	Mon, 27 Oct 2025 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761585027; x=1764177028; bh=ZVRpw
	jq79Tz8kZZc/VZkhWWI7puTWbCTwrKvhsiSunA=; b=cnVOlfVpN1TGOXefX4frz
	1OLty24h0+lGfmtw3n2kRu6xyZhYZZVivgAHjOf3DVtSWmd0KJk2yQndmlPEaiw/
	8akczOYuyiUpjHK7NKT1VZ3sqEx7qg68oDO+i/FtC+U7PoWtl3sZrHB5BJb9/VBb
	a7LjYF0rTP0KsHwQ0pf+TMS8NV6UtZ4HygWiJuCM09RIopoQwC8TX1/RVlwQdAxY
	opMKNwY4BnUxR0B2g+43vPSFaEi6sHOnHnopAyMefjDOzEMsh7KQ6kDeoa+l5yOK
	6RsvwQBXVajL3DlorGRCjb2OoIAmqWQblGIw0oe6u2ljyMzynvO/iEZTTTvHOIQX
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4D_sasJUGykR; Mon, 27 Oct 2025 17:10:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cwKkw5Vkzzm0yTy;
	Mon, 27 Oct 2025 17:10:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Huan Tang <tanghuan@vivo.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Gwendal Grignou <gwendal@chromium.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Liu Song <liu.song13@zte.com.cn>,
	Daniel Lee <chullee@google.com>,
	Bean Huo <huobean@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/2] ufs: core: Change the ufs_sysfs_{add,remove}_nodes() argument type
Date: Mon, 27 Oct 2025 10:09:29 -0700
Message-ID: <20251027170950.2919594-2-bvanassche@acm.org>
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

Prepare for adding code that accesses a struct ufs_hba member. No
functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-sysfs.c | 7 ++++---
 drivers/ufs/core/ufs-sysfs.h | 5 +++--
 drivers/ufs/core/ufshcd.c    | 4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index c040afc6668e..7150c15287d1 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -2089,8 +2089,9 @@ const struct attribute_group ufs_sysfs_lun_attribut=
es_group =3D {
 	.attrs =3D ufs_sysfs_lun_attributes,
 };
=20
-void ufs_sysfs_add_nodes(struct device *dev)
+void ufs_sysfs_add_nodes(struct ufs_hba *hba)
 {
+	struct device *dev =3D hba->dev;
 	int ret;
=20
 	ret =3D sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
@@ -2100,7 +2101,7 @@ void ufs_sysfs_add_nodes(struct device *dev)
 			__func__, ret);
 }
=20
-void ufs_sysfs_remove_nodes(struct device *dev)
+void ufs_sysfs_remove_nodes(struct ufs_hba *hba)
 {
-	sysfs_remove_groups(&dev->kobj, ufs_sysfs_groups);
+	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
 }
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 6efb82a082fd..c9e3751c6793 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -8,9 +8,10 @@
 #include <linux/sysfs.h>
=20
 struct device;
+struct ufs_hba;
=20
-void ufs_sysfs_add_nodes(struct device *dev);
-void ufs_sysfs_remove_nodes(struct device *dev);
+void ufs_sysfs_add_nodes(struct ufs_hba *hba);
+void ufs_sysfs_remove_nodes(struct ufs_hba *hba);
=20
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5d6297aa5c28..9521aa38211c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10429,7 +10429,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 		ufshcd_rpm_get_sync(hba);
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
-	ufs_sysfs_remove_nodes(hba->dev);
+	ufs_sysfs_remove_nodes(hba);
 	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
@@ -10887,7 +10887,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
-	ufs_sysfs_add_nodes(hba->dev);
+	ufs_sysfs_add_nodes(hba);
 	async_schedule(ufshcd_async_scan, hba);
=20
 	device_enable_async_suspend(dev);
