Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A198113BC04
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 20:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745337; cv=none; b=R0PuMXGgHjftheocgMqB7G35AEAUSfYfQiV3787fH3qqmw1XlHGWiHmCyvx8SwEXnnJO6u26kdc3QR4AapcJbWLgwxNyzwA+0wNBO5/beYwlrpgglWsihWbr8MMeGQw5U4Iia9qjizSyv0PUJGuimo41OZZmmvspveCHEJEE2Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745337; c=relaxed/simple;
	bh=noY0Ok43Br9Lq9vxVD8O578wOnnwfbfMJqrIM3jYkv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kemgqd2jUIq1X3BzAQb8WSnZciJ3a23+5FxoPwW0iaLXBGhH5AVBPKVkg7BTkHx7tFZrDPVIIMCpMPyrXZZRT3gqBbgEuhSlkHg4GlSZTvz/LrBbZwOy6Uaol/4/jNQ4WvX85XCT29a3MazFhBDcxjpV9+F2t9F69GlzA6rrQ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LC3784WG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LC3784WG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711745334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+uex28Uh2UrmMwKWwWQdWkljJkUfVw1qoAdqpkkJAvI=;
	b=LC3784WGNwHDpgi+e7sSH/tsGMaAc1YW87Wj09DGuIr/+KcBMhM0sTp2ea+R4XebbAnLuc
	z371yWufDoGjh7ySCoeWtWsCirt3Dqpb+F8nREftmPP+H7+24opDcVXHlK2Ox/QGInemYX
	QDss2pH2D05aeVXWC8+n6APillYN5Bk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-0s-tA4UIOe6qP39tY5UcAQ-1; Fri, 29 Mar 2024 16:48:53 -0400
X-MC-Unique: 0s-tA4UIOe6qP39tY5UcAQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-698ec7e66e1so12381036d6.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 13:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711745329; x=1712350129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+uex28Uh2UrmMwKWwWQdWkljJkUfVw1qoAdqpkkJAvI=;
        b=Wi5lKccspLIpL4RNA+s8/Xq8YqErCgSGIOXF94zVWrRdBdOnUh5NNQ21vSvJE2PBOv
         CoUE/3Zn4tPXly1EXSEB2B3vFaqXv01x1UdJ1TRqdPTCPCW8aTGr9cLEGqDmOUNpxwrf
         OxXEyGe9E4OwuYryg3ssq2tYboaOo6OZTOPhHBIa1g24N2V+jer0PpYvU9mqgfE4NEqd
         RS652CrPiDoOoJQL/ou7vNjcWoDIIveYY2brqrZlNtJdCcZbzJ0gqlpKEKTQ+1gaVfQe
         ob+PolegNfxTADaLwtM0nup/CYfeWccOYSFg8pMrCDKTGFLXn+Rqn0FqVatTrnofKF+m
         ylgA==
X-Forwarded-Encrypted: i=1; AJvYcCU/CXLvwxiWUoyZSNFhg9NGx/cczHX4rPjmyw17LflIqFzh2/13vSvlnikCR6fjqVGbi/3RJJNlpTED3CN0Ls7lAEqgP3XTB3IJUw==
X-Gm-Message-State: AOJu0YwBbjWklPbIDnb3IfyoY3ZzWq1Ty8hyQZ4+SUwDOtPNivqamcxN
	Rx8mTY6VgNtdhaSN/q+QKNUN4g/1w1u7kIXlMR1Pe88Q268QxiA3DCYWH4+8UAhWFMNHrAHPiiE
	XTp87D79uooUD5giB7Amwq/5tR3KBW29kEiJhKpj14PUYAnMg2E094JN+G98=
X-Received: by 2002:a0c:b542:0:b0:696:a324:cd9e with SMTP id w2-20020a0cb542000000b00696a324cd9emr3095520qvd.29.1711745328980;
        Fri, 29 Mar 2024 13:48:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvBfgYmwP1iGTeLUYx8CVUhOtv1wYg6+LYE6N5bTtRV/i7BJo/aa22Q4+l3Q6ah0cplyRTFg==
X-Received: by 2002:a0c:b542:0:b0:696:a324:cd9e with SMTP id w2-20020a0cb542000000b00696a324cd9emr3095504qvd.29.1711745328590;
        Fri, 29 Mar 2024 13:48:48 -0700 (PDT)
Received: from x1gen2nano.redhat.com ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id jz10-20020a0562140e6a00b00698f27c6460sm794271qvb.110.2024.03.29.13.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:48:45 -0700 (PDT)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/11] scsi: ufs: qcom: Perform read back after writing
 REG_UFS_SYS1CLK_1US
Date: Fri, 29 Mar 2024 15:46:44 -0500
Message-ID: <20240329-ufs-reset-ensure-effect-before-delay-v5-2-181252004586@redhat.com>
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

Currently after writing to REG_UFS_SYS1CLK_1US a mb() is used to ensure=0D
that write has gone through to the device.=0D
=0D
mb() ensure that the write completes, but completion doesn't mean that=0D
it isn't stored in a buffer somewhere. The recommendation for=0D
ensuring this bit has taken effect on the device is to perform a read=0D
back to force it to make it all the way to the device. This is=0D
documented in device-io.rst and a talk by Will Deacon on this can=0D
be seen over here:=0D
=0D
    https://youtu.be/i6DayghhA8Q?si=3DMiyxB5cKJXSaoc01&t=3D1678=0D
=0D
Let's do that to ensure the bit hits the device. Because the mb()'s=0D
purpose wasn't to add extra ordering (on top of the ordering guaranteed=0D
by writel()/readl()), it can safely be removed.=0D
=0D
Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and powe=
r optimizations")=0D
Reviewed-by: Can Guo <quic_cang@quicinc.com>=0D
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>=0D
---=0D
 drivers/ufs/host/ufs-qcom.c | 2 +-=0D
 1 file changed, 1 insertion(+), 1 deletion(-)=0D
=0D
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c=0D
index 06859e17b67b..804dc8153e7b 100644=0D
--- a/drivers/ufs/host/ufs-qcom.c=0D
+++ b/drivers/ufs/host/ufs-qcom.c=0D
@@ -501,7 +501,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32=
 gear,=0D
 		 * make sure above write gets applied before we return from=0D
 		 * this function.=0D
 		 */=0D
-		mb();=0D
+		ufshcd_readl(hba, REG_UFS_SYS1CLK_1US);=0D
 	}=0D
 =0D
 	return 0;=0D
=0D
-- =0D
2.44.0=0D
=0D

