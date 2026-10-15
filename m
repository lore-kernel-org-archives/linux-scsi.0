Received: from out28-50.mail.aliyun.com (out28-50.mail.aliyun.com [115.124.28.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6774212CDA5;
	Thu, 15 Oct 2026 02:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792029917; cv=none; b=e4H1xaVNGYLKV46JGJeAxNe0TBvNkBRnxbW27oqLwoXuycM+Cq782xjZiwtYBthJxyLXTmQ+Q8CCq/fP1dLsP1r2ZTH7UEYSXdnmUzHD9nfXvdu1B3eUJ9ar5e3qXawUZvdSYhjkPvA5z9nbLJVLWMxCPxDtaTNo+qWqloRzcnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792029917; c=relaxed/simple;
	bh=E0qFVwIZ2mJBG5gvVdsgG0qRxxVufNf7sdeFMQFt87E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nPPdrzdn114aH6dYfYxeKU+8xWLa9SCvX1O9wFRMx4Eiymx7Ek4V4+VPvXZ+Rb01UO8Vg8eWKbGWXhe4HmTE5BW4R5QTxFAiEYigTjs0jdTNSZR9ZFlw90flX617hf/h+Ut/eigqA4IbJa9aXCIxNWA7t1enD6tVkbt4/GtiDVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=UBSMS9VR; arc=none smtp.client-ip=115.124.28.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="UBSMS9VR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1792029905; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To;
	bh=ddfdEguDaX6c4FkkpforSmdvFura/FqYULAt1pPSyTo=;
	b=UBSMS9VROvECWqmfbigV3FJ8v+W7D1peo4xUTlXw2xkspU+YXStP1Nku3fdMISEgq9pDxe7gTjgSyCfj8VxJWoNRma+sqY8KIvuAdsVqNNCnNfpA2ImXRJih5yjVdUDgWFPInKm6OYZaWwL7D+X0RG3WdAk5GoQHbUwCsdZDiYU=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1059943|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0161397-0.000655564-0.983205;FP=12650301549640222675|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033068016216;MF=liuwb@xiaopeng.com;NM=1;PH=DS;RN=11;RT=11;SR=0;TI=SMTPD_---.je--kJ9_1792029903;
Received: from 127.0.0.1(mailfrom:liuwb@xiaopeng.com fp:SMTPD_---.je--kJ9_1792029903 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 10:05:04 +0800
From: Weibin Liu <liuwb@xiaopeng.com>
Date: Thu, 15 Oct 2026 10:05:03 +0800
Subject: [PATCH] scsi: mpt3sas: fix OOB SGE write at the request frame
 boundary
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-mpt3sas-sge-offset-v1-1-9b91c265f2c1@xiaopeng.com>
X-B4-Tracking: v=1; b=H4sIAM800GoC/x2MQQqAIBAAvyJ7Tkgtqb4SHaTW2kMprkQQ/j3pO
 AwzLzAmQoZJvJDwJqZwVVCNgPVw146StsqgW21Vq3p5xmzYseSqgveMWZqh03ZbR6OchRrGhJ6
 efzovpXwX9K5xZAAAAA==
X-Change-ID: 20261015-mpt3sas-sge-offset-38426dc931a6
To: suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com, 
 linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com, 
 ranjan.kumar@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, 
 James.Bottomley@HansenPartnership.com, mkp@kernel.org, 
 stable@vger.kernel.org, Weibin Liu <liuwb@xiaopeng.com>
X-Mailer: b4 0.14.3

_ctl_do_mpt_command() bounds the user-supplied data_sge_offset with
strict inequalities:

	if (karg.data_sge_offset * 4 > ioc->request_sz ||
	    karg.data_sge_offset > (UINT_MAX / 4)) {
		ret = -EINVAL;
		goto out;
	}

When data_sge_offset * 4 is exactly ioc->request_sz, both comparisons
pass. The SGE array pointer is then derived as

	psge = (void *)request + (karg.data_sge_offset * 4);

which points just past the end of the request frame. The per-function
SGE builders then write entries at psge; _base_build_sg(), for one,
emits a zero-length SGE there when data_out_sz and data_in_sz are both
zero. The write lands outside the request frame and corrupts adjacent
memory in the request DMA pool.

Use >= for the frame size comparison so that an offset placing the
start of the SGE array at or beyond the end of the request frame is
rejected with -EINVAL.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Cc: stable@vger.kernel.org
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..d8d3ee11ed52 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -739,7 +739,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	}
 
 	/* Check for overflow and wraparound */
-	if (karg.data_sge_offset * 4 > ioc->request_sz ||
+	if (karg.data_sge_offset * 4 >= ioc->request_sz ||
 	    karg.data_sge_offset > (UINT_MAX / 4)) {
 		ret = -EINVAL;
 		goto out;

---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261015-mpt3sas-sge-offset-38426dc931a6

Best regards,
-- 
Weibin Liu <liuwb@xiaopeng.com>

