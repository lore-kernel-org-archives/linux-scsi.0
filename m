Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA9465184
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QYAhkS7N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703183138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n1l5xZhbao6yyLMAHMlDGMBOyE+StA4U3ea1c7HAYjQ=;
	b=QYAhkS7NaxaAtt3UzdI80oINkSHoaFMJYgNk1bvUSAek2zISUc4CEcfGJwo3NKmBGL0gzl
	ywwBtWtyHreZFEpqS2I+sxgUIuA5cf+Rzjw4Dnz4N+QRyoJLK8HkRjF320voXF6FhyNYY8
	/91s9PsY6v8/mRDblG9HNlNsgfyFKgs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-rWcXwPO1PUGFikw0v9k16Q-1; Thu, 21 Dec 2023 13:25:36 -0500
X-MC-Unique: rWcXwPO1PUGFikw0v9k16Q-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-67f772d30a9so14601896d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 10:25:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703183136; x=1703787936;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1l5xZhbao6yyLMAHMlDGMBOyE+StA4U3ea1c7HAYjQ=;
        b=ayy1PUYBqXkIOO+U/IbcagJri/WwFfLBCw9q5iOswLhXU2EjpFp5SA5PFyvVj3V7ag
         bltWFbhkoUcg3z86f4j4NDDFWV7oMkB7BhFpyk2LK4Eot6BUJtqO3D0vz6QItLsMJrQz
         ILg90Fe1E4b0Z20J0auFwsWpUpr/md+1dH6zKOrEoOEjKFuq1vYiih+6HADZhn6w3c7p
         m/4+EII1FfUFZ2C8qC5YZq3jgdUpKi0z87otYtIoBegAESv2T7/LXrSYOSVuwQ5D0Gnv
         CW6CDFKbx2DvxR2tKF1nRtESJ5X1xN166WP5drbRaCdK5Q6ocK4s/oom85rv3fHjvFdH
         1v2A==
X-Gm-Message-State: AOJu0YxpzJSASQgJuIbgz50KTH5LyvdYkU5ZGyGTjQsuvs9UCnbXAMic
	T9OFFV6sbsnHZwvul8Jx4xLvix287+V23Tq3er4Jl/WU5AaDfscOE8ZKfClumaZlHNc4oqcmFvj
	UhxtZywc9jxrYqOEftlQwh3Nhl6zt4A==
X-Received: by 2002:a05:6214:d64:b0:67f:8030:11b6 with SMTP id 4-20020a0562140d6400b0067f803011b6mr143701qvs.1.1703183136390;
        Thu, 21 Dec 2023 10:25:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAzXrN6xp5NXvGmNMODFPQUjQ7aDI/PGRXenVrRKBESBkOuIGn70QZyjUSa4x9/Ih3wgVgcg==
X-Received: by 2002:a05:6214:d64:b0:67f:8030:11b6 with SMTP id 4-20020a0562140d6400b0067f803011b6mr143691qvs.1.1703183136181;
        Thu, 21 Dec 2023 10:25:36 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id da7-20020a05621408c700b0067f2c03d4adsm779605qvb.100.2023.12.21.10.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:25:35 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Thu, 21 Dec 2023 12:25:20 -0600
Subject: [PATCH RFC v2 03/11] scsi: ufs: qcom: Perform read back after
 writing testbus config
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231221-ufs-reset-ensure-effect-before-delay-v2-3-75af2a9bae51@redhat.com>
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

Currently, the testbus configuration is written and completed with an
mb().

mb() ensure that the write completes, but completion doesn't mean
that it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed
by writel()/readl()), it can safely be removed.

Fixes: 9c46b8676271 ("scsi: ufs-qcom: dump additional testbus registers")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 4c15c8a1d058..6df2ab3b6f23 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1332,6 +1332,9 @@ static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
 	ufshcd_rmwl(host->hba, UFS_REG_TEST_BUS_EN,
 			UFS_REG_TEST_BUS_EN, REG_UFS_CFG1);
 	ufshcd_rmwl(host->hba, TEST_BUS_EN, TEST_BUS_EN, REG_UFS_CFG1);
+
+	/* dummy read to ensure this has been enabled prior to returning */
+	ufshcd_readl(host->hba, REG_UFS_CFG1);
 }
 
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host)
@@ -1429,11 +1432,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 		    (u32)host->testbus.select_minor << offset,
 		    reg);
 	ufs_qcom_enable_test_bus(host);
-	/*
-	 * Make sure the test bus configuration is
-	 * committed before returning.
-	 */
-	mb();
 
 	return 0;
 }

-- 
2.43.0

