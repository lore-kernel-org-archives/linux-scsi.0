Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A344148CCD
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 20:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745438; cv=none; b=sJ5O1KpfExKed2/yawE4PD2ej6VuScWDBq1gHWw7czmgyox9fjxJLTkKqj35h8/g0qDAP5T1nQ5WuX1Klfw1pdaFRezB22CmzIEeSFsmA18Aqy5aISPzMwQ9RYUSAm3tB1nQXtRdIh8XVATO3/LLyVBtClTBz12XLfpNHbAFKgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745438; c=relaxed/simple;
	bh=rUiFGJENhkjaL5XQk3rVKmNTCac0phrGlXxO+qQgbyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=erwNqvVoNms4lPJ12Tz/K0dbwc3cVPfYeiBUTN5w1kqGCb+fFL+8JGsGeXmQme8DAVCX7TWOO5B2wZ6bZkvgTzhXZ+7weXN6QgFSFmi1WIfmVtyK0x5FR7p304EH9U+JHSD38BVw5SFkWHjy1YUmQbGXoBIP9XbLbUO/oYfmMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rwx9wsfm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rwx9wsfm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711745435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kfliicv5toOd2B87oyO1cEhsCWrclX7x2KOA+OKHojY=;
	b=Rwx9wsfmQ81+Sm2pfj+F5OwJsfHI0tgP3fkh2nXRXEo8d636Cc3q3dFLZiFfX1jrHHxnzo
	6u6qE8zMVSm4rZ+zBlDfpi3oqT/bvhoWRnKI/DaYK+n5q1Zip9onpdNAljtyMIfz06ZMmQ
	SWpzBjlSiNnS8TpLd1fNmiaxtDoiY+E=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-noR1HHE1ORaWqlgxz7XEIw-1; Fri, 29 Mar 2024 16:50:34 -0400
X-MC-Unique: noR1HHE1ORaWqlgxz7XEIw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-698ec7e66e1so12390356d6.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 13:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711745433; x=1712350233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfliicv5toOd2B87oyO1cEhsCWrclX7x2KOA+OKHojY=;
        b=ncz2cMlpeulnLEN5N0GPiluPDP0auTsixBCslY8nmjM+E1jElfFXil6ZgsIdGJTSt3
         QHHElrMsvFTcD36Wj3DZkgxhp1Cl15+qmFdRS0hxMTN9Z1R/Vzwi19izP9+2mxzFyqwj
         NryKNIvv+G8/GJAl5avBpxjOICQARkaprUI2GVnUAH1misqxqP9JeiFRA7Pr1GsYNCRQ
         FB58tcmyz5FC0pLPZNDV/pATxBMYmfh5Vi4HXxskQZYEIYjs5ouaYKKrPJGo8jLIwR9/
         0kLAWyYFGLjPa3GA9AfyQMFB5xZqhmZ1aSB0b196mvsF4o5rvYxn8oPDYI2YjBiDqoAb
         6gHA==
X-Forwarded-Encrypted: i=1; AJvYcCXMeL96lysePA18irwApv+DrlYe8ljRsTUxH5XMi4iPYZGDbIOJsfoK0Ec9kEG/cazAaouBMb4M6hNkbE80IouM4lBi/bxEkxow8g==
X-Gm-Message-State: AOJu0Yy+yGxLb/21YjASAx9xQt7m0r4VRRs3KOwIaIbZY5RRGHIljbn+
	+IoeAvCN4g+BtrXBI7xVNOHynQarrn2B3grS+ygHlKmr/plgPMS+q2IY2jdtdy0FsjCrzhuzdRh
	D3j+dA+C7V0X18zu48wdLKZmpD53aUK63EsTm31G6oU3S8lEuR6TXzybfdfs=
X-Received: by 2002:a05:6214:190a:b0:696:b095:c429 with SMTP id er10-20020a056214190a00b00696b095c429mr3119259qvb.40.1711745433046;
        Fri, 29 Mar 2024 13:50:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSRd/5i8QlyLSkwg85Jxr+u352RMnwF3m/7r26iSWU00W9M/Q4Hw8RMOt9vf05jAbg6L8gpQ==
X-Received: by 2002:a05:6214:190a:b0:696:b095:c429 with SMTP id er10-20020a056214190a00b00696b095c429mr3119243qvb.40.1711745432697;
        Fri, 29 Mar 2024 13:50:32 -0700 (PDT)
Received: from x1gen2nano.redhat.com ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id jz10-20020a0562140e6a00b00698f27c6460sm794271qvb.110.2024.03.29.13.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:50:31 -0700 (PDT)
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
Subject: [PATCH v5 08/11] scsi: ufs: core: Perform read back after
 disabling interrupts
Date: Fri, 29 Mar 2024 15:46:50 -0500
Message-ID: <20240329-ufs-reset-ensure-effect-before-delay-v5-8-181252004586@redhat.com>
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
index a89887878d98..268fcfebd7bd 100644=0D
--- a/drivers/ufs/core/ufshcd.c=0D
+++ b/drivers/ufs/core/ufshcd.c=0D
@@ -10616,7 +10616,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
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
2.44.0=0D
=0D

