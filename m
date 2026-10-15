Received: from out28-147.mail.aliyun.com (out28-147.mail.aliyun.com [115.124.28.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4D2175A88;
	Thu, 15 Oct 2026 02:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030068; cv=none; b=F/cq3i49i66FXje2XZUn3HFaQeIn0stHN3RY+EV3GP2Ld+58clNpHl5siuLC4qJMHX6bcwoH60GkuU6t6u5cUieyCJlLgtPMY1BpEMK5ekP7SpXdR6ttsZkUVyuV1X8CBPDjcocG02tAoyJcHFsCUYe0qk0nLeCcF8nuYp66btQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030068; c=relaxed/simple;
	bh=LIVps6C22OKqOgpQj/k1pIVCMDz1WGGq/njlckKoXvg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=rd2xFybHnwQkTHpIQofOymI4iNDJhMgp4ylLBa8Zk0CJAyp+E3PoSoL/IHVw45QCEtx/QFqbdxeISErVkpJMRGE2aw6cGn3tRGIr806MXCpX6Py+PmR/G/VNpKkPH/UPw0gES3aZT1KcoGwexGiaTuEH+vVYX00CDYxWrl6UulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=kTq68Ebe; arc=none smtp.client-ip=115.124.28.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="kTq68Ebe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1792030058; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To;
	bh=43dyrKZZYu1jx/wFsWKDpNclAyAipHCd9IxRp1UurD8=;
	b=kTq68EbeqDFdlYhTvbbOMOsuRZsTNxXtrOLRs3ZGZEgT8aNLtKSLXctv6pXsKaCIKKn5D1SWDH+zI/aPYegmGm8nZeHCu6VPRwxMWuo2pvbDh9QwqSzhxtbF/5akPKxg8NZNFkG0N621ogiVhpPiwEQL2wO3bX4Oc44YGcsifuU=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1108121|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00632761-0.0027573-0.990915;FP=12604082306750682867|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037025160;MF=liuwb@xiaopeng.com;NM=1;PH=DS;RN=12;RT=12;SR=0;TI=SMTPD_---.jdtwXG0_1792030056;
Received: from 127.0.0.1(mailfrom:liuwb@xiaopeng.com fp:SMTPD_---.jdtwXG0_1792030056 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 10:07:37 +0800
From: Weibin Liu <liuwb@xiaopeng.com>
Date: Thu, 15 Oct 2026 10:07:37 +0800
Subject: [PATCH] scsi: mpt3sas: validate data_out size before SMP
 link-reset check
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-mpt3sas-dataout-sz-v1-1-0781d24bb7ad@xiaopeng.com>
X-B4-Tracking: v=1; b=H4sIAGg10GoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0NT3dyCEuPixGLdlMSSxPzSEt3iKt1Ei0SDJGMz8+QUkzQloMaCotS
 0zAqwodGxtbUADW5tZmQAAAA=
X-Change-ID: 20261015-mpt3sas-dataout-sz-a8a0b367cd4f
To: linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com, 
 sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com, 
 sathya.prakash@broadcom.com
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, 
 MPT-FusionLinux.pdl@broadcom.com, mkp@kernel.org, stable@vger.kernel.org, 
 Weibin Liu <liuwb@xiaopeng.com>, Guanglei Zhu <zhugl3@xiaopeng.com>
X-Mailer: b4 0.14.3

_ctl_do_mpt_command() handles MPI2_FUNCTION_SMP_PASSTHROUGH by reading
data[1] and data[10] of the data_out buffer to detect SMP link-reset
requests. The non-IMMEDIATE path sets data = data_out without checking
data_out_sz, so a request whose data_out payload is smaller than 11
bytes reads past the end of the DMA coherent buffer, and out-of-bounds
bytes can silently set ioc_link_reset_in_progress and ignore_loginfos.

Require data_out_sz >= 11 bytes alongside !data_out before touching
the payload. The IMMEDIATE path reads within the request frame itself
and needs no guard.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Cc: stable@vger.kernel.org # 3.8+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..ae9b2be51ce0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -968,7 +968,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		    MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE)
 			data = (u8 *)&smp_request->SGL;
 		else {
-			if (unlikely(data_out == NULL)) {
+			if (unlikely(!data_out || data_out_sz < 11)) {
 				pr_err("failure at %s:%d/%s()!\n",
 				    __FILE__, __LINE__, __func__);
 				mpt3sas_base_free_smid(ioc, smid);

---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261015-mpt3sas-dataout-sz-a8a0b367cd4f

Best regards,
-- 
Weibin Liu <liuwb@xiaopeng.com>

