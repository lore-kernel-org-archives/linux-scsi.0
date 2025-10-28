Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB712E0901
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761690311; cv=none; b=aTejhsa0ZDp+g5VbTjILiXAIX4vVkKdBqgjq55Yol+cNH3au7mDjjG5E2h6PIn9wrsnSJnBzdz7jAn/CR0Qk/egKbqSzZmCfxfCtgdbp+mCBM1sKvEDa6OvV2tJN2WdsEl2od5w6xdSHmd3DWllaX7DvV9VW9nNGvqCPWdWunSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761690311; c=relaxed/simple;
	bh=E2/uhuHZtUQSLu1FcY/vAyHM1gxIoa8DcqxBLeHTH04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tBQ0jRytKKROzys3Atsi5EFxqkGK2OtymlrILBfZMM4dxFDqxvJAfEFaPqAW6owmHsAlcNwyOEEf04TDTYmsbWEPOBQupj1oLUHX+Tc/6g/XdyRUdEzbkFAbfJYlNY7aIH7iLYsS9aTSz1m/BRtUsL75uTHa+AJAIuJqJ3tkwJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mp2r8OMF; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mp2r8OMF"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cx4gf3sV6zm0yTr;
	Tue, 28 Oct 2025 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1761690299; x=1764282300; bh=ZDqNy0Gsqyb27mGJwPi40r78zuUrMxIJoDx
	XIxPbpkM=; b=Mp2r8OMF5JYtev+NbV9DIhfXmPY8aq/6EdIsIZRuFntGWgef+h8
	8AncnRAZyWsW178SH+JOtzedAFgeJ8lDbaA4LVmDSIybEDwR26okWDwkDFeuuUTF
	jrKhODgvst+eVkJD/eEYZMBYlC2oCFFUYqItn+FyDMhEAzriGImeoaI6oSf+EIwJ
	pIge83J9zjIDj88ajCQ/75kyT8aFxTndKQxP0vADCDd82PK5u7ltUqkK8oun+6QT
	7i4/vniFcyy2oyHURk3UpUxIlgs9/yPnJJkaLbOv8Zn7F8qwCkoH4qfgPX/W9xew
	t4W3JTIjD6JGycf18dks3vnhvoTetBYOl8g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DxX4a3d5L8qJ; Tue, 28 Oct 2025 22:24:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cx4gK3zmczm0yT2;
	Tue, 28 Oct 2025 22:24:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Daniel Lee <chullee@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Huan Tang <tanghuan@vivo.com>,
	Avri Altman <avri.altman@wdc.com>,
	Liu Song <liu.song13@zte.com.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Bean Huo <huobean@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH] ufs: core: Revert "Make HID attributes visible"
Date: Tue, 28 Oct 2025 15:24:24 -0700
Message-ID: <20251028222433.1108299-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Patch "Make HID attributes visible" is needed for older kernel versions
(e.g. 6.12) where ufs_get_device_desc() is called from ufshcd_probe_hba()=
.
In these older kernel versions ufshcd_get_device_desc() may be called
after the sysfs attributes have been added. In the upstream kernel howeve=
r
ufshcd_get_device_desc() is called before ufs_sysfs_add_nodes(). See also
the ufshcd_device_params_init() call from ufshcd_init(). Hence, calling
sysfs_update_group() is not necessary.

See also commit 69f5eb78d4b0 ("scsi: ufs: core: Move the
ufshcd_device_init(hba, true) call") in kernel v6.13.

This patch fixes the following kernel warning:

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
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
---
 drivers/ufs/core/ufs-sysfs.c | 2 +-
 drivers/ufs/core/ufs-sysfs.h | 1 -
 drivers/ufs/core/ufshcd.c    | 2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index c040afc6668e..0086816b27cd 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobj=
ect *kobj,
 	return	hba->dev_info.hid_sup ? attr->mode : 0;
 }
=20
-const struct attribute_group ufs_sysfs_hid_group =3D {
+static const struct attribute_group ufs_sysfs_hid_group =3D {
 	.name =3D "hid",
 	.attrs =3D ufs_sysfs_hid,
 	.is_visible =3D ufs_sysfs_hid_is_visible,
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 6efb82a082fd..8d94af3b8077 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -14,6 +14,5 @@ void ufs_sysfs_remove_nodes(struct device *dev);
=20
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
-extern const struct attribute_group ufs_sysfs_hid_group;
=20
 #endif
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5d6297aa5c28..2b76f543d072 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8499,8 +8499,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
=20
-	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
-
 	model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
=20
 	err =3D ufshcd_read_string_desc(hba, model_index,
