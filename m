Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD576DA2
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 18:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VM4LL54d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703183152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4md7/lhuz61o/OLaxynlTwcjr95vaOPE75vAR/46vcY=;
	b=VM4LL54dGavXS+Rs58oaseBCdh8QSMLnMVRl1WnxF84KmtRMKGvRoAZvxLnWUHNC8YGt3Z
	dsNBsmsdejCPMc63LWq08APkxOSzopXmWmk0S1gY2bKEAjIdgtgwP4FtLKubNTqjXEFV9S
	I6z+Wu35EzNIyE5RjllAzyn0EHtdSy0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-MVofFxg-N7ayR-hTFCY9rw-1; Thu, 21 Dec 2023 13:25:51 -0500
X-MC-Unique: MVofFxg-N7ayR-hTFCY9rw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-67ec592bc29so15300076d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 10:25:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703183151; x=1703787951;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4md7/lhuz61o/OLaxynlTwcjr95vaOPE75vAR/46vcY=;
        b=LBJViZ0+dWFYRaQsxzl/sNCMcdEkznVLauigH7X1dQj+rCuZ/OPsd7MuSVsB30aEu8
         xnS7YIRcdBkwqrC0s+x0TRMlASSm05CT18fCaXruZ2ToWYTxGk8iKjw9UYAWergHUtGh
         +txAMzRsftVgZRqw4k5WV6iQJaRMi5iS9bkHoayga2ds1s0bC8bkMpbdZfIFaT1Xa24f
         TSgcqjOUFsHZK1GSAo6yXIlVR0TPcveCvBBDa9u8ZdOb88TLTHCJ/PMZ0YutvkoOVnpP
         zx3A6LHf49ZbSV7CNfeA6ixhXoUCRw9IUp0y+/6Ygn3zedi5TxuP2pLWFckJ0OvNOrkN
         6Rjg==
X-Gm-Message-State: AOJu0Yw+NgI7UXCV5H1oYwv4/2ffi+eJCLR9T3Pv/d/bbetVOwZCJrIy
	vZsvad0XuLzwe42GGrrsViPyM/kg182UmqXXjltie98oHQA24SzbM8Paja2OOARFuHk4d4ZuYBO
	Dk3Ky+RM0Odc+W8q+nBjBZv6tqFt2VA==
X-Received: by 2002:a05:6214:f04:b0:67f:106c:aaca with SMTP id gw4-20020a0562140f0400b0067f106caacamr136444qvb.48.1703183151329;
        Thu, 21 Dec 2023 10:25:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExmZV+caO5vbXAe3tRFmp3a2qAi57YtrPfWuDvh+LaHqaf0w9mGD/BoRsz8IzVXIh+shJ/JQ==
X-Received: by 2002:a05:6214:f04:b0:67f:106c:aaca with SMTP id gw4-20020a0562140f0400b0067f106caacamr136438qvb.48.1703183151057;
        Thu, 21 Dec 2023 10:25:51 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id da7-20020a05621408c700b0067f2c03d4adsm779605qvb.100.2023.12.21.10.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:25:50 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Thu, 21 Dec 2023 12:25:25 -0600
Subject: [PATCH RFC v2 08/11] scsi: ufs: core: Perform read back after
 disabling interrupts
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231221-ufs-reset-ensure-effect-before-delay-v2-8-75af2a9bae51@redhat.com>
References: <20231221-ufs-reset-ensure-effect-before-delay-v2-0-75af2a9bae51@redhat.com>
In-Reply-To: <20231221-ufs-reset-ensure-effect-before-delay-v2-0-75af2a9bae51@redhat.com>
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>, 
 Hannes Reinecke <hare@suse.de>, Subhash Jadavani <subhashj@codeaurora.org>, 
 Gilad Broner <gbroner@codeaurora.org>, 
 Venkat Gopalakrishnan <venkatg@codeaurora.org>, 
 Janek Kotas <jank@cadence.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Anjana Hari <quic_ahari@quicinc.com>, Dolev Raviv <draviv@codeaurora.org>, 
 Can Guo <quic_cang@quicinc.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Halaney <ahalaney@redhat.com>
X-Mailer: b4 0.12.3

Currently, interrupts are cleared and disabled prior to registering the
interrupt. An mb() is used to complete the clear/disable writes before
the interrupt is registered.

mb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring these bits have taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure these bits hit the device. Because the mb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed
by writel()/readl()), it can safely be removed.

Fixes: 199ef13cac7d ("scsi: ufs: avoid spurious UFS host controller interrupts")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7bfb556e5b8e..bb603769b029 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10568,7 +10568,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 * Make sure that UFS interrupts are disabled and any pending interrupt
 	 * status is cleared before registering UFS interrupt handler.
 	 */
-	mb();
+	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
 	/* IRQ registration */
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);

-- 
2.43.0

