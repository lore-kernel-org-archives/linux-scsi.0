Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC855793
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944325; cv=none; b=uywnkOoc2lxhknguXNQTNLw4s0XJai8L5ZFxmyzcxgdaSUJDX4eX1QAdPDQ3kVQDWt8IvVkPYQrdZEwk1ZvC7uX4LaOHJjG0ugXod4m4tKHUNAd5njnFBLjCeNBawXRKDPheQoubrZwLqt61oyoXDQRm6bKzvewoxX/lQptVIws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944325; c=relaxed/simple;
	bh=W4mJLP2iaxCUp7jWQvTVdyu+M70cTTTVM83ZPvkZy40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GDzzPbasQeiYMg4sfyrSCOjq+hqcCyBNFgIfad+PHbsS8ZOo9T9Ef3C9LtinJxQKwp/X8SXJF/Bpib3VxlWeVmQPmGAXbgG6DRO8NFRpKBp7FzqOZywqYj7890VzDnI5TCuwb2hk6hh8RDJgJrP1O7JYFR4NtrovQECntrzO+mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y4bcaRSD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y4bcaRSD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jvd6d1nUhV9LrU5f+xXncvSCqH2blthYX1l8ESnZEkg=;
	b=Y4bcaRSDMSXVG76e7F0dPFuMcE41iBJbQGB53hfa5Sjxhpz11GMoQAJJ4+HR37jD0WQ4CN
	qtok0JQoYHdr2ylIh8wRAlxMwxL5WdnIDaaMH2fKkTY2qFG0MeUhutzxrkFe0YrOXQNQGf
	wkvdxSqW19hNDsyTJXocXMd4UawyzWE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-vOkEu0-HNN6mBeTzXWlirQ-1; Mon, 22 Jan 2024 12:25:16 -0500
X-MC-Unique: vOkEu0-HNN6mBeTzXWlirQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7833751431dso566368085a.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:25:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944315; x=1706549115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jvd6d1nUhV9LrU5f+xXncvSCqH2blthYX1l8ESnZEkg=;
        b=rUuWW+mJYxtJQWizxPAtwtb20d/u2oiHX0yIcC8o56QahNbT8bXbk9n6y5a53JdCKO
         39uhYijszA2gHPf15JKjJQ4oY+YJ8ihdj/is+2O5QQfvRYdRWmUVjbIJhfBJtvfn8reE
         zMLXvthUN6PaNbtFoVooWlhyxaVA+Jo3jEWRgkFZuMBGX/LAGnEkl89d7BC9xA3q5p8p
         +9zczk0j0ei7IExVre1e8xz54l8Ih8SqS9fh7Q+D6pAPpUxqP45FmOySarMBHg2oOV/B
         1SNtq7awEopEUAYrqK13mQLZZxOZFQ87T+6a+Hj1Cv0qu7UDO9pTghKH95JObx/WOYqI
         I5mw==
X-Gm-Message-State: AOJu0Yw3hRMdQJaobpmF5yKfy6kOJukvLeIEyGIcuvkB0AnGcxPn4O2C
	8l6TdB6pEPI8H4+54mhKzcAMnIVR5RxV3zOJSYh2QY+DhUchvTg3iRFbzKASb66G2svKvN7kkRh
	7NGNfpFuvrDp+2Rb6O5SzoHONFiBEmN0fr+Z+IdH1B7szZ9akapXncjqMRmw=
X-Received: by 2002:a05:620a:8212:b0:783:375d:452c with SMTP id ow18-20020a05620a821200b00783375d452cmr5390434qkn.33.1705944314861;
        Mon, 22 Jan 2024 09:25:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoliCfOOS1LOszyII+v7aqIDivdgIeZaJ30/Z5vvVM98B2l3IKb8HadDNAIgovxwuK2kQKjA==
X-Received: by 2002:a05:620a:8212:b0:783:375d:452c with SMTP id ow18-20020a05620a821200b00783375d452cmr5390410qkn.33.1705944314547;
        Mon, 22 Jan 2024 09:25:14 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id c7-20020a05620a200700b00781ae860c31sm2280992qka.70.2024.01.22.09.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:25:14 -0800 (PST)
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
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH RFC v4 08/11] scsi: ufs: core: Perform read back after
 disabling interrupts
Date: Mon, 22 Jan 2024 11:24:04 -0600
Message-ID: <20240122-ufs-reset-ensure-effect-before-delay-v4-8-90a54c832508@redhat.com>
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

Currently, interrupts are cleared and disabled prior to registering the=0D
interrupt. An mb() is used to complete the clear/disable writes before=0D
the interrupt is registered.=0D
=0D
mb() ensure that the write completes, but completion doesn't mean that=0D
it isn't stored in a buffer somewhere. The recommendation for=0D
ensuring these bits have taken effect on the device is to perform a read=0D
back to force it to make it all the way to the device. This is=0D
documented in device-io.rst and a talk by Will Deacon on this can=0D
be seen over here:=0D
=0D
    https://youtu.be/i6DayghhA8Q?si=3DMiyxB5cKJXSaoc01&t=3D1678=0D
=0D
Let's do that to ensure these bits hit the device. Because the mb()'s=0D
purpose wasn't to add extra ordering (on top of the ordering guaranteed=0D
by writel()/readl()), it can safely be removed.=0D
=0D
Fixes: 199ef13cac7d ("scsi: ufs: avoid spurious UFS host controller interru=
pts")=0D
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>=0D
Reviewed-by: Bart Van Assche <bvanassche@acm.org>=0D
Reviewed-by: Can Guo <quic_cang@quicinc.com>=0D
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>=0D
---=0D
 drivers/ufs/core/ufshcd.c | 2 +-=0D
 1 file changed, 1 insertion(+), 1 deletion(-)=0D
=0D
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c=0D
index e2e6002fe46a..9b6355555897 100644=0D
--- a/drivers/ufs/core/ufshcd.c=0D
+++ b/drivers/ufs/core/ufshcd.c=0D
@@ -10564,7 +10564,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)=0D
 	 * Make sure that UFS interrupts are disabled and any pending interrupt=0D
 	 * status is cleared before registering UFS interrupt handler.=0D
 	 */=0D
-	mb();=0D
+	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);=0D
 =0D
 	/* IRQ registration */=0D
 	err =3D devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba)=
;=0D
=0D
-- =0D
2.43.0=0D
=0D

