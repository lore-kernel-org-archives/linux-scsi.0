Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E82464AA0
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3gA7xHh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703182679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nPTRfp6XgPJwYrXbStNGHlrTw26cplB52DVfER92OzE=;
	b=K3gA7xHhRZVmlhzukBCOmFNROY3PMH2orGRi6ZzR1Okcv33oPdBy0ZIy99ZBtbyYokLi2K
	6zlM7UYBnwYKqb/B6VViegBjStVK0dDqKs7UwfjLksgrDt03OUWMHVh9N1uFJG+KaJSuEG
	R1nnHNSs3IUQIsNQNjlX1PPhWa4Lx1U=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-PC2BslOgNkGJrFPaVfCTCQ-1; Thu, 21 Dec 2023 13:17:57 -0500
X-MC-Unique: PC2BslOgNkGJrFPaVfCTCQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-42784a3e560so14278381cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 10:17:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703182672; x=1703787472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPTRfp6XgPJwYrXbStNGHlrTw26cplB52DVfER92OzE=;
        b=SDrCayyi2InhjDmECT3aFkd5Gbgtfy0VWGEnc9MpfrxH79ioJ2fLGb08WAsKRZZCNm
         /GdLXX7LmN9JjUxgSRLWggAV8g7Ux2YINxsOjCoILkXyLxBAeoAha0OCXwyy8bdgTffB
         mOnaL65bytSzOV7WCXHFKqs11ElI0zC5J5fRtFhq8AthF93wnKd71clK9k69HvywuiWy
         hxLw1TtkWkybdvciTr5jn+G8f3pX+LUbMLoAbRHw5AA603aTdA9Uud+ppc09zLdR7gFW
         8kvILJNhRN3bYE3TtKErmVgCSYE/+pVHxfBcxz2hgPii1IwWT0moS65qEvu09r93/ocb
         ZXWQ==
X-Gm-Message-State: AOJu0YwFN2Ko0ufe0fRjkZ7ox2JbJSUI8QLHjow6ZBiVNjs5i11bi6nF
	j+R5cm4OFaZnrCIaqA5vVWDou3Fv9dc6Wle97mkq45+sC+gedElnloLS4G85kK7jaZZKB4irWMj
	nwICAEPKcWU6jK7A7dC2uPsQztLN+gg==
X-Received: by 2002:a05:622a:94:b0:425:f0e0:eb6e with SMTP id o20-20020a05622a009400b00425f0e0eb6emr209505qtw.19.1703182672265;
        Thu, 21 Dec 2023 10:17:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFcjXn2BW/AWUDCkYR+8jI419VRXJtkzGurVXqT4ZuggYayrxK9omBtR9cVrIEfl+WGQGlBCA==
X-Received: by 2002:a05:622a:94:b0:425:f0e0:eb6e with SMTP id o20-20020a05622a009400b00425f0e0eb6emr209477qtw.19.1703182671973;
        Thu, 21 Dec 2023 10:17:51 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id hj10-20020a05622a620a00b00425e8c7d65fsm1025758qtb.23.2023.12.21.10.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:17:50 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Thu, 21 Dec 2023 12:16:47 -0600
Subject: [PATCH RFC v2 01/11] scsi: ufs: qcom: Perform read back after
 writing reset bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231221-ufs-reset-ensure-effect-before-delay-v2-1-6dc6a48f2f19@redhat.com>
References: <20231221-ufs-reset-ensure-effect-before-delay-v2-0-6dc6a48f2f19@redhat.com>
In-Reply-To: <20231221-ufs-reset-ensure-effect-before-delay-v2-0-6dc6a48f2f19@redhat.com>
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
 Andrew Halaney <ahalaney@redhat.com>, 
 Manivannan Sadhasivam <mani@kernel.org>
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

