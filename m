Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30FA3793B5
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 07:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769672323; cv=none; b=R+QV6MlD6SBJAOcZo2rqTazRQUGhwbAu1Ys90wJzojDbXUsTt92s11DMoFSB/Sfq/y43iBrchVRdQ9MmV5lMwt8roKdrKnNMHwzj7UMCvj19FFFJMrSkJYVi/KRKi84/ECGX08NzijKoKZ3gE4Mzba3YlYkz7kHCJ6EjiPbjGbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769672323; c=relaxed/simple;
	bh=PmaYDRNArfyuojBEcajPNrOJP8kPqJiIHREyZgI5rkY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=LCffMOvOGPF9QRvum1ICXmHJ6R+8vW3YfbvqY0isuIswv5naakSB03iVuLu0HRgad6gQkNylMvTr+a2g96Ip5JWX7823ZAKUfHxyLc0z2nVoe/imCbafcTpPmUBwr3Ff1QSzPKnCGPbUynzGd2g6ua6WP1LDY/08eokc4PNr+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=4SQCfbk6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="4SQCfbk6"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-430f3ef2d37so534964f8f.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 23:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1769672320; x=1770277120; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TbOIHVaOGbxzrvzjWHvUZsbmdUqai/LursAc/ajXxRQ=;
        b=4SQCfbk6twnMyuQmc1eO+9aU7/NDkhZpMal3+wp4gTBVvObIDyWBgMxjpStQQcYif+
         KBVUKGdceHCEVlpshmhP/ps9CqNy6c2mjyFyAXrOdK5ai4fwlnJAH94plz+yPDyUCZrH
         KX5qfr1SeY2wVKNE7e4lAypubZ1H4V3IwscJtKSIqmAEw3lYETS/cjbTBhsCm5wktX7Z
         NKlAVfV3aKMVD8pjz+gmaO8AoBUpQDUr3ipj/5myFbUManFi2IENXpaDVi5YfYniItFa
         Zsvs7yYRh5kLJiFS7RwXVcUFMeLdnOtbiKOEf/1YYA2UWckm5q/BjQXFNblIWYCGgWdQ
         pJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769672320; x=1770277120;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbOIHVaOGbxzrvzjWHvUZsbmdUqai/LursAc/ajXxRQ=;
        b=mT/7Cx6sqNdDsmnug5+goGhT6irFF9UVf5c+CEieZDIqve5PaUglBKV0tx2CeOgIpq
         jYVfQwg3ODP5uvoM0Av95EYVH7PizqZjTJV5HMtKt1GpzkGqXQeMm+J+tUa+pFTinygF
         MdF5eVOvItzNeOB/IKZQhN4pvgv1Jr5fAXXAI/kf1Y8xFi4OAm8fkawwvvUYaS7QYsiJ
         /po98rCx3HdvEc3V7dp+21KKtWeYHDtnsGdB1XL/tOWiz/MtTUeB03mLYW6Hdc2gfQmI
         8Dy9KDNkm1vxmIzErPzGEnBRZqE6Af5Q6Hf58oRXr1RUpQZMelhIWvbPfmWXRofqXkV5
         ef0w==
X-Gm-Message-State: AOJu0YzJMwdDiwP6buj6ABK5sO+8CB06jIQZZ6BH/pgWcN3+aA8I1MnJ
	UCYEmvT176GzQzY65Qp5lqTuwUBONI1Pn0MkIWWVMbPwzl3ta8tsZRtIGrXhMixqYuY=
