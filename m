Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC614A4F3
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2024 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303288; cv=none; b=r0BzuVOJPL3bolPVaAHSWLKqFJ18y6vlV6mswS9eC1RRpsYPU80EiSL1rX+W0YKKEKGBQGfHpFHVs39/YTKuo0yQwvRFPwJ5mON0HG9Mhl+Xy8SZ0QNULEHQEK59YX2g4+seSN5UlmQzNXy9oVzLh2I7SQD+m/UaOG/RjQOonQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303288; c=relaxed/simple;
	bh=4Pm7lRVeDxAxTTAE1RjwSM52yXCD4XEqdMVtN4NZ2wc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lwA1+lmybO/nRBpIAR00lP23MebBgsUErI2BbCcXSAGuLJ7fSM3gxmtmuCXYtYJOqUFlIIeJdnA2OiJzUvIp4hpz5wp0hieiK6IVfiq2mvoUAh0/YzCon+k4LgoyRrOCgGiOzFXyFdzb4FrVW6dN3LIN22eCYWBMbV1gw1j+skk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FmqyRc3j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FmqyRc3j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718303285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Pt7JMdv2zQuXXKN4eq/m/SVF3iNPHye0V9QpcQS+Yf0=;
	b=FmqyRc3jAhwPyOocU2ME+lTz/iriV3Rx4j0k+uRO1smD+p0csy54cW2mYA2ga0V0cn+K/l
	BHjahUz7cvnQacRdU8IpZ5bM9XF20KlN/QWdefFeU0rRd1GvxLkGBAlwqK4nVB7U5Glm3a
	rsfhn3VjAu19ZXyBYR0Qhhvy1c/jYfw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-a9ivuM1jPDeAsFZDy-CvfQ-1; Thu,
 13 Jun 2024 14:28:04 -0400
X-MC-Unique: a9ivuM1jPDeAsFZDy-CvfQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D69A1956095;
	Thu, 13 Jun 2024 18:28:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.16.90])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A192B1956058;
	Thu, 13 Jun 2024 18:27:58 +0000 (UTC)
From: Joel Slebodnick <jslebodn@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	ahalaney@redhat.com,
	beanhuo@micron.com,
	Joel Slebodnick <jslebodn@redhat.com>
Subject: [PATCH] scsi: ufs: core: Free memory allocated for model before reinit
Date: Thu, 13 Jun 2024 14:27:28 -0400
Message-Id: <20240613182728.2521951-1-jslebodn@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Under the conditions that a device is to be reinitialized within
ufshcd_probe_hba, the device must first be fully reset.

Resetting the device should include freeing U8 model (member of
dev_info)  but does not, and this causes a memory leak.
ufs_put_device_desc is responsible for freeing model.

unreferenced object 0xffff3f63008bee60 (size 32):
  comm "kworker/u33:1", pid 60, jiffies 4294892642
  hex dump (first 32 bytes):
    54 48 47 4a 46 47 54 30 54 32 35 42 41 5a 5a 41  THGJFGT0T25BAZZA
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc ed7ff1a9):
    [<ffffb86705f1243c>] kmemleak_alloc+0x34/0x40
    [<ffffb8670511cee4>] __kmalloc_noprof+0x1e4/0x2fc
    [<ffffb86705c247fc>] ufshcd_read_string_desc+0x94/0x190
    [<ffffb86705c26854>] ufshcd_device_init+0x480/0xdf8
    [<ffffb86705c27b68>] ufshcd_probe_hba+0x3c/0x404
    [<ffffb86705c29264>] ufshcd_async_scan+0x40/0x370
    [<ffffb86704f43e9c>] async_run_entry_fn+0x34/0xe0
    [<ffffb86704f34638>] process_one_work+0x154/0x298
    [<ffffb86704f34a74>] worker_thread+0x2f8/0x408
    [<ffffb86704f3cfa4>] kthread+0x114/0x118
    [<ffffb86704e955a0>] ret_from_fork+0x10/0x20

Signed-off-by: Joel Slebodnick <jslebodn@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0cf07194bbe8..a0407b9213ca 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8787,6 +8787,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
 		/* Reset the device and controller before doing reinit */
 		ufshcd_device_reset(hba);
+		ufs_put_device_desc(hba);
 		ufshcd_hba_stop(hba);
 		ufshcd_vops_reinit_notify(hba);
 		ret = ufshcd_hba_enable(hba);
-- 
2.40.1

