Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953F257C8D
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2024 20:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718308959; cv=none; b=NCdIGVeLkXddSOHkwkE9fK5nXT80DDSxC+Tp7yHOex2QgpSRa8QBmtoOxfcABhfpgqkvIvbAsZdxTwO2OWj/wq414HxCim4RMJT2dRNmfFZoePWKYxFptVj9rM7bk4GDLPai097JwM0frCHdl+QRJF8YyxZbvDi11JrN5CqC/Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718308959; c=relaxed/simple;
	bh=nZHkn9CFpefrZY3eWeeEqqD5HAzw2mDE+4bndbTLj6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TpjnU3fTDe/rR1lhhsI6nmJpk8uC9K5Yr95zLmgXhcuSFAJ/zWycE5K53XAvufvQqvXOqlcNyqiuhkO+L7/eRrl/C+B1/oHcB0EgH9lYj/EobkZJE1ploje3JkdH5XD0x6aUDiW9tvfNL9pJDd+VUKwclguyAGQGX+mxybmHNs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OzgLoEv1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OzgLoEv1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718308956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVEaHilVHQqQUsCzFKQ9WozHv/uf627moCvVT7gZQEQ=;
	b=OzgLoEv15uoBSdmq+iYAXGAhPD5NlgPrC/c7eJ7SpwNKCNTi0H0xaK4hYwTkCa5rUh+JhE
	SEjdfa4ShokjWNk5DkZmI86ot8OYOxVrXx/sVG5Yb0yhAvPCne4Nm+0wPA+L1uXmTFyh29
	/iN6at9/QImlc6z9F8TWKa1KHhWBYog=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-LNr-28ksPey-89cceves8A-1; Thu,
 13 Jun 2024 16:02:33 -0400
X-MC-Unique: LNr-28ksPey-89cceves8A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1699E19560B1;
	Thu, 13 Jun 2024 20:02:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.16.90])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 87B821956050;
	Thu, 13 Jun 2024 20:02:26 +0000 (UTC)
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
	Joel Slebodnick <jslebodn@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ufs: core: Free memory allocated for model before reinit
Date: Thu, 13 Jun 2024 16:02:02 -0400
Message-Id: <20240613200202.2524194-1-jslebodn@redhat.com>
In-Reply-To: <20240613182728.2521951-1-jslebodn@redhat.com>
References: <20240613182728.2521951-1-jslebodn@redhat.com>
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

Fixes: 96a7141da332 ("scsi: ufs: core: Add support for reinitializing the UFS device")
Cc: <stable@vger.kernel.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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