X-Gm-Gg: AZuq6aJzBNks6Icrozyw+Jh0NOlXKr8KujCFw7X60/KdPnMqfjFRWx8qt71vy+pD5aj
	GKGsPdkOXaIPIxTcN2fv80AvMKqd4hmSOyrVVCDMnzjT2E2l+LYC7C7LX/nkLDQA7cmQjjk0n5u
	044aTo40iYecF+88j9cB011/1N9mnJf+FVSJ0SPqiXEXM1PdFYHv07B2ecKo6UeK+wUfYPzZKdl
	HkW+oPOSbJxQva6rXJiTtFaGOGw9be6T9RlBWCVq5VkoDbSzu+ldjH6ZjBPTHCX+U/8lFgi8VIS
	gm6mNedqzZZSlY8GOiVMPGP/Ixj4YC5lKw/p+CjBAVb6xMn8mScqUrV4AZmnpq3OWO08ylXfBu+
	knBNacuCPSRbIukHpRrv8o0KHHYJaBl8lQelegIpQxZdIjFCl0b8ZWgIkpIvKqm/k4BbyPG6P16
	3BjGmu97OkDZ0/wxBxDqSmONcrHmZpa72EqCWT04PiRD4eFKTr7KKeo6fDjLEwM+tBoQ==
X-Received: by 2002:a05:6000:310f:b0:435:9ea8:8b83 with SMTP id ffacd0b85a97d-435dd074b85mr11666526f8f.19.1769672320024;
        Wed, 28 Jan 2026 23:38:40 -0800 (PST)
Received: from alchark-surface.localdomain (bba-83-110-134-52.alshamil.net.ae. [83.110.134.52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10ee040sm12418751f8f.11.2026.01.28.23.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 23:38:39 -0800 (PST)
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 29 Jan 2026 11:38:35 +0400
Subject: [PATCH] scsi: ufs: core: Fix RPMB region size detection for UFS
 2.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net>
X-B4-Tracking: v=1; b=H4sIAHoOe2kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQyNL3dK0Yt2igtwk3RRDS4tEM0vLRBODFCWg8oKi1LTMCrBR0bG1tQD
 LvFbbWgAAAA==
X-Change-ID: 20260129-ufs-rpmb-d198a699a40d
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1922; i=alchark@flipper.net;
 h=from:subject:message-id; bh=PmaYDRNArfyuojBEcajPNrOJP8kPqJiIHREyZgI5rkY=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWRW8zUEbZVzCQp6X+lUdITlx1/ZC64pZe5r9jExXvrPH
 /R68aHujoksDGJcDJZiiixzvy2xnWrEN2uXh8dXmDmsTCBDpEUaGICAhYEvNzGv1EjHSM9U21DP
 0FDHWMeIgYtTAKb62iGG/zGG3Keb73xiXBkaW7L+3tnpFs9SgrYXiU6a1vsgd29n9D6G32wp5of
 F731mSL2auMJjQfyGkrwJO2dWGd2pULxY9aZgHR8A
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Older UFS spec devices (2.2 and earlier) do not expose per-region RPMB
sizes, as only one RPMB region is supported. In such cases, the size of
the single RPMB region can be deduced from the Logical Block Count and
Logical Block Size fields in the RPMB Unit Descriptor.

Add a fallback mechanism to calculate the RPMB region size from these
fields if the device implements an older spec, so that the RPMB driver
can work with such devices - otherwise it silently skips the whole RPMB.

        Section 14.1.4.6 (RPMB Unit Descriptor)

Link: https://www.jedec.org/system/files/docs/JESD220C-2_2.pdf
Cc: stable@vger.kernel.org
Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 52ffd0c3aa4c..80be7d0a0315 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5249,6 +5249,15 @@ static void ufshcd_lu_init(struct ufs_hba *hba, struct scsi_device *sdev)
 		hba->dev_info.rpmb_region_size[1] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION1_SIZE];
 		hba->dev_info.rpmb_region_size[2] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION2_SIZE];
 		hba->dev_info.rpmb_region_size[3] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION3_SIZE];
+
+		if (hba->dev_info.wspecversion <= 0x0220) {
+			/* Only one RPMB region used, and no per-region size information */
+			hba->dev_info.rpmb_region_size[0] =
+				get_unaligned_be64(desc_buf
+					+ RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_COUNT)
+				<< desc_buf[RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_SIZE]
+				>> 17; /* convert to 128 kBytes units */
+		}
 	}
 
 

---
base-commit: 3f24e4edcd1b8981c6b448ea2680726dedd87279
change-id: 20260129-ufs-rpmb-d198a699a40d

Best regards,
-- 
Alexey Charkov <alchark@flipper.net>

