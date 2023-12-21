Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E130473197
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8893dha"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703183143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4219KYM+Lx5MIoMXHlnouIE3ETSXouTN4mLohiWEzAY=;
	b=S8893dha1yDSxx6pcwLwg+/SS0cuzBTO362gOrARS1rxIhBBjIm9sNzFXXut5yna04Kj5a
	8lNWihDVcITMoypaWwWMT19mu02zQl7bYFWfQZifc58QxPQ8PnHRj1vZG2MdAk/RexuHWP
	CWGe9LGyaGi73RlFyN1DEYu5jIzHmBk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-pH5IXlUFOIOv2uFD2kgWyg-1; Thu, 21 Dec 2023 13:25:41 -0500
X-MC-Unique: pH5IXlUFOIOv2uFD2kgWyg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-67ef53b1f17so16444896d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 10:25:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703183140; x=1703787940;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4219KYM+Lx5MIoMXHlnouIE3ETSXouTN4mLohiWEzAY=;
        b=ISTHhL99RP+gVOuzvhKH9LNjubUmACVuKKIqZbdVjQXe0WGhe5GH01kMeAKHxlrXC7
         s6CeXQAmZZatxNWsYE/EKqFGzQm8liazmLShbSEoFkd1dQVxebccl/QQRWFvoScxQ2Pn
         9lQ0A3hNoSXug2CuyBTLao+GtVy/PbtCc9nk9Kvv8i0BkFz6ab/9HwYEeiiwF4EPlCIB
         06UUKtKc1B2Ckst0QgMvx3kVuAnadabYD9DQtbIpg/ix2lsVXDR085qVGvzKw6L/X5ZS
         Cwwux8vqBgUv835DgBME1cwskmbZjW7vAWq9qIGgblmxW3axMeiMhlCiJ63FaH2J+U7n
         QqwA==
X-Gm-Message-State: AOJu0YwKeCOigKkaXhMJJQe3zLqSQUNcCpJw/nxlYCOQhLAdfC4c8LWu
	h4I3C5mvBScqG5XmTR2PTLWbY/gtqGEpxTYN2flxXl7nK+lde6hn6tnypOhvTAnhNvEkOHk6YUQ
	bMgrp1BQyA6DnfjL8YA4v2KTN6mYu1w==
X-Received: by 2002:a05:6214:c69:b0:67f:2167:add8 with SMTP id t9-20020a0562140c6900b0067f2167add8mr128956qvj.63.1703183139772;
        Thu, 21 Dec 2023 10:25:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZ5Ey0k8eka1Tmd1wHccFHcVx5O7AMpaYlZVPVIE4Mlzs93Ul5Aid/9sPv0OnMJmxA3rI2gQ==
X-Received: by 2002:a05:6214:c69:b0:67f:2167:add8 with SMTP id t9-20020a0562140c6900b0067f2167add8mr128935qvj.63.1703183139516;
        Thu, 21 Dec 2023 10:25:39 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id da7-20020a05621408c700b0067f2c03d4adsm779605qvb.100.2023.12.21.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:25:37 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Thu, 21 Dec 2023 12:25:21 -0600
Subject: [PATCH RFC v2 04/11] scsi: ufs: qcom: Perform read back after
 writing unipro mode
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231221-ufs-reset-ensure-effect-before-delay-v2-4-75af2a9bae51@redhat.com>
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

Currently, the QUNIPRO_SEL bit is written to and then an mb() is used to
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

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 6df2ab3b6f23..ab1ff7432d11 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -280,7 +280,7 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
 
 	/* make sure above configuration is applied before we return */
-	mb();
+	ufshcd_readl(host->hba, REG_UFS_CFG1);
 }
 
 /*

-- 
2.43.0

