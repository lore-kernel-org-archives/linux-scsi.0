Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1295305074
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472115; cv=none; b=k2jsIfOy9S551JBoHDUzNzifIGSV/x5FesrwtHIfbecgj3f7AtmLZiD5I/LtmkD6klEt10sOvVTJ+iy6lVBvUuDqerQGipCk7PMamHG0RlnmBn1cH5s793+I2xsO8QSjuH3XkJHVYGqVeGxKRZABoGatQ14fFfBvzmd9B/G/cGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472115; c=relaxed/simple;
	bh=oYRm4DKb1uFZXtCf8GDTmchd9HaeMXDf6MRyszWOY1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pppJwGo6ckUUB261YTz0MggsMHnq90d5ZjcriSpiIvzXfLs8r5a+sc158zKTQiIVCG9Bt+Dfv/jt1mU6wHL8x+Oq52aKKN+zUmPmpGh8Gya7/WkwP71z0w/meJuOUQS2RZ0uGah1yQkxekltctEdFC2aOwjcj8YvSTjmqUTts0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Cr5PhFX9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Cr5PhFX9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQ8x0Slkzlgqyf;
	Tue, 14 Oct 2025 20:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472111; x=1763064112; bh=3n7YT
	Vxf1ltzFeL6OKWV29CEHYTzQlWtFLlZa7AMiDg=; b=Cr5PhFX9blp0TilM+4rHt
	1h1dbWIp5yPrE9lZKrOr8X8R+J7rtMtBH/ID0or7bZYcFEoTspIgDOJ1QnN/qE90
	xz3h8ZekVWTcMW12gEJciehF3W5klmDhIqQyOSmc85lAzymnwDpNnsXgIp3KWGN7
	d1zKmVB7FQYhK6JLoiDcvQc7C3wx8hWCgAWQG4lFeD4Zh+53rWJZjSicHfeAMbCa
	haAYMSv+dLGS1qT9H8ff1bG26NRmzhHIdZlF7ry+Cr45je99XNnEldhq58xLzW8j
	/ZxZrc+6Ow6tFGLpymInWRnZJwKBNSo0xeIBzlULI+t1te8KdsWd4jmoIutp5RhF
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AV-PlNUZxKsD; Tue, 14 Oct 2025 20:01:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQ8g6y0BzlgqVm;
	Tue, 14 Oct 2025 20:01:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Daniel Lee <chullee@google.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid" attribute group
Date: Tue, 14 Oct 2025 13:00:53 -0700
Message-ID: <20251014200118.3390839-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014200118.3390839-1-bvanassche@acm.org>
References: <20251014200118.3390839-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

ufs_sysfs_add_nodes() is called concurrently with ufs_get_device_desc().
This may cause the following code to be called before
ufs_sysfs_add_nodes():

	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);

If this happens, ufs_sysfs_add_nodes() triggers a kernel warning and
fails. Fix this by calling ufs_sysfs_add_nodes() before SCSI LUNs are
scanned since the sysfs_update_group() call happens from the context of
thread that executes ufshcd_async_scan(). This patch fixes the following
kernel warning:

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
Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8339fec975b9..26c2aafd7338 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10885,8 +10885,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
-	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
+	async_schedule(ufshcd_async_scan, hba);
=20
 	device_enable_async_suspend(dev);
 	ufshcd_pm_qos_init(hba);
