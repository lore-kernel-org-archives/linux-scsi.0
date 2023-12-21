Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4656A73182
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 19:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hGuIszF5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703185840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5DIcTT5Lroakb0MY1T0EdVJKAtxjaPCe5FVxbyPj6I=;
	b=hGuIszF5ZZgnsW3OOMT0vrZFJ609xnQR5GHxXhpDpDImsgh6AJz7KOniVG8EY0omWToPc2
	3f6Y6JeoBnD/te85R3mTupqzT6L8SKLtfjAvu/C71c0080ET/zi6uTOrnjz+DzpVIsgyf9
	ZQHurXYzkZ2iT4RcOMI0BbUEI3ZXNBY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-ALx3xI1_O7u7RkwHLYoyNQ-1; Thu, 21 Dec 2023 14:10:38 -0500
X-MC-Unique: ALx3xI1_O7u7RkwHLYoyNQ-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7811e34e9d4so89945785a.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:10:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703185835; x=1703790635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5DIcTT5Lroakb0MY1T0EdVJKAtxjaPCe5FVxbyPj6I=;
        b=YiCiTVdj9x2SYZevjdwPeTU2odtesp2w79aIrgU3vA6UCNNXHoGaoqPec7wuyF8RpO
         FyBBg2APFuLGKVjb3dkPgrAStVqkMm9Pw1TIhcLBUsPeYfprnI/CwdFQOO/edoLN8Y0B
         n+4bu26hGCv+58ZHJPw60JRh7GpnwteD4tTEeEI/I4vCCMQfLfrnqKqrPGHSZg/5Y4ky
         aDJM/kGQNVT8dNYK0qVFQbTPuyGBJ32fTbb+lpHhufpQKvXKImtWpBCKU5lMWCv0LQfK
         StD9/G4W+AplX5auQNdJpN7l2zkvFGr9tDet4vtVmRsDvwQBKPxhcjIcnaAgPvxbfSBY
         wnlw==
X-Gm-Message-State: AOJu0Yxo3mIFSBCoJ2tBdrX97jOQuqzUYHPGxECewMozydJTtAyEgw8M
	KKLUEhVHutoppiK04GGdpBGuN7BGk6hfvXKd+CQlByjFjog4lSGfl7qsAf82kf1M29eg4rZiiZy
	J+JHV4lHBxd50upJ+zE13fNjyKxgI7Q==
X-Received: by 2002:a05:620a:ed0:b0:77e:fba3:a799 with SMTP id x16-20020a05620a0ed000b0077efba3a799mr242440qkm.119.1703185835163;
        Thu, 21 Dec 2023 11:10:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFS+oPxyve51zvVte/ZBKV14CQT1Ccn6OrbcUqVZrbK82UWo0e9oMDiIDekfpn18HkqUsfhdA==
X-Received: by 2002:a05:620a:ed0:b0:77e:fba3:a799 with SMTP id x16-20020a05620a0ed000b0077efba3a799mr242430qkm.119.1703185834841;
        Thu, 21 Dec 2023 11:10:34 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id 25-20020a05620a04d900b0077f0a4bd3c6sm846370qks.77.2023.12.21.11.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 11:10:34 -0800 (PST)
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
Subject: [PATCH RFC v3 02/11] scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US
Date: Thu, 21 Dec 2023 13:09:48 -0600
Message-ID: <20231221-ufs-reset-ensure-effect-before-delay-v3-2-2195a1b66d2e@redhat.com>
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

Currently after writing to REG_UFS_SYS1CLK_1US a mb() is used to ensure
that write has gone through to the device.

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
index 480787048e75..4c15c8a1d058 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -501,7 +501,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
 		 * make sure above write gets applied before we return from
 		 * this function.
 		 */
-		mb();
+		ufshcd_readl(hba, REG_UFS_SYS1CLK_1US);
 	}
 
 	return 0;

-- 
2.43.0

