Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32C313CC7B
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 20:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745454; cv=none; b=k+RpwWd3lAJTNw7LUdUKaif6eIHoWXAnBUm+ypvHpS5xt4x/TfLoMNefyIuECnZFxd+mOeS1LVaAsjWvv/RuneWttMfuqmDvPvZ8pxqCxhqh4v754CFvweyOsZejitp9Yqx/aIiIM2G+64qztr2DD+blfDV/QKgeEWUdPQcAfY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745454; c=relaxed/simple;
	bh=BGXknjcLA50bcUKtFtKJCi5N6HFf284Wv0+1aI9g+Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpR75iL6/aPxftWCGeIFH1S07LLSn1h3WfsbGZ4jnP62Se/uenHx9Pq+qWBhUdtJMYura2bbSk3fXULy1k2AlxtgedxUDZCN+hq+uQLQbyxB06aLewOWfNJjZ9xdlKbFMEDdXc6zgV2bK7FVQJ2Qbjb3TUXFIV2DHbp5U86KFkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fCXnaQJX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fCXnaQJX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711745452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf4SOXbG4RAjshjCtScug3Y0ECaz5dSCoqxe3hdLj3E=;
	b=fCXnaQJXPETrf8Zh5kStvYL4K+0A/nLv6EuhTKP3tFvkXa2jyKmfeLJEY+dOn6kmP1bzhQ
	ckKJZBZxIJdVKv8dbDrcURhcMiSCZw0bBwNI4c6k7zErwiitNgdPSLNhbpB8E1WGZyPZIA
	kCRj5zdYjdoK/qd7CtG3p146FOQJMHM=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-6jXk8dxoP3GCuZg_OI9ZTQ-1; Fri, 29 Mar 2024 16:50:50 -0400
X-MC-Unique: 6jXk8dxoP3GCuZg_OI9ZTQ-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7e05b1ef83dso1098499241.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 13:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711745448; x=1712350248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uf4SOXbG4RAjshjCtScug3Y0ECaz5dSCoqxe3hdLj3E=;
        b=QWYtKARCwWPMIPz08EfhnoCJQ68iIijWOFWSF/FzLLr2irCfpW2bK1//zUVtFC9qjE
         UfOOpHohQiQcMcjxWYLwEQC5vbNI7UfjunQRmevXZ2cn0ONzNfbHD5kneOb2jiffWPvg
         hF1s7AjkbuIMMo6qAkhpVt5T/9hfB9sZENRUL8Hko98/KMdT/iyCdZwHPSjrLwgpBkAP
         szXyPckm+sVm3sxRHDOzowvpCx8O7LocrnYkCkFl/Xc0V8TyHO35Sdx4pPJDAQPL2VH+
         VV7GfI75FGjJeM8mIuWCgfwwbFXVqGLo9PzIxDRX1mXkrSd7KtXkkwoCTa76NDM5ng53
         vDOA==
X-Forwarded-Encrypted: i=1; AJvYcCXGPYQFfzrp7zw+fSaaE79JcYRwhMxvSAJv2hQaGrRr+21+olIMunn5mTcuRPVXKrKUnVtvRPOd4fq0fBffjur1DQMAaEFV0kJDZw==
X-Gm-Message-State: AOJu0YziepwE2hDAOzaF/w91/27/BzaIlD11+HmY0BJcSp+absgVqeo5
	8AxCDvevLJzkHkluKN9hGBxN8N0xFnnrwXge5FmhM02Aus7VtaAMo10J+ODYl700TP1csXZtN7t
	WwndNZ7rF2Evi6F4E2l4pLJnV8OLb9R+OKUlSnLw+kk5e8xK1Wj/AFr+cAmQ=
X-Received: by 2002:a05:6102:dd3:b0:476:fab9:237d with SMTP id e19-20020a0561020dd300b00476fab9237dmr3651555vst.2.1711745448243;
        Fri, 29 Mar 2024 13:50:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbJHgBjF3eN8i3ddN3z1R3cQ/XH02K5EBI2mtVmXktFIkJdXz1ZhnDrVZGUZxKmIZMOtcJjg==
X-Received: by 2002:a05:6102:dd3:b0:476:fab9:237d with SMTP id e19-20020a0561020dd300b00476fab9237dmr3651537vst.2.1711745447887;
        Fri, 29 Mar 2024 13:50:47 -0700 (PDT)
Received: from x1gen2nano.redhat.com ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id jz10-20020a0562140e6a00b00698f27c6460sm794271qvb.110.2024.03.29.13.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:50:44 -0700 (PDT)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/11] scsi: ufs: core: Remove unnecessary wmb() prior
 to writing run/stop regs
Date: Fri, 29 Mar 2024 15:46:53 -0500
Message-ID: <20240329-ufs-reset-ensure-effect-before-delay-v5-11-181252004586@redhat.com>
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

Currently a wmb() is used to ensure that writes to the=0D
UTP_TASK_REQ_LIST_BASE* regs are completed prior to following writes to=0D
the run/stop registers.=0D
=0D
wmb() ensure that the write completes, but completion doesn't mean that=0D
it isn't stored in a buffer somewhere. The recommendation for=0D
ensuring the bits have taken effect on the device is to perform a read=0D
back to force it to make it all the way to the device. This is=0D
documented in device-io.rst and a talk by Will Deacon on this can=0D
be seen over here:=0D
=0D
    https://youtu.be/i6DayghhA8Q?si=3DMiyxB5cKJXSaoc01&t=3D1678=0D
=0D
But, none of that is necessary here. All of the writel()/readl()'s here=0D
are to the same endpoint, so they will be ordered. There's no subsequent=0D
delay() etc that requires it to have taken effect already, so no=0D
readback is necessary here.=0D
=0D
For that reason just drop the wmb() altogether.=0D
=0D
Fixes: 897efe628d7e ("scsi: ufs: add missing memory barriers")=0D
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>=0D
---=0D
 drivers/ufs/core/ufshcd.c | 6 ------=0D
 1 file changed, 6 deletions(-)=0D
=0D
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c=0D
index a2f2941450fd..cf6a24e550f0 100644=0D
--- a/drivers/ufs/core/ufshcd.c=0D
+++ b/drivers/ufs/core/ufshcd.c=0D
@@ -4769,12 +4769,6 @@ int ufshcd_make_hba_operational(struct ufs_hba *hba)=
=0D
 	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),=0D
 			REG_UTP_TASK_REQ_LIST_BASE_H);=0D
 =0D
-	/*=0D
-	 * Make sure base address and interrupt setup are updated before=0D
-	 * enabling the run/stop registers below.=0D
-	 */=0D
-	wmb();=0D
-=0D
 	/*=0D
 	 * UCRDY, UTMRLDY and UTRLRDY bits must be 1=0D
 	 */=0D
=0D
-- =0D
2.44.0=0D
=0D

