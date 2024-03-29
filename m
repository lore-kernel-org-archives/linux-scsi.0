Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BA545955
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 20:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745332; cv=none; b=ox+ugb06docYaDrqi5op8ZYrRD61Lzi3bleiCjJaVoGqza2bNd6Jo1lTDxD91SxJKHxfi+GV49xkr2fZ1UWnNX3e09sHqkAuvQ4jM3Q7doQxGim7EvrmXEoPub6K/AVP4+BV1FLYWBppozonsKVMoNh3u79ROZPBiCsSA1J4JZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745332; c=relaxed/simple;
	bh=BP7pHzMFsulC5h5RfnNlVkbRbr65ixQCUgccOfbpOGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cnWZ2+qCQH3g2KET0GeSrG8vA4lf6Ac7I1gT961agcHUYqfAph9Dvx5fLYR23oe3LE8YErNcQp06qYcRopeaj81boFvkJPHE9bO4X2xJqOXxFHIqsd0SAGczLr2RHWNQIG1Ha2KxQd58gYS55P9pji3OgyVOH6DuaxvIP88tVMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtxErGAO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtxErGAO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711745329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4OnoxFSVXPqXgZAXqDum+B43kEJjiL2qzIJ+ix8ScM=;
	b=WtxErGAOEH7wgmq4Bs2CKq8z8zaqPOylcKHcO/81ugi9lXIXNjxkO+59viV7703RLGJWII
	YjQQMRX5QFcTzANcqyKJRkHGdrD168bSUeUqJwujvFlzoPxtIFejeY9NBGb9F8V9Nwwhm0
	Dr80Pw0mloB9BmHHacWKoVm+m8DBr0A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-8ZXKI4KnOrCQ9vH_ZFiwbw-1; Fri, 29 Mar 2024 16:48:48 -0400
X-MC-Unique: 8ZXKI4KnOrCQ9vH_ZFiwbw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-69680b07160so27358196d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 13:48:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711745324; x=1712350124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c4OnoxFSVXPqXgZAXqDum+B43kEJjiL2qzIJ+ix8ScM=;
        b=FVtX9EChq2zVGn4HAE4NuoqUU53kNrJtuZkBCMIYC6928FgSwrdb3gcwXReSejh1Ll
         ahiI859cAPHHHjiaIIeTNmdVgjTjfWllu7AyjQX7qnhnV/WzvaTu41PBrEa1HjwIQDME
         BgcRMD9gy7eftIy+bGWhOKBff0463Cpyk7rrZV9I4AeuQ6fj6vMQVMR+8MhSgtoevaxa
         aRfFQH9X0IfR0Hespj+a/qCPDzdJ0w+RKalbIL7TCuVwuGEnZ6Do5lfI0//EvdKJSVPT
         PoORsgLA3PrZ11wwJS2kTch8+LVHvEk7Ei8CaLVCCgmRgRWdMQO3PrayrclcItzTm+jn
         +aCg==
X-Forwarded-Encrypted: i=1; AJvYcCUsgCf5nhtAcew3TEF2AXTraupPLtgjWqwC4u2zWF3E444KqIJ/Y0i/3rdZPAEjeyvG18LanKshFTlq/qWbqUTfuUIzZ8Dox0YrOw==
X-Gm-Message-State: AOJu0YxwxHx9Xc13KZXngGwfLocBzD1Crqw2rdjGKcUMwEOpTAFFslhK
	IWRnPkeBy5qOkwetqUySbZKLcE3cCuELOIkHHn7adEwwQWSqMXhJAIg3yzCVB/rIBrdOMLxXT1D
	7Br1j7movXZjIbINwZvg3lRKPq52Ia9NbmIPYc07gebHyU6kEEYJH96REQEc=
X-Received: by 2002:a0c:9a91:0:b0:698:f39f:841f with SMTP id y17-20020a0c9a91000000b00698f39f841fmr2060279qvd.20.1711745324156;
        Fri, 29 Mar 2024 13:48:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJf7oVmqD60ifmlE6hginnH1lrLHud0fYzJl7uMi++kQu2bupDlSX6vEV/iu1GxrCkHuddlQ==
