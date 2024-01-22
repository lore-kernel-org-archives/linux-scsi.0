Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE4963115
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944342; cv=none; b=lfIwV5X0LYWKSHwoXzK5yPmT+YsahBxOLKikvnIJ4gUwWPtcziEXe/HMdrUfu4sHFROkcyuq7GD90oR0EDr5zMcarn7+uiLyCgRM2s51yZ3Ay5cKJdIoKkEc06F0uFrdZtTPl8JNH2ao2xwSQ101aE2TA1bvZBL3A1ZrSAYwXm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944342; c=relaxed/simple;
	bh=lrt06U9MjfT0+aAqB1+xoJHCrTf+UY09+oCiHhhT3Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHiA4OFuWTi1ZUmRiW3FDYGkQuESgY+/VXFQOkAgKqxui5MYY/Z4ncaMBoFsip6jfqYnmdEX+F/Yd8vl6/2qPeM8z+1hVtn3soMn/H5fp7rStaYCam5X+XmnxAIfA4rEOsdNmdIkmO5kNCVqkTWXpKSHXg0lGQdsjvxzv+DuNx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NiJFdtad; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NiJFdtad"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xvA2uv2JUZrdT2MKiipHpiF6tbdfVobWEO3O5fZ7MOA=;
	b=NiJFdtadtsWkArX3ayAncZ40S/JUERmz1qvDg5ab1wMNKh37ejImxFQ9pGY5mtPXvMd2Wz
	4158UowfHMQ/G1FXaXugpf4X30dJiN08ABoqzSRzmVSb831FPj9yiFJt5uyHbGQmBm1Pyc
	7d0gv4txrYRFfG+Kj3h5jieVdZkOPdY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-evM8U4iQMW2L6Aj7AH1gQQ-1; Mon, 22 Jan 2024 12:25:38 -0500
X-MC-Unique: evM8U4iQMW2L6Aj7AH1gQQ-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-42a4660fae8so11720931cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:25:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944337; x=1706549137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvA2uv2JUZrdT2MKiipHpiF6tbdfVobWEO3O5fZ7MOA=;
        b=nQynND7E+FuBNqzrCaoQ4rcMQMDBtjwVCN6TcGIoK4z2XPcwIC6G1hEGExTgpTyugr
         D1wnsoZMk2f8XE2PiTHmoaWgBuk5YFfxzWSmM03mN/B8ZcqsFssxWbdzAy5j/K4/PwVw
         OLv3/dmZDmGe89KDF2KDJ3ro1sTMsqJQX39/i+ZO/FxWvgl7za/oERrif4f8vfZ0eqvR
         8Ra73jbwN2XYOWlxh0eZ4+Hz1X8wq3uxDDDmYuVwIGY5r5ETbg4ilvUTOv90n8jtL4Uz
         Y4PWsJJT+4AgPYaTs8XgXkQAmauslYbw/qVEabO96bgcfQjNUIHMpHh4+9K8Rj/Pf//B
         zUVw==
X-Gm-Message-State: AOJu0YwnVVATt9J3U1kw61abm9710Gu5Y1xmieRMb6Unsdhq/KPaMlUE
	t7s/dG0Q8+wGQUo5Jz4mYMgHwr/yLtV3WLXxS9PI9KM99HSH3+A6kGnRDcp3d2lz7Xd8GT5QEst
	s3ktbsxBCEF29oJB6H2aHnyC8hZIOSu5SdXZ0GU5GRQSdh9W4bAJNb+Srgfo=
X-Received: by 2002:ac8:4c8c:0:b0:42a:2666:a410 with SMTP id j12-20020ac84c8c000000b0042a2666a410mr5552761qtv.63.1705944336846;
        Mon, 22 Jan 2024 09:25:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJcK9rtAYzFRJnLuAvRQK60DVL+9ETfuJh2rfvtLBRbekkrCVPXBMhXR6sp/967Twv/QzifA==
X-Received: by 2002:ac8:4c8c:0:b0:42a:2666:a410 with SMTP id j12-20020ac84c8c000000b0042a2666a410mr5552733qtv.63.1705944336119;
        Mon, 22 Jan 2024 09:25:36 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id c7-20020a05620a200700b00781ae860c31sm2280992qka.70.2024.01.22.09.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:25:35 -0800 (PST)
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
	Can Guo <quic_cang@quicinc.com>
Cc: Andrew Halaney <ahalaney@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC v4 11/11] scsi: ufs: core: Remove unnecessary wmb()
 prior to writing run/stop regs
Date: Mon, 22 Jan 2024 11:24:07 -0600
Message-ID: <20240122-ufs-reset-ensure-effect-before-delay-v4-11-90a54c832508@redhat.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-90a54c832508@redhat.com>
References: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-90a54c832508@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.3
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
index 21f93d8e5818..358857ea9ff6 100644=0D
--- a/drivers/ufs/core/ufshcd.c=0D
+++ b/drivers/ufs/core/ufshcd.c=0D
@@ -4722,12 +4722,6 @@ int ufshcd_make_hba_operational(struct ufs_hba *hba)=
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
2.43.0=0D
=0D

