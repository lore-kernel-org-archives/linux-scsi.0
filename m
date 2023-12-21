Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F79768E4
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 18:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aqFylSxv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703183148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hFXXGAQMvAtKWxVkRcpFMTchD2fzgAOU8dNzT5bz2Wo=;
	b=aqFylSxv/dZsyrd41kfWDYyUHWPk5QUZa5ly9QhE/LTIyEazUzKJzoeR3QWsDJwp+C/X/i
	/iv5Lp6iDWxvgXwrlxpgfthzEoOgE66kuWlxk0IqhdFfjQ7QhCw5cDQGohA38Lc7h9BdLY
	6Yvq3AtvZpThsYCdXceGsRv+pwq+EqE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-40JaUZ3mPz6yEsVK_ZA9CQ-1; Thu, 21 Dec 2023 13:25:46 -0500
X-MC-Unique: 40JaUZ3mPz6yEsVK_ZA9CQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-67f7b69433dso16491266d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 10:25:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703183145; x=1703787945;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hFXXGAQMvAtKWxVkRcpFMTchD2fzgAOU8dNzT5bz2Wo=;
        b=YPuPj0Ryt+Iq6tk1fuhR5fLpgupD+ANAUOf7hsd8CSolXOXqhRcgZWZg9x3hzj2yG1
         hqiTMiUmpuS7Ln8rslpIHaAX/YF4ofqF6bOss/Ws9c0V1p2hcvpTLSN9rTyOKI0Cm7VP
         Y6XIEEPsq+mdEMpKif5QEixJNeJ+o7XPYow0cBxVmnyWkkXxb0ee+I783CUK5fWcxl0j
         xSD1HtDsJM3qBU/wSlAky8kA5JqG1j5r/yioUsbpg3DNRtMO4k2kJrJGDYIf8G+uB7Nk
         z006YZzOb3aG0ItswjDRLsciiclBd/ym1iLzvOzbQ/vNpXVdLcNVzsDLUBVCLEqiH4zM
         SJEw==
X-Gm-Message-State: AOJu0YxlxXe0kOcL8A+DMtdJtaU9Pkg+dt3pKGGYAaGumktr24mv06Lr
	ZF/m/D35xF7FlcGVFElXlooL9xlrgMXbX8sgq4Ih/5/Ee1CkfuCRsq+5K+gvJcGLrcfL3rLfK7l
	aQqV3j1xJAdvrdlLFZn83RLSmo/ih6A==
X-Received: by 2002:a05:6214:20e6:b0:67a:a721:caf4 with SMTP id 6-20020a05621420e600b0067aa721caf4mr121000qvk.85.1703183144903;
        Thu, 21 Dec 2023 10:25:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIzHIP8IP+Btntq31oA+NJrP8wQlY6ZrjfmYei4CjrYTO1lr59Bq4x9PrGSfUb4jsXlwQcHw==
X-Received: by 2002:a05:6214:20e6:b0:67a:a721:caf4 with SMTP id 6-20020a05621420e600b0067aa721caf4mr120983qvk.85.1703183144634;
        Thu, 21 Dec 2023 10:25:44 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id da7-20020a05621408c700b0067f2c03d4adsm779605qvb.100.2023.12.21.10.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:25:44 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Thu, 21 Dec 2023 12:25:23 -0600
Subject: [PATCH RFC v2 06/11] scsi: ufs: cdns-pltfrm: Perform read back
 after writing HCLKDIV
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231221-ufs-reset-ensure-effect-before-delay-v2-6-75af2a9bae51@redhat.com>
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

Currently, HCLKDIV is written to and then completed with an mb().

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

Fixes: d90996dae8e4 ("scsi: ufs: Add UFS platform driver for Cadence UFS")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/cdns-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index bb30267da471..66811d8d1929 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -136,7 +136,7 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
 	 * Make sure the register was updated,
 	 * UniPro layer will not work with an incorrect value.
 	 */
-	mb();
+	ufshcd_readl(hba, CDNS_UFS_REG_HCLKDIV);
 
 	return 0;
 }

-- 
2.43.0

