Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E7D1EB222
	for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2024 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725646077; cv=none; b=RraYLoeVNQMzFgBZcnvLNDyJpphFEX7TWp5gBsyfOXFFKag7+jzmwlvoT3mM1itrz5+EHtVkY3sctrCUVMJLKp5KN0EHzYloiPScC1HFtl2dRpIGX0e8TxJViuLBLtN5UZum6KGJXXXLfn9RFeZhoACCVX8lJVGPS8cKuvPfmyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725646077; c=relaxed/simple;
	bh=XmKi3om+QIlz1n1d0BE5fPvlcfOFLvqiCAL3MzSWSf8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Rdty6DcaFaTGliAtgBGgWS5egIGwXSK7WEXnTtfsBSEPDCFnctxBNRJBmr+3sIkNXeSGHKOAvaHg0sAA0gwoRus4m9P4TjlbXSFCCKvNDscSphAL9tZPlXAhq4tb9VTohrBaBRyuHFvBcX0rO0LNSiHioy4uGyqRg/nLzEqtB7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=F9I4hcTN; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="F9I4hcTN"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42bbe809b06so17571345e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Sep 2024 11:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1725646071; x=1726250871; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJzQD2LEed34myQpxxJLF222iqCvf6GrK4TLRL1oSug=;
        b=F9I4hcTNabVb3vrwYAcdwVK3UXQUpuTw2eEBWRShyX4bWrIVM+qX2bYdBqKBCVCuL6
         W2s5+MgMzcPFDuIaEK46bvqMcZXk4WEknEipmSZ2es63dnH70nQu1Lwqo+nIq5TljH0g
         Jeicr4efqo55PFGvX5q9wN7eN7TVhiR8pSgWW7CwEgoT0go45Qe6l6lekcnwwhSef/qX
         5nwqrjrHxW989nxYdad6eg3vSEaHn7sixQMx3qe6qkey7sAGcfMPEWVo9UB5qieeJa48
         5SsQ67KvTHbTrdMunansNYYtnscalRH1/iOXeKdSCGV93DcDvcICFFcAdPOyteQ5FxlW
         gEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725646071; x=1726250871;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJzQD2LEed34myQpxxJLF222iqCvf6GrK4TLRL1oSug=;
        b=Uetnlq28MztJV9U6RnqJI6p7BgjOkRZOsKP7mjWhcIQ58CX8wkXvJaBGEJ9Wf8AcLH
         pfs8sWbnJ8N/T6vkiq3o/9ayyrLflSBg83E/Bdi9k7XUWhHGTn+aR4vf/4qxtWNIVPzQ
         xmndv5rfVVEwMl5pzGpoW/5lZgFZodEiT0pG/CiwgCGHpBMdBDkemruG9vTyQujV0pRn
         LIugazygjYjzhpmUQfuPctqOGjNYw5wI3KHh3JtIKM++MpcoU65ZK2fP5p+U5pikND6b
         QSwI0qEaFh3ykis6N7xNkClSUrMbDCjrV2D6JM/fznteV8YfIKuaShI8nhrNAYuT+J3D
         MbqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaZlFBcnEdcalJPVwvQfXReHtMUmFYqxIboBwXIq+GThGGlphkE/DQJ+79UgqlhiV4XUyj5txvUf3/@vger.kernel.org
X-Gm-Message-State: AOJu0YzWnO8T0WO8L45DKg6TWHoCXKUGop71jRbcsSSewzcFXKbbBSCW
	Aa4dDbDYjgh6bOqH/ot8FFhprqKhNbGVT9l8kaZL2qsrbjFCcQfxO9iOKGvfczA=
X-Google-Smtp-Source: AGHT+IEyoMWYkwPX8KGRJ2s0GL9eSAS2Y+HjmZlVPBL9Brpu8bEP2tLNAZiNmlP+UkXcD//ENdL1dA==
X-Received: by 2002:a05:600c:1c16:b0:42b:afe3:e9f4 with SMTP id 5b1f17b1804b1-42cad746525mr709545e9.3.1725646071221;
        Fri, 06 Sep 2024 11:07:51 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:b9fc:a1e7:588c:1e37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42cac8543dbsm5880485e9.42.2024.09.06.11.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 11:07:50 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 06 Sep 2024 20:07:19 +0200
