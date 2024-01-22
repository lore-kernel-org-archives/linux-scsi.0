Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD62260B82
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944101; cv=none; b=IhoA9NbmFxHJRaDlOGtDbVtY+70rP6DQG4E6twSALCs28toRmu6UVoV3YiIhlSmq2otpfX7vFFl0efZ+PagwyxISMFji5aMuQyp4rNJHr9oKedW8ppPwdsS8wOMBnciPPAsIz3z5K19GzpsDSPLwTphDfHh1AEbTsoN/isbisgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944101; c=relaxed/simple;
	bh=09zxCdt+NCfT08JtVbcGX9+GXw8iPNk0hTs2e6ou3d4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mfU87xKTlj2yKKrRVVg3S86zUR2XU1+OElmbOHEfDFZBrMNMcXUBsIKrH6wJ16ZGz3Ddi2Xk0CAzfDRktya4z0rZI6NGg1fMRjSDKqxRmMDGsbjhAtOdq4La/uKdxnKc8HTLY6NZJ7Gm4d8Bd7YyDSJivpqzb3dV8LFPqDjlLCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DybB23Sa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DybB23Sa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NX3H6VfoJEzhW/8XTfEE0I9qy52CGxJXMOtu5CoBhrc=;
	b=DybB23Sa76Y2D/dlrAOig/lCjtWiCdurEVX8iMShH0Mip6OuiVLqHh/WiMNfWghwC2/An0
	IYwbDUvrmeNHeTzlx1edEYqJhQSwbjJb5o2RLv/BUqBEjH7WOehjmwb9lHq39qLBHtC3w1
	jMRtSLxwvGX30DH0Lf4QOMCv5o5wtQ0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-HvrVSZEwP6We7v3CZ1vUDg-1; Mon, 22 Jan 2024 12:21:37 -0500
X-MC-Unique: HvrVSZEwP6We7v3CZ1vUDg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6855c0719a8so36357186d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:21:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944092; x=1706548892;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NX3H6VfoJEzhW/8XTfEE0I9qy52CGxJXMOtu5CoBhrc=;
        b=YGJuHEdfprXvEkLFrl5W6quCcYe+RyZe2njutp31w8IJuU+urYCoMDRkhMwFPeccjw
         ENQ9Gam+TCWRZ4DjxXz+u3AcL2aYMIaGpHlslW55Ojw0jLKDWg8O9+iwtdxq3nGW4lEg
         jGVCOQwslZuAjq1VweD+neMgtNswnll7Hqk4NEfIeoadZy+9mdWQ3thzd3yIs7EXPEAF
         ihoJ6NEAUZBN0ENSvBFUp/1rrMIWJy6GomsJ8OSc/qvH/Abfbmn+PIsmM6EpW9Ghz1qr
         UsKazVkvgn7XEECyuLS2oAG8o34/kqsS/j5kYWo7l0j39CgciL257O2Eb95+0sH5j5MX
         t1iw==
X-Gm-Message-State: AOJu0Ywq9lzZ4KMkO/GlvEHOBXyjS6Z/j+mhA8MnycjcE8IEFIzcor2R
	kQV/6qvVkzAFMwlLQJIXIjpjpfkmCBgxQElsHUREgAsnMI9ZfsdHE5k8VlALV0mFIHrT/Y00WRe
	XNRysnGQK+pRYTLzZEMWnZCz3Ei7XnzFAqK6of+MLkwKrDfyzytLwhUiGySM=
X-Received: by 2002:a05:6214:76d:b0:685:7524:dd7b with SMTP id f13-20020a056214076d00b006857524dd7bmr5671172qvz.97.1705944092384;
        Mon, 22 Jan 2024 09:21:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETM3O+0LREiehrGMV5y+Bz61CfAxNisi0IJmhr61MCq4f9E5bPXPlQXvd5/xIk78wvftei+A==
X-Received: by 2002:a05:6214:76d:b0:685:7524:dd7b with SMTP id f13-20020a056214076d00b006857524dd7bmr5671151qvz.97.1705944091962;
        Mon, 22 Jan 2024 09:21:31 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id lf3-20020a0562142cc300b00680c25f5f06sm2567738qvb.86.2024.01.22.09.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:21:31 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Mon, 22 Jan 2024 11:21:26 -0600
Subject: [PATCH RFC v4 01/11] scsi: ufs: qcom: Perform read back after
 writing reset bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240122-ufs-reset-ensure-effect-before-delay-v4-1-6c48432151cc@redhat.com>
References: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-6c48432151cc@redhat.com>
In-Reply-To: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-6c48432151cc@redhat.com>
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Hannes Reinecke <hare@suse.de>, Janek Kotas <jank@cadence.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Can Guo <quic_cang@quicinc.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Halaney <ahalaney@redhat.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
X-Mailer: b4 0.12.3

Currently, the reset bit for the UFS provided reset controller (used by
its phy) is written to, and then a mb() happens to try and ensure that
hit the device. Immediately afterwards a usleep_range() occurs.

mb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. By doing so and
guaranteeing the ordering against the immediately following
usleep_range(), the mb() can safely be removed.

Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 9dd9a391ebb7..b9de170983c9 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -151,10 +151,10 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
 
 	/*
-	 * Make sure assertion of ufs phy reset is written to
-	 * register before returning
+	 * Dummy read to ensure the write takes effect before doing any sort
+	 * of delay
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG1);
 }
 
 static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
@@ -162,10 +162,10 @@ static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, 0, REG_UFS_CFG1);
 
 	/*
-	 * Make sure de-assertion of ufs phy reset is written to
-	 * register before returning
+	 * Dummy read to ensure the write takes effect before doing any sort
+	 * of delay
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG1);
 }
 
 /* Host controller hardware version: major.minor.step */

-- 
2.43.0

