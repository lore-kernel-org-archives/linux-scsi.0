Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD887691A
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gY4edpsD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703185855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oX0CWwSSb/xcfXKSUEFguRgCx8LqXafuU1W5XbBtf6I=;
	b=gY4edpsDhHnwH+l/JQ3iK08HKdl26Z5WHFyRyiXRmRxnEQ9FD5i6zeQAoGjq4l6xBG8Rd8
	Ka2DmaY9g1El1l/YHch05wWSZ8Cdn7tAz0fecDqr4RibUQbT2+xSdOobKtHhcxHB/pRZkO
	ZRz55o9/c9WKGNTpiuEWQokSNsXOReE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-pWtqZU1eO1i7JbXMm3QPMg-1; Thu, 21 Dec 2023 14:10:54 -0500
X-MC-Unique: pWtqZU1eO1i7JbXMm3QPMg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7810802421bso135538585a.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:10:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703185850; x=1703790650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oX0CWwSSb/xcfXKSUEFguRgCx8LqXafuU1W5XbBtf6I=;
        b=ucFMXcMwjxsbf8t/mgDeBkQcpotRsvpeX2dCFZJb8lPWLtR8omm5+y2BNQ50VYMwYq
         zxC1K8YMzz2EtKjED16OZoRvoMeGhyIjPJy+mYxwqgRrO2hm6X/DulHXxEJLKSwwCtsY
         K0l+5A9sugab86OsHBjEd3//sOaxpO4QicpDMul29CUx0vL9U6hydfLtV7C1YNCk+Htd
         /+FtM89WBA5slm51eLjDGM+ePWjnJa+EPKKWLJ8PJD55otGUVSefdGj2QFxLxNgBvQ43
         tfjza7TZuqQsyS8p5S4U8ChqCZ3NxayiTBpv1Q5zbyHXVtlzSwhZ9ZHwXMY/zykiTu3+
         STpg==
X-Gm-Message-State: AOJu0YyeaHC6fbM7gVPWCekm3X0eHXBKY1XGHS8DWD6ee9Pv+kQfRV9F
	vEu6FRleDvCIoMQtqou2DXvSbKTsysRiwEKd8oEPtiMSAvnbIwONuOwIyfLHXvx3l2k4/omKask
	x5xbYNjFEAY25yhainAprF5jab8JccA==
X-Received: by 2002:a05:620a:2914:b0:77f:92f:fcc0 with SMTP id m20-20020a05620a291400b0077f092ffcc0mr328952qkp.24.1703185850248;
        Thu, 21 Dec 2023 11:10:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFFmVes4XMCZ3lGbcjd+Jg+rBUmhWnl7+B+n29gnbBYnepEnbM62uIlen/a5SDWSV96Vlghg==
X-Received: by 2002:a05:620a:2914:b0:77f:92f:fcc0 with SMTP id m20-20020a05620a291400b0077f092ffcc0mr328927qkp.24.1703185849959;
        Thu, 21 Dec 2023 11:10:49 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id 25-20020a05620a04d900b0077f0a4bd3c6sm846370qks.77.2023.12.21.11.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 11:10:48 -0800 (PST)
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
Subject: [PATCH RFC v3 05/11] scsi: ufs: qcom: Perform read back after writing CGC enable
Date: Thu, 21 Dec 2023 13:09:51 -0600
Message-ID: <20231221-ufs-reset-ensure-effect-before-delay-v3-5-2195a1b66d2e@redhat.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
References: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.3
Content-Transfer-Encoding: 8bit

Currently, the CGC enable bit is written and then an mb() is used to
ensure that completes before continuing.

mb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed
by writel()/readl()), it can safely be removed.

Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index ab1ff7432d11..3db19591d008 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -409,7 +409,7 @@ static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 		    REG_UFS_CFG2);
 
 	/* Ensure that HW clock gating is enabled before next operations */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG2);
 }
 
 static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,

-- 
2.43.0