Subject: [PATCH v6 16/17] ufs: host: add a callback for deriving software
 secrets and use it
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240906-wrapped-keys-v6-16-d59e61bc0cb4@linaro.org>
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
In-Reply-To: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Asutosh Das <quic_asutoshd@quicinc.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2513;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=idjNjWapj1bs0Ldu/9tHu9tyNyBC4AsG5ouabbctqz0=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBm20Ta2lebndwd66b+zzmajpsSSPL4dPKl7vpCQ
 fPPf1aj/RCJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZttE2gAKCRARpy6gFHHX
 csEyD/9SVw5arcoptqwXkk4O3NKDnxuWvg9guPiq9pNQnUpUKOXHvzWg+kef98Vi3nGnKHIVql1
 PySghu5/7BFDuGZxc6AaLEAZLyR4VXn9vIu/oodP9NThamajDDM3dcPKDGU18XrpVVNgdIBWpwJ
 95E/G/00SezC3y7PtKO+JLO2RIAgvH7abFtQfIBVftiniLr30GhPbIjUCSi+7VFVCZaGQAdCJM3
 4xsVf3WkMATBgMjSCYaSrB4rYNGbgbqbsy2XXmRehFumf4w1/DQGKAnuhNO9uODJen+ld3fLqjQ
 X7Bl5i1ojWc2/HgpPzwVroJJd0A8dUaInmUmVR26m0eLTILn73BPZJ3LE+4sn0YHascCQqHnyiG
 cqmjPHEFn54JnVnDfCBMS5liIRe8MFwkXbIciqoOiWAQsPtphpyXcrP1+qaQzkjnDq8aHyEtuiK
 MFRKNKF/MJytb1mGQW/vjKoAzuKvbyaHwzD/K2XUGuGJPRraYhKfb1hXyVJhb91Y3ueHPHTehy5
 3hyFQlzT/uwITQ0skkksVB+/6ftCzZ4nsHglM8Agvrinhvv+8gTqBnjuZbGAFDBGK5UFyIlyoNZ
 2SwUodqRrJXeW4BrTRIXAXM1xLD8mnHqr+P9TGVMfVazPwaEX5p46juHIT8HUpT35xlvH/RBvWB
 MAQ3AzPLJftzBdg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Add a new UFS core callback for deriving software secrets from hardware
wrapped keys and implement it in QCom UFS.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 15 +++++++++++++++
 include/ufs/ufshcd.h        |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 366fd62a951f..77fb5e66e4be 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -182,9 +182,23 @@ static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 		return qcom_ice_evict_key(host->ice, slot);
 }
 
+/*
+ * Derive a software secret from a hardware wrapped key. The key is unwrapped in
+ * hardware from trustzone and a software key/secret is then derived from it.
+ */
+static int ufs_qcom_ice_derive_sw_secret(struct ufs_hba *hba, const u8 wkey[],
+					 unsigned int wkey_size,
+					 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_derive_sw_secret(host->ice, wkey, wkey_size, sw_secret);
+}
+
 #else
 
 #define ufs_qcom_ice_program_key NULL
+#define ufs_qcom_ice_derive_sw_secret NULL
 
 static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
@@ -1815,6 +1829,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
+	.derive_sw_secret	= ufs_qcom_ice_derive_sw_secret,
 	.reinit_notify		= ufs_qcom_reinit_notify,
 	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
 	.get_hba_mac		= ufs_qcom_get_hba_mac,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index c11dd3baf53c..b8b1763df022 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -323,6 +323,7 @@ struct ufs_pwr_mode_info {
  * @device_reset: called to issue a reset pulse on the UFS device
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
+ * @derive_sw_secret: derive sw secret from a wrapped key
  * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear switch

-- 
2.43.0