X-Received: by 2002:a0c:9a91:0:b0:698:f39f:841f with SMTP id y17-20020a0c9a91000000b00698f39f841fmr2060248qvd.20.1711745323770;
        Fri, 29 Mar 2024 13:48:43 -0700 (PDT)
Received: from x1gen2nano.redhat.com ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id jz10-20020a0562140e6a00b00698f27c6460sm794271qvb.110.2024.03.29.13.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:48:43 -0700 (PDT)
From: Andrew Halaney <ahalaney@redhat.com>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Janek Kotas <jank@cadence.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Anjana Hari <quic_ahari@quicinc.com>
Cc: Andrew Halaney <ahalaney@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v5 01/11] scsi: ufs: qcom: Perform read back after writing
 reset bit
Date: Fri, 29 Mar 2024 15:46:43 -0500
Message-ID: <20240329-ufs-reset-ensure-effect-before-delay-v5-1-181252004586@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240329-ufs-reset-ensure-effect-before-delay-v5-0-181252004586@redhat.com>
References: <20240329-ufs-reset-ensure-effect-before-delay-v5-0-181252004586@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.13.0
Content-Transfer-Encoding: quoted-printable

Currently, the reset bit for the UFS provided reset controller (used by=0D
its phy) is written to, and then a mb() happens to try and ensure that=0D
hit the device. Immediately afterwards a usleep_range() occurs.=0D
=0D
mb() ensure that the write completes, but completion doesn't mean that=0D
it isn't stored in a buffer somewhere. The recommendation for=0D
ensuring this bit has taken effect on the device is to perform a read=0D
back to force it to make it all the way to the device. This is=0D
documented in device-io.rst and a talk by Will Deacon on this can=0D
be seen over here:=0D
=0D
    https://youtu.be/i6DayghhA8Q?si=3DMiyxB5cKJXSaoc01&t=3D1678=0D
=0D
Let's do that to ensure the bit hits the device. By doing so and=0D
guaranteeing the ordering against the immediately following=0D
usleep_range(), the mb() can safely be removed.=0D
=0D
Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc p=
latforms")=0D
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>=0D
Reviewed-by: Can Guo <quic_cang@quicinc.com>=0D
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>=0D
---=0D
 drivers/ufs/host/ufs-qcom.h | 12 ++++++------=0D
 1 file changed, 6 insertions(+), 6 deletions(-)=0D
=0D
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h=0D
index 9dd9a391ebb7..b9de170983c9 100644=0D
--- a/drivers/ufs/host/ufs-qcom.h=0D
+++ b/drivers/ufs/host/ufs-qcom.h=0D
@@ -151,10 +151,10 @@ static inline void ufs_qcom_assert_reset(struct ufs_h=
ba *hba)=0D
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, UFS_PHY_SOFT_RESET, REG_UFS_CFG1);=0D
 =0D
 	/*=0D
-	 * Make sure assertion of ufs phy reset is written to=0D
-	 * register before returning=0D
+	 * Dummy read to ensure the write takes effect before doing any sort=0D
+	 * of delay=0D
 	 */=0D
-	mb();=0D
+	ufshcd_readl(hba, REG_UFS_CFG1);=0D
 }=0D
 =0D
 static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)=0D
@@ -162,10 +162,10 @@ static inline void ufs_qcom_deassert_reset(struct ufs=
_hba *hba)=0D
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, 0, REG_UFS_CFG1);=0D
 =0D
 	/*=0D
-	 * Make sure de-assertion of ufs phy reset is written to=0D
-	 * register before returning=0D
+	 * Dummy read to ensure the write takes effect before doing any sort=0D
+	 * of delay=0D
 	 */=0D
-	mb();=0D
+	ufshcd_readl(hba, REG_UFS_CFG1);=0D
 }=0D
 =0D
 /* Host controller hardware version: major.minor.step */=0D
=0D
-- =0D
2.44.0=0D
=0D

